# Skill Repository

Curated meta-skill orchestrator ("BOSS") and AI agent skills for Antigravity AI — with AIngram-powered persistent memory.

## Structure

```
.agents/
├── memory/                       # AIngram persistent memory layer
│   ├── aingram-mcp-server.py     # MCP server wrapper (stdio transport)
│   └── aingram.db                # SQLite memory store (self-learning)
└── skills/
    └── boss/                     # Meta-orchestrator + curated skills (29 total)
        ├── SKILL.md              # BOSS meta-orchestrator (native brain + AIngram)
        ├── BOSS_INDEX.json       # Compact skill discovery index
        ├── update-index.ps1      # Script to rebuild index from YAML frontmatter
        ├── code-plan/            # Planning skills
        ├── debugging/            # Systematic debugging, bug-hunter, logic-lens, perf-optimizer
        ├── doc-create/           # Python-pptx generator, LibreOffice writer
        ├── github/               # Git-pushing, pre-push codebase audit
        ├── marketing/            # SEO-optimized social post writer
        ├── memory/               # MCP agent-memory skill (legacy)
        ├── scripts/              # Automation scripts
        ├── skill-create/         # Skill-creator, skill-check
        ├── technical-change-tracker/
        ├── tools/                # YouTube summarizer
        ├── ui-ux/                # 10 skills: design system, accessibility, UX audit
        └── writing/              # Copywriting, unslop, WordPress blogwriting
```

## Setup

### Prerequisites
- Python 3.11+ with `pip`
- PowerShell 7+

### Install AIngram (Memory Layer)
```powershell
pip install aingram[mcp]
```

### Rebuild Skill Index
After adding or removing skills from the registry:
```powershell
pwsh .agents/skills/boss/update-index.ps1
```

## Memory System

This project uses a **two-tier memory philosophy**:

| Tier | System | Role |
|------|--------|------|
| **Tier 1** | Native Brain/KI | LLM's own reasoning and in-context learning (always primary) |
| **Tier 2** | AIngram | Persistent SQLite memory for cross-session recall (fallback) |

AIngram stores everything in `.agents/memory/aingram.db` — a single portable SQLite file with:
- **Hybrid retrieval** — FTS5 full-text + vector search (ONNX local embeddings) + knowledge graph, fused via Reciprocal Rank Fusion
- **95.5% recall@10** on LongMemEval-S
- **Self-learning** — contradiction detection (DeBERTa-v3), consolidation, knowledge graph extraction
- **Zero cloud** — no API keys, no external services, Apache 2.0 license
- **MCP-native** — exposes `remember`, `recall`, `reference`, `verify` tools to any MCP-compatible client

## Usage

BOSS orchestrates skill discovery automatically:

1. **Guardrail check** — Can native brain solve it directly? If yes, done.
2. **Registry query** — Match task keywords against `BOSS_INDEX.json` (29 skills across 9 categories)
3. **Skill loading** — Load only the matched SKILL.md files (max 3 at once)
4. **AIngram recording** — Record successful skill combinations for future sessions

## Junction Setup

Link BOSS into each Antigravity workspace:
```powershell
# From the workspace directory:
mklink /J "skills\boss" "D:\OneDrive - New Light Anglican Church\Documents\antigravity\skill-repository\.agents\skills\boss"
```

## Syncing

This repo is backed by OneDrive. Git operations sync through OneDrive automatically.
```powershell
git pull origin main
# OneDrive handles the rest
```
