<#
.SYNOPSIS
   Copy Configuration Manager ShortCut to Application Menu
.DESCRIPTION
   Copy the Configuration Manager Control Panel ShortCut to
   the application menu for easy access.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Copy-CMIcon
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

# ---------------------------------------------------------------------------
# Get-LogDir:  Return the location for logs and output files
# ---------------------------------------------------------------------------

Function Get-LogDir
{
  try
  {
    $TS = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    if ($TS.Value("LogPath") -ne "")
    {
      $LogDir = $TS.Value("LogPath")
    }
    else
    {
      $LogDir = $TS.Value("_SMSTSLogPath")
    }
  }
  catch
  {
    $LogDir = $env:TEMP
  }

  return $LogDir
}

# ---------------------------------------------------------------------------
# Copy-CM: Copy the CM Icon to Apps list of Start Menu
# ---------------------------------------------------------------------------

Function Copy-CM {

$IconPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager"

    If (Test-path -Path $IconPath){Copy-Item $PSScriptRoot\Config*.* $IconPath;Write-Information "Icon copied"}
    Else
    {
    $SystemCenter = "Microsoft System Center"
    $ConfigManager= "Configuration Manager"
    New-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" -Name $SystemCenter -ItemType Directory
    New-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$SystemCenter" -Name $ConfigManager -ItemType Directory
    Copy-Item $PSScriptRoot\Config*.* $IconPath
    Write-Information "Icon copied (backup)"
    }
    #Write-Information "Path not Found";Stop-Transcript;Exit 1}


}

# ---------------------------------------------------------------------------
# Main Logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$LogDir\OSD-Copy-CMIcon.log"

Write-Information "$(Get-Date -UFormat %R)"

Copy-CM

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript