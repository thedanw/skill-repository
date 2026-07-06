---
name: 00_meta-plan-pipeline
description: "Orchestrate the full development workflow: brainstorm → plan → review-execute → review. Coordinates 01_brainstorming, 02_concise-planning, and 03_executing-plans into one consistent pipeline with decision tree output, file-tracked context, git integration, and quality gates."
category: code-plan
risk: safe
source: local
tags: [pipeline, orchestration, brainstorm, plan, execute, review, workflow, git, testing, quality]
triggers: [build, create, develop, implement, start-project, new-feature, dev, pipeline]
---

# Dev Pipeline

Orchestrate the full development workflow. Four stages, file-tracked context, git integration, quality gates.

## Pipeline Overview

```
┌─────────────┐   ┌─────────────┐   ┌───────────────────┐   ┌──────────┐
│  BRAINSTORM  │──▶│    PLAN     │──▶│  EXECUTE & REVIEW │──▶│  REVIEW  │
│             │   │             │   │  (batch loops)    │   │          │
│ 01-decision.md │   │ 02-plan.md     │   │ 03-context files     │   │ 04-summary  │
│ decision    │   │ scope       │   │ git commits       │   │ options  │
│ tree        │   │ action items│   │ checkpoints       │   │          │
└─────────────┘   └─────────────┘   └───────────────────┘   └──────────┘
      │                 │                     │                    │
      ▼                 ▼                     ▼                    ▼
 01_brainstorming    02_concise-planning      03_executing-plans       00_meta-plan-pipeline
                                         (per batch)
```

**Sub-skills used:**

- **01_brainstorming** — Phase 1: Design facilitation, decision tree output
- **02_concise-planning** — Phase 2: Atomic plan with TDD, git steps, file tracking
- **03_executing-plans** — Phase 3: Batch execution with checkpoints, context updates

---

## File Conventions

All planning files live in the **project directory** (where code lives):

| File | Purpose | Created By | Updated By |
|------|---------|------------|------------|
| `decision.md` | Decision tree, assumptions, constraints | Phase 1 | — |
| `plan.md` | Atomic action items, scope, git steps | Phase 2 | User (if plan changes) |
| `task_plan.md` | Phase/task progress tracking | Phase 2 (init) | Phase 3 (per batch) |
| `findings.md` | Research, discoveries | Phase 1 (context) | Phase 2 (scan), Phase 3 (discoveries) |
| `progress.md` | Session log, errors, test results | Phase 2 (init) | Phase 3 (per batch) |

---

## Phase 1: BRAINSTORM

**Skill:** `01_brainstorming/SKILL.md`

### Goal

Transform the user's idea into a validated design with a decision tree captured in `decision.md`.

### Process

1. Read `01_brainstorming/SKILL.md` — follow its full process
2. Scan project context: existing files, docs, README
3. Ask one question at a time — understand purpose, users, constraints
4. Clarify non-functional requirements (performance, scale, security)
5. Present **Understanding Summary** → get explicit confirmation (Understanding Lock)
6. Explore 2-3 design approaches with trade-offs
7. Maintain running **Decision Log** — every decision captured as it's made (not after)
8. Write `decision.md` with the complete decision tree

### Mode Adaptations

| Project State | Behavior |
|--------------|----------|
| Empty / no source | Greenfield — full brainstorm from scratch |
| Source, no tests | In-Progress — focus on what changes vs exists |
| Source + tests + CI | Mature — abbreviated, confirm scope, find integration points |
| "fix this bug" | Targeted — minimal brainstorm, identify affected files |

### Output: decision.md

```markdown
# Decision: [Feature Name]

## What & Why
[What is being built and why]

## Who
[Target users]

## Constraints
- [Constraint 1]
- [Constraint 2]

## Non-Goals
- [Explicit out-of-scope item]

## Assumptions
- [Assumption 1] (marked ⚠️ if uncertain)

## Decision Log
| # | Decision | Alternatives | Rationale |
|---|----------|-------------|-----------|
| 1 | [What] | [Alt1, Alt2] | [Why] |

## Approaches Considered
### Recommended: [Name]
[Why this approach]

### Alternative: [Name]
[Trade-off summary]
```

### Gate (Hard Stops)

- [ ] Understanding Lock confirmed by user
- [ ] At least one design approach accepted
- [ ] Decision Log complete (every decision captured)
- [ ] `decision.md` written to project directory

**Do NOT proceed to Phase 2 until all gates pass.**

---

## Phase 2: PLAN

**Skill:** `02_concise-planning/SKILL.md`

### Goal

Create an atomic, TDD-focused implementation plan optimized for small context steps. Incorporate decisions from the decision tree. Initialize file-tracked context.

### Process

1. Read `decision.md` — incorporate every decision into plan scope and approach
2. Read `findings.md` — understand existing project state
3. **Git Assessment:**

   ```powershell
   git status --short
   git branch --show-current
   git remote -v
   git log --oneline -5
   ```

4. Initialize planning files: `task_plan.md`, `findings.md`, `progress.md`
5. Generate atomic plan with:
   - Approach incorporating decision tree choices
   - Scope (In/Out) from decision Non-Goals
   - Batches of 3-5 bite-sized tasks (2-5 min each)
   - TDD cycle for every coding task (write failing test → implement → verify)
   - Git steps: branch creation, commit per batch, push at end
   - Required: at least one test batch, one polish batch
6. Save to `plan.md`

### Git Strategy

Include in plan:

- **Branch:** `feature/[short-name]` from `main`
- **Commit points:** After each batch with conventional messages (`feat:`, `test:`, `chore:`, `docs:`, `fix:`)
- **Push:** After all batches complete

### Output: plan.md

```markdown
# Plan: [Feature Name]

**Goal:** [One sentence from decision]
**Approach:** [2-3 sentences incorporating decision tree choices]
**Branch:** `feature/[short-name]` (from `main`)

## Scope
- In: [From decision — what's included]
- Out: [From decision Non-Goals]

## Action Items

### Batch 1: Setup
- [ ] Task 1.1: [Specific setup step]
- [ ] Task 1.2: [Initial file creation]
- [ ] **Commit:** `chore: [description]`

### Batch 2: [Component] (TDD)
- [ ] Task 2.1: **Write failing test** for [behavior]
  Code: `tests/exact/path.py`
- [ ] Task 2.2: **Run test** to verify it fails
  Run: `pytest tests/path.py::test_name`
  Expected: FAIL
- [ ] Task 2.3: **Implement minimal code** to pass
  Code: `exact/path/to/file.py`
- [ ] Task 2.4: **Run test** to verify it passes
  Run: `pytest tests/path.py::test_name`
  Expected: PASS
- [ ] **Commit:** `feat: add [behavior]`

### Batch 3: Test
- [ ] Run all tests, verify coverage ≥ 70%
- [ ] **Commit:** `test: verify coverage for [feature]`

### Batch 4: Polish
- [ ] Lint + format + type check
- [ ] Remove dead code / debug statements
- [ ] **Commit:** `chore: lint, format, cleanup`

### Final
- [ ] **Push:** `git push origin feature/[name]`

## Validation
- [ ] All tests pass
- [ ] Coverage ≥ 70%
- [ ] No lint/type errors
- [ ] Build succeeds

## Open Questions
- [Blocking questions, max 3]
```

Initialize `task_plan.md`:

```markdown
# Task Plan: [Feature Name]

## Status: planning

| Phase | Status | Notes |
|-------|--------|-------|
| Brainstorm | complete | decision.md written |
| Plan | in_progress | |
| Execute & Review | pending | |
| Review | pending | |
```

### Gate (Hard Stops)

- [ ] `plan.md` complete with atomic action items
- [ ] Every coding task follows TDD cycle
- [ ] At least one test batch included
- [ ] At least one polish batch included
- [ ] Git branch strategy determined
- [ ] Planning files initialized (`task_plan.md`, `findings.md`, `progress.md`)
- [ ] User confirms plan

**Do NOT proceed to Phase 3 until user confirms plan.**

---

## Phase 3: EXECUTE & REVIEW (Batch Loops)

**Skill:** `03_executing-plans/SKILL.md`

### Goal

Execute the plan in batches. After each batch: update context files, git commit, report to user for review. The review-between-batches is what makes this "review-execute" — not a separate phase but an integral part of every batch loop.

### Context Recovery (If Resuming)

Before starting or resuming, read ALL planning files:

1. `decision.md` — what was decided and why
2. `plan.md` — what to build
3. `task_plan.md` — where we left off
4. `progress.md` — what was tried, what failed
5. `findings.md` — what was learned

### Process (Per Batch)

```
┌──────────────────────────────────────────────────────────────┐
│                      BATCH LOOP                              │
│                                                              │
│  1. Load plan → find next pending batch                     │
│  2. Execute tasks (default 3, or remaining)                 │
│  3. Update task_plan.md (mark tasks complete)               │
│  4. Update progress.md (log results + errors)               │
│  5. Git commit (conventional message)                        │
│  6. REPORT to user (what was built + verification)          │
│  7. USER REVIEW → approve, adjust, or rework               │
│  8. If approved → next batch | If done → Phase 4           │
└───────────────────────────────────────────-──────────────────┘
```

### Batch Execution

For each task in the batch:

1. Mark `in_progress` in `task_plan.md`
2. Follow plan steps exactly
3. Run verifications as specified
4. Mark `completed` in `task_plan.md`
5. Log errors to `progress.md`

**Coding Standards (all batches):**

1. **Read before write** — Read 2-3 similar files before creating new ones
2. **Match conventions** — Follow existing naming, import style, architecture
3. **No type suppression** — Never use `as any`, `@ts-ignore`, or equivalent
4. **Never delete failing tests** — Fix the code, not the test
5. **Never leave broken state** — If tests fail, fix before moving on

### Report (After Each Batch)

Update `progress.md`:

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

- What was implemented (referencing decision tree choices)
- Verification output (tests, lint, build)
- Say: **"Batch [N] complete. Ready for feedback."**

### User Review (After Each Batch)

The user can:

1. **Approve** → proceed to next batch
2. **Adjust** → modify remaining plan, continue
3. **Rework** → go back to brainstorm or plan phase

This is the "review" in "review-execute" — it happens between every batch, not at the end.

### Git Integration

After each approved batch:

```powershell
git add -A
git commit -m "[type]: [batch description] — tasks N-N"
```

After all batches:

```powershell
git push origin [branch-name]
```

### Error Handling (3-Strike Protocol)

1. **Strike 1:** Diagnose and fix. Log to `progress.md`.
2. **Strike 2:** Different approach. Log to `progress.md`.
3. **Strike 3:** STOP. Revert. Document in `progress.md`. Ask user.

**Never repeat the exact same failing action.**

### Gate

- [ ] All batches complete
- [ ] All batches committed
- [ ] Tests pass (from test batch)
- [ ] Lint clean (from polish batch)
- [ ] Branch pushed
- [ ] User approved final batch

---

## Phase 4: REVIEW

### Goal

Final summary. Show what was built vs planned. Present completion options.

### Process

1. Read `task_plan.md` and `progress.md` for full summary
2. Show what was built vs plan (referencing decisions)
3. Show git log / branch status
4. Present options

### Output

```markdown
## Review: [Feature Name]

### Built vs Plan
| Decision/Plan | Built | Notes |
|---------------|-------|-------|
| [Decision 1] | ✅ | [How it was implemented] |
| [Decision 2] | ✅ | |
| [Batch 2: Component] | ✅ | |

### Quality Metrics
- Tests: [N] passing, [coverage]% coverage
- Lint: clean / [N] warnings
- Commits: [N] on branch

### Git Summary
- Branch: `[branch]`
- Commits: `[N] conventional commits`
- Status: [clean/dirty]

### Options
1. **Merge** — merge feature branch to main
2. **Iterate** — go back to brainstorm or plan phase
3. **Cleanup** — close branch, keep for later
4. **Ship** — merge + push + tag release
```

---

## Anti-Patterns (Hard Stops — Never Do These)

| Wrong | Why | Correct |
|-------|-----|---------|
| Skipping brainstorm for "simple" tasks | Hidden assumptions cause rework | Always brainstorm first |
| Planning without reading decision.md | Loses decision tree context | Always read decision first |
| No TDD in plan | No quality gate | Every coding task: failing test first |
| No test batch in plan | Tests are optional, not plan items | Every plan needs ≥1 test batch |
| Executing without reading planning files | Can't recover context | Always read all files first |
| Not updating task_plan.md | Lost progress tracking | Update after every task |
| Not updating progress.md | Can't resume if interrupted | Update after every batch |
| Skipping git commits | No rollback point | Commit after every batch |
| No checkpoint report | User can't course-correct | Report after every batch |
| Forcing through blockers | Wastes time, breaks things | 3-strike protocol: stop and ask |
