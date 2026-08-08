---
name: 02_concise-planning
description: "Use when a user asks for a plan for a coding task. Generates a clear, actionable, atomic checklist following TDD and git-best practices, while initializing file-based context tracking."
category: code-plan
risk: safe
source: adapted
tags: [planning, checklist, tasks, scope, tdd, git, context, organization]
triggers: [plan, checklist, scope, action-items, tasks, roadmap, implementation-plan, write-plan]
---

# Concise Planning (Token-Optimized)

Turn a user request into a **single, actionable plan** with atomic steps, TDD enforcement, and file-tracked context.

## Goal

Create a plan a developer with zero context could follow exactly. DRY. YAGNI. TDD. Frequent commits.

## Workflow

### 1. Scan Context & Recover State

- Read `decision.md` (if Phase 1 brainstorm was run)
- Read existing planning files: `task_plan.md`, `findings.md`, `progress.md`
- Read `README.md`, docs, relevant code files
- Identify constraints (language, frameworks, tests)

### 2. Minimal Interaction

- Ask ≤2 questions, only if truly blocking
- Make reasonable assumptions for non-blocking unknowns

### 3. Initialize Planning Files

Create/update in `project/planning/[plan-title]/` (not skill dir):

| File | Purpose |
|------|---------|
| `task_plan.md` | Phase tracking (Status: planning) |
| `findings.md` | Research, discoveries, architecture notes |
| `progress.md` | Session log, error table (init empty) |

### 4. Git Assessment

- Current branch, remote, clean/dirty working tree
- Determine if new branch needed (e.g. `feat/[name]`)

### 5. Generate Plan

Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`, link from `plan.md` in project root.

---

## Plan Structure

### Header
```
# [Feature Name] Implementation Plan

Goal: [One sentence]
Approach: [2-3 sentences on architecture/approach]
Branch: `feat/[name]` (from `main`)

Scope
- In: [What's included]
- Out: [What's excluded]
```

### Action Items (Bite-Sized & TDD-Focused)

**Key:** Batch task lists in `task_plan.md`, NOT this file. This file = batch goals + high-level structure.

Each batch optimized for small context windows (see `skill.agents\skills\boss\ai-meta\context-optimization\SKILL.md`):

- **Compaction**: Summarize completed work in `progress.md` vs full details in context
- **Observation Masking**: Replace verbose outputs with `progress.md` refs
- **KV-Cache**: Stable context (goals, architecture) at start, variable at end
- **Context Partitioning**: Sub-agent isolation for independent subtasks
- **Budget**: 20% goals/approach, 30% current batch, 30% recent history, 20% buffer

Each batch uses todo tools:
- `manage_todo_list` → atomic, trackable tasks
- One `in_progress` at a time (limit: 1)
- Update status immediately on completion

```
Action Items

Batch 1: Setup
Goal: Establish project foundation and dev environment
- [ ] Commit: `chore: initialize project setup`

Batch 2: [Component/Feature]
Goal: Implement core feature with TDD cycle
- [ ] Commit: `feat: implement [component/feature]`

Batch 3: Test
Goal: Ensure quality through comprehensive testing
- [ ] Commit: `test: verify [feature] functionality`

Batch 4: Polish
Goal: Refine code quality and readiness for review
- [ ] Commit: `chore: final code quality and cleanup`

Final
- [ ] Push: `git push origin feature/[name]`
```

### Finalization
```
Open Questions
- [Zero to max 3 blocking questions]

Verification
- [ ] All tests pass
- [ ] Coverage ≥ 70%
- [ ] Lint/Format clean
```

---

## Checklist Guidelines

- **Atomic**: One action (2-5 min)
- **Verb-first**: "Add...", "Refactor...", "Verify..."
- **Concrete**: Exact file paths and line numbers
- **Reproducible**: Exact commands with expected output
- **TDD**: Never write code without failing test first
- **DRY/YAGNI**: Minimal, no duplication

## Context Hygiene (from planning-with-files)

- **2-Action Rule**: Write key findings to `findings.md` every 2 ops
- **Read Before Decide**: Re-read plan before major decisions
- **Log ALL Errors**: Every error → error table in `progress.md`
- **3-Strike Error Protocol**:
  1. Fix specific error
  2. Try alternative approach
  3. STOP, revert, update plan, ask user

## Context Caching Optimisation
Order context to maximize cache hits: stable elements first (system prompt, tool defs), then frequent reuse, unique last.

## 5-Question Reboot Test

Before executing, answer:
1. **Where am I?** (Current batch)
2. **Where am I going?** (Next batch)
3. **What's the goal?** (Header statement)
4. **What have I learned?** (findings.md)
5. **What have I tried?** (progress.md)

## Execution Handoff

After saving plan, offer:
1. **Subagent-Driven**: This session, fresh subagent per batch
2. **Parallel Session**: New session with `executing-plans`, batch execution
