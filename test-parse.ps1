$cmdOutput = cmd /c 'dir /AL /S D:\daniel\Documents\vibecoding\ChurchCRM\.agents\skills 2>nul'
$lines = $cmdOutput -split "`r`n"
$currentDir = ''
foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -match '^Directory of (.+)$') {
        $currentDir = $matches[1].Trim()
        Write-Host "Dir: $currentDir"
        continue
    }
    if ($line -match '<JUNCTION>') {
        if ($line -match '\s+<JUNCTION>\s+(\S+)\s+\[(.+)\]') {
            $junctionName = $matches[1]
            $junctionTarget = $matches[2]
            $junctionPath = Join-Path $currentDir $junctionName
            Write-Host "Junction: $junctionPath -> $junctionTarget"
        }
    }
}