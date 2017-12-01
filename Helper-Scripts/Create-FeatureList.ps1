<#
.SYNOPSIS
   Create the Feature list to be removed during Task Sequence
.DESCRIPTION
   Create a list with Windows Features to be remove during a Task Sequence.
   The file Remove-Optional-Features.txt will be created on the desktop.
   Edit the text file if needed and add it to your Scripts Folder.
   Or create a Configration Manager package and use it with a Task sequence.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Create-FeatureList
.EXAMPLE
   Create-FeatureList -Overwrite -Verbose
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
  Param
  (
  [Switch]$Overwrite
  )

Function Create-FeatureList {
  [CmdletBinding()]
  Param
  (
  [Switch]$Overwrite
  )

    # Look for a config file.
    $configFile = "$env:USERPROFILE\Desktop\Remove-Optional-Features.txt"
    if ((Test-Path -Path $configFile) -and (!($Script:PSBoundParameters["Overwrite"])))
    {
      # Read the list
      Write-Verbose "File already exists at $configFile"
      $list = Get-Content $configFile
      Write-Verbose "Apps in list: $($list.Count)"
    }
    else
    {
      # Build the List
      Write-Verbose "Building list of all Features"
      $list = @()
      Get-WindowsOptionalFeature -Online | where {$_.State -eq 'Enabled'} | % { $list += $_.FeatureName }
     
      # Write the List
      $logDir = "$env:USERPROFILE\Desktop"
      $configFile = "$logDir\Remove-Optional-Features.txt"
      $list | Set-Content $configFile
      Write-Verbose "Wrote list of features to $logDir\Remove-Optional-Features.txt, edit and place in the same folder as the script to use that list for future script executions"
      Write-Verbose "Features written to list: $($list.Count)"
    }
}

Create-FeatureList