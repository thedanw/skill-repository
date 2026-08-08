# BOSS Index Optimisation Implementation Plan

**Goal:** Implement dual-index system (Category Index + Alphabetical Index) for low-token agentic skill discovery

**Approach:** Enhance .agents\skills\boss\01-manage\skill-manage\SKILL.md including the script update-index.ps1 to generate two minimal JSON indexes from SKILL.md frontmatter. Update skill-manage to optimise taxonomy governance. Single build step, backward compatible.

**Branch:** `feat/boss-index-optimisation` (from `main`)

---

## Scope
- **In:** update-index.ps1 dual output, skill-manage taxonomy governance, category-index.json, alphabetical-index.json, schema validation, skill registration centralization, category consolidation to ~10
- **Out:** skill-create/skill-aquire changes, three-tier registry changes, agent query logic changes

---

## Action Items (Partitioned for Sub-Agent Isolation)

### Batch 1: Index Generation Script & Centralization (Independent)
**Goal:** Enhance update-index.ps1 for dual-index generation; centralize skill registration in skill-manage
**Partition:** Isolated - reads SKILL.md, writes JSON
**Sub-Agent Friendly:** Yes - no shared state

- [ ] **Commit:** `feat: enhance update-index.ps1 for dual-index generation`
  - Read all SKILL.md frontmatter from category folders
  - Generate skill descriptions (when/why format) from frontmatter.description
  - Generate search_terms from tags + triggers + description (specific coder terms, max 5)
  - Build CAT-IDX: array of category objects with cat_id, category_description, skills[{id, description, path}]
  - Build ALPHA-IDX: array of skill objects with id, description, path, search_terms (sorted by id)
  - Use manual category descriptions from skill-manage taxonomy table
  - Write category-index.json and alphabetical-index.json
  - Optionally update legacy BOSS_INDEX.json for backward compat
  - Validation: every skill has SKILL.md, frontmatter valid, category matches folder, no duplicate IDs

- [ ] **Commit:** `feat: centralize skill registration in skill-manage`
  - skill-manage\SKILL.md becomes single source of truth for registering new skills
  - Manage skill names, descriptions, search_terms, and catalogue assignments
  - skill-create and skill-aquire delegate registration to skill-manage
  - Update skill-create and skill-aquire workflows to call skill-manage for registration

- [ ] **Commit:** `refactor: move update-index.ps1 to skill-manage/scripts/`
  - Create folder: `.agents/skills/boss/01-manage/skill-manage/scripts/`
  - Move update-index.ps1 to scripts folder
  - Update all references in skill-manage, skill-create, skill-aquire, manage-orchestrator
  - Update BOSS SKILL.md registry lookup paths

**Compaction:** Script generates two indexes from frontmatter; validation ensures data integrity; skill-manage owns registration.

---

### Batch 2: Taxonomy Governance & Category Consolidation (Independent)
**Goal:** skill-manage owns category definitions, skill descriptions, search terms; consolidate to ~10 categories
**Partition:** Isolated - updates skill-manage SKILL.md only
**Sub-Agent Friendly:** Yes - documentation-only

- [ ] **Commit:** `feat: enhance skill-manage with taxonomy governance`
  - Category definitions table with cat_id and category_description (manually curated)
  - Skill description generation rules (what → when/why transform)
  - Coder search_terms generation rules (specific terms only, max 5, comma-separated)
  - Validation rules enforced by update-index.ps1
  - Anti-patterns: no manual index editing, no cross-listing without path, no vague search_terms
  - Taxonomy maintenance workflows: add/update/remove category
  - Single source of truth: one file copy, multiple index listings with path refs

- [ ] **Commit:** `feat: consolidate categories to ~10 with advanced reasoning`
  - Analyze existing 14+ categories for overlap and consolidation opportunities
  - Apply advanced reasoning: group by functional domain, user intent, skill overlap
  - Target: ~10 semantic categories (e.g., merge ai-meta+ai-skills, debugging+tools, design+ui-ux, doc-create+writing, marketing+seo, github+memory)
  - Maintain category descriptions in skill-manage taxonomy table
  - Update category-index.json and alphabetical-index.json after consolidation
  - Document consolidation rationale in skill-manage SKILL.md

- [ ] **Commit:** `feat: add skill-manage/refs/ for live category/schema references`
  - Create folder: `.agents/skills/boss/01-manage/skill-manage/refs/`
  - Add `schemas.md` - JSON schema definitions for CAT-IDX and ALPHA-IDX
  - Add `categories.md` - live updated list of categories and descriptions
  - categories.md maintained as direct replication of category-index.json + alphabetical-index.json
  - update-index.ps1 updates refs/ after index generation
  - skill-manage SKILL.md references refs/ for source of truth

**Compaction:** skill-manage owns taxonomy; categories consolidated to ~10; refs/ provides live schema/category references.

---

### Batch 3: Migration & Backfill (Sequential - depends on 1,2)
**Goal:** Generate indexes for all 40+ existing skills with consolidated categories
**Partition:** Requires Batch 1+2 complete; runs single script
**Observation Masking:** Script output masked to summary only

- [ ] **Commit:** `chore: generate initial dual indexes for all skills`
  - Run enhanced update-index.ps1 from scripts/ folder
  - Verify category-index.json and alphabetical-index.json created
  - Verify all 40+ skills present in both indexes
  - Verify descriptions are task-focused (when/why format)
  - Verify search_terms are specific coder terms (not vague)
  - Verify categories consolidated to ~10
  - Manual review of category descriptions in skill-manage

**Compaction:** Dual indexes generated for all skills; descriptions and search_terms validated; categories consolidated.

---

### Batch 4: Validation & Testing (Sequential - depends on 3)
**Goal:** Ensure indexes work for agent discovery and human reference
**Partition:** Test execution; results masked to pass/fail + metrics

- [ ] **Commit:** `test: validate dual-index output and agent usability`
  - Verify index rebuild < 2s
  - Verify combined index size < 50KB
  - Verify CAT-IDX: agents reason about category → scan skills
  - Verify ALPHA-IDX: human-readable, alphabetical, searchable
  - Verify cross-category listings include path refs
  - Verify legacy BOSS_INDEX.json still generated
  - Test agent query flow: CAT-IDX → category → skill selection
  - Verify skill registration via skill-manage works end-to-end
  - Verify refs/schemas.md and refs/categories.md updated correctly

**Compaction:** All validation criteria met; indexes production-ready.

---

### Batch 5: Documentation & Cleanup (Independent)
**Goal:** Document new index system and clean up legacy references
**Partition:** Isolated - documentation updates only
**Sub-Agent Friendly:** Yes

- [ ] **Commit:** `docs: document dual-index system and migration`
  - Update BOSS SKILL.md with new index structure
  - Document agent query pattern using new indexes
  - Update agents.md if needed
  - Clean up deprecated fields references
  - Document skill-manage as single registration authority
  - Document category consolidation rationale

**Compaction:** Documentation updated; legacy references cleaned.

---

## KV-Cache Optimization: Stable Context Prefix

Place at start of each session for maximum cache reuse:
```
Goal: Implement dual-index system for low-token skill discovery
Approach: update-index.ps1 generates CAT-IDX + ALPHA-IDX from SKILL.md
Branch: feat/boss-index-optimisation
Current Batch: [BATCH_NUMBER]
```

---

## Trigger-Based Optimization Checkpoints

| Trigger | Action |
|---------|--------|
| Token usage > 80% | Compact current batch to summary; start fresh context |
| Batch complete | Write compaction summary to progress.md; mask details |
| Validation fail | Revert to last checkpoint; update plan; ask user |
| 3+ errors same type | STOP; revert; update plan; ask user (3-strike protocol) |

---

## Open Questions
- [ ] Should category descriptions be stored in separate JSON or kept in skill-manage SKILL.md?
- [ ] Do we need a migration script for skills with empty descriptions?

---

## Verification
- [ ] All tests pass (index generation, validation)
- [ ] Index rebuild < 2s
- [ ] Combined index size < 50KB
- [ ] 100% description coverage
- [ ] Lint/Format clean