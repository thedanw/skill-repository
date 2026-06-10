---
name: boss
description: "Meta-skill orchestrator for the Antigravity skill repository. Discovers, selects, and coordinates skills from curated awesome-skills and custom domain skills. Low-token discovery via BOSS_INDEX.json."
category: meta
risk: safe
source: custom
tags: [orchestration, meta-skill, discovery, skill-management]
---

# Boss — Meta-Skill Orchestrator

## Purpose

Boss is the central skill coordinator for this Antigravity workspace. It provides a **low-token discovery mechanism** to find and activate the right skill for any task, then coordinates multi-skill execution for complex work.

## Discovery Protocol (Read This First)

**Before any task**, follow this protocol:

### Step 1: Evaluate Task Complexity

- **Simple task** (single file edit, quick search, basic question) → Solve directly. Do NOT load any skill.
- **Complex task** (multi-step, multi-domain, requires specialized knowledge) → Proceed to Step 2.

### Step 2: Read the Index

Read `BOSS_INDEX.json` (this folder). It contains a compact mapping of all available skills:

```json
{
  "id": "brainstorming",
  "name": "brainstorming",
  "category": "workflow",
  "description": "Use before creative or constructive work...",
  "triggers": ["brainstorm", "ideate", "plan", "creative"],
  "path": "awesome/brainstorming",
  "source": "awesome-skills"
}
```

Match the task to skills using:
1. **Trigger keywords** in the task description
2. **Category** alignment
3. **Description** relevance

### Step 3: Load and Execute

- **1 skill matched** → Load its `SKILL.md`, follow its instructions.
- **2+ skills matched** → Determine orchestration pattern:
  - **Pipeline**: Output of one feeds into the next (e.g., brainstorm → code → test)
  - **Parallel**: Independent skills working on different aspects
  - **Primary + Support**: One lead skill, others provide supplementary data

## Available Skill Sources

### Awesome Skills (`awesome/`)
Curated subset from [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills). Installed via:

```powershell
npx antigravity-awesome-skills --path ".agents/skills/boss/awesome" --category development,workflow --risk safe
```

### Custom Skills (`custom/`)
Domain-specific skills for this workspace:
- `nlac-gospel-preaching` — Sermon preparation and Bible study workflows
- `nlac-twick` — Twick video studio development
- `nlac-wordpress` — WordPress content management
- `nlac-css-architecture` — CSS design system patterns

## Orchestration Patterns

### Pattern 1: Pipeline (Sequential)
```
Task → Skill A → Skill B → Skill C → Result
```
Use when skills form a chain (planning → implementation → testing).

### Pattern 2: Parallel (Independent)
```
Task → [Skill A, Skill B, Skill C] → Aggregated Result
```
Use when skills work on independent aspects simultaneously.

### Pattern 3: Primary + Support
```
Task → Primary Skill (leads) + Support Skill (provides data) → Result
```
Use when one skill clearly dominates and others supplement.

## Adding New Skills

1. Create a folder under `awesome/` or `custom/`
2. Add a `SKILL.md` with YAML frontmatter (name, description, category, tags)
3. Run `update-index.ps1` to regenerate `BOSS_INDEX.json`
4. Commit and push to GitHub

## Updating from Awesome-Skills

To pull in new skills from the upstream repo:

```powershell
# Re-run the installer with desired categories
npx antigravity-awesome-skills --path ".agents/skills/boss/awesome" --category development,workflow,design --risk safe

# Rebuild the index
.agents/skills/boss/update-index.ps1
```

## Guardrails

- **Do NOT** use specialized skills for simple tasks
- **Do NOT** load more than 3-4 skills at once
- **Do NOT** create new skills — only combine existing ones
- **Always** evaluate complexity before invoking skills
