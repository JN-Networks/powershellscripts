#####################################
#   Copyright 2025 by Justin Nolte  #
#   Please be note that the script  #
#   is under the MIT license        #
#####################################

# Insert your registry path
$RegistryPath = "YOUR_REGISTRY_PATH"

$SIDs = Get-ChildItem -Path "Registry::HKEY_USERS" | Where-Object { 
    $_.Name -match '^HKEY_USERS\\S-1-5-' -and $_.Name -notmatch 'Classes'
}
foreach ($SID in $SIDs) {
    $SIDPath = $SID.PSChildName
    try {
        $user = New-Object System.Security.Principal.SecurityIdentifier($SIDPath)
        $account = $user.Translate([System.Security.Principal.NTAccount])
        $RegPath = "Registry::HKEY_USERS\$SIDPath\$RegistryPath"
        if (Test-Path $RegPath) {
            Write-Output "SID: $SIDPath ($account)"
            Write-Output "Alle Registry-Werte für HookCairo.Connect:"
            $Properties = Get-ItemProperty -Path $RegPath
            foreach ($Property in $Properties.PSObject.Properties) {
                if ($Property.Name -notmatch '^PS') {
                    Write-Output "$($Property.Name): $($Property.Value)"
                }
            }
            Write-Output "-----------------------------------------"
        }
    } catch {
        Write-Output "SID: $SIDPath - No valid User, scipped."
    }
}
