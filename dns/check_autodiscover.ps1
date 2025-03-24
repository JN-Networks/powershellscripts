Write-Host "##########################################" -ForegroundColor Cyan
Write-Host "          NSLOOKUP AUTODISCOVER           " -ForegroundColor Cyan
Write-Host "##########################################" -ForegroundColor Cyan

$domain = Read-Host "Please enter the domain name: "

if ([string]::IsNullOrWhiteSpace($domain)) {
    Write-Host "Error: No domain provided." -ForegroundColor Red
    exit
}

Write-Host "`nResult for: nslookup -q=SRV _autodiscover._tcp.$domain`n" -ForegroundColor Yellow
try {
    $result = nslookup -q=SRV "_autodiscover._tcp.$domain" 2>&1
    $result | ForEach-Object { Write-Host $_ }
} catch {
    Write-Host "An error has occurred: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPress any button to close the window..." -ForegroundColor Gray
Read-Host