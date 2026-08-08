---
name: 03_executing-plans
description: "Use when you have a written implementation plan to execute. Load plan, review critically, execute tasks in batches with file-tracked context, report for review between batches. Integrates with pipeline planning files (task_plan.md, findings.md, progress.md) and git. Uses agent todo tools for task management and context optimization techniques for efficient context usage."
category: code-plan
risk: safe
source: adapted
tags: [execution, implementation, batch, review, checkpoint, tasks, git, context-recovery, todo, context-optimization]
triggers: [execute, implement, run-plan, follow-plan, batch, checkpoint, todo, context-optimization]
allowed-tools: [manage_todo_list, read_file, write_file, edit_file, run_in_terminal, grep_search, file_search]
---

# Executing Plans (Token-Optimized)

## Overview

Load plan, review critically, execute in batches, report between batches. Update planning files each step. Git commit after each batch.

**Core principle:** Batch execution with checkpoints. File-tracked context for resumability. Agent todo tools for task decomposition. Context optimization for token efficiency.

**Announce:** "I'm using the executing-plans skill to implement this plan."

---

## Process

### Step 0: Context Recovery (If Resuming)

Read ALL planning files:
1. `decision.md` — decisions and rationale
2. `plan.md` — what to build (source of truth)
3. `task_plan.md` — current position, phase status
4. `progress.md` — tried, failed, succeeded
5. `findings.md` — research, discoveries, architecture

If resuming: find last completed task, start next pending.

**Compaction Strategy (if context > 70%):**
- Summarize completed tasks in `progress.md` vs full history in context
- Store detailed findings in `findings.md`, reference by summary
- Mask observations: replace verbose outputs with `progress.md` refs

---

### Step 1: Load and Review Plan

1. Read `plan.md`
2. Review critically — identify questions/concerns
3. If concerns: raise with user before starting
4. If none: update `task_plan.md` status to `in_progress`, proceed

**Todo Decomposition:**
- `manage_todo_list` → atomic, trackable tasks
- Create items for each phase, batch, task
- One `in_progress` at a time (limit: 1)
- Update status immediately on completion

```
Todo Example
- Phase 1: Setup & Configuration
  - Task 1.1: Initialize project structure
  - Task 1.2: Configure build tools
  - Task 1.3: Set up linting/formatting
- Phase 2: Core Implementation
  - Task 2.1: Implement data models
  - Task 2.2: Implement API layer
  - Task 2.3: Implement business logic
- Phase 3: Testing & Validation
  - Task 3.1: Write unit tests
  - Task 3.2: Write integration tests
  - Task 3.3: Run full test suite
```

---

### Step 2: Execute Batch

**Default batch: 3 tasks** (or fewer if remaining < 3).

**Context Optimization During Execution:**
- **Observation Masking**: Summarize key findings in `progress.md` after each tool call vs full output in context
- **KV-Cache**: Stable context (plan, architecture) at top; variable (tool outputs, current task) at end
- **Context Partitioning**: Sub-agents with isolated contexts for independent subtasks
- **Budget**: 20% plan/architecture, 30% current task, 30% recent history, 20% buffer

Per task:
1. Mark `in_progress` in `task_plan.md` AND todo list
2. Follow steps exactly (plan has bite-sized steps)
3. Run verifications
4. Mark `completed` in `task_plan.md` AND todo list
5. Log errors to `progress.md` with summary (not full output)
6. **Context Check**: If > 70% utilized, compact before next task

**Coding Standards (all batches):**
1. Read before write — Read 2-3 similar files before creating new
2. Match conventions — Follow existing naming, imports, architecture
3. No type suppression — Never `as any`, `@ts-ignore`, equivalent
4. Never delete failing tests — Fix code, not test
5. Never leave broken state — Fix before moving on
6. Respect existing code — Don't refactor what you didn't break

---

### Step 3: Report (Checkpoint)

Batch complete → update `progress.md`:

```
Batch [N] Complete — [date]
- Task [X]: [description]
- Task [X]: [description]
- Task [X]: [description]
- Commit: `[hash]`

Errors
| Error | Resolution |
|-------|-----------|
| [If any] | [How resolved] |

Context Optimization Applied
- Compaction: [yes/no, token reduction %]
- Masking: [observations masked, tokens saved]
- Partitioning: [sub-agents used, context isolation]
```

Report to user:
- What implemented
- Verification output
- Context optimization metrics
- "Ready for feedback."

---

### Step 4: Git Commit

After batch passes review:
```
git add -A
git commit -m "[type]: [batch description] — tasks N-N"
```

Commit types: `feat`, `test`, `chore`, `docs`, `fix`

---

## Context Optimization Reference

### When to Apply
- Context > 70% utilized
- Response quality degrades
- Costs increase from long contexts
- Latency increases with conversation length

### Strategy Selection
| Dominant Component | Primary Strategy |
|-------------------|------------------|
| Tool outputs | Observation masking |
| Retrieved docs | Summarization or partitioning |
| Message history | Compaction with summarization |
| Multiple | Combine strategies |

### Performance Targets
- Compaction: 50-70% token reduction, <5% quality loss
- Masking: 60-80% reduction in masked observations
- Cache optimization: 70%+ hit rate for stable workloads

### Quick Reference
```
# Compaction trigger
if context_tokens / context_limit > 0.7:
    context = compact_context(context)

# Observation masking
if len(observation) > max_length:
    ref_id = store_observation(observation)
    return f"[Obs:{ref_id} elided. Key: {extract_key(observation)}]"

# Cache-friendly ordering
context = [system_prompt, tool_definitions]  # Stable, cacheable
context += [reused_templates]  # Reusable
context += [unique_content]  # Unique per request
```

---

### Step 5: Continue or Complete

Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until all tasks complete

After all complete and verified:
- Run final verification (tests, lint, build)
- Update `task_plan.md` status to `complete`
- Present completion options

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
