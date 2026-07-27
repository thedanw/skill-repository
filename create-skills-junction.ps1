# Create a junction named 'skills' in the current terminal folder
# that points to D:\daniel\Documents\antigravity\skill-repository\.agents\skills

param()

$targetPath = 'D:\daniel\Documents\antigravity\skill-repository\.agents\skills'
$linkName = Join-Path -Path (Get-Location) -ChildPath 'skills'

Write-Host "Target path: $targetPath"
Write-Host "Link path:   $linkName"

if (-not (Test-Path -Path $targetPath)) {
    Write-Error "Target path does not exist: $targetPath"
    exit 1
}

if (Test-Path -Path $linkName) {
    $existing = Get-Item -Path $linkName -ErrorAction SilentlyContinue
    if ($existing -and $existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing junction or symbolic link found at $linkName. Removing it."
        Remove-Item -Path $linkName -Force
    } else {
        Write-Error "A file or folder already exists at $linkName and is not a junction. Remove it before running this script."
        exit 1
    }
}

New-Item -Path $linkName -ItemType Junction -Value $targetPath | Out-Null
Write-Host "Junction created: $linkName -> $targetPath"