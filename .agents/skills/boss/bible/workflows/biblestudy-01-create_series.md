---
description: Initialize a new Bible Study series document from a sermon outline
---

# Bible Study Series Setup Workflow

## 1. Gather Information

- **Identify the Series**: Locate the active sermon series folder (e.g., `Sermons_n_Series/2026/GospelOfMark`).
- **Source Outline**: Locate the main series outline file (e.g., `02_Mark-TheChosen.md` or `outline.md`).
- **Target File Path**: Construct the filename as `[series title]_biblestudies.md` within that same folder.

## 2. Extract Data

For every week/talk in the outline, extract:

- **Study Number** (e.g., Week 1)
- **Thematic Title** (e.g., "The Power over Demons")
- **Brief Summary/Subtitle** (Extracted from the "Summary" or "Outcome" field)
- **Passage Reference** (e.g., Mark 5:1-20)

## 3. Lay Out the Document

Generate the boilerplate for the entire series using the established table format. Iterate through every week in the outline.

**Boilerplate Format for each study entry:**

```
| # **[Numerical digit]** | # **[Title]** |
| :--- | :--- |
| **Main Idea**: [Brief Summary] | **Passages**: [Passage Reference] |
| | |

## **Opening Discussion**

1. \[Placeholder Question]

## **Read \[Passage]**

1. \[Placeholder Question]

---
```

## 4. Final Output

- Save the document as `[SeriesName]_biblestudies.md`.
- Ensure all weeks from the outline are represented.
- Notify the user once the document is created and ready for individual study development using `/single_bible_study`.
