# Findings: BOSS Index Optimisation

## Current State Analysis

### BOSS_INDEX.json (v2, generated 2026-08-06)
- **40 skills** across 14 categories
- **Flat array structure**: skills[] with id, name, description, category, tags, triggers, risk, path, source
- **Tag coverage**: ~50% of skills have empty tag arrays (bible category especially)
- **Trigger generation**: Auto-extracted from description verbs (create, build, debug, fix, audit, review, design, write, plan, test, deploy, analyze, optimize, convert, generate, push, summarize, validate, track)
- **Size**: ~25KB current

### Category Distribution
| Category | Skills | Tag Coverage |
|----------|--------|--------------|
| bible | 10 | 0% (all empty) |
| code-plan | 4 | 100% |
| ai-meta | 1 | 100% |
| ai-skills | 1 | 100% |
| debugging | ? | ? |
| doc-create | ? | ? |
| github | ? | ? |
| marketing | ? | ? |
| memory | ? | ? |
| seo | ? | ? |
| tools | ? | ? |
| ui-ux | ? | ? |
| writing | ? | ? |
| content | ? | ? |

### update-index.ps1 Current Behavior
- Scans immediate subdirectories of `.agents/skills/boss/` (excludes `scripts/`)
- Extracts YAML frontmatter from each SKILL.md
- Generates triggers from description using hardcoded verb patterns
- Outputs flat array sorted by category, then name
- Single JSON file: BOSS_INDEX.json

### manage-orchestrator (00-manage-orchestrator/SKILL.md)
- Coordinates 3 sub-skills: skill-create, skill-aquire, skill-manage
- Enforces: skills go in `boss/<category>/`, never in `01-manage/`
- Requires index rebuild after changes via update-index.ps1
- Anti-patterns documented

### skill-manage (skill-manage/SKILL.md) - TO BE ENHANCED
- Currently manages category folders and index sync
- Will own: taxonomy, category management, dual-index maintenance, skill registration authority

## Key Problems Identified

1. **Empty tags on 20+ skills** - bible category has 0% tag coverage
2. **No category metadata** - agents can't reason about categories, only scan skills
3. **Flat structure forces full scan** - no category-first filtering
4. **Triggers auto-generated but limited** - only 19 hardcoded verbs
5. **No human-readable index** - maintenance requires parsing JSON
6. **Cross-category discovery impossible** - skills only in primary category
7. **Single large JSON file** - agents must read entire file (25KB+ tokens) to find relevant skills
8. **Redundant fields** - tags, triggers, risk, source not needed for discovery
9. **No centralized skill registration** - skill-create, skill-aquire, skill-manage each handle registration differently
10. **Too many categories (14+)** - increases cognitive load for agent category selection
11. **update-index.ps1 at root** - not co-located with skill-manage that owns it
12. **No live schema/category references** - schemas and categories documented but not maintained as live files

## Opportunities (New Strategy)

1. **Two minimal indexes** - Category Index + Alphabetical Index
2. **Category Index (CAT-IDX)**: Array of category objects with cat_id, category_description, skills[{id, description, path}] only
3. **Alphabetical Index (ALPHA-IDX)**: Array of skill objects with id, description, path, search_terms only
4. **Cross-category references via path** - skill appears in primary category folder, listed in multiple CAT-IDX categories with path refs
5. **No searchTerms in Category Index** - descriptions sufficient for agent reasoning
6. **No triggers/tags in either index** - descriptions + search_terms cover discovery
7. **Coder search_terms**: specific, comma-separated, one line (e.g., "debug, error" not "fix, solve")
8. **Single build step** - update-index.ps1 generates both from SKILL.md frontmatter
9. **skill-manage owns taxonomy/index governance** - clear ownership
10. **Schemas defined** - CAT-IDX: array of category objects; ALPHA-IDX: direct array of skill objects
11. **Schema examples documented** - schemas.md provides reference implementation
12. **Single source of truth** - one file copy per skill, multiple index listings with path refs
13. **skill-manage as single registration authority** - skill-create and skill-aquire delegate registration
14. **update-index.ps1 moved to skill-manage/scripts/** - co-located with owner
15. **skill-manage/refs/ with schemas.md and categories.md** - live replication of index schemas and category definitions
16. **Categories consolidated from 14+ to ~10** - advanced reasoning: group by functional domain, user intent, skill overlap