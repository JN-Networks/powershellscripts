# Benutzer nach Pfad fragen
Write-Host "Bitte geben Sie den Pfad ein:" -ForegroundColor Yellow
$Pfad = Read-Host "Pfad" 

# Benutzer nach Suchtext fragen
Write-Host "Bitte geben Sie den Suchtext ein:" -ForegroundColor Yellow
$Suchtext = Read-Host "Suchtext"

# Alle Dateien im angegebenen Pfad rekursiv durchsuchen
$Dateien = Get-ChildItem -Path $Pfad -File -Recurse

# Ergebnisse speichern
$Ergebnisse = @()

foreach ($Datei in $Dateien) {
    # Dateiinhalt durchsuchen
    $Treffer = Select-String -Path $Datei.FullName -Pattern $Suchtext
    
    foreach ($TrefferZeile in $Treffer) {
        # Daten für Tabelle speichern
        $Ergebnisse += [PSCustomObject]@{
            "Dateiname" = $Datei.Name
            "Pfad" = $Datei.FullName
            "Zeilennummer" = $TrefferZeile.LineNumber
        }
    }
}

# Tabelle ausgeben
if ($Ergebnisse.Count -gt 0) {
    $Ergebnisse | Format-Table -AutoSize
} else {
    Write-Host "Keine Treffer gefunden." -ForegroundColor Red
}
