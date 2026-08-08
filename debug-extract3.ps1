$content = Get-Content '.agents/skills/boss/00-setup/agents-md/SKILL.md' -Raw -Encoding UTF8
if ($content -match '(?s)---\s*\n(.*?)\n---') {
    $frontmatter = $matches[1]
    Write-Host "Frontmatter extracted"
    if ($frontmatter -match '(?m)^description:\s*(.+)') {
        $desc = $matches[1].Trim().Trim('"').Trim("'")
        Write-Host "Description found: '$desc'"
    } else {
        Write-Host "Description NOT found in frontmatter"
    }
    if ($frontmatter -match '(?m)^tags:\s*\[(.+?)\]') {
        $tags = $matches[1] -split ',' | ForEach-Object { $_.Trim().Trim('"').Trim("'") } | Where-Object { $_ -ne '' }
        Write-Host "Tags found: $tags"
    } else {
        Write-Host "Tags NOT found in frontmatter"
    }
} else {
    Write-Host "Frontmatter NOT found"
}