$content = Get-Content '.agents/skills/boss/00-setup/agents-md/SKILL.md' -Raw -Encoding UTF8
if ($content -match '(?s)---\s*\n(.*?)\n---') {
    $frontmatter = $matches[1]
    if ($frontmatter -match '(?m)^description:\s*(.+)') {
        $desc = $matches[1].Trim().Trim('"').Trim("'")
        Write-Host "Original desc: '$desc'"
        Write-Host "Desc length: $($desc.Length)"
        Write-Host "Desc is null/empty: $([string]::IsNullOrEmpty($desc))"
    }
}