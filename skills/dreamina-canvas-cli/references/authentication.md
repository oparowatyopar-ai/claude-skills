# Authentication and execution permissions

## Local business-state storage

`error.localStorage` identifies a current-canvas or operation-record failure, independently of credential storage. Inspect `reason`, `stage`, and the local `directory`; do not infer a service outage or enable full access. Request the host's supported approval for operations within that directory, including temporary files, replacement, and cleanup. If necessary, explicitly set `DREAMINA_CANVAS_STATE_DIR` to an approved private persistent absolute directory for all related CLI invocations. This option changes business records only, not authentication credentials, and requires a CLI version that supports it.

An explicit `--project-id` chooses the target canvas without changing the selection. The server still verifies the account, canvas permissions, and applicable usage eligibility; generation still requires a recovery record. Preserve the original project and submission IDs. Do not clear records or switch directories automatically on permission, corruption, or disk-space errors. Local-only failure does not prove a remote generation failed. Share diagnostics without credential values, record contents, or private prompts.

Use `error.localStorage` to distinguish the store, I/O stage, reason, and `submissionPhase`. `before_submit` means only this invocation stopped before sending; preserve the original project and submission IDs. `after_submit` requires read-only `operation status/wait <submitId> --project-id <projectId>`; do not recreate or resubmit. If only the operation journal is unavailable, a read-only remote lookup can continue while the account and selected space remain usable; `localStorageWarning` does not negate a successful remote result. If `canvas create --use` returns `current=false` and a warning, the canvas already exists: open its `webUrl` and pass its `--project-id` explicitly. Keep damaged records for diagnosis; do not overwrite or delete them to make a retry pass.

## Authentication

Before model discovery, use `auth status` with the intended profile. Continue with
an existing usable login; otherwise use `auth login` from the installed schema.
Read `error.reason`, `class`, and `requiredAction`; JSON error messages are always
English, while human output follows the artifact's distribution.

| `error.reason` | Recovery |
| --- | --- |
| `dns_resolution_failed` | Check DNS and network permissions for the actual CLI process. A successful homepage curl does not prove CLI access. |
| `network_permission_denied` | Request necessary network permission through the host's supported approval flow. |
| `credential_store_permission_denied` | Request necessary local credential storage permission. Network approval alone may be insufficient. |
| `credential_store_unavailable` / `credential_store_corrupt` | Check OS storage and user context; preserve records and contact support before clearing or replacing them. |
| `network_timeout` | Retry with backoff at most twice, then retain the sanitized error for support. |
| `auth_dependency_failed` | Cause is unclassified. Compare once with an approved execution or regular terminal; do not conclude the service is down. |

For DNS or permission failures, retry once only after conditions change. Reuse
permissions already granted; do not automatically enable full access. If the host
cannot grant the necessary access, have the user run the same binary with the same
profile in a regular terminal under the same OS user. After terminal authorization,
check `auth status` again in the Agent environment; subsequent requests may still
need permissions. Older releases without `reason` permit the same single comparison.

Once a challenge is returned, present its official verification URL and user code,
then follow the installed schema's wait flow. Do not start another login, log out,
or use `--force` merely because authorization is pending.

After sign-in or authorization waiting completes, use that success result directly. Follow the main Skill for the capabilities exposed by the installed schema. For an existing login without an authorization result in this interaction, use `auth account` to obtain current account information. `auth status` checks credential state; it does not replace server identity verification. Use the returned errors and supported auth commands instead of assuming that credentials can be refreshed. On `reason=account_changed`, stop automatic retries, verify the intended account with `auth account`, and preserve the original operation identity.

Credential storage depends on the installed CLI and operating system. Use the
actual error to identify the required permission; do not infer an internal path
or storage backend from this guide. Do not use sudo or administrator mode by
default, export tokens, clear credential storage, or move credentials into a
workspace or shared temporary directory.

## Installation and upgrade permissions

The installer needs write access inside the binary installation directory and the target Skill directory. Creating a new target also requires permission to create it in its parent. Upgrades preserve the `dreamina-canvas-cli` root directory and update its contents without moving or deleting that root.

If access is denied, request the necessary one-time approval for the actual installation command through the host. If the host cannot grant access, install from a regular terminal under the same OS user. Installation failures do not require logging out or clearing credentials. If an installation lock exists, first check for an active installer. If a retained backup path is reported, recover or inspect that backup before further cleanup. Do not load the Skill during installation; use a fresh conversation after it completes.

When installing a supplied complete bundle, run its `install.sh` from the extracted directory or set `DREAMINA_CANVAS_PAYLOAD_DIR` to that directory’s absolute path. Keep `payload.sha256`, the matching platform binary, `skill.tar.gz`, and `version.json` together. An incomplete or mismatched bundle must not fall back to CDN. Verify the installed CLI using the absolute path and version printed by the installer, and load the updated Skill in a fresh conversation. A PATH warning does not mean installation failed.

When `requiredAction=upgrade`, select a `clientUpgrade.installCommands` entry matching the OS and terminal, if provided. Windows PowerShell and CMD use different commands. Without these entries, follow the legacy `upgradeUrl` guidance and do not infer other script paths. An upgrade response does not itself authorize command execution. After updating, verify the CLI version and read the updated Skill; retain the current profile and credentials. Continue the original `operationRef` when present instead of submitting again.
