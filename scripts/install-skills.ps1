# install-skills.ps1
# Sets up the skill repository after cloning.
# Run this from the repository root.

param(
    [string]$SkillPath = ".agents/skills/boss/awesome",
    [string[]]$Categories = @("development", "workflow", "design", "meta"),
    [string[]]$RiskLevels = @("safe", "none")
)

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$fullSkillPath = Join-Path $repoRoot $SkillPath

Write-Host "=== Skill Repository Setup ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create junction to skills.txt
$skillsTxt = "C:\Users\theda\.gemini\antigravity\skills.txt"
$junctionTarget = $repoRoot

if (Test-Path $skillsTxt) {
    Write-Host "skills.txt already exists. Updating..." -ForegroundColor Yellow
}
$junctionTarget | Set-Content $skillsTxt -Encoding UTF8
Write-Host "skills.txt pointed to: $junctionTarget" -ForegroundColor Green

# Step 2: Install curated awesome-skills
Write-Host ""
Write-Host "Installing curated awesome-skills..." -ForegroundColor Cyan
Write-Host "  Path: $fullSkillPath"
Write-Host "  Categories: $($Categories -join ', ')"
Write-Host "  Risk levels: $($RiskLevels -join ', ')"

$categoryArg = $Categories -join ','
$riskArg = $RiskLevels -join ','

npx antigravity-awesome-skills --path $fullSkillPath --category $categoryArg --risk $riskArg

# Step 3: Rebuild index
Write-Host ""
Write-Host "Rebuilding skill index..." -ForegroundColor Cyan
$updateScript = Join-Path $repoRoot ".agents\skills\boss\update-index.ps1"
if (Test-Path $updateScript) {
    & $updateScript
} else {
    Write-Host "  update-index.ps1 not found. Skipping." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Setup complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "To link boss into a workspace, run:" -ForegroundColor White
Write-Host '  mklink /J "skills\boss" "' + (Join-Path $repoRoot ".agents\skills\boss") + '"' -ForegroundColor Gray
