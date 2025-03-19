#####################################
#   Copyright 2025 by Justin Nolte  #
#   Please be note that the script  #
#   is under the MIT license        #
#####################################

function Get-FolderSize {
    param (
        [string]$FolderPath
    )
    $totalSize = 0
    $items = Get-ChildItem -Path $FolderPath -Recurse -ErrorAction SilentlyContinue
    foreach ($item in $items) {
        if (-not $item.PSIsContainer) {
            $totalSize += $item.Length
        }
    }
    return $totalSize
}
$Username = $env:USERNAME
$TempPath = Join-Path $env:USERPROFILE "AppData\Local\Temp"
if (Test-Path $TempPath) {
    $InitialSizeBytes = Get-FolderSize -FolderPath $TempPath
    $InitialSizeMB = [math]::Round($InitialSizeBytes / 1MB, 2)
    $Files = Get-ChildItem -Path $TempPath -File -Recurse -ErrorAction SilentlyContinue
    $FileCount = $Files.Count
    $SubfolderCountBefore = (Get-ChildItem -Path $TempPath -Directory -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
    $DeletedFiles = 0
    $FailedDeletions = 0
    $DeletedSizeBytes = 0
    foreach ($file in $Files) {
        try {
            $FileSize = (Get-Item $file.FullName).Length
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            $DeletedFiles++
            $DeletedSizeBytes += $FileSize
        } catch {
            $FailedDeletions++
        }
    }
    $Directories = Get-ChildItem -Path $TempPath -Directory -Recurse -ErrorAction SilentlyContinue
    foreach ($dir in $Directories) {
        try {
            Remove-Item -Path $dir.FullName -Force -Recurse -ErrorAction Stop
        } catch {
        }
    }
    $FinalSizeBytes = Get-FolderSize -FolderPath $TempPath
    $FinalSizeMB = [math]::Round($FinalSizeBytes / 1MB, 2)
    $DeletedSizeMB = [math]::Round($DeletedSizeBytes / 1MB, 2)
    $SubfolderCountAfter = (Get-ChildItem -Path $TempPath -Directory -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
    Write-Output "Zusammenfassung:"
    Write-Output "User: $Username"
    Write-Output "Ordneranzahl: $SubfolderCountBefore"
    Write-Output "Gesamte Dateien: $FileCount"
    Write-Output "Dateien entfernt: $DeletedFiles"
    Write-Output "Nicht entfernt: $FailedDeletions"
    Write-Output "Gesamte Größe: $InitialSizeMB MB"
    Write-Output "Gelöschtes Datenvolumen: $DeletedSizeMB MB"
    Write-Output "Neues Datenvolumen Temp: $FinalSizeMB MB"
    Write-Output "Neue Ordneranzahl: $SubfolderCountAfter"
} else {
    Write-Output "Der Temp-Ordner unter $TempPath wurde nicht gefunden."
}
