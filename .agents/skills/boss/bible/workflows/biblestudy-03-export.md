---
description: Design and generate a print-ready HTML booklet from markdown Bible studies using the central createDocs system.
---

# Bible Study Export Workflow

This workflow uses the central `createDocs` engine to generate professionally designed Bible study booklets.

## 1. Goal
Convert a series of Bible studies into multiple formats (HTML, RTF, GDoc, PDF) with specific branding for group discussion.

## 2. Process

### Step 1: Preparation
1.  **Select Target**: Identify the `.md` file containing the studies.
2.  **Verify Brand**: Ensure `.agents/skills/brand/SKILL.md` is loaded.

### Step 2: Invoke createDocs
// turbo
1.  **Generate Base Files**: Run the central conversion: 
    - `python .agents\skills\sync-docs\scripts\create_docs.py "[Target Path]" --html`
    - `python .agents\skills\sync-docs\scripts\md_to_gdoc.py "[Target Path]" --export docx,pdf`

### Step 3: Bible Study Specialization
When using `createDocs` for Bible Studies, ensure the following logic is applied (via prompts or manual script adjust):

1.  **Table of Contents**: 
    - Include a hyperlinked TOC at the top.
    - Format: "Title" and "Passages" in the same cell.
2.  **Study Headers (The "Mark" Standard)**:
    - **Container**: `.header-top` grid (70px 1fr) with a 3px double border at the bottom.
    - **Study Number**: 70x70 orange box (`#FF7300`), white text, `Inter Tight` 800 weight.
    - **Title**: H1 `Inter Tight` 800 weight, capitalized.
    - **Subtitle**: 0.95rem, grey italic, below the title.
3.  **Metadata Blocks**:
    - Background: `#F8F9FA`.
    - Border: 4px solid grey on the left.
    - Labels: Orange bold, all-caps (e.g., MAIN IDEA, PASSAGES).
4.  **Question Numbering**:
    - Questions must be **continuously numbered within each study** (Opening Q1, next section Q2, Q3, etc., Bonus questions continue the sequence).
    - Numbering resets to 1 at the start of each new study.
    - In the markdown source, each question's number reflects its position in the continuous sequence (e.g., `1.`, `2.`, `3.` across all sections, not restarting per section).
    - The HTML output uses CSS counters (`counter-reset: question` on `.study-container`, `counter-increment: question` on `ol li`) to render continuous numbers. The markdown `1.`, `2.` text is hidden via `list-style: none` and replaced by `::before` pseudo-elements.
5.  **Section Heading Levels**:
    - Read section headings: `## **[Read Passage](link)**` (H2, bold, linked) — always use "Read" never "Reach".
    - Bonus Questions heading: `### **Bonus Questions**` (H3, bold) — never H2.
    - Opening Discussion heading: `## **Opening Discussion**` (H2, bold).
6.  **Bible Links**:
    - Convert all "Read [Passage]" headers into hyperlinked text.
    - URL Pattern: `https://team.newlight.app/bible?&q=[Encoded+Passage]` (e.g., `https://team.newlight.app/bible?&q=Esther+6%3A1-11`).

## 3. HTML Template Specifications (The Gold Standard)

The generated HTML should follow these CSS and Structural rules:

### CSS Variables & Base Styles
```css
:root {
    --primary: #FF7300;
    --text-dark: #313638;
    --secondary-grey: #60695C;
    --meta-bg: #F8F9FA;
}

.page {
    max-width: 210mm; 
    min-height: 297mm; 
    margin: 0 auto;
    padding: 2cm;
    background: #fff;
}
```

### CSS Counter System (Continuous Numbering)
```css
/* Each study container resets the counter */
.study-container { counter-reset: question; }

/* Hide default list numbers — CSS counters render the continuous number */
ol { padding-left: 0; list-style: none; }
ol li {
    margin-bottom: 0.6rem;
    padding-left: 1.5rem;
    position: relative;
    counter-increment: question;
}
ol li::before {
    content: counter(question) ".";
    position: absolute; left: 0;
    font-weight: bold; color: var(--primary);
    font-family: 'Inter Tight', sans-serif;
}
```

### Structural Templates

**1. Title Page**:
```html
<div class='page'>
    <div class='title-page'>
        <div class='church-title'>New Light Anglican Church</div>
        <div class='series-title'>[Series Title]</div>
        <div class='series-subtitle'>[Series Subtitle]</div>
        <div class='year-mark'>[Year]</div>
    </div>
</div>
<div class='page-break'></div>
```

**2. Table of Contents**:
```html
<div class='page'>
    <div class='toc-header'>Series Overview</div>
    <table class='toc'>
        <thead>
            <tr>
                <th width='10%'>#</th>
                <th width='90%'>Study</th>
            </tr>
        </thead>
        <tbody>
            <!-- Study Rows -->
        </tbody>
    </table>
</div>
<div class='page-break'></div>
```

**3. Study Container**:
Every study must be wrapped in these divs to ensure anchors work:
```html
<div class='page'>
    <div id='study-[N]' class='study-container'>
        <div class='header-top'>
            <div class='study-num'>[N]</div>
            <div class='study-title'>
                <h1>[Title]</h1>
                <div class='study-subtitle'>[Subtitle]</div>
            </div>
        </div>
        <!-- Meta Block & Content -->
    </div>
</div>
<div class='page-break'></div>
```

## 4. Completion
- Upload the GDoc to the correct Year/Series folder.
- Share the HTML file for print-ready browser viewing.
- Share the RTF/DOCX for manual editing.
