$catIdx = Get-Item '.agents/skills/boss/category-index.json'
$alphaIdx = Get-Item '.agents/skills/boss/alphabetical-index.json'
$legacyIdx = Get-Item '.agents/skills/boss/BOSS_INDEX.json'
Write-Host "category-index.json: $($catIdx.Length / 1KB) KB"
Write-Host "alphabetical-index.json: $($alphaIdx.Length / 1KB) KB"
Write-Host "BOSS_INDEX.json: $($legacyIdx.Length / 1KB) KB"
Write-Host "Combined: $((($catIdx.Length + $alphaIdx.Length) / 1KB)) KB"