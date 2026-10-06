---
name: clarify-first
description: |
  Interview the user one question at a time before starting an ambiguous task, then
  confirm a written brief before acting. Use when a request is underspecified: the
  goal, scope, deliverable, or a key decision could each be read several ways, or
  the work is large enough that guessing wrong wastes real effort. Skip for clear,
  small, mechanical requests.
license: MIT
metadata:
  version: "1.0.0"
---

# clarify-first: ask until the task is clear, then start

One vague instruction can send an agent hours in the wrong direction. This skill
trades a few focused questions for that risk.

## Step 0: decide whether to interview

After reading the prompt, rate four things: goal, scope, deliverable, key decisions.

- Two or more are unclear, or the task is large and hard to reverse: interview, continue below.
- Everything is clear: skip the interview, do the task. State your understanding in
  one sentence before starting.
- The user says "don't ask, just do it": skip to the brief (step 3), no interview.

## Step 1: build the question list

List what you would need to know to pick one approach over another. Sort every item
into two piles before asking anything:

- Look it up yourself: anything the codebase, docs, or the web can answer. These are
  never asked.
- Only the user knows: intent, taste, priorities, constraints of their environment,
  budget of time or money. These are the interview questions.

Order them so an early answer can remove or reshape the questions after it.

## Step 2: ask one at a time

1. Pick the highest-value open question.
2. Ask it alone with AskUserQuestion: one question per call, 2-4 options, each option
   with a one-line description. Put your recommended option first with
   "(Recommended)" at the end of its label. The user can always pick "Other" and
   type freely. If the host has no AskUserQuestion tool, ask the same single
   question in chat, listing the options as a numbered list.
3. Derive follow-up questions from the answer and add them to the list.
4. Stop when the remaining unknowns could no longer change the approach or the
   deliverable. That is the 95% bar: the questions left are ones whose answers
   would not change what gets built.

Ask in the language the user writes in.

Guard rails:

- About 7 questions per task is the ceiling. Past that, you are asking things you
  could have looked up.
- If the user picks the recommended option three times in a row, offer to accept
  all remaining recommendations at once.
- Never batch several questions into one AskUserQuestion call during the interview.
  Follow-ups depend on earlier answers; that dependency is the point of asking one
  at a time.

## Step 3: confirm the brief

Write a task brief and get one confirmation:

- Goal: one sentence.
- In scope: short list.
- Out of scope: what you will deliberately not touch.
- Deliverable: what exists for the user at the end.
- Assumptions: anything you decided without asking.

Then ask with AskUserQuestion, question "Ready to start on this brief?":

- "Yes, start" (Recommended)
- "Change something" (ask what, fix the brief, confirm again)

Only after a yes does work begin. If new ambiguity appears mid-task, solve small
ones yourself and record them under Assumptions; come back and ask only when the
answer would change the deliverable.
