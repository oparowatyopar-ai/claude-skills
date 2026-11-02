---
name: scrub
description: Build a scroll-driven ("scroll-scrubbed") video hero section for a landing page or client pitch demo, where scrolling the page plays a video clip frame-by-frame instead of it autoplaying. Use this whenever the user asks for a video hero, a cinematic/parallax scroll effect tied to video, a "flythrough" section, or says things like "scrub", "scroll through the video", or wants a hero that reacts to scroll position. Also use it when building any real-estate, hospitality, product, or portfolio landing page that has a short video clip (drone flythrough, product shot, walkthrough) meant to feel premium and deliberate rather than just autoplaying in a loop.
---

# Scroll-scrubbed video hero

Ties a short video clip's playback position directly to scroll position, so scrolling "drives" the footage instead of it autoplaying. Reads as a deliberate, premium cinematic effect — good for real-estate flythroughs, product reveals, and pitch demos.

Reference implementation this pattern was extracted from: a real-estate agency demo (villa flythrough hero, logo crossfade at the door, frozen last frame behind the rest of the page).

## Why not just `<video autoplay>` or CSS scroll-timeline

Seeking a `<video>` while it's paused does not reliably repaint the visible frame across browsers — notably iOS Safari, which is exactly the audience for a polished landing page. The reliable fix: keep the `<video>` element decode-only (never shown), and on every scroll-driven seek, explicitly draw the current frame to an overlaid `<canvas>` via `drawImage`. The canvas is what the user actually sees.

## Core mechanics

1. **Hidden decode-only `<video>` + visible `<canvas>` on top.** `muted playsinline preload="auto"`, `display:none` (or otherwise not rendered) on the video; canvas sits in the same fixed backdrop layer.
2. **Tall "runway" wrapper** (e.g. `height:200vh`) holding a `position:sticky; top:0` hero. Scroll progress (0→1) through the runway:
   ```js
   const rect = heroScrubSpace.getBoundingClientRect();
   const scrollable = rect.height - window.innerHeight;
   const progress = scrollable > 0 ? clamp(-rect.top / scrollable, 0, 1) : 0;
   ```
3. **rAF-throttled scroll handler** maps `progress → video.currentTime = progress * video.duration`, then draws the frame on the `seeked` event with cover-fit scaling (`scale = Math.max(canvasW/videoW, canvasH/videoH)`, centered) — same visual result as `object-fit:cover`.
4. **"Duration is Infinity" fix.** Some H.264 exports report `Infinity` for `duration` until forced to seek near the end once. On `loadedmetadata`: seek to `1e7`, wait for `seeked`, reset to `0`, then start real scrubbing.
5. **Silent warm-up.** Call `play()` then `pause()` ~50ms later right after load so mobile browsers actually decode frames ahead of the first real seek. Swallow the `play()` promise rejection — autoplay can be silently blocked and that's fine, it's just a warm-up.
6. **Cross-fading overlays** (hero text out, logo/payoff in, etc.) driven by the *same* `progress` value via small ramp helpers:
   ```js
   const rampIn  = (p, start, end) => p <= start ? 0 : p >= end ? 1 : (p - start) / (end - start);
   const rampOut = (p, start, end) => 1 - rampIn(p, start, end);
   ```
   Pick start/end windows per overlay so one finishes fading out around where the next fades in — no dead gap, no overlap that looks muddy.
7. **Freeze past the runway.** Once `progress` clamps at 1, the canvas holds the last drawn frame — later page sections scroll normally over that frozen backdrop (the fixed backdrop layer stays `z-index:0` under everything).
8. **Respect `prefers-reduced-motion` by default.** Fall back to drawing one static frame (e.g. `currentTime = 0.1`) instead of scrubbing. Only disable that check (`DEMO_MODE = true`) when the user explicitly wants a pitch/demo page that presents identically for every viewer regardless of OS setting — call this out to the user rather than assuming it.

## How to use this skill

1. Copy [`assets/scroll-scrub-template.html`](assets/scroll-scrub-template.html) as the starting point — it's a complete, working, vanilla-JS implementation of all 8 points above with two example cross-fading overlays.
2. Swap in the real video source, and adjust the runway height (`.hero-scrub-space`) if the clip needs more or less scroll travel to feel right — longer/slower clips or clips with more "beats" (e.g. a door opening, then a room reveal) generally want a taller runway.
3. Replace the placeholder overlays with the real hero copy / brand mark / CTA, and tune the ramp windows in `updateOverlays` to match where those beats happen in the footage (scrub through the clip manually — e.g. in QuickTime — to find the right progress fractions).
4. If the page has multiple sections below the hero, make sure they sit in a `position:relative; z-index:1` stacking context so they scroll normally over the fixed, frozen video backdrop (see `main` in the template).
5. No build step or framework is required — this is plain HTML/CSS/JS and drops into any static page.
