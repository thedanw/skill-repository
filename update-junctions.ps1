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

# Function to get junction target using fsutil
function Get-JunctionTarget {
    param([string]$Path)
    
    try {
        $result = fsutil reparsepoint query $Path 2>$null
        if ($result -match 'Substitute Name:\\s*(.+)') {
            $target = $matches[1].Trim()
            # Remove the \??\ prefix if present
            if ($target -match '^\\\\\?\\\\') {
                $target = $target.Substring(4)
            }
            return $target
        }
    } catch {
        Write-Warning "Failed to query junction: $Path"
    }
    return $null
}

# Function to create/update junction
function Set-Junction {
    param(
        [string]$JunctionPath,
        [string]$TargetPath,
        [switch]$Force
    )
    
    # Remove existing junction if it exists
    if (Test-Path $JunctionPath) {
        if ($Force) {
            cmd /c "rmdir `"$JunctionPath`"" 2>$null
        } else {
            Write-Warning "Junction already exists: $JunctionPath (use -Force to overwrite)"
            return $false
        }
    }
    
    # Create parent directory if needed
    $parent = Split-Path $JunctionPath -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    
    # Create the junction
    try {
        cmd /c "mklink /J `"$JunctionPath`" `"$TargetPath`"" 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $true
        } else {
            Write-Error "Failed to create junction: $JunctionPath -> $TargetPath"
            return $false
        }
    } catch {
        Write-Error "Exception creating junction: $_"
        return $false
    }
}

Write-Host "=== Junction Update Script ===" -ForegroundColor Cyan
Write-Host "Source Root: $SourceRoot" -ForegroundColor Gray
Write-Host "Target Root: $TargetRoot" -ForegroundColor Gray
Write-Host "Search Root: $SearchRoot" -ForegroundColor Gray
Write-Host "Dry Run: $DryRun" -ForegroundColor Gray
Write-Host ""

# Find all junctions in the search root
Write-Host "Scanning for junctions..." -ForegroundColor Yellow
$junctions = @()

# Use cmd dir to find all junctions recursively
$cmdOutput = cmd /c "dir /AL /S `"$SearchRoot`" 2>nul"
$lines = $cmdOutput -split "`r`n"

foreach ($line in $lines) {
    if ($line -match '<JUNCTION>') {
        # Parse the line to get junction name and target
        # Format: "DD/MM/YYYY  HH:MM AM/PM    <JUNCTION>     name [target]"
        if ($line -match '\s+<JUNCTION>\s+(\S+)\s+\[(.+)\]') {
            $junctionName = $matches[1]
            $junctionTarget = $matches[2]
            
            # Find the full path of this junction
            # We need to find which directory this junction is in
            # The dir output shows the directory before the junction entries
        }
    }
}

# Better approach: Use PowerShell to find reparse points
Write-Host "Using PowerShell to find reparse points..." -ForegroundColor Yellow

$allJunctions = Get-ChildItem -Path $SearchRoot -Recurse -Force -ErrorAction SilentlyContinue | 
    Where-Object { $_.LinkType -eq "Junction" } |
    ForEach-Object {
        $target = Get-JunctionTarget $_.FullName
        if ($target -and $target.StartsWith($SourceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            $_ | Add-Member -MemberType NoteProperty -Name "ResolvedTarget" -Value $target -Force
            $_
        }
    }

Write-Host "Found $($allJunctions.Count) junctions pointing to $SourceRoot" -ForegroundColor Green

if ($allJunctions.Count -eq 0) {
    Write-Host "No junctions to update." -ForegroundColor Yellow
    exit 0
}

# Group by target to show what will be changed
$groups = $allJunctions | Group-Object ResolvedTarget

foreach ($group in $groups) {
    $oldTarget = $group.Name
    $newTarget = $oldTarget -replace [regex]::Escape($SourceRoot), $TargetRoot
    
    Write-Host ""
    Write-Host "Target: $oldTarget" -ForegroundColor Cyan
    Write-Host "  -> New: $newTarget" -ForegroundColor Green
    Write-Host "  Junctions ($($group.Count)):" -ForegroundColor Gray
    
    foreach ($junction in $group.Group) {
        Write-Host "    $($junction.FullName)" -ForegroundColor Gray
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

foreach ($junction in $allJunctions) {
    $oldTarget = $junction.ResolvedTarget
    $newTarget = $oldTarget -replace [regex]::Escape($SourceRoot), $TargetRoot
    $junctionPath = $junction.FullName
    
    # Verify new target exists
    if (-not (Test-Path $newTarget)) {
        Write-Warning "New target does not exist: $newTarget (skipping $junctionPath)"
        $failed++
        continue
    }
    
    Write-Host "Updating: $junctionPath" -NoNewline -ForegroundColor Gray
    Write-Host " -> $newTarget" -ForegroundColor Cyan
    
    if (Set-Junction -JunctionPath $junctionPath -TargetPath $newTarget -Force) {
        $updated++
        Write-Host "  OK" -ForegroundColor Green
    } else {
        $failed++
        Write-Host "  FAILED" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Updated: $updated" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red