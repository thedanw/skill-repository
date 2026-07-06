# update-index.ps1
# Rebuilds BOSS_INDEX.json by scanning all one-level-deep category folders
# under .agents/skills/boss/ for SKILL.md files.
# Run this after adding, removing, or updating any skill.
#
# Category folders are: code-plan/, debugging/, doc-create/, github/,
# marketing/, memory/, scripts/, skill-create/, technical-change-tracker/,
# tools/, ui-ux/, writing/

$bossDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$indexFile = Join-Path $bossDir "BOSS_INDEX.json"
$skills = @()

# Get all immediate subdirectories (category folders)
$categoryDirs = Get-ChildItem -Path $bossDir -Directory | Where-Object {
    # Skip scripts/ folder and root config files
    $_.Name -notin @('scripts') -and
    # Only include folders that have subfolders (skills are one level deep)
    (Get-ChildItem -Path $_.FullName -Directory -ErrorAction SilentlyContinue).Count -gt 0
} | Sort-Object Name

$skillCount = 0
$skipCount = 0

foreach ($catDir in $categoryDirs) {
    $category = $catDir.Name
    $skillDirs = Get-ChildItem -Path $catDir.FullName -Directory -ErrorAction SilentlyContinue | Sort-Object Name

    foreach ($skillDir in $skillDirs) {
        $skillMd = Join-Path $skillDir.FullName "SKILL.md"
        if (-not (Test-Path $skillMd)) {
            $skipCount++
            continue
        }

        $content = Get-Content $skillMd -Raw -Encoding UTF8

        # Extract YAML frontmatter
        $name = $skillDir.Name
        $description = ""
        $skillCategory = $category
        $tags = @()
        $risk = "unknown"
        $triggers = @()

        if ($content -match '(?s)---\s*\n(.*?)\n---') {
            $frontmatter = $matches[1]

            if ($frontmatter -match '(?m)^name:\s*(.+)') {
                $name = $matches[1].Trim().Trim('"').Trim("'")
            }
            if ($frontmatter -match '(?m)^description:\s*(.+)') {
                $description = $matches[1].Trim().Trim('"').Trim("'")
            }
            if ($frontmatter -match '(?m)^category:\s*(.+)') {
                $skillCategory = $matches[1].Trim()
            }
            if ($frontmatter -match '(?m)^risk:\s*(.+)') {
                $risk = $matches[1].Trim()
            }
            if ($frontmatter -match '(?m)^tags:\s*\[(.+?)\]') {
                $tags = $matches[1] -split ',' | ForEach-Object { $_.Trim().Trim('"').Trim("'") } | Where-Object { $_ -ne '' }
            }
        }

        # Generate triggers from description (action verbs)
        if ($description) {
            $triggerPatterns = @(
                @{word="create"; desc="creating"}, @{word="build"; desc="building"},
                @{word="debug"; desc="debugging"}, @{word="fix"; desc="fixing"},
                @{word="audit"; desc="auditing"}, @{word="review"; desc="reviewing"},
                @{word="design"; desc="designing"}, @{word="write"; desc="writing"},
                @{word="plan"; desc="planning"}, @{word="test"; desc="testing"},
                @{word="deploy"; desc="deploying"}, @{word="analyze"; desc="analyzing"},
                @{word="optimize"; desc="optimizing"}, @{word="convert"; desc="converting"},
                @{word="generate"; desc="generating"}, @{word="push"; desc="pushing"},
                @{word="summarize"; desc="summarizing"}, @{word="validate"; desc="validating"},
                @{word="track"; desc="tracking"}
            )
            $descLower = $description.ToLower()
            foreach ($tp in $triggerPatterns) {
                if ($descLower -match "\b$($tp.word)\w*\b") {
                    $triggers += $tp.word
                }
            }
        }

        $skills += [PSCustomObject]@{
            id = $skillDir.Name
            name = $name
            description = if ($description) { $description.Substring(0, [Math]::Min(200, $description.Length)) } else { "" }
            category = $skillCategory
            tags = $tags
            triggers = $triggers | Sort-Object -Unique
            risk = $risk
            path = "$category/$($skillDir.Name)"
            source = "installed"
        }

        $skillCount++
    }
}

# Sort skills by category then name
$skills = $skills | Sort-Object category, name

# Build the index
$index = [PSCustomObject]@{
    version = 2
    generatedAt = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    registryType = "boss-local"
    skills = $skills
}

# Write as JSON with proper depth
$json = $index | ConvertTo-Json -Depth 5

# Fix single-element triggers arrays that PowerShell serializes as strings
$json = [System.Text.RegularExpressions.Regex]::Replace($json, '"triggers":\s*"((?:(?!\s*\}).)+)"', '"triggers": ["$1"]')

# Fix empty triggers serialized as objects
$json = $json -replace '"triggers":\s*\{\s*\}', '"triggers": []'

# Also fix empty tags arrays serialized as empty (though they're already fine, just being safe)
$json = $json -replace '"tags":\s*\{\s*\}', '"tags": []'

$json | Set-Content $indexFile -Encoding UTF8

Write-Host "BOSS_INDEX.json rebuilt successfully."
Write-Host "  Categories scanned: $($categoryDirs.Count)"
Write-Host "  Skills indexed: $skillCount"
if ($skipCount -gt 0) {
    Write-Host "  Folders skipped (no SKILL.md): $skipCount"
}
