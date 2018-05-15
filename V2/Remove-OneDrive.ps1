<#
.SYNOPSIS
   Removes the OneDriveSetup.exe from the Default User profile
.DESCRIPTION
   Remove OneDriveSetup.exe from the Default User profile under
   Software\Microsoft\Windows\CurrentVersion\Run. This way OneDrive
   will never get installed automatically and other measures to
   block or revert OneDrive settings are not needed. 
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Remove-OneDrive
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
# Remove-OneDrive:  Remove Onedrivesetup.exe from Default User run
# ---------------------------------------------------------------------------

Function Remove-OneDrive{

# Load Default User Profile
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"

# Set Path
New-PSDrive -name Default -Psprovider Registry -root HKEY_USERS\Default >> $null

# Load Path to Registry Keys
$Regkey  = "Default:\Software\Microsoft\Windows\CurrentVersion\Run"

# Remove OneDrive Installation
Remove-ItemProperty -Path $Regkey -Name OneDriveSetup
Write-Information "OneDriveSetup.exe removed"

# Remove Path
Remove-PSDrive -Name Default >> $null

# Unload Default User Profile
reg unload "hku\Default"

}

# Remove OneDrive Shortcut on version 1803

$OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

if ($OSBuildNumber -le "17134") {

            Remove-Item -Path "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Onedrive.lnk" -Force

}

# ---------------------------------------------------------------------------
# Main Logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$LogDir\OSD-Remove-OneDrive.log"

Write-Information "$(Get-Date -UFormat %R)"

Remove-OneDrive

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript
