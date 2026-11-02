# Recovery and idempotency

Use this reference after timeout, process interruption, transport loss, partial
batch response, or an uncertain terminal result.

For authentication failures, follow [the authentication recovery flow](authentication.md) before resuming the same operation.

## Freeze identity before effects

- node save: retain the Node ID and update ID declared by the release;
- node run: retain one submit ID per input item;
- long operation: retain the returned operation reference;
- final selection: retain the chosen Resource ID.

Do not create a new identity just because the first response was lost.

For a `node run` result, each `data.items[].submitId` is the exact `<operation-ref>` accepted by
`operation status` and `operation wait`. Observe the same work with
`operation wait <submitId> --project-id <projectId>`; do not pass the Node ID or mint another UUID.

## Recovery decision table

| Observation | Action |
| --- | --- |
| operation is still `running` | continue observing the same operation reference |
| local wait budget expired | return resumable state (exit `20`); the server task may still run |
| media `--run --wait` was accepted, but status queries failed | retain `partialData.items[0].nodeId`, `submitId`, and `state=ACCEPTED`; continue with `operation wait <submitId> --project-id <projectId>`, not create/edit/run |
| a plain node create/edit save failed or its response was lost | inspect the node and draft before retrying with the original node/update identity and source declaration. A target link may remain even if the draft did not save; do not unlink it automatically. |
| **media `--run` exited `10` after the quote** | the node is saved and nothing was charged. Reuse **both** `partialData.items[0].nodeId` and `submitId`; supply an approval and rerun |
| submit response was lost | inspect read-only with the same submit ID; **do not replay the run** — the original request may never have reached the server, so a replay becomes a first submission and really charges |
| submit is already `completed` / `in_progress` | replay its recorded result; do not demand a new confirmation |
| a bound saved node is still `awaiting_confirmation` and has not been submitted | continue approval from that saved node and its original IDs; do not save again. Request approval only if the existing approval no longer covers it |
| item is terminally `rejected` (e.g. timeline clips over the limit, overlapping audio, or a material/type mismatch) | fix the input or plan; blind retry is useless |
| referenced upstream material has an existing generation still in progress (can occur with a generation reference or a timeline clip) | retain its original submit ID and wait with `--wait` / `operation wait` for a usable output; do not submit another generation for that source |
| referenced upstream node has never been submitted for generation and has no output | there is no submit ID to wait on; generate that source within the user's authorized scope, then continue the downstream operation after a usable output exists |
| **submission state is `absent`** | do not infer that nothing ran: the record can have expired. Inspect canvas or the credit ledger before any resubmission |
| identity cannot yet be resolved and the submission was `accepted` | keep state `unknown` and require resume; never report empty success, and do not resubmit |

Status/inspection must remain read-only. It must not launch generation merely to
discover a missing Resource ID.

Wait retries a transient status-query failure at most twice, at the polling interval, within
the original timeout; it never repeats save, quote, confirm, or run. `--timeout 0` queries once.
After an accepted media submission, exhausted transient errors, timeout, or interruption return
`ok=false`, exit `20`, `class=operation_incomplete`, `retryable=false`, and `requiredAction=resume`.
This means the original create/edit/run must not be retried; a new read-only `operation wait`
with the returned submit ID is safe. Keep the original region and environment. Acceptance is
not proof that generation finished. The status error code and available log IDs remain diagnostic.
Authentication, permission, upgrade, and invalid-response errors are not automatically retried
or converted to `resume`: follow their original `requiredAction`, then observe the same submit ID.

**`absent` and `unknown` are not synonyms and live on different axes, but neither alone
authorizes an automatic resubmit.** `absent` is a submission-fact state (whether the submission
exists on the server at all) and can mean the record has expired; `unknown` is a per-item verdict
(whether this output was accepted or rejected) and means the service cannot establish a safe
conclusion. Decide from the full submission fact and external evidence, never by guessing from
local state.

## Batch recovery

Create submit IDs for the entire batch before the request. Preserve an
equal-length, input-order result vector. A transport failure must not discard the
identities of later items.

A batch run accepts a submit ID **per item**, corresponding to the node list
position by position. The CLI records generation identities before submission so
an interrupted process can be observed by its original ID. Keep returned IDs;
supply them explicitly when the caller needs to retain them before the first response.
If the local record is missing, query the known original submit ID with
`--project-id`; do not assume the operation never ran or create a new attempt.

A count mismatch, a duplicate, an empty value, or a non-UUID value exits with an invalid-input
error **before the run request is sent**: nothing runs and nothing is charged. Such input errors
therefore need no recovery flow — fix the arguments and rerun.

Classify each item independently as `accepted`, `rejected`, or `unknown` (the run verdict axis),
and as `pending` / `running` / `succeeded` / `failed` (the resource axis). These are observations
on different axes, not one enum. Recover `unknown` items with their original submit IDs; do not
rerun accepted items under new IDs.

## Local job state

Keep the original authenticated account and canvas during recovery. On
`cli.operation_context_mismatch`, stop and explicitly restore the intended context;
do not switch it silently. On `cli.operation_identity_unknown`, a record can be
observed under current permissions but cannot be adopted for approval or submission.
Composed `--run` operations already attempted are inspected with `operation status/wait`,
not saved or submitted again. Follow [authentication and local-state recovery](authentication.md)
for storage errors and warnings; a successful result with `localStorageWarning`
remains remotely successful.

Use the CLI's recovery records instead of editing them by hand. If the host keeps
additional task notes, retain only the identifiers needed to resume: region,
canvas, Node IDs, update IDs, submit IDs, operation references and selected
Resource IDs. Keep those notes private to the user.

Never store credentials, signed URLs, provider payloads, access material, or
credit-confirmation tokens.

## Completion rule

An empty resource set is not “all succeeded.” Completion requires a positive,
terminal resource fact for every required output. See
[completion-and-validation.md](completion-and-validation.md).

## Video sample promotion

Before generating a sample and when delivering sample results, explicitly tell the user: **Samples are stored for up to 7 days and cannot be used to generate final videos after expiry.** If the user needs a final video for delivery, remind them to promote the sample before it expires; do not wait for a failed promotion to explain the deadline.

The server determines the exact deadline. If a tool explicitly returns it, tell the user the deadline and time zone. Otherwise, state only the 7-day maximum; do not invent a date or countdown, or restart the period from the current viewing or delivery time. If a sample has expired, explain that a new sample is needed before trying promotion again. Retrying cannot extend the original sample's lifetime; generating a new sample still follows the existing credit-approval rules.

Use `search --type video --detail full` to discover `generationKind=sample` and `draftPromotion.params`. Submit `node promote video-sample --node-id <nodeId> --resolution <resolution> --credit-ceiling <credits>`. A successful submission creates a new output node; the source remains a sample. After a timeout, use `operation status/wait` with the same `submitId`. Never generate a new submission ID to resolve uncertainty. Confirmation tokens are scoped to this operation and target resolution. Availability and expiry remain server-authoritative.
