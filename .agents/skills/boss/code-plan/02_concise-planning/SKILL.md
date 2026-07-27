---
name: 02_concise-planning
description: "Use when a user asks for a plan for a coding task. Generates a clear, actionable, atomic checklist following TDD and git-best practices, while initializing file-based context tracking."
category: code-plan
risk: safe
source: adapted
tags: [planning, checklist, tasks, scope, tdd, git, context, organization]
triggers: [plan, checklist, scope, action-items, tasks, roadmap, implementation-plan, write-plan]
---

# Concise Planning (Unified)

Turn a user request into a **single, actionable plan** with atomic steps, TDD enforcement, and file-tracked context.

## Goal

Create a plan that a developer with zero context could follow exactly. DRY. YAGNI. TDD. Frequent commits.

## Workflow

### 1. Scan Context & Recover State

- Read `decision.md` (if Phase 1 brainstorm was run).
- Read any existing planning files: `task_plan.md`, `findings.md`, `progress.md`.
- Read `README.md`, docs, and relevant code files.
- Identify constraints (language, frameworks, tests).

### 2. Minimal Interaction

- Ask **at most 1–2 questions** and only if truly blocking.
- Make reasonable assumptions for non-blocking unknowns.

### 3. Initialize Planning Files

Create/Update these in the project/planning/[current plan title] directory (not the skill directory):

| File | Purpose |
|------|---------|
| `task_plan.md` | Phase tracking (Status: planning) |
| `findings.md` | Research, discoveries, architecture notes |
| `progress.md` | Session log, error table (init empty) |

### 4. Git Assessment

Assess the environment before planning steps:
- Current branch, remote, clean/dirty working tree.
- Determine if new branch needed (e.g. `feat/[name]`).

### 5. Generate Plan

Use the following structure. Save to `docs/plans/YYYY-MM-DD-<feature-name>.md` and link to it from `plan.md` in the project root.

---

## Plan Structure

### Header
```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence]
**Approach:** [2-3 sentences about architecture/approach]
**Branch:** `feat/[name]` (from `main`)

## Scope
- In: [What's included]
- Out: [What's excluded]
```

### Action Items (Bite-Sized & TDD-Focused)

**Important:** Batch task lists are stored in `task_plan.md`, NOT in this plan file. This plan file only contains batch goals and high-level structure.

Each batch is optimized for small context windows using context optimization techniques (see `skill.agents\skills\boss\ai-meta\context-optimization\SKILL.md`):

- **Compaction**: Summarize completed work in `progress.md` rather than keeping full details in context
- **Observation Masking**: Replace verbose tool outputs with references to `progress.md` entries
- **KV-Cache Optimization**: Keep stable context (goals, architecture) at start, variable content at end
- **Context Partitioning**: For complex batches, consider sub-agent isolation for independent subtasks
- **Budget Management**: Allocate context: 20% goals/approach, 30% current batch, 30% recent history, 20% buffer

Each batch explicitly uses todo tools for task management:
- Use `manage_todo_list` to break batches into atomic, trackable tasks
- Mark one todo as `in_progress` at a time (limit: 1)
- Update todo status immediately upon completion

```markdown
## Action Items

### Batch 1: Setup
**Batch Goal:** Establish project foundation and development environment
- [ ] **Commit:** `chore: initialize project setup`

### Batch 2: [Component/Feature]
**Batch Goal:** Implement core feature with TDD cycle
- [ ] **Commit:** `feat: implement [component/feature]`

### Batch 3: Test
**Batch Goal:** Ensure quality through comprehensive testing
- [ ] **Commit:** `test: verify [feature] functionality`

### Batch 4: Polish
**Batch Goal:** Refine code quality and readiness for review
- [ ] **Commit:** `chore: final code quality and cleanup`

### Final
- [ ] **Push:** `git push origin feature/[name]`
```

### Finalization
```markdown
## Open Questions
- [Zero to max 3 blocking questions]

## Verification
- [ ] All tests pass
- [ ] Coverage ≥ 70%
- [ ] Lint/Format clean
```

---

## Checklist Guidelines

- **Atomic:** Each step is one action (2-5 minutes).
- **Verb-first:** "Add...", "Refactor...", "Verify...".
- **Concrete:** Exact file paths and line numbers always.
- **Reproducible:** Exact commands with expected output.
- **TDD:** Never write code without a failing test first.
- **DRY/YAGNI:** Keep it minimal and avoid duplication.

## Context Hygiene (from planning-with-files)

- **2-Action Rule:** Write key findings to `findings.md` every 2 operations.
- **Read Before Decide:** Re-read the plan file before major decisions.
- **Log ALL Errors:** Every error goes in the error table in `progress.md`.
- **3-Strike Error Protocol:**
  1. Fix specific error.
  2. Try alternative approach.
  3. STOP, revert, update plan, ask user.

## 5-Question Reboot Test

Before executing, ensure you can answer:
1. **Where am I?** (Current batch in plan)
2. **Where am I going?** (Next batch)
3. **What's the goal?** (Header statement)
4. **What have I learned?** (findings.md)
5. **What have I tried?** (progress.md)

## Execution Handoff

After saving the plan, offer execution choice:
1. **Subagent-Driven:** This session, fresh subagent per batch.
2. **Parallel Session:** New session with `executing-plans`, batch execution.
