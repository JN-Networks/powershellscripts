Write-Host "Please insert your path:" -ForegroundColor Yellow
$path = Read-Host "path"

Write-Host "Please insert your searchtext:" -ForegroundColor Yellow
$searchtext = Read-Host "searchtext"

# Dateien rekursiv sammeln
$files = Get-ChildItem -Path $path -File -Recurse

$results = @()

foreach ($file in $files) {
    $matches = Select-String -Path $file.FullName -Pattern $searchtext

    foreach ($match in $matches) {
        $results += [PSCustomObject]@{
            "Filename"     = $file.Name
            "Path"         = $file.FullName
            "Pointer Line" = $match.LineNumber
        }
    }
}

if ($results.Count -gt 0) {
    $results | Format-Table -AutoSize
} else {
    Write-Host "No results found." -ForegroundColor Red
}
