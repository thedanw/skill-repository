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

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches. Update planning files at every step. Git commit after each batch.

**Core principle:** Batch execution with checkpoints for review. File-tracked context for resumability. **Agent todo tools for task decomposition. Context optimization for efficient token usage.**

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

**Context Optimization - Compaction Strategy:**
- If context utilization exceeds 70%, apply compaction before resuming
- Summarize completed tasks in `progress.md` rather than keeping full history in context
- Store detailed findings in `findings.md` file, reference by summary in context
- Use observation masking: replace verbose tool outputs with references to `progress.md` entries

---

### Step 1: Load and Review Plan

1. Read `plan.md`
2. Review critically — identify questions or concerns
3. If concerns: raise them with the user before starting
4. If no concerns: update `task_plan.md` status to `in_progress` and proceed

**Task Decomposition with Todo Tools:**
- Use `manage_todo_list` to break the plan into atomic, trackable tasks
- Create todo items for each phase, batch, and individual task
- Mark one todo as `in_progress` at a time (limit: 1)
- Update todo status immediately upon completion

```markdown
## Todo List Example
- [ ] Phase 1: Setup & Configuration
  - [ ] Task 1.1: Initialize project structure
  - [ ] Task 1.2: Configure build tools
  - [ ] Task 1.3: Set up linting/formatting
- [ ] Phase 2: Core Implementation
  - [ ] Task 2.1: Implement data models
  - [ ] Task 2.2: Implement API layer
  - [ ] Task 2.3: Implement business logic
- [ ] Phase 3: Testing & Validation
  - [ ] Task 3.1: Write unit tests
  - [ ] Task 3.2: Write integration tests
  - [ ] Task 3.3: Run full test suite
```

---

### Step 2: Execute Batch

**Default batch size: 3 tasks** (or fewer if remaining < 3).

**Context Optimization During Execution:**
- **Observation Masking**: After each tool execution, summarize key findings in `progress.md` rather than keeping full output in context
- **KV-Cache Optimization**: Keep stable context elements (plan, architecture decisions) at the top of context; place variable content (tool outputs, current task details) at the end
- **Context Partitioning**: For complex multi-file tasks, consider using sub-agents with isolated contexts for independent subtasks
- **Budget Management**: Allocate context budget: 20% plan/architecture, 30% current task, 30% recent history, 20% buffer

For each task:
1. Mark as `in_progress` in `task_plan.md` AND update todo list
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as `completed` in `task_plan.md` AND update todo list
5. Log any errors to `progress.md` with summary (not full output)
6. **Context Check**: If context > 70% utilized, trigger compaction before next task

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

### Context Optimization Applied
- Compaction: [yes/no, token reduction %]
- Masking: [observations masked, tokens saved]
- Partitioning: [sub-agents used, context isolation achieved]
```

Then report to user:
- What was implemented
- Verification output
- Context optimization metrics
- Say: "Ready for feedback."

---

### Step 4: Git Commit

After each batch passes review:

```powershell
git add -A
git commit -m "[type]: [batch description] — tasks N-N"
```

---

## Context Optimization Reference

### When to Apply Optimization
- Context utilization exceeds 70%
- Response quality degrades as conversation extends
- Costs increase due to long contexts
- Latency increases with conversation length

### Strategy Selection
| Dominant Context Component | Primary Strategy |
|---------------------------|------------------|
| Tool outputs | Observation masking |
| Retrieved documents | Summarization or partitioning |
| Message history | Compaction with summarization |
| Multiple components | Combine strategies |

### Performance Targets
- Compaction: 50-70% token reduction, <5% quality degradation
- Masking: 60-80% reduction in masked observations
- Cache optimization: 70%+ hit rate for stable workloads

### Quick Reference Commands
```python
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
