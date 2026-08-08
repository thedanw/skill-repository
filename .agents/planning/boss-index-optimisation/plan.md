# Plan: BOSS Index Optimisation

## Goal
Optimise the BOSS skill index system for low-token agentic workflows by implementing a dual-index architecture maintained by skill-manage:
- **Category Index (CAT-IDX)**: Skills grouped by category with minimal fields (cat_id, category_description, skills[{id, description, path}]) for agent category-first reasoning
- **Alphabetical Index (ALPHA-IDX)**: Flat skills array with id, description, path, search_terms for human reference and direct lookup
- **Enhanced skill-manage**: Single source of truth for skill registration, owns taxonomy, category management, dual-index maintenance, and category consolidation to ~10
- **Enhanced update-index.ps1**: Single build step generating both indexes from SKILL.md frontmatter, moved to skill-manage/scripts/

## Scope
- Modify `update-index.ps1` to produce dual output (CAT-IDX + ALPHA-IDX), move to skill-manage/scripts/
- Enhance `skill-manage/SKILL.md` as single source of truth for skill registration, taxonomy/index governance
- Define exact JSON schemas for both indexes in skill-manage/refs/schemas.md
- Generate skill descriptions from SKILL.md frontmatter (when/why to use)
- Generate coder search_terms from skill content (specific, comma-separated)
- Backfill descriptions for 40+ existing skills
- Remove deprecated fields: tags, triggers, risk, source, searchTerms
- Add path field to CAT-IDX skills for cross-category references
- Consolidate categories from 14+ to ~10 using advanced reasoning
- Create skill-manage/refs/ with schemas.md and categories.md (live replication of indexes)
- Update skill-create and skill-aquire to delegate registration to skill-manage

## Out of Scope
- Changes to three-tier registry architecture
- Changes to how agents query the index (they use existing tools)

## Success Criteria
- Index rebuild < 2s
- Agent skill lookup < 100ms via category reasoning
- Combined index size < 50KB
- 100% description coverage across all skills
- Human-readable alphabetical index with coder search terms
- Single source of truth: one file copy per skill, multiple index listings with path refs
- No redundant fields (tags, triggers, risk, source, searchTerms removed)
- Categories consolidated to ~10 semantic groups
- skill-manage is single registration authority for all skills
- refs/schemas.md and refs/categories.md live-updated with indexes

## Implementation Plan
See `implementation-plan.md` for detailed action items across 5 batches.