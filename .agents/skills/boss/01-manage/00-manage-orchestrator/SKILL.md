---
name: manage-orchestrator
description: "Orchestrate the BOSS skill management sub-skills at .agents/skills/boss/01-manage/. Coordinates skill-create, skill-aquire, and skill-manage sub-skills for creating, acquiring, and managing skills in the BOSS repository. Use when managing, creating, acquiring, or maintaining skills in the boss skill library."
category: meta
risk: safe
source: local
tags: [orchestrator, repository, skill-management, boss, manage, 01-manage]
triggers: [manage, create, acquire, install, validate, index, search, add, remove, update, skill-create, skill-aquire, skill-manage]
allowed-tools: Read Write Glob Grep Bash
---

# Manage Orchestrator

> **LOCATION: `.agents/skills/boss/01-manage/00-manage-orchestrator/`**
> 
> This orchestrator coordinates the three skill-management sub-skills located in `.agents/skills/boss/01-manage/`:
> - `skill-create/` — Create new skills or adapt existing ones → outputs to `boss/` category folders
> - `skill-aquire/` — Search and install skills from awesome-skills GitHub repo → outputs to `boss/` category folders
> - `skill-manage/` — Manage `boss/` category folders, keep `BOSS_INDEX.json` in sync

## Target Directory

**All skills managed by this orchestrator go to:**

```
.agents/skills/boss/<category>/<skill-name>/
```

**Never here (tooling only):**

```
.agents/skills/boss/01-manage/        ← TOOLING ONLY, not for skills
```

## Sub-Skills

| Sub-skill | Location | Purpose |
|-----------|----------|---------|
| **skill-create** | `../skill-create/` | Create new skills or adapt existing ones → outputs to `boss/` |
| **skill-aquire** | `../skill-aquire/` | Search and install skills from awesome-skills GitHub repo → outputs to `boss/` |
| **skill-manage** | `../skill-manage/` | Manage `boss/` category folders, keep `BOSS_INDEX.json` in sync |

## Workflow

### 1. Determine Intent

Identify what the user wants:

- **Create/adapt a skill** → delegate to `../skill-create/skill-creator/SKILL.md`
- **Validate a skill** → delegate to `../skill-create/skill-check/SKILL.md`
- **Search/install external skill** → delegate to `../skill-aquire/SKILL.md`
- **Manage categories/index** → delegate to `../skill-manage/SKILL.md`
- **Rebuild BOSS_INDEX.json** → run `../../boss/update-index.ps1`
- **Audit the repo** → scan for missing fields, empty tags, duplicates

### 2. Delegate

Read the relevant sub-skill's SKILL.md and follow its process. Each sub-skill is responsible for placing skills in the correct `boss/<category>/` folder.

### 3. Confirm Target

Before any write operation, verify the target path:

```
CORRECT: .agents/skills/boss/<category>/<skill-name>/
WRONG:   .agents/skills/boss/01-manage/<anything>/
WRONG:   .agents/skills/<skill-name>/              (no category folder)
```

If a sub-skill tries to write outside `boss/`, **stop and correct**.

### 4. Update Index

After any add/remove/update to `boss/`, rebuild the index:

```powershell
powershell -ExecutionPolicy Bypass -File ../../boss/update-index.ps1
```

## Repo Structure

```
.agents/skills/
├── boss/                    ← SKILLS LIVE HERE (target for all operations)
│   ├── BOSS_INDEX.json      ← master skill registry
│   ├── update-index.ps1     ← index rebuild script
│   ├── SKILL.md             ← BOSS meta-orchestrator
│   ├── 01-manage/           ← SKILL MANAGEMENT TOOLING
│   │   ├── 00-manage-orchestrator/  ← THIS ORCHESTRATOR
│   │   ├── skill-create/    ← skill creation tools
│   │   │   ├── skill-creator/   ← scaffold + write skills
│   │   │   └── skill-check/     ← validate skills
│   │   ├── skill-aquire/    ← external skill discovery
│   │   │   └── awesome-skills_index.json
│   │   └── skill-manage/    ← category & index management
│   ├── code-plan/           ← planning, brainstorm, architecture
│   ├── debugging/           ← debug, fix, troubleshoot
│   ├── doc-create/          ← document creation
│   ├── github/              ← git, GitHub, CI/CD
│   ├── marketing/           ← marketing, growth, SEO
│   ├── memory/              ← memory & knowledge management
│   ├── tools/               ← general tools & utilities
│   ├── ui-ux/               ← UI, UX, design, frontend
│   └── writing/             ← writing & content
└── ...                      ← other skill categories
```

## BOSS_INDEX.json Schema

```json
{
  "id": "skill-folder-name",
  "name": "Human Readable Name",
  "description": "What it does and when to use it",
  "category": "boss-category-folder",
  "tags": ["tag1", "tag2"],
  "triggers": ["verb1", "verb2"],
  "risk": "safe|moderate|critical",
  "path": "category/skill-folder",
  "source": "installed|local|adapted"
}
```

## Key Rules

1. **ALL skills go in `boss/<category>/`** — this is non-negotiable
2. **NEVER create skill folders in `01-manage/`** — it is tooling-only
3. **Always rebuild index** after structural changes to `boss/`
4. **Never edit BOSS_INDEX.json by hand** — use `update-index.ps1`
5. **Use kebab-case** for skill folder names
6. **Every skill must have valid YAML frontmatter** in SKILL.md
7. **Verify target path** before any write — if it doesn't start with `boss/`, stop

## Anti-Patterns (Hard Stops)

| Wrong Action | Why | Correct Action |
|-------------|-----|---------------|
| Creating skill in `01-manage/` | 01-manage is tooling, not a skill destination | Create in `boss/<category>/` |
| Creating skill directly in `boss/` (no category) | Skills must be in category folders | Create in `boss/<category>/<skill-name>/` |
| Editing BOSS_INDEX.json manually | Will be overwritten by update-index.ps1 | Run update-index.ps1 after changes |
| Forgetting to rebuild index | BOSS won't discover new skills | Always run update-index.ps1 after add/remove/move |
