---
name: knock-first
description: |
  Check whether the user is at the computer and get their permission before taking
  over the desktop for testing. Use before any action that drives the machine:
  taking screen captures, launching a compiled app to verify it, simulating mouse
  or keyboard, resizing or switching windows, or any test a keystroke from the user
  would break. Covers the full cycle: detect, ask, run, hand back.
license: MIT
metadata:
  version: "1.0.0"
---

# knock-first: knock before you drive

Tests that move the mouse and type can collide with the person using the machine.
A failed test is the mild outcome; a lost edit or a stray click is worse. Run this
cycle every time.

## 1. Detect

Run `bash scripts/check_user_activity.sh` from this skill's directory. It prints
one JSON object:

```json
{"platform":"darwin","idle_seconds":187,"foreground_app":"Xcode",
 "visible_apps":["Xcode","Safari"],"meeting_or_media_active":false,
 "user_present":true,"idle_threshold_seconds":300}
```

`user_present` is true when input was recent, or a meeting or media app is
playing. It is also true when detection is unavailable (non-macOS, or a probe
failed): treat "cannot tell" as "user is present" and continue to step 2.

Detection is a courtesy signal for the next message; it never replaces asking.

## 2. Request

Call AskUserQuestion with exactly one question (or ask the same thing in chat when
the host has no AskUserQuestion tool, and wait for the reply). The question text
states:

- What detection found: "You are 23 minutes idle" or "You are working in Xcode
  right now".
- The exact list of actions about to run: "open the built app, resize its window
  to 1280x800, capture 3 screenshots, type one search query".
- A duration estimate.

Options:

- "Go ahead" (Recommended)
- "Go ahead, don't ask again this session": remember the grant for the rest of
  this session and skip step 2 (never step 1) for similar takeovers.
- "Not now": stop, then propose work that needs no desktop (static analysis,
  unit tests, code review).

Consent lives in the current conversation only. Never write it to a file,
environment variable, or config. A new session asks again.

## 3. Run

Do exactly what the list said. When a test needs a step beyond the list, come
back and ask before doing it. For runs longer than a couple of minutes, post one
short progress note per phase so the user can follow without watching.

## 4. Hand back

When the takeover ends:

1. Run `bash scripts/notify_done.sh "Testing done" "<one-line result>"`. It posts
   a macOS notification with a sound, so the user notices even from another
   window. On other platforms it prints to stderr instead.
2. In chat, report what was tested, what passed or failed, and say the computer
   is theirs again.

## macOS permissions

Screen capture and UI automation need Screen Recording (and sometimes
Accessibility) granted to the app hosting the agent. If a capture comes back
empty or black, give the user the exact fix: System Settings > Privacy &
Security > Screen Recording, enable the terminal app, then retry once. Do not
retry in a loop.
