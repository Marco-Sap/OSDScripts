<#
.SYNOPSIS
   Expand Cab files in Folder to be used for LGPO
.DESCRIPTION
   Expand Cab files in seperate folders to be used in LGPO Solution.
   Cab files are the default backup from AGMP or GPMC, but LGPO uses
   the extracted folder structure to import the policy.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Invoke-ExtractCab
.EXAMPLE
   Invoke-ExtractCab -Verbose
.DISCLAIMER
   This script code is provided as is with no guarantee or waranty
   concerning the usability or impact on systems and may be used,
   distributed, and modified in any way provided the parties agree
   and acknowledge that Microsoft or Microsoft Partners have neither
   accountabilty or responsibility for results produced by use of
   this script.

   Microsoft will not provide any support through any means.
#>
[CmdletBinding()]
  Param()

Function Invoke-ExtractCab {
[CmdletBinding()]
Param()

  # Get Cab Files from folder
  $CabFiles = Get-ChildItem -Path "$PSScriptRoot" -Filter *.cab

    ForEach ($CabFile in $CabFiles)
    {

    # Create folders per Cab file
    Write-Verbose "Processing $PSScriptRoot\$CabFile"
    $FolderName = (Get-Item "$PSScriptRoot\$CabFile").BaseName
    if (!(Test-Path -path $PSScriptRoot\$FolderName)) {New-Item "$PSScriptRoot\$FolderName" -ItemType directory > $null}

    # Use expand on Cab file
    $Arguments = @("$CabFile", "$FolderName", "-F:*")
    $Process = Start-Process -FilePath "$env:Systemroot\system32\expand.exe" -ArgumentList $Arguments -WindowStyle Hidden -Wait -PassThru 
    
    # Handle Exit from process
    if ($Process.ExitCode -eq 0) {Write-Verbose "$CabFile has been successfully processed"} else {Write-Verbose "Exit Code $($Process.ExitCode) for $CabFile"}

    }
}

Invoke-ExtractCab