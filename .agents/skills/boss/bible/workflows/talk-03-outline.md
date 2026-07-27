---
description: Brainstorm and output a refined sermon outline
---

1. Ask user for `Talk Path` and `Bible Reference`.
2. **Goal**: Transform main idea and research into a refined, memorable sermon outline.
3. **Role**: Reformed Homiletician.

4. **Phase 1: Initialize & Main Idea (Chat Interaction)**
   - Analyze `.knowledge/user-DNA`.
   - Read `[bibleRef].md` for Main Idea. If missing, ask user.
   - Read `[bibleRef]/Research` for content.
   - **Clarify Main Theme**: Identify 4 theological nuances of the main idea. Present them in chat and ask user to clarify/select one.

5. **Phase 2: Brainstorm Outline Options (Chat Interaction)**
   - **Review**: The synthesized content from `03-summary.md`. 
   - **Creative Tactics**: Generate 7 different outline variations using the [.agent/skills/rhetoric] skill 
   - **Constraints**
   - 1. Each outline must be anchored around one main idea that sums up a majority of the research
   - 2. Each outline must drive a cohesive argument using the majority of the content from `03-summary.md`.
   - 3. Each outline argument MUST follow the order of the biblical text
   - 4. Every outline MUST use application-focused arguments for both `main idea` and `# first-level` headings. Avoid descriptive or thematic labels.
   - **Presentation**: Return the 7 options in the chat (each showing just the Top-level headings).
   - **Constraint**: Do NOT write to the file yet.
   - **Interactive Selection**: Ask user to choose one option.

6. **Phase 3: Final Output Construction (File Creation)**
   - **Wait for user selection**.
   - **Create File**: Updated `[Talk Path]/[BibleRef].md` with the full expanded version.
   - **Construction Logic**: Synthesize content from `talk-01` and `talk-02` (`Research/03-summary.md`) to build a cohesive argument driven from observations in the biblical text and its context. The research, teaching points, and textual nuances should shape the headings and application, not the other way around. Ensure a **comprehensive** use of all unique insights from the source material.
   - **Structural Rules**:
     - **# 1 - 4**: Top level application-focused headings from Phase 2.
     - **## A - C**: Second level headings should form a cohesive argument from the biblical text/context to support the first level heading and MUST be strictly application-focused (Headings must be <30 chars).
     - **### 1 - 4**: Third level of the outline is the detail/examples of the argument, synthesized from teaching points, text observations, and illustrations. All synthesized third-level points must be <90 chars.
     - **Comprehensive Subpoints**: Include as many subpoints at every level (##, ###, and list items) as necessary to utilize the majority of the research material.
     - **No Singletons Rule**: Only create a lower hierarchy level if there are **two or more** points at that level. If a heading would have only one subpoint, merge the subpoint content into the parent heading and use the next level of points in its place. (e.g., If # 1 has only one ## A, merge ## A's argument into # 1 and list the details ad ## A - D etc. At the lowest level just list the details).
     - **Biblical Clauses**: Displayed to give examples of the second or third-level points as appropriate—quoted exactly from `Research/BibleText(NLT).md` preceeded by the bible reference reference (e.g., book ch:v-v) and displayed in code blocks.
     
   - **Format**:

   ```markdown
   # 1. [Top-Level Argument: Application Focused]

   ## A. [Application-Focused Argument <30 chars]

   ### 1. [Synthesized logical argument/teaching point <90 chars]
   ```text
   [Bible ref]
   "[Full quoted clause exactly from BibleText(NLT).md]"
   ```
     - Textual Observation that reinforces the argument <90 chars
     - **Point**: teaching conclusion from text observation
     - **Illustration**: title <30char -> description <90char [Source]
     - **Application**: specific takeaway <90 chars
   
   ### 2. [Second logical argument <90 chars]
   ```text
   [Bible ref]
   "[Full quoted clause exactly from BibleText(NLT).md]"
   ```
     - Textual Observation that reinforces the argument <90 chars
     - **Point**: teaching conclusion from text observation
     - **Illustration**: title <30char -> description <90char [Source]
     - **Application**: specific takeaway <90 chars
   ```
7. **Phase 4: Final Quality Gate**
   - **Audit against Research**: Before concluding the workflow, explicitly cross-check the generated outline against `Research/03-summary.md` and `Research/03-research.md` to ensure no hallucination and correct citations . 
   - **Verification Requirement**: Ensure that the *majority* of the synthesized research (teaching points, textual nuances, and illustrations) from `Research/03-summary.md` has been successfully incorporated into the final output.
   - **Correction**: If significant portions of the research were omitted, revise the outline to include them naturally into the argument, or explicitly inform the user why certain portions were deliberately excluded.