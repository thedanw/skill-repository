---
description: Sync a Markdown sermon outline to Google Docs using the central createDocs system
---

# Sync to Docs (createDocs Shortcut)
---
description: Sync a Markdown sermon outline to Google Docs using the central createDocs system
---

# Sync to Docs (createDocs Shortcut)

This workflow is a simplified wrapper for the central `createDocs` system, focused on Google Docs synchronization.

1.  **Identify Target**: Locate the `.md` file to sync.
2.  **Execute Sync**:
    // turbo
    - Invoke the central workflow: `python .agents\skills\sync-docs\scripts\md_to_gdoc.py "[Target Path]" --export pdf,docx`
3.  **Result**: Provide the Google Doc link and confirm that PDF and DOCX exports have been saved to the local folder.
