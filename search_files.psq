# Benutzer nach Pfad fragen
Write-Host "Bitte geben Sie denn Pfad ein:" -ForegroundColor Yellow
$Pfad = Read-Host "Pfad" 

# Benutzer nach Suchtext fragen
Write-Host "Bitte geben Sie den Suchtext ein:" -ForegroundColor Yellow
$Suchtext = Read-Host "Suchtext"

# Alle Dateien im angegebenen Pfad rekursiv durchsuchen
$Dateien = Get-ChildItem -Path $Pfad -File -Recurse

foreach ($Datei in $Dateien) {
    # Dateiinhalt einlesen und überprüfen, ob der Suchtext enthalten ist
    if (Select-String -Path $Datei.FullName -Pattern $Suchtext -Quiet) {
        Write-Output $Datei.FullName  # Gefundene Datei ausgeben
    }
}
