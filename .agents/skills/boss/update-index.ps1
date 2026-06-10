# update-index.ps1
# Rebuilds BOSS_INDEX.json by scanning all SKILL.md files in the boss directory.
# Run this after adding or removing skills.

$bossDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$indexFile = Join-Path $bossDir "BOSS_INDEX.json"
$skills = @()

# Scan awesome/ and custom/ subdirectories
$sourceDirs = @("awesome", "custom")

foreach ($sourceDir in $sourceDirs) {
    $dirPath = Join-Path $bossDir $sourceDir
    if (-not (Test-Path $dirPath)) { continue }

    $skillDirs = Get-ChildItem -Path $dirPath -Directory -ErrorAction SilentlyContinue

    foreach ($skillDir in $skillDirs) {
        $skillMd = Join-Path $skillDir.FullName "SKILL.md"
        if (-not (Test-Path $skillMd)) { continue }

        $content = Get-Content $skillMd -Raw -Encoding UTF8

        # Extract YAML frontmatter
        $name = ""
        $description = ""
        $category = "uncategorized"
        $tags = @()
        $risk = "unknown"
        $source = $sourceDir

        if ($content -match '(?s)---\s*\n(.*?)\n---') {
            $frontmatter = $matches[1]

            if ($frontmatter -match 'name:\s*(.+)') { $name = $matches[1].Trim() }
            if ($frontmatter -match 'description:\s*["\x27]?(.+?)["\x27]?\s*$') { $description = $matches[1].Trim() }
            if ($frontmatter -match 'category:\s*(.+)') { $category = $matches[1].Trim() }
            if ($frontmatter -match 'risk:\s*(.+)') { $risk = $matches[1].Trim() }
            if ($frontmatter -match 'tags:\s*\[(.+?)\]') {
                $tags = $matches[1] -split ',' | ForEach-Object { $_.Trim() }
            }
        }

        # Use directory name as fallback
        if (-not $name) { $name = $skillDir.Name }

        # Extract triggers from description (first 100 chars as summary)
        $triggers = @()
        if ($description) {
            # Common trigger words to look for
            $triggerWords = @("use", "when", "before", "after", "create", "build", "test", "debug", "plan", "review", "deploy", "design", "write", "analyze", "fix", "implement", "manage", "automate", "convert", "generate")
            foreach ($word in $triggerWords) {
                if ($description -match "\b$word\b") { $triggers += $word }
            }
        }

        $skills += [PSCustomObject]@{
            id = $skillDir.Name
            name = $name
            description = $description.Substring(0, [Math]::Min(120, $description.Length))
            category = $category
            tags = $tags
            triggers = $triggers
            risk = $risk
            path = "$sourceDir/$($skillDir.Name)"
            source = if ($sourceDir -eq "awesome") { "awesome-skills" } else { "custom" }
        }
    }
}

# Build the index
$index = [PSCustomObject]@{
    version = 1
    generatedAt = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    skills = $skills
}

# Write as JSON
$index | ConvertTo-Json -Depth 5 | Set-Content $indexFile -Encoding UTF8

Write-Host "Index rebuilt: $($skills.Count) skills indexed."
Write-Host "  Awesome: $(($skills | Where-Object { $_.source -eq 'awesome-skills' }).Count)"
Write-Host "  Custom:  $(($skills | Where-Object { $_.source -eq 'custom' }).Count)"
