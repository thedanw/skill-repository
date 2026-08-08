<#
.SYNOPSIS
    Updates junctions pointing from D:\daniel\Documents\antigravity\... to D:\daniel\Documents\vibecoding\...

.DESCRIPTION
    This script finds all junctions (directory symbolic links) in the vibecoding directory
    that point to paths under antigravity, and updates them to point to the corresponding
    paths under vibecoding instead.

.NOTES
    Run as Administrator for best results.
#>

param(
    [string]$SourceRoot = "D:\daniel\Documents\antigravity",
    [string]$TargetRoot = "D:\daniel\Documents\vibecoding",
    [string]$SearchRoot = "D:\daniel\Documents\vibecoding",
    [switch]$DryRun,
    [switch]$Verbose
)

Write-Host "=== Junction Update Script ===" -ForegroundColor Cyan
Write-Host "Source Root: $SourceRoot" -ForegroundColor Gray
Write-Host "Target Root: $TargetRoot" -ForegroundColor Gray
Write-Host "Search Root: $SearchRoot" -ForegroundColor Gray
Write-Host "Dry Run: $DryRun" -ForegroundColor Gray
Write-Host ""

# Use cmd dir to find all junctions - much faster than Get-ChildItem -Recurse
Write-Host "Scanning for junctions using cmd dir..." -ForegroundColor Yellow

$cmdOutput = cmd /c "dir /AL /S `"$SearchRoot`" 2>nul"
$lines = $cmdOutput -split "`r`n"

$junctions = @()
$currentDir = ""

foreach ($line in $lines) {
    $line = $line.Trim()
    
    # Check for directory header
    if ($line -match '^Directory of (.+)$') {
        $currentDir = $matches[1].Trim()
        continue
    }
    
    # Check for junction line
    if ($line -match '<JUNCTION>') {
        # Format: "DD/MM/YYYY  HH:MM AM/PM    <JUNCTION>     name [target]"
        if ($line -match '\s+<JUNCTION>\s+(\S+)\s+\[(.+)\]') {
            $junctionName = $matches[1]
            $junctionTarget = $matches[2]
            
            # Remove \??\ prefix if present
            if ($junctionTarget -match '^\\\\\?\\\\') {
                $junctionTarget = $junctionTarget.Substring(4)
            }
            
            # Check if target is under SourceRoot
            if ($junctionTarget.StartsWith($SourceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                $junctionPath = Join-Path $currentDir $junctionName
                $newTarget = $junctionTarget -replace [regex]::Escape($SourceRoot), $TargetRoot
                
                $junctions += [PSCustomObject]@{
                    Path = $junctionPath
                    Name = $junctionName
                    Target = $junctionTarget
                    NewTarget = $newTarget
                }
            }
        }
    }
}

Write-Host "Found $($junctions.Count) junctions pointing to $SourceRoot" -ForegroundColor Green

if ($junctions.Count -eq 0) {
    Write-Host "No junctions to update." -ForegroundColor Yellow
    exit 0
}

# Group by target to show what will be changed
$groups = $junctions | Group-Object Target

foreach ($group in $groups) {
    $oldTarget = $group.Name
    $newTarget = $group.Group[0].NewTarget
    
    Write-Host ""
    Write-Host "Target: $oldTarget" -ForegroundColor Cyan
    Write-Host "  -> New: $newTarget" -ForegroundColor Green
    Write-Host "  Junctions ($($group.Count)):" -ForegroundColor Gray
    
    foreach ($junction in $group.Group) {
        Write-Host "    $($junction.Path)" -ForegroundColor Gray
    }
}

if ($DryRun) {
    Write-Host ""
    Write-Host "=== DRY RUN - No changes made ===" -ForegroundColor Yellow
    exit 0
}

# Confirm before proceeding
if (-not $Verbose) {
    $confirm = Read-Host "Proceed with updating these junctions? (y/N)"
    if ($confirm -notmatch '^y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Update junctions
Write-Host ""
Write-Host "Updating junctions..." -ForegroundColor Yellow

$updated = 0
$failed = 0
$skipped = 0

foreach ($junction in $junctions) {
    $junctionPath = $junction.Path
    $newTarget = $junction.NewTarget
    
    # Verify new target exists
    if (-not (Test-Path $newTarget)) {
        Write-Warning "New target does not exist: $newTarget (skipping $junctionPath)"
        $skipped++
        continue
    }
    
    Write-Host "Updating: $junctionPath" -NoNewline -ForegroundColor Gray
    Write-Host " -> $newTarget" -ForegroundColor Cyan
    
    # Remove existing junction
    $removeResult = cmd /c "rmdir `"$junctionPath`" 2>&1"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Failed to remove: $removeResult" -ForegroundColor Red
        $failed++
        continue
    }
    
    # Create new junction
    $createResult = cmd /c "mklink /J `"$junctionPath`" `"$newTarget`" 2>&1"
    if ($LASTEXITCODE -eq 0) {
        $updated++
        Write-Host "  OK" -ForegroundColor Green
    } else {
        Write-Host "  FAILED: $createResult" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Updated: $updated" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red
Write-Host "Skipped (target missing): $skipped" -ForegroundColor Yellow