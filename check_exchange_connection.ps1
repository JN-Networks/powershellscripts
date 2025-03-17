#####################################
#   Copyright 2025 by Justin Nolte  #
#   Please be note that the script  #
#   is under the MIT license        #
#####################################

$server = "YOUR_SERVERNAME"
$ports = @(25, 587, 993, 995)
$logfile = "YOUR_LOG_PATH"
$autodiscoverDomain = "_autodiscover._tcp.YOUR_DOMAIN"
$exchangeServer = "YOUR_EXCHANGE_SERVER"

while ($true) {
    "==================== $(Get-Date) ====================" | Out-File -Append -FilePath $logfile
    Write-Host "==================== $(Get-Date) ====================" -ForegroundColor Yellow
    
    foreach ($port in $ports) {
        $connection = Test-NetConnection -ComputerName $server -Port $port -InformationLevel Detailed
        
        if ($connection.TcpTestSucceeded) {
            $message = "Port $port is available on $server."
            Write-Host $message -ForegroundColor Green
            $message | Out-File -Append -FilePath $logfile
        } else {
            $message = "ERROR: Port $port is not available on $server!"
            Write-Host $message -ForegroundColor Red
            $message | Out-File -Append -FilePath $logfile
        }
    }
    
    try {
        $dnsRecord = Resolve-DnsName -Name $autodiscoverDomain -Type SRV -ErrorAction Stop
        $message = "Autodiscover-Entry $autodiscoverDomain was successfull resolved."
        Write-Host $message -ForegroundColor Green
        $message | Out-File -Append -FilePath $logfile
    } catch {
        $message = "ERROR: Autodiscover-Entry $autodiscoverDomain cannot be resolved!"
        Write-Host $message -ForegroundColor Red
        $message | Out-File -Append -FilePath $logfile
    }
    
    try {
        $exchangeConnection = Test-NetConnection -ComputerName $exchangeServer -Port 443 -InformationLevel Detailed
        if ($exchangeConnection.TcpTestSucceeded) {
            $message = "Exchange ($exchangeServer) is available."
            Write-Host $message -ForegroundColor Green
            $message | Out-File -Append -FilePath $logfile
        } else {
            $message = "ERROR: Exchange ($exchangeServer) is not available!"
            Write-Host $message -ForegroundColor Red
            $message | Out-File -Append -FilePath $logfile
        }
    } catch {
        $message = "ERROR: Connection to Exchange ($exchangeServer) not available!"
        Write-Host $message -ForegroundColor Red
        "ERROR: $_" | Out-File -Append -FilePath $logfile
    }
    
    "=====================================================" | Out-File -Append -FilePath $logfile
    Write-Host "=====================================================" -ForegroundColor Yellow
}
