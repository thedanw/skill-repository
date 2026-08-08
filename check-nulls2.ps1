$alphaIdx = Get-Content '.agents/skills/boss/alphabetical-index.json' | ConvertFrom-Json
$nullDesc = 0
$nullSearch = 0
foreach ($skill in $alphaIdx) {
    if (-not $skill.description -or $skill.description -eq 'null') {
        $nullDesc++
        Write-Host "NULL DESC: $($skill.id)"
    }
    if (-not $skill.search_terms -or $skill.search_terms -eq 'null') {
        $nullSearch++
        Write-Host "NULL SEARCH: $($skill.id)"
    }
}
Write-Host "Total null descriptions: $nullDesc"
Write-Host "Total null search_terms: $nullSearch"