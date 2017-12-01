<#
.SYNOPSIS
   Create the Appx list to be removed during Task Sequence
.DESCRIPTION
   Create a list with provisioned Appx applications to be remove during
   a Task Sequence. The file Remove-Inbox-Apps.txt will be created on the
   desktop. Edit the text file if needed and add it to your Scripts Folder.
   Or create a Configration Manager package and use it with a Task sequence.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Create-AppxList
.EXAMPLE
   Create-AppxList -Overwrite -Verbose
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

Function Create-AppxList {
  [CmdletBinding()]
  Param
  ()
  
    # Look for a config file.
    $configFile = "$env:USERPROFILE\Desktop\Remove-Inbox-Apps.txt"
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
      Write-Verbose "Building list of provisioned apps"
      $list = @()
      Get-AppxProvisionedPackage -Online | % { $list += $_.DisplayName }
     
      # Write the List
      $FilePath = "$env:USERPROFILE\Desktop"
      $configFile = "$FilePath\Remove-Inbox-Apps.txt"
      $list | Set-Content $configFile
      Write-Verbose "Wrote list of apps to $filePath\Remove-Inbox-Apps.txt"
      Write-Verbose "Apps written to list: $($list.Count)"

    }  
}

Create-AppxList