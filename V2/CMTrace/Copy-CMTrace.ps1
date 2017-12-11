<#
.SYNOPSIS
   Copy CMTrace.exe to C:\Windows
.DESCRIPTION
   Copy CMTrace.exe to C:\Windows for easy access on using CM logs.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Copy-CMTrace
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

Function Get-LogDir{
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

Function Copy-CMTrace {

Copy-Item $PSScriptRoot\CMTrace.exe $env:SystemRoot
Write-Information "CMTrace copied to c:\windows"

}

# ---------------------------------------------------------------------------
# Main Logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$LogDir\OSD-Copy-CMTrace.log"

Write-Information "$(Get-Date -UFormat %R)"

Copy-CMTrace

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript