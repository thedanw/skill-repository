$catIdx = Get-Content '.agents/skills/boss/category-index.json' | ConvertFrom-Json
$nullCount = 0
foreach ($cat in $catIdx) {
    foreach ($skill in $cat.skills) {
        if (-not $skill.description -or $skill.description -eq 'null') {
            $nullCount++
            Write-Host "NULL: $($cat.cat_id)/$($skill.id)"
        }
    }
}
Write-Host "Total null descriptions: $nullCount"