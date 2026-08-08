# JSON Schema Examples: BOSS Index Optimisation

## Category Index (CAT-IDX) - category-index.json

```json
[
  {
    "cat_id": "debugging",
    "category_description": "Debug production issues: logging, profiling, error analysis, root cause analysis",
    "skills": [
      {
        "id": "context-optimization",
        "description": "Reduce token usage for small-context LLMs: compression, caching, partitioning strategies",
        "path": "ai-meta/context-optimization"
      },
      {
        "id": "pylance-refactoring",
        "description": "Automated Python refactorings: unused imports, type annotations, wildcard conversions",
        "path": "debugging/pylance-refactoring"
      }
    ]
  },
  {
    "cat_id": "code-plan",
    "category_description": "Plan features, design architecture, create technical specs, break down work",
    "skills": [
      {
        "id": "01_brainstorming",
        "description": "Transform vague ideas into validated designs through structured dialogue before implementation",
        "path": "code-plan/01_brainstorming"
      },
      {
        "id": "02_concise-planning",
        "description": "Create minimal implementation plans from validated designs with clear steps and acceptance criteria",
        "path": "code-plan/02_concise-planning"
      }
    ]
  },
  {
    "cat_id": "ai-meta",
    "category_description": "Optimize agent context, prompts, and multi-agent orchestration for token efficiency",
    "skills": [
      {
        "id": "context-optimization",
        "description": "Reduce token usage for small-context LLMs: compression, caching, partitioning strategies",
        "path": "ai-meta/context-optimization"
      }
    ]
  }
]
```

## Alphabetical Index (ALPHA-IDX) - alphabetical-index.json

```json
[
  {
    "id": "01_brainstorming",
    "description": "Transform vague ideas into validated designs through structured dialogue before implementation",
    "path": "code-plan/01_brainstorming",
    "search_terms": "brainstorm, design, plan, requirements, architecture"
  },
  {
    "id": "02_concise-planning",
    "description": "Create minimal implementation plans from validated designs with clear steps and acceptance criteria",
    "path": "code-plan/02_concise-planning",
    "search_terms": "plan, implement, breakdown, tasks, criteria"
  },
  {
    "id": "context-optimization",
    "description": "Reduce token usage for small-context LLMs: compression, caching, partitioning strategies",
    "path": "ai-meta/context-optimization",
    "search_terms": "context, tokens, compression, cache, partition, llm"
  },
  {
    "id": "pylance-refactoring",
    "description": "Automated Python refactorings: unused imports, type annotations, wildcard conversions",
    "path": "debugging/pylance-refactoring",
    "search_terms": "refactor, python, imports, types, wildcard, pylance"
  }
]
```

## Field Rules Summary

| Index | Field | Rule |
|-------|-------|------|
| CAT-IDX | cat_id | Folder name, semantic, unique, kebab-case |
| CAT-IDX | category_description | Minimum words, task-focused purpose, imperative |
| CAT-IDX | skills[].id | Folder name, semantic, unique, kebab-case |
| CAT-IDX | skills[].description | Minimum words, when/why to use, task-focused |
| CAT-IDX | skills[].path | Relative to `.agents/skills/boss/` (e.g., `ai-meta/context-optimization`) — required for cross-category refs |
| ALPHA-IDX | id | Folder name, semantic, unique, kebab-case |
| ALPHA-IDX | description | Same as CAT-IDX skill description |
| ALPHA-IDX | path | Relative to `.agents/skills/boss/` (e.g., `code-plan/01_brainstorming`) |
| ALPHA-IDX | search_terms | One line, comma-separated, specific coder terms only (e.g., "debug, error" not "fix, solve") |

## Generation Rules

1. **Skill description**: Extract from SKILL.md frontmatter `description` field, rewrite to "when/why to use" format
2. **Category description**: Maintained manually in skill-manage, or derived from category purpose
3. **Search terms**: Extract from skill's tags/triggers/description, filter to specific coder terms, max 5 terms
4. **Cross-category references**: Skill appears in primary category folder, listed in multiple CAT-IDX categories with path refs
5. **Alphabetical sort**: ALPHA-IDX sorted by id ascending
6. **Single source of truth**: One file copy per skill, multiple index listings with path refs