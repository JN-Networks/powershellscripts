Write-Host "Please insert your path:" -ForegroundColor Yellow
$path = Read-Host "path" 

Write-Host "Please insert your searchtext:" -ForegroundColor Yellow
$searchtext = Read-Host "searchtext"

$files = Get-ChildItem -Path $Pfad -File -Recurse

$results = @()

foreach ($files in $file) {
    $pointer = Select-String -Path $files.FullName -Pattern $Suchtext
    
    foreach ($pointerline in $pointer) {
        $results += [PSCustomObject]@{
            "Filename" = $files.Name
            "Path" = $files.FullName
            "Pointer Line" = $pointerline.LineNumber
        }
    }
}

if ($results.Count -gt 0) {
    $results | Format-Table -AutoSize
} else {
    Write-Host "No results find." -ForegroundColor Red
}
