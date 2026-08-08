# fix-categories.ps1
# One-off migration: sets the `category:` field in every SKILL.md frontmatter to
# match its parent folder (the consolidated target category). Adds the field if
# missing. Idempotent. Run from repo root.
$bossDir = '.agents/skills/boss'
$updated = 0
$added = 0
$skipped = 0

Get-ChildItem $bossDir -Directory | Where-Object { $_.Name -ne '01-manage' } | ForEach-Object {
    $cat = $_.Name
    Get-ChildItem $_.FullName -Directory | ForEach-Object {
        $skillMd = Join-Path $_.FullName 'SKILL.md'
        if (-not (Test-Path $skillMd)) { $skipped++; return }
        $content = Get-Content $skillMd -Raw -Encoding UTF8
        if ($content -notmatch '(?s)---\s*\n(.*?)\n---') { $skipped++; return }
        $fm = $matches[1]

        $lines = $fm -split "`n"
        $newLines = @()
        $found = $false
        foreach ($line in $lines) {
            if ($line -match '^category:\s*') {
                $newLines += "category: $cat"
                $found = $true
            } else {
                $newLines += $line
            }
        }
        if (-not $found) {
            $out = @()
            $inserted = $false
            foreach ($line in $newLines) {
                $out += $line
                if (-not $inserted -and $line -match '^name:\s*') {
                    $out += "category: $cat"
                    $inserted = $true
                }
            }
            if (-not $inserted) { $out = @("category: $cat") + $out }
            $newLines = $out
            $added++
        } else {
            $updated++
        }

        $newFm = $newLines -join "`n"
        if ($newFm -ne $fm) {
            $idx = $content.IndexOf($fm)
            $newContent = $content.Substring(0, $idx) + $newFm + $content.Substring($idx + $fm.Length)
            Set-Content $skillMd -Value $newContent -Encoding UTF8 -NoNewline
        }
    }
}
Write-Host "category fields updated: $updated"
Write-Host "category fields added: $added"
Write-Host "SKILL.md not found / skipped: $skipped"
