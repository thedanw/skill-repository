---
name: Sync & Document Generation
description: Sync markdown to Google Docs and generate high-fidelity RTF, HTML, and PDF documents with New Light Branding.
---

# Sync & Document Skill

A centralized suite of scripts for syncing sermon notes to Google Docs and generating print-ready materials (RTF, HTML, PDF, DOCX) with church-specific styling.

## 1. Google Doc Sync (`md_to_gdoc.py`)
Primary tool for uploading local Markdown sermon outlines to Google Docs while maintaining formatting.

**Usage:**
```powershell
python .agents/skills/sync-docs/scripts/md_to_gdoc.py "[PathToMD]" --id [OptionalGDocID] --export [pdf,docx,rtf]
```
*   **Sync**: Updates the Google Doc linked to the file or creates a new one.
*   **Export**: If `--export` is provided, it saves local copies of those formats in the same directory.

## 2. Multi-Format Generation (`create_docs.py`)
Centralized local generator for RTF and HTML formats.

**Usage:**
```powershell
python .agents/skills/sync-docs/scripts/create_docs.py "[PathToMD]" --html --rtf
```
*   Use this for direct markdown-to-formatted-file conversion without involving Google Docs.

## 3. Bible Study RTF Generator (`md_to_rtf_studies.py`)
Specialized high-fidelity RTF generator for Bible Study booklets. Uses New Light brand colors (Orange #FF7300) and specific layouts.

**Usage:**
```powershell
python .agents/skills/sync-docs/scripts/md_to_rtf_studies.py "[PathToMD]" "[OptionalOutputPath]"
```
*   **Format**: Expects studies separated by `---`.
*   **Styling**: Automatically applies the New Light "Header Table" design for each study.

## Support Files
These must remain in the `scripts/` directory for Google API authentication:
*   `credentials.json`: OAuth client secrets.
*   `token.json`: Active user session token.

## Detailed Capabilities

### `md_to_gdoc.py` Capabilities

**Path-Based Folder Organization:**
- Automatically parses `Sermons_n_Series/{Year}/{Series}/` from the local file path
- Creates corresponding folder hierarchy in Google Drive under the root folder

**Document Creation:**
- Root folder ID in Google Drive: `1dGRJkjh5hVGvhYc5cZ7k99BeCNA262yy`
- Uses a shared Google Docs template (`1o3tbW_5jlMNsFKaZhht9xfT8rx6mYUdpqYfTJ3o8Zn8`) as the base for new documents
- Copies the template, names it after the markdown file, and places it in the correct Drive folder

**Inline Markdown Style Parsing:**
- `**bold**` → Bold text style
- `_underline_` → Underline text style
- `*italic*` → Italic text style
- `[link text](url)` → Hyperlinked text

**Table Support:**
- Creates native Google Docs tables from markdown pipe-delimited tables
- First row automatically receives bold styling (header row)
- Table callout rendering: 1x2 tables with a left border, used for code blocks and backtick-wrapped inline text

**Horizontal Rules:**
- `---`, `***`, `___` rendered as centered Unicode dash lines

**List Support:**
- Bullet lists with indentation levels (▪ for top level, - for nested)
- Numbered lists with tab indentation

**Export Formats:**
- Supported: `pdf`, `docx`, `rtf`, `txt`, `odt`

**Authentication:**
- Re-authentication flow: if `token.json` expires, runs the OAuth flow again automatically
- Uses `credentials.json` for initial OAuth client secrets

**Heading Support (Google Docs styles):**
- Only `HEADING_1`, `HEADING_2`, `HEADING_3` heading levels are supported

### `create_docs.py` Capabilities

**HTML Generation:**
- Uses `bible_study_template.html` located in the scripts directory as the HTML template
- Template variables available for replacement:
  - `{{title}}` - Series title
  - `{{series_title}}` - Series title (repeated)
  - `{{intro_text}}` - Introductory text before the studies
  - `{{year}}` - Year detected from file path
  - `{{toc_rows}}` - Table of Contents rows generated from parsed studies
  - `{{study_pages}}` - Individual study page HTML blocks

**Study Header Format Support:**
- **2x2 Table (Esther style)**: `| # **Num** | # **Title** |` row followed by `| **Main Idea**: ... | **Passages**: ... |` row
- **1x2 Table (Mark style)**: Single row with number + title/subtitle, plus separate **Main Idea** and **Passages** lines parsed from the content

**Metadata Detection:**
- Automatically detects year from file path using regex (`20\d{2}`)
- Generates a Table of Contents from parsed studies with links to study anchors

**PDF Generation:**
- Uses headless Chrome or Edge browser (checks standard Windows install paths)
- `--pdf` flag generates PDF from the HTML output automatically
- Requires HTML generation first (or `--pdf` implies `--html`)

**Brand Colors Baked In:**
- `PRIMARY_ORANGE: #FF7300`
- `MIDNIGHT: #313638`
- `SECONDARY_GREEN: #60695C`
- `OFF_WHITE: #F8F9FA`
- Fonts: Inter Tight (headings), Inter (body)

**RTF Generation (built-in):**
- Simple RTF generation with font table (Inter, Inter Tight) and color table (Orange, Midnight)
- Heading levels: `#` → large orange Inter Tight, `##` → medium orange Inter Tight
- Numbered list support with hanging indent
- Unicode escape handling for extended characters
- A4 page size with 1-inch margins

### `md_to_rtf_studies.py` Capabilities

**RTF Color Table:**
- Color 0: Black (Auto)
- Color 1: Brand Orange `#FF7300`
- Color 2: White `#FFFFFF`
- Color 3: Brand Grey `#313638`
- Color 4: Light Grey Accent `#F4F3EF` (warm off-white)

**Fonts Used:**
- Inter (body text, regular)
- Inter Tight (headings, bold)
- Segoe UI Symbol (bullet characters)

**Header Table Design:**
- Cell 1: Orange background (`\clcbpat1`) with white bold text for study number, 36pt (fs72), centered
- Cell 2: White background with orange title, grey summary paragraph, and italic grey passage reference

**Content Block Types:**
- `h2` — Heading 2, Inter Tight Bold, Brand Grey, ~24px
- `numbered_list` — Hanging indent with left indent 720 twips
- `bullet_list` — Bullet character prefix with hanging indent
- `meta` — Italic grey text for metadata lines (Main Idea, Passages)
- `para` — Standard paragraph, Inter Regular, 24pt, Brand Grey

**Layout:**
- Page breaks inserted between studies
- Paper: A4 (11906x16838 twips) with 1-inch margins (1440 twips)
- Unicode escape handling for characters outside ASCII range (signed 16-bit `\uN?` format)

## Brand Integration

The scripts reference brand assets defined in the [brand skill](../brand/SKILL.md):

**Color Reference (from brand skill):**
- Full brand color specifications available in RGB, CMYK, and Pantone values
- Primary Orange `#FF7300` (Pantone 151 C) for primary actions, headings, links
- Midnight `#313638` (Pantone 447 C) for body text, dark UI elements
- Secondary Green `#60695C` for info, secondary actions

**Typography (from brand skill):**
- Inter Tight Bold for all major headings (weight 700, capitalize)
- Inter Regular for body text (weight 400, sentence case)
- Mobile-first responsive font size scale

**Design Patterns (from brand skill):**
- Square corners (0px border-radius) as default
- Occasional single rounded corner accent (8px-12px) for featured elements
- Double-line accent style for decorative dividers

## Ecosystem Integration

**Antigravity Skill Ecosystem:**
- Sync-docs is part of the Antigravity skill ecosystem managed by the meta-orchestrator (boss skill)
- Successful sync workflows should be recorded via `memory_write` with type `skill_combination` for future reuse
- Task complexity guardrails apply: simple single-file updates do not need orchestration

**Input Sources:**
- The input markdown files for sync-docs are produced by the `individual_sermon_brainstormer` workflow
- Brainstormer output is written to `[Talk Path]/[BibleRef].md`
- These markdown files contain sermon outlines with rhetorical devices from the rhetoric skill

## Utility Scripts

The `scripts/` directory includes additional helper utilities:

- `list_files.py`: Lists the 5 most recent files in the connected Google Drive (for verification purposes)
- `get_links.py`: Retrieves file names and `webViewLink` URLs from Google Drive, saves output to `links.txt`
- `links.txt`: Output file generated by `get_links.py` containing file names and web links
- `output.txt`: Log output file

## Dependencies

**Python Libraries (required):**
- `google-auth` — Google authentication library
- `google-auth-oauthlib` — OAuth flow support
- `google-auth-httplib2` — HTTP transport for Google auth
- `google-api-python-client` — Google APIs client library
- `markdown` — Python Markdown to HTML conversion

**For PDF Generation:**
- Google Chrome or Microsoft Edge browser installed on Windows (headless mode)
