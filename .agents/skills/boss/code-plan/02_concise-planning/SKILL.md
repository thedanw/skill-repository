---
name: 02_concise-planning
description: "Use when a user asks for a plan for a coding task. Generates a clear, actionable, atomic checklist following TDD and git-best practices, while initializing file-based context tracking. Optimized for small context LLMs with subphase breakdowns, evolving context statements, and mandatory todo/subagent usage."
category: code-plan
risk: safe
source: adapted
tags: [planning, checklist, tasks, scope, tdd, git, context, organization, small-context, subagents]
triggers: [plan, checklist, scope, action-items, tasks, roadmap, implementation-plan, write-plan]
---

# Concise Planning (Token-Optimized for Small Context LLMs)

Turn a user request into a **single, actionable plan** with atomic steps, TDD enforcement, and file-tracked context. Every phase broken into small subphases with evolving context statements to prevent context loss.

## Goal

Create a plan a developer with zero context could follow exactly. DRY. YAGNI. TDD. Frequent commits. Optimized for small context windows.

## Workflow

1. **Scan Context** — Read `decision.md`, `task_plan.md`, `findings.md`, `progress.md`, `README.md`, relevant code; identify constraints
2. **Minimal Interaction** — Ask ≤2 blocking questions; assume rest
3. **Initialize Planning Files** in `project/planning/[plan-title]/`:
   - `task_plan.md` — Phase tracking (Status: planning)
   - `findings.md` — Research, discoveries, architecture notes
   - `progress.md` — Session log, error table (init empty)
4. **Git Assessment** — Branch, remote, clean/dirty; determine if `feat/[name]` needed
5. **Generate Plan** — Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`, link from `plan.md`

## Plan Structure

### Header
```
# [Feature Name] Implementation Plan
Goal: [One sentence]
Approach: [2-3 sentences]
Branch: `feat/[name]` (from `main`)
Scope: In: [...] | Out: [...]
```

### Checklist Guidelines
- **Atomic**: One action (2-5 min)
- **Verb-first**: "Add...", "Refactor...", "Verify..."
- **Concrete**: Exact file paths and line numbers
- **Reproducible**: Exact commands with expected output
- **TDD**: Never write code without failing test first
- **DRY/YAGNI**: Minimal, no duplication

### Context Hygiene
- **2-Action Rule**: Write key findings to `findings.md` every 2 ops
- **Read Before Decide**: Re-read plan before major decisions
- **Log ALL Errors**: Every error → error table in `progress.md`
- **3-Strike Error Protocol**: Fix → Alternative → STOP/revert/ask

### Context Caching
Order: stable (system prompt, tool defs) → frequent reuse → unique last.

### 5-Question Reboot Test
1. Where am I? (Current batch)
2. Where am I going? (Next batch)
3. What's the goal? (Header)
4. What have I learned? (findings.md)
5. What have I tried? (progress.md)

### Execution Handoff
1. **Subagent-Driven**: Fresh subagent per batch this session
2. **Parallel Session**: New session with `executing-plans`, batch execution

---

## Phase Execution Protocol (Small Context Optimized)

### Universal Requirements (EVERY Phase)

**Evolving Context Statement** — Start of EVERY phase:
```
## Phase Context: [Name]
- Goal: [One sentence]
- Previous: [2-3 sentences from progress.md]
- Key Findings: [Ref findings.md]
- Current State: [Done, blocked, next]
- Budget: Stable 20% | Current 30% | History 30% | Buffer 20%
```

**Mandatory Tools** — EVERY phase:
- `manage_todo_list` — Atomic tasks, max 1 in-progress
- Subagents — For independent subtasks (context partitioning)
- Update `progress.md` — Log every action, error, decision, completion

**Doc Optimization**:
- ≤200 lines per phase
- Use refs (`see progress.md#section`) not inline details
- Summarize completed work; no full history repeat
- Stable context top; variable bottom

### Subphase Template (Max 5 per Phase)
```
### Phase N: [Name]

#### Subphase N.1: [Name]
Context: [Evolving context statement]
Todo: [manage_todo_list atomic tasks]
Subagent: [Yes if independent >5 min]
Progress: [Update progress.md on done]
Deliverable: [Concrete output]
```

### Standard Phases & Subphases

**Default Context Budget**: Stable 20% | Current 30% | History 30% | Buffer 20% (adjust per subphase)

#### Phase 1: Setup & Foundation
| Subphase | Goal | Context (Prev → Current) | Todo | Subagent | Deliverable |
|----------|------|--------------------------|------|----------|-------------|
| 1.1 Env Init | Initialize project structure & dev env | None → Fresh workspace | Create structure, configs, deps | No | Working dev env |
| 1.2 Core Infra | CI, linting, test framework | Env initialized → Ready for infra | Configure CI/CD, lint, test | Yes (parallel) | Running CI pipeline |
| 1.3 Arch Decisions | Document key architecture decisions | Infra ready → Need ADRs | Write ADRs | No | ADRs in findings.md |

#### Phase 2: Core Implementation
| Subphase | Goal | Context (Prev → Current) | Todo | Subagent | Deliverable |
|----------|------|--------------------------|------|----------|-------------|
| 2.1 Data Models | Define core types, interfaces, schemas | Arch decided → Ready for models | Create type defs, interfaces | Yes (parallel) | Type definitions |
| 2.2 Business Logic | Implement logic TDD: test→impl→refactor | Models defined → Writing failing tests | Write failing tests → implement | Yes (per component) | Tested business logic |
| 2.3 API Layer | Expose functionality via API/interface | Logic tested → Building interfaces | Create routes, controllers | Yes (parallel) | Working API |
| 2.4 Integration | Wire components together | API ready → Integration | Connect layers, DI, middleware | No | End-to-end feature |

#### Phase 3: Testing & Quality
| Subphase | Goal | Context (Prev → Current) | Todo | Subagent | Deliverable |
|----------|------|--------------------------|------|----------|-------------|
| 3.1 Unit Coverage | Achieve ≥70% unit coverage | Feature integrated → Running tests | Add missing unit tests | Yes (parallel) | ≥70% coverage |
| 3.2 Integration | Verify cross-component behavior | Unit tests pass → Writing integration | Write integration scenarios | Yes (parallel) | Passing integration tests |
| 3.3 E2E/Contract | Validate full user flows | Integration pass → E2E testing | Write critical journey tests | No | Verified user flows |

#### Phase 4: Polish & Delivery
| Subphase | Goal | Context (Prev → Current) | Todo | Subagent | Deliverable |
|----------|------|--------------------------|------|----------|-------------|
| 4.1 Code Quality | Clean up, remove tech debt | All tests pass → Refactoring | Lint, format, dead code, names | Yes (parallel) | Clean codebase |
| 4.2 Documentation | Document for maintainers | Code clean → Writing docs | Update README, API docs, runbooks | Yes (parallel) | Complete docs |
| 4.3 Release Prep | Prepare for merge/release | Docs done → Release prep | Version bump, changelog, tag, push | No | Ready-to-merge branch |

---

### Progress.md Update Protocol (MANDATORY Every Subphase)

At end of EVERY subphase, append to `progress.md`:

```markdown
## [Phase N.Subphase] - [Date/Time]

### Context Snapshot
- Phase: [Name] | Subphase: [Name] | Goal: [One sentence] | Status: [Complete/Partial/Blocked]

### Actions Taken
- [ ] Task: [Description] → [Result]

### Errors
| Error | Fix Attempted | Resolution |
|-------|---------------|------------|

### Decisions
- [Decision]: [Rationale]

### Next: [Next subphase goal]

### Budget: Stable X% | Current Y% | History Z% | Buffer W%
```

---

### Subagent Spawning Rules

**Spawn When**:
- Independent subtasks >5 min
- Parallel file ops (tests, configs, docs)
- Research/discovery
- Benefits from fresh context

**Don't Spawn When**:
- Sequential dependencies
- Simple edits <2 min
- Shared mutable state required

**Subagent Prompt**:
```
Task: [Subphase goal]
Context: [Parent phase evolving context]
Deliverable: [Concrete output]
Constraints: [TDD, file paths, patterns]
Update: Write to findings.md, log to progress.md
```
