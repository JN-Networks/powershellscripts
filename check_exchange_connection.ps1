$server = "outlook.office365.com"
$ports = @(25, 587, 993, 995)  # Wichtige Mailserver-Ports
$logfile = "C:\Admin\temp\Outlook_connection\Mailserver_Check.txt"
$autodiscoverDomain = "_autodiscover._tcp.koehnlein-kollegen.de"
$exchangeServer = "outlook.office365.com"

while ($true) {
    "==================== $(Get-Date) ====================" | Out-File -Append -FilePath $logfile
    Write-Host "==================== $(Get-Date) ====================" -ForegroundColor Yellow
    
    foreach ($port in $ports) {
        $connection = Test-NetConnection -ComputerName $server -Port $port -InformationLevel Detailed
        
        if ($connection.TcpTestSucceeded) {
            $message = "Port $port ist erreichbar auf $server."
            Write-Host $message -ForegroundColor Green
            $message | Out-File -Append -FilePath $logfile
        } else {
            $message = "FEHLER: Port $port ist nicht erreichbar auf $server!"
            Write-Host $message -ForegroundColor Red
            $message | Out-File -Append -FilePath $logfile
        }
    }
    
    try {
        $dnsRecord = Resolve-DnsName -Name $autodiscoverDomain -Type SRV -ErrorAction Stop
        $message = "Autodiscover-Eintrag $autodiscoverDomain wurde erfolgreich aufgelöst."
        Write-Host $message -ForegroundColor Green
        $message | Out-File -Append -FilePath $logfile
    } catch {
        $message = "FEHLER: Autodiscover-Eintrag $autodiscoverDomain konnte nicht aufgelöst werden!"
        Write-Host $message -ForegroundColor Red
        $message | Out-File -Append -FilePath $logfile
    }
    
    try {
        $exchangeConnection = Test-NetConnection -ComputerName $exchangeServer -Port 443 -InformationLevel Detailed
        if ($exchangeConnection.TcpTestSucceeded) {
            $message = "Exchange ($exchangeServer) ist erreichbar."
            Write-Host $message -ForegroundColor Green
            $message | Out-File -Append -FilePath $logfile
        } else {
            $message = "FEHLER: Exchange ($exchangeServer) ist nicht erreichbar!"
            Write-Host $message -ForegroundColor Red
            $message | Out-File -Append -FilePath $logfile
        }
    } catch {
        $message = "FEHLER: Verbindung zu Exchange ($exchangeServer) fehlgeschlagen!"
        Write-Host $message -ForegroundColor Red
        "FEHLER: $_" | Out-File -Append -FilePath $logfile
    }
    
    "=====================================================" | Out-File -Append -FilePath $logfile
    Write-Host "=====================================================" -ForegroundColor Yellow
}
