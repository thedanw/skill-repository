# Skill Repository

Curated meta-skill orchestrator ("boss") and custom skills for Antigravity AI.

## Structure

```
.agents/skills/boss/          # Meta-orchestrator + curated awesome-skills
├── SKILL.md                  # Boss meta-orchestrator
├── BOSS_INDEX.json           # Compact skill discovery index
├── update-index.ps1          # Script to rebuild index from frontmatter
├── awesome/                  # Curated skills from awesome-skills repo
│   ├── brainstorming/
│   ├── skill-creator/
│   └── ... (~50-100 selected skills)
└── custom/                   # Domain-specific custom skills
    ├── nlac-gospel-preaching/
    ├── nlac-twick/
    └── ...
```

## Setup

### Clone and Install

```powershell
git clone https://github.com/thedanw/skill-repository.git
cd skill-repository
.\scripts\install-skills.ps1
```

### Install Antigravity Skills (Curated)

```powershell
npx antigravity-awesome-skills --path ".agents/skills/boss/awesome" --category development,workflow --risk safe
```

### Rebuild Index

After adding/removing skills:

```powershell
.agents/skills/boss/update-index.ps1
```

## Junction Setup

Link boss into each Antigravity workspace:

```powershell
# From the workspace directory:
mklink /J "skills\boss" "D:\OneDrive - New Light Anglican Church\Documents\antigravity\skill-repository\.agents\skills\boss"
```

## Syncing

This repo is backed by OneDrive. After git pull/push, OneDrive syncs automatically.

```powershell
git pull origin main
# OneDrive handles the rest
```
