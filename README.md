<p align="center"><img src="media/cover.png" alt="ask-first cover" width="800"></p>

# ask-first

Two agent skills that ask before they act.

`clarify-first` interviews you one question at a time until the task is specific enough to build, then confirms a written brief before any work starts. `knock-first` checks whether you are at the computer and gets your permission before the agent drives the desktop for testing, then notifies you when the machine is yours again.

Both problems look the same from the user's side: an agent guesses, acts on the guess, and the guess was wrong. Asking first is cheaper than rebuilding.

## Install

The [skills CLI](https://skills.sh) handles host detection for Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, opencode, Amp, and the rest of its supported hosts:

```bash
npx skills add M1688-cpu/ask-first -g
```

Or run the installer in this repo, which detects the agents on your machine and copies into each one (`--all` for every supported agent, `--list` to preview, `--remove` to uninstall):

```bash
git clone https://github.com/M1688-cpu/ask-first.git
bash ask-first/install.sh
```

Claude Code can also install it as a plugin:

```text
/plugin marketplace add M1688-cpu/ask-first
/plugin install ask-first@ask-first
```

For a manual copy, these are the folders each agent reads:

| Agent | Skills folder |
| --- | --- |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Gemini CLI | `~/.gemini/skills` |
| opencode | `~/.config/opencode/skill` |
| Amp | `~/.amp/skills` |
| OpenClaw | `~/.openclaw/skills` |
| ZCode | `~/.zcode/skills` |
| any agent reading the open format | `~/.agents/skills` |

After installing, the skills trigger on their own when their conditions match; you can also invoke them by name.

## clarify-first

An agent that guesses on a vague request builds the wrong thing with confidence. This skill makes it ask.

It triggers when the goal, scope, deliverable, or a key decision in a request can be read several ways. Clear, small, mechanical requests pass through untouched, with a one-line restatement of what the agent understood.

The interview:

1. One question at a time, each with 2-4 options and a recommended answer, so most replies are a click.
2. Follow-up questions come from your answers, so the interview converges instead of running down a checklist.
3. Anything the agent can look up in the codebase, docs, or the web is never asked. Only you get asked about intent, taste, and constraints.
4. Around 7 questions is the ceiling; past that the agent is asking the wrong things.
5. At 95% confidence it writes a task brief: goal, in scope, out of scope, deliverable, assumptions. Work starts after you approve it.

```text
you:    add dark mode to my site
agent:  Which parts? Whole site, or the reading pages first?
        (Recommended: reading pages first, they carry 80% of reading time)
you:    reading pages
agent:  Follow the system appearance setting, or add its own toggle?
        (Recommended: follow the system setting, one less widget to maintain)
you:    follow the system
agent:  Brief: dark palette on the reading pages, follows the system appearance,
        admin area untouched, palette tokens go in theme.css. Start?
        [yes / change something]
```

## knock-first

Tests that move the mouse and type can collide with the person using the machine. A failed test is the mild outcome; a lost edit or a stray click is worse. This skill makes the agent check, ask, run, and hand back.

It triggers before any desktop takeover: screenshots, launching the app that was just built, simulating input, resizing windows for a test.

The cycle:

1. Detect: a script reads keyboard and mouse idle time, the frontmost app, and whether a meeting or media app is playing, then reports whether you appear to be at the machine. Someone watching video with an idle keyboard still counts as present.
2. Request: one dialog states what detection found, the exact list of planned actions, and a duration estimate. Options: go ahead, skip asking for the rest of the session, or not now. Consent lives in the current conversation only and is never written anywhere.
3. Run: exactly the listed actions. Anything beyond the list comes back for another ask.
4. Hand back: a macOS notification with a sound, plus a result summary in chat, so you know the moment the machine is yours again.

```text
agent:  You are working in Xcode right now (idle 40 s). I need the desktop for
        about 3 minutes to: open the built app, resize it to 1280x800, capture
        3 screenshots, type one search query. Go ahead?
        [go ahead / skip asking this session / not now]
you:    go ahead
        ... tests run ...
agent:  Posted a notification: "Testing done: 3 screenshots saved."
        In chat: the search crash did not reproduce, screenshots are in
        artifacts/. Your computer is yours again.
```

## Files

```text
skills/clarify-first/SKILL.md        the interview skill
skills/knock-first/SKILL.md          the desktop-consent skill
skills/knock-first/scripts/          activity check and notification helpers (macOS)
install.sh                           detect installed agents and copy into each
.claude-plugin/                      Claude Code plugin manifest
media/cover.html                     source of the cover image
```

## Requirements

`clarify-first` works anywhere the agent can ask questions; hosts without a question dialog fall back to asking in chat. The `knock-first` scripts use macOS interfaces (`ioreg`, `lsappinfo`, `osascript`); on other platforms detection reports "present" and the agent asks every time. Screen capture needs Screen Recording granted to the terminal hosting the agent.

## License

MIT
