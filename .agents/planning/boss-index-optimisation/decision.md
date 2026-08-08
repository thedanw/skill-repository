# Decision: BOSS Index Optimisation

## Aliases
BOSS = BOSS meta-orchestrator skill
CAT-IDX = Category index (skills grouped by category)
ALPHA-IDX = Alphabetical index (flat, all skills)
SM = skill-manage sub-skill (maintains both indexes, single registration authority)
MO = manage-orchestrator skill (coordinates sub-skills)

## What & Why
Optimise BOSS skill index for low-token agentic workflows. Two minimal indexes maintained by skill-manage:
- **Category Index**: Agents reason about category purpose → scan skills in that category
- **Alphabetical Index**: Human reference + direct skill lookup with coder search terms
- **skill-manage**: Single source of truth for skill registration, taxonomy, category consolidation to ~10

## Who
Primary: AI agents using BOSS for skill discovery
Secondary: Human developers maintaining skill repository

## Constraints
- Index rebuild < 2s, agent lookup < 100ms
- Combined index size < 50KB
- Backward compatible with 40+ existing skills
- Extensible for new categories/skills without breaking changes

## Non-Goals
- Change three-tier registry architecture
- Change how agents fundamentally query the index

## Assumptions
- Agents can reason about category descriptions to select relevant category
- Category IDs = folder names (semantic, human-friendly, unique)
- Skill IDs = folder names (semantic, human-friendly, unique)
- Skill descriptions = when/why to use (minimum words, task-focused)
- Coder search terms = specific, comma-separated, one line (e.g., "debug, error")

## Decision Log: decision → Rationale
1 SM maintains two indexes: CAT-IDX + ALPHA-IDX → Single source of truth, clear ownership
2 CAT-IDX: JSON array of category objects, each with cat_id, category_description, skills[{id, description, path}] → Minimal tokens, category-first reasoning, cross-category refs via path
3 ALPHA-IDX: JSON array of skill objects, each with id, description, path, search_terms → Human-readable, direct lookup, coder-friendly search
4 CAT-IDX category IDs = folder names → Semantic, unique, no mapping needed
5 CAT-IDX skill IDs = folder names → Semantic, unique, no mapping needed
6 CAT-IDX category_description: minimum words, task-focused purpose → Agent matches intent to category
7 CAT-IDX skill description: minimum words, when/why to use → Agent selects skill within category
8 ALPHA-IDX path: relative to boss skill folder → Direct navigation
9 ALPHA-IDX search_terms: one comma-separated line, specific coder terms only → Low token, precise matching
10 Single source of truth: one file copy per skill, multiple index listings with path refs → No file duplication, cross-category discovery enabled
11 No searchTerms in CAT-IDX: category_description + skill descriptions sufficient → Agents digest whole document, no separate keyword index needed
12 No triggers/tags in either index: descriptions + search_terms cover discovery → Redundant fields removed
13 MO remains coordinator only → Separation of concerns, SM owns index governance
14 update-index.ps1 enhanced to generate both indexes from SKILL.md frontmatter → Single build step, consistent output
15 CAT-IDX schema: [{cat_id, category_description, skills: [{id, description, path}]}] → Array of category objects
16 ALPHA-IDX schema: [{id, description, path, search_terms}] → Direct array of skill objects
17 Schema examples documented in schemas.md → Reference for implementation
18 SM is single registration authority for all skills → skill-create and skill-aquire delegate registration to SM
19 update-index.ps1 moved to SM/scripts/ → Centralized index generation, single source of truth
20 SM/refs/ with schemas.md and categories.md → Live replication of index schemas and category definitions
21 Categories consolidated from 14+ to ~10 via advanced reasoning → Reduce cognitive load, improve agent category selection accuracy
22 Category consolidation rationale: group by functional domain, user intent, skill overlap → Semantic coherence, fewer categories to reason about

## Decision Gap Log
1 Algorithm for generating skill descriptions from SKILL.md frontmatter (when/why format)
2 Algorithm for generating coder search_terms from skill content (specific terms only)
3 Migration: backfill descriptions for 40+ existing skills
4 update-index.ps1 changes: dual output, description generation, search_terms generation, move to scripts/
5 skill-manage/SKILL.md enhancements: taxonomy governance, index maintenance rules, registration authority
6 Category descriptions source: manual curation vs auto-generation
7 Category consolidation mapping: which existing categories merge into which ~10 target categories
8 skill-create/skill-aquire workflow updates to delegate registration to SM