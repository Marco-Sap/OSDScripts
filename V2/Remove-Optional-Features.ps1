<#
.SYNOPSIS
   Disable optional Windows Features which are not needed
.DESCRIPTION
   
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Remove-Optional-Features
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
# Get Offline or Online OS
# ---------------------------------------------------------------------------

if ($env:SYSTEMDRIVE -eq "X:")
{
  $script:Offline = $true

  # Find Windows
  $drives = get-volume | ? {-not [String]::IsNullOrWhiteSpace($_.DriveLetter) } | ? {$_.DriveType -eq 'Fixed'} | ? {$_.DriveLetter -ne 'X'}
  $drives | ? { Test-Path "$($_.DriveLetter):\Windows\System32"} | % { $script:OfflinePath = "$($_.DriveLetter):\" }
  Write-Verbose "Eligible offline drive found: $script:OfflinePath"
}
else
{
  Write-Verbose "Running in the full OS."
  $script:Offline = $false
}

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
# Remove Capabilities (Optional Features)
# ---------------------------------------------------------------------------

Function Remove-Capability {

    if ($script:Offline){
    Remove-WindowsCapability -Path $script:OfflinePath -Name App.Support.ContactSupport~~~~0.0.1.0
    Write-Information "Removed Contact Support offline"
    }
    else
    {
    Remove-WindowsCapability -Online -Name App.Support.ContactSupport~~~~0.0.1.0
    Write-Information "Removed Contact Support online"
    }

}

# ---------------------------------------------------------------------------
# Remove-Features:
# ---------------------------------------------------------------------------

Function Remove-Features {

$Features = Get-Content "$PSScriptRoot\Remove-Optional-Features.txt"
$Text = "Number of Features being disabled: " + $Features.Count

Write-Information $Text

foreach ($Feature in $Features) {

    Try
    {

    Disable-WindowsOptionalFeature -Path $script:OfflinePath -FeatureName $Feature -NoRestart | Out-Null
    Write-Information "Disabled: $Feature"

    }
    Catch [System.Exception]
    {

    Write-Information -Message $_.Exception.Message 

    }

}

}

# ---------------------------------------------------------------------------
# Main logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$LogDir\OSD-Remove-Optional-Features.log"

Write-Information "$(Get-Date -UFormat %R)"

Remove-Capability

Remove-Features

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript