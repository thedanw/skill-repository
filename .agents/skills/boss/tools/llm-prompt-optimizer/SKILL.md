---
name: llm-prompt-optimizer
description: "Transforms weak prompts into precision-engineered instructions using RSCIT framework, chain-of-thought, few-shot patterns, and structured output templates. Use when prompts return inconsistent results or to reduce token usage without sacrificing quality."
category: tools
risk: safe
source: adapted
tags: [prompts, optimization, llm, engineering, tokens, chain-of-thought, few-shot]
triggers: [prompt-weak, inconsistent-output, token-waste, hallucination, bad-output]
---

# LLM Prompt Optimizer

## Overview

This skill transforms weak, vague, or inconsistent prompts into precision-engineered instructions that reliably produce high-quality outputs from any LLM (Claude, Gemini, GPT-4, Llama, etc.). It applies systematic prompt engineering frameworks — from zero-shot to few-shot, chain-of-thought, and structured output patterns.

## When to Use This Skill

- Use when a prompt returns inconsistent, vague, or hallucinated results
- Use when you need structured/JSON output from an LLM reliably
- Use when designing system prompts for AI agents or chatbots
- Use when you want to reduce token usage without sacrificing quality
- Use when implementing chain-of-thought reasoning for complex tasks
- Use when prompts work on one model but fail on another

## Step-by-Step Guide

### 1. Diagnose the Weak Prompt

Before optimizing, identify which problem pattern applies:

| Problem | Symptom | Fix |
|---------|---------|-----|
| Too vague | Generic, unhelpful answers | Add role + context + constraints |
| No structure | Unformatted, hard-to-parse output | Specify output format explicitly |
| Hallucination | Confident wrong answers | Add "say I don't know if unsure" |
| Inconsistent | Different answers each run | Add few-shot examples |
| Too long | Verbose, padded responses | Add length constraints |

### 2. Apply the RSCIT Framework

Every optimized prompt should have:

- **R** — **Role**: Who is the AI in this interaction?
- **S** — **Situation**: What context does it need?
- **C** — **Constraints**: What are the rules and limits?
- **I** — **Instructions**: What exactly should it do?
- **T** — **Template**: What should the output look like?

**Before (weak prompt):**
```
Explain machine learning.
```

**After (optimized prompt):**
```
You are a senior ML engineer explaining concepts to a junior developer.

Context: The developer has 1 year of Python experience but no ML background.

Task: Explain supervised machine learning in simple terms.

Constraints:
- Use an analogy from everyday life
- Maximum 200 words
- No mathematical formulas
- End with one actionable next step

Format: Plain prose, no bullet points.
```

### 3. Chain-of-Thought (CoT) Pattern

For reasoning tasks, instruct the model to think step-by-step:

```
Solve this problem step by step, showing your work at each stage.
Only provide the final answer after completing all reasoning steps.

Problem: [your problem here]

Thinking process:
Step 1: [identify what's given]
Step 2: [identify what's needed]
Step 3: [apply logic or formula]
Step 4: [verify the answer]

Final Answer:
```

### 4. Few-Shot Examples Pattern

Provide 2-3 examples to establish the pattern:

```
Classify the sentiment of each review as POSITIVE, NEGATIVE, or NEUTRAL.

Examples:
Review: "This product changed my life, absolutely amazing!" -> POSITIVE
Review: "It arrived broken and support was useless." -> NEGATIVE
Review: "Product works as described, nothing special." -> NEUTRAL

Now classify:
Review: "[your review here]" ->
```

### 5. Structured JSON Output Pattern

```
Extract the following information from the text below and return it as valid JSON only.
Do not include any explanation or markdown — just the raw JSON object.

Schema:
{
  "name": string,
  "email": string | null,
  "company": string | null,
  "role": string | null
}

Text: [input text here]
```
