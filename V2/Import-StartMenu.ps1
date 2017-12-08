<#
.SYNOPSIS
   Import a new Start Menu layout as a preference.
.DESCRIPTION
   Import Start Menu Layout during OSD and set it as a preference.
   In the Task Sequence Powershell Task set the -MenuName through
   parameters.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Import-StartMenu
.EXAMPLE
   Import-StartMenu -MenuName 1709-O2013.xml
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
  [String]$MenuName = "1709.xml"
  )


# ---------------------------------------------------------------------------
# Get-LogDir:  Return the location for logs and output files
# ---------------------------------------------------------------------------

Function Get-LogDir{
  Try
  {
    $TS = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    If ($TS.Value("LogPath") -ne "")
    {
      $LogDir = $TS.Value("LogPath")
    }
    Else
    {
      $LogDir = $TS.Value("_SMSTSLogPath")
    }
  }
  Catch
  {
    $LogDir = $env:TEMP
  }

  Return $LogDir
}

# ---------------------------------------------------------------------------
#
# ---------------------------------------------------------------------------

Function Import-StartMenu {
 [CmdletBinding()]
 Param()
  
  Import-StartLayout -LayoutPath "$PSScriptRoot\$($Script:PSBoundParameters["MenuName"])" -MountPath $env:SystemDrive\
  Write-Information "Applied $($Script:PSBoundParameters["MenuName"]) to $env:SystemDrive"

}

# ---------------------------------------------------------------------------
# Main Logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$LogDir\OSD-Import-StartMenu.log"

Write-Information "$(Get-Date -UFormat %R)"

Import-StartMenu

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript