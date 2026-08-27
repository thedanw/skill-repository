---
description: Brainstorm and create a bible study for a discussion group
---

# Bible Study Creation Workflow (Single)

Use RSCIT-style prompt structure: role, context, constraints, instructions, output format before action.

## Step 0: Choose series mode

- NEW Series: start a new series file.
- CONTINUE EXISTING Series: append to an existing file.

Ask the user to choose and confirm before proceeding.

## Step 1: Pick target file

- New Series: locate the active sermon series folder and create `[series title]_biblestudies.md`.
- Continue Existing: locate the existing file and append.

Repeat the exact path and filename for the user to confirm.

## Step 2: Save every step immediately

- Draft one question or section at a time.
- Show the draft and ask for confirmation or refinement.
- Write only confirmed text.
- Do not batch-save.
- Start with:

```markdown
| # **[Num]**              | # **[Title]**       |
| :----------------------- | :------------------ |
| **Main Idea**: [Summary] | **Passages**: [Ref] |
|                          |                     |

## **Opening Discussion**

...
```

## Step 3: Style rules

- Role: author of discusion guide
- Language: simple Year 8 vocabulary, adult tone.
- Sentences: short, clear, simple sentences.
- No double negatives.
- Use direct instruction language.
- Tone: Kingdom vs World contrast.
- No filler, summaries, or extra commentary.
- Use Observe, Interpret, Apply in each application cycle.

## Step 3a: Agent strategies and tools

Use the method that fits the passage, user need, and study flow.

- Ask, “What words repeat in this passage and what do they show?”
- Ask, “What does this section say about the people involved?”
- Ask, “How does this verse explain what happened earlier?”
- Ask, “Where else in Scripture do we see the same theme?”
- Ask, “What does this text reveal about God’s power or people’s need?”

Use tools sparingly; offer lookup only when it deepens the current text focus.

## Step 4: Orient and research

1. Orient from `../.knowledge/user-DNA` first.
   - Reuse session context if relevant.
   - Reload only when theology or context changes.
   - Prime Grace Dynamic theology and user DNA without hard-coded links.
2. Identify the main passage and supporting texts.
3. Consult `../.knowledge/ResearchSources.md` and use selector logic.
   - Each source must yield hooks, structure, candidate pivot verses, and practical applications.
   - Use the selector only to choose sources/tools.
4. Filter through Grace Dynamic theology: focus on Christ’s sufficiency, not human fix.
5. Use Research Protocol (`../individual_sermon_researcher/SKILL.md`) to fetch and extract.
   - Extract structure, hooks/striking phrases, pivot verses showing Jesus’ sufficiency or human inability, and application points.
   - Follow access, extraction, and anti-hallucination rules.
6. Consolidate, deduplicate, and choose the strongest pivot verse and 2–3 application points.

After research, summarize findings and ask the user to confirm passage, outline, pivot verse, and application points.

## Step 5: Propose 5 application options

- Generate 5 numbered options from the passage.
- Each option must include:
  - Title: short, active (3–6 words).
  - Key logic: 1–2 sentences showing how the passage supports it.
- Return a numbered list only.
- Ask the user to reply with numbers, All, or `Add: <text>`.
- Do not draft until the options are confirmed.

## Step 6: Develop reading strategy

- Based on selected options, generate 3–4 strategies.
- Present a numbered list only.
- Each strategy needs:
  - title
  - readings and application mapping or split logic
  - brief logic sentence (<20 words) when split
- Ask the user to choose or add a custom strategy.
- Do not draft questions until the strategy is confirmed.
- Draft the selected plan and confirm before saving.

## Step 7: Draft the Study (Collaborative)

**Draft the body Observe/Interpret/Apply sets first.** Do not draft the Opening Question yet.

- Use the confirmed reading strategy and the agreed application options from Step 5.
- Loop through each confirmed application option one at a time.
- For each confirmed application:
  - Draft one Observe question, one Interpret question, and one Apply question.
  - Ensure the Observe question leads into the Interpret question, and the Interpret question leads into the Apply question as a single, cohesive train of thought.
  - Write the draft questions directly into the target file immediately (using placeholder spaces or replacing placeholders).
  - Stop and present the drafted questions to the user, waiting for explicit confirmation, refinement, or edits. Do NOT move to the next application set or write further questions until this set is confirmed.
- If the user requests changes, update the same draft section in the file and wait for confirmation again.
- Do not draft the Opening Discussion until all application sections are confirmed.

1. **Question labeling (CRITICAL)**:
   - Questions use labels, not sequence numbers, in each section.
   - The first section is the Opening Discussion.
   - Each `## **Read [Passage]**` section contains an Observe question, an Interpret question, and an Apply question.
   - Bonus questions continue after the main body as labeled bonus questions.

2. **Section Headings (If applicable)**:
   - Each passage-based section must start with `## **Read [Passage Reference]**` (e.g., `## **Read Mark 5:1-10**`).
   - The first section is always `## **Opening Discussion**` (Q1).
   - Map each movement from the agreed Reading Strategy (## 4) to a `## **Read [Passage]**` section.
   - Each Read section contains questions about that specific portion of the passage.

3. **Logic (Observe-Interpret-Apply Connections)**:
   - The three questions within each section MUST form a single, tight, cohesive train of thought focused on the same subject.
   - **Observe** surfaces a specific raw detail or action in the text.
   - **Interpret** uses that exact detail or action from the Observe question to draw out theological meaning or character traits of God/people (using scripture to interpret scripture).
   - **Apply** directly translates the theological meaning or trait discovered in the Interpret question into a practical, depersonalized life response.
   - Work collaboratively with the user in groups of three questions, each group focused on one application section.

4. **Question logic: Chain-of-Thought for each question type**: Build questions in sets of 3. Each set of 3 should follow one train of thought that leads to the Apply question (3rd question):
   - For each question type, build it with this CoT pattern:
     1. **Identify what is given** in the passage or supporting Scripture.
     2. **Identify what is needed** by the question: overview, meaning, or life response.
     3. **Apply logic** to form the question from the text, ensuring it references the subject of the previous question in the set.
     4. **Verify** the question can be answered from the passage, keeps the reader in the text, and maintains subject continuity across the set.


   ### Observe
   1. Observation methods
      - Focus on verbs, sentence structure, and literary genre that might relate to the application.
      - Ask about audience, setting, and what the original readers would notice.
      - Draw attention to key terms, repeated words, lists, contrasts, and connectives like therefore, but, for, so that.
      - Notice structure and movement inside the passage that might relate to the application.

   2. Observation Steps
      - Step 1: identify sets of facts, groups of events, repeated words, lists of words or themes, sets of contrasts, or details in the text.
      - Step 2: identify that the question must allow multiple answers and aim to explore a significant potion of the overal passage or subsection.
      - Step 3: apply logic to ask one broad, text-rooted question that points toward the application.
      - Step 4: verify that the answer stays within the passage and does not assume outside knowledge.

   Examples:
   - "What things did the king do to show everyone how rich and important he was?" (Esther 1:1-12)
   - "What examples are in the passage that show the power these spirits had over the man's life?" (Mark 5:1-13)
   - "What clues in verses 1-3 show why the people in the palace were afraid?" (Esther 3:1-6)

   ### Interpret

   1. Decide whether interpretation within the passage or correlation with other passages is the best strategy
      A. Interpretation methods
         - Trace the argument flow and logical connections.
         - Explore historical and cultural context when it helps the text explain itself.
         - Identify Old Testament allusions, New Testament echoes, and authorial intent.
         - Ask about grammar, syntax, or word meaning only when it clarifies the text.
         - Example prompts:
           - “Why does the author use this phrase here?”
           - “What does this verse mean when the passage says...?”
           - “How does this section explain the earlier event?”

      B. Correlation methods
         - Pursue cross-references and parallel passages.
         - Connect the passage to major biblical themes: God’s character, humanity, sin, redemption, the people of God, the age to come.
         - Explore typology, prophecy, and fulfillment patterns.
         - Example prompts:
           - “Where else in Scripture do we see this pattern?”
           - “How does this passage relate to that other text?”
           - “What does this tell us about the big story of the Bible?”

   2. Interpretation/Correlation Steps
      - Step 1: identify the meaning clues in the text or a parallel Scripture that relate to the answers from the previous question.
      - Step 2: identify that the question must use scripture to interpret scripture, either from the given passage or a supporting passage. Identify whether any additional information needs to be given briefly in the question to communicate the logical flow from the previous question or to inform the answer.
      - Step 3: apply logic to ask one broad, text rooted question that asks the user to interpret the information of the previous question, using provided scripture and pointing toward the application.
      - Step 4: verify the answer is grounded in Scripture, not reader opinion.
      - Grace Dynamic note: prefer answers that show Christ’s sufficiency or human inability rather than a human-centered fix.

   Examples:
   - "What clues do we see as to why the king so angry and embarrassed when the queen said 'no'?" (Esther 1:1-12)
   - "In what ways does the passage show Jesus' power and authority?" (Mark 5:1-13)
   - "How does Proverbs 16:33 show that God was actually in control of Haman’s dice?" (Esther 3:7-13)

   ### Apply
   1. Application methods
      - Ground application in what the text reveals about God and his work before asking what it calls people to do.

### Answer Formatting (for Leader/Participant dual export)
   - **Format**: Place answers in HTML comments immediately after each question using the `<!-- ANSWER ... -->` syntax.
   - **Placement**: Directly after the question line, before any blank line or next question.
   - **Content**: Concise, text-grounded answer (2-4 sentences max). Reference verse numbers.
   - **Example**:
     ```markdown
     **Observe**: Who are the three main characters in this chapter, and what does each one do?
     <!-- ANSWER: Woman (God's people/Israel), Child (Jesus), Dragon (Satan). The woman gives birth; the dragon tries to devour the child; the child is caught up to God. -->
     
     **Interpret**: Who do the woman, the child, and the dragon represent?
     <!-- ANSWER: Woman = God's people (Isaiah 54, 66); Child = Jesus (Psalm 2:9); Dragon = Satan (Rev 12:9). -->
     ```
   - **Export logic**: 
     - Participant guide: strip all `<!-- ANSWER ... -->` comments
     - Leader guide: unwrap comments and render as muted grey text (CSS `color: var(--answer-grey, #888); font-size: 0.9em;`)
      - Draw out communal and life response questions.
      - Keep the question rooted in the passage, not in moralistic add-ons.
      - Example prompts:
        - “What does this text reveal about people’s need or God’s power?”
        - “What does this passage call people to believe or do?”
        - “How does this shape the group’s prayer or faith?”

   2. Application Steps
      - Step 1: identify the passage’s result, command, or character trait.
      - Step 2: identify that the question must ask for a life response that relates to the previous 2 questions. Identify whether any additional information needs to be given briefly in the question to communicate the logical flow from the previous question.
      - Step 3: apply logic by asking how the text should shape belief, behavior, or group life.
      - Step 4: verify the question flows from the text, is not generic moralizing, is depersonalised (to talk about people generally, not you or me specifically)
      - Grace Dynamic note: frame the response around Christ’s sufficiency or human need, not a human attempt to solve the problem.

   Examples:
   - "Why do people feel unsafe when they realize they aren’t in total control?" (Esther 1:1-12)
   - "What does this tell us about God's timing when situations get worse?" (Mark 5:30-43)
   - "How does knowing God is in charge of the timing of our lives help people stay calm in an uncertain world?" (Esther 3:7-13)

5. **Review Logic**:
   - **Depersonalize**: Ensure questions ask "Why do people..." rather than "Why do you..." (depersonalising the question).
   - **Length Check**: Are all questions <20 words?
      - **Numbering**: Bonus questions continue from the main study (e.g., Q9, Q10).
      - **Focus**: The first bonus question is for **interest/curiosity**; the second MUST be **application-focused**.
      - **Supporting Passage**: Consider how the supporting passage might shed light on the study and replace a question in the main study if it adds more value.
   - **Bonus Bucket**: Identify 1 additional and related application to draw from the study. Build an Observation or Interpretation question from the passage to lead to this bonus application. List these 2 additional questions as your bonus questions.

## Step 8: Write the opening question last

After the body is done, offer 3–5 opening options.
- Must be depersonalized.
- Must be sociological.
- Must prepare the group for the study flow.

Have the user choose the opening question and refine the wording.

## Step 9: Final review

Check:
- headings are correct
- questions use Observe, Interpret, Apply labels
- questions are short and clear
- Language: simple Year 8 vocabulary, but adult tone and logic.
- Kingdom vs World contrast is present

Review the full draft with the user and accept any final refinements before finalizing.

## Final output structure

```markdown
| # **[Item]**             | # **[Title]**            |
| :------------------------ | :----------------------- |
| **Main Idea**: [Summary]  | **Passages**: [Refs]     |
|                           |                          |

## **Opening Discussion**

- [Opening question — depersonalized sociological hook]

## **Read [Passage Reference — Movement 1]**

- **Observe**: [Observation question]
- **Interpret**: [Interpret question]
- **Apply**: [Apply question]

## **Read [Passage Reference — Movement 2]**

- **Observe**: [Observation question]
- **Interpret**: [Interpret question]
- **Apply**: [Apply question]

---

## **Bonus Questions**

- **Bonus curiosity**: [Bonus curiosity question]
- **Bonus application**: [Bonus application question]

---
```
