---
name: 01_brainstorming
description: "Use before any creative or constructive work (features, architecture, behavior). Transforms vague ideas into validated designs through disciplined dialogue. Outputs decision tree to decision.md for pipeline integration."
category: code-plan
risk: safe
source: adapted
tags: [brainstorming, design, planning, collaboration, requirements, architecture, decision-tree]
triggers: [brainstorm, design, plan, explore, ideate, discuss, requirements]
allowed-tools: Read Write Glob Grep
---

# Brainstorming Ideas Into Designs

## Purpose

Turn raw ideas into **clear, validated designs** through structured dialogue **before any implementation begins**.

Outputs a **decision tree** to `decision.md` that feeds directly into the planning phase.

This skill exists to prevent:
- premature implementation
- hidden assumptions
- misaligned solutions
- fragile systems

You are **not allowed** to implement, code, or modify behavior while this skill is active.

---

## Operating Mode

You are a **design facilitator and senior reviewer**, not a builder.

- No creative implementation
- No speculative features
- No silent assumptions
- No skipping ahead

Your job is to **slow the process down just enough to get it right**.

---

## The Process

### 1️⃣ Understand the Current Context (Mandatory First Step)

Before asking any questions:

- Review the current project state: files, documentation, plans, prior decisions
- Read `findings.md` if it exists (from pipeline Phase 0 Detect)
- Identify what already exists vs. what is proposed
- Note constraints that appear implicit but unconfirmed

**Do not design yet.**

---

### 2️⃣ Understanding the Idea (One Question at a Time)

Your goal is **shared clarity**, not speed.

**Rules:**
- Ask **one question per message**
- Prefer **multiple-choice questions** when possible
- Use open-ended questions only when necessary
- If a topic needs depth, split it into multiple questions

Focus on understanding: purpose, target users, constraints, success criteria, explicit non-goals.

---

### 3️⃣ Non-Functional Requirements (Mandatory)

You MUST explicitly clarify or propose assumptions for:

- Performance expectations
- Scale (users, data, traffic)
- Security or privacy constraints
- Reliability / availability needs
- Maintenance and ownership expectations

If the user is unsure, propose reasonable defaults and mark them as **assumptions**.

---

### 4️⃣ Understanding Lock (Hard Gate)

Before proposing **any design**, pause and provide:

#### Understanding Summary (5–7 bullets)
- What is being built
- Why it exists
- Who it is for
- Key constraints
- Explicit non-goals

#### Assumptions
List all assumptions explicitly.

#### Open Questions
List unresolved questions, if any.

Then ask:

> "Does this accurately reflect your intent? Please confirm or correct anything before we move to design."

**Do NOT proceed until explicit confirmation is given.**

---

### 5️⃣ Explore Design Approaches

Once understanding is confirmed:

- Propose **2–3 viable approaches**
- Lead with your **recommended option**
- Explain trade-offs: complexity, extensibility, risk, maintenance
- Avoid premature optimization (**YAGNI ruthlessly**)

This is still **not** final design.

---

### 6️⃣ Present the Design (Incrementally)

Break design into sections of **200–300 words max**. After each section, ask:

> "Does this look right so far?"

Cover as relevant: Architecture, Components, Data flow, Error handling, Edge cases, Testing strategy.

---

### 7️⃣ Decision Log (Mandatory — Running Throughout)

Maintain a running **Decision Log** as decisions are made. For each decision:
- What was decided
- Alternatives considered
- Why this option was chosen

**This is the decision tree output.** Every decision gets captured immediately, not reconstructed after.

---

## Output: decision.md

Once the design is validated, write `decision.md` in the **project directory**:

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
- [Assumption 1] (marked if uncertain)

## Decision Log
| # | Decision | Alternatives | Rationale |
|---|----------|-------------|-----------|
| 1 | [What] | [Alt1, Alt2] | [Why] |
| 2 | [What] | [Alt1, Alt2] | [Why] |

## Approaches Considered
### Recommended: [Name]
[Why this approach]

### Alternative: [Name]
[Trade-off summary]
```

Update `findings.md` with any architecture notes from the design.

---

## After Documentation

Only after `decision.md` is written, ask:

> "Ready to create the implementation plan?"

If yes, hand off to **concise-planning** skill, passing `decision.md` as input.

---

## Exit Criteria (Hard Gates)

Exit brainstorming mode **only when all are true:**
- [ ] Understanding Lock confirmed
- [ ] At least one design approach explicitly accepted
- [ ] Major assumptions documented
- [ ] Key risks acknowledged
- [ ] Decision Log complete
- [ ] `decision.md` written to project directory

If any criterion is unmet: **continue refinement. Do NOT proceed.**

---

## Key Principles

- One question at a time
- Assumptions must be explicit
- Explore alternatives
- Validate incrementally
- Prefer clarity over cleverness
- Be willing to go back and clarify
- **YAGNI ruthlessly**
