---
name: 03_executing-plans
description: "Use when you have a written implementation plan to execute. Load plan, review critically, execute tasks in batches with file-tracked context, report for review between batches. Integrates with pipeline planning files (task_plan.md, findings.md, progress.md) and git."
category: code-plan
risk: safe
source: adapted
tags: [execution, implementation, batch, review, checkpoint, tasks, git, context-recovery]
triggers: [execute, implement, run-plan, follow-plan, batch, checkpoint]
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches. Update planning files at every step. Git commit after each batch.

**Core principle:** Batch execution with checkpoints for review. File-tracked context for resumability.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

---

## The Process

### Step 0: Context Recovery (If Resuming)

Before starting or resuming, read ALL planning files:

1. `decision.md` — what was decided and why
2. `plan.md` — what to build (the source of truth)
3. `task_plan.md` — current position and phase status
4. `progress.md` — what was tried, what failed, what succeeded
5. `findings.md` — research, discoveries, architecture notes

If resuming: find the last completed task. Start from the next pending task.

---

### Step 1: Load and Review Plan

1. Read `plan.md`
2. Review critically — identify questions or concerns
3. If concerns: raise them with the user before starting
4. If no concerns: update `task_plan.md` status to `in_progress` and proceed

---

### Step 2: Execute Batch

**Default batch size: 3 tasks** (or fewer if remaining < 3).

For each task:
1. Mark as `in_progress` in `task_plan.md`
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as `completed` in `task_plan.md`
5. Log any errors to `progress.md`

**Coding Standards (apply during all batches):**
1. **Read before write** — Read 2-3 similar files before creating new ones
2. **Match conventions** — Follow existing naming, import style, architecture
3. **No type suppression** — Never use `as any`, `@ts-ignore`, or equivalent
4. **Never delete failing tests** — Fix the code, not the test
5. **Never leave broken state** — If tests fail, fix before moving on
6. **Respect existing code** — Don't refactor what you didn't break

---

### Step 3: Report (Checkpoint)

When batch complete, update `progress.md`:

```markdown
## Batch [N] Complete — [date]
- ✅ Task [X]: [description]
- ✅ Task [X]: [description]
- ✅ Task [X]: [description]
- Commit: `[hash]`

### Errors
| Error | Resolution |
|-------|-----------|
| [If any] | [How resolved] |
```

Then report to user:
- What was implemented
- Verification output
- Say: "Ready for feedback."

---

### Step 4: Git Commit

After each batch passes review:

```powershell
git add -A
git commit -m "[type]: [batch description] — tasks N-N"
```

Commit types: `feat`, `test`, `chore`, `docs`, `fix`

---

### Step 5: Continue or Complete

Based on user feedback:
- Apply changes if needed
- Execute next batch
- Repeat until all tasks complete

After all tasks complete and verified:
- Run final verification (tests, lint, build)
- Update `task_plan.md` status to `complete`
- Present completion options to user

---

## Error Handling (3-Strike Protocol)

1. **Strike 1:** Diagnose and fix the specific error. Log to `progress.md`.
2. **Strike 2:** Try a different approach. Log to `progress.md`.
3. **Strike 3:** STOP. Revert. Document in `progress.md`. Ask user.

**Never repeat the exact same failing action.**

---

## When to Stop and Ask for Help

**STOP immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly (strike 3)

**Ask for clarification rather than guessing.**

---

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- User updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** — stop and ask.

---

## Remember

- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Update `task_plan.md` after every task
- Update `progress.md` after every batch
- Git commit after every batch
- Stop when blocked, don't guess
- Read planning files to recover context if resuming
