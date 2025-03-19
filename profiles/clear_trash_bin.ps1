#####################################
#   Copyright 2025 by Justin Nolte  #
#   Please be note that the script  #
#   is under the MIT license        #
#####################################

# Please be note, this script is only on login of an user functional

$RecycleBinShell = New-Object -ComObject Shell.Application
$RecycleBinFolder = $RecycleBinShell.Namespace(10)
$RecycleBinItems = $RecycleBinFolder.Items()
if ($RecycleBinItems.Count -gt 0) {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Output "Trash bin of user succesfully deleted."
} else {
    Write-Output "Trash bin is already empty."
}