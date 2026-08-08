$catIdx = Get-Content '.agents/skills/boss/category-index.json' | ConvertFrom-Json
$total = 0
foreach ($cat in $catIdx) {
    $total += $cat.skills.Count
}
Write-Host "Total skills in CAT-IDX: $total"
$alphaIdx = Get-Content '.agents/skills/boss/alphabetical-index.json' | ConvertFrom-Json
Write-Host "Total skills in ALPHA-IDX: $($alphaIdx.Count)"