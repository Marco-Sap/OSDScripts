<#
.SYNOPSIS
   Install Dutch language Pack version 1803
.DESCRIPTION
   
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Install-LP
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
# Check in WINPE or Full OS
# ---------------------------------------------------------------------------


if ($env:SYSTEMDRIVE -eq "X:")
{
  $script:Offline = $true

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
    $ts = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    If ($ts.Value("LogPath") -ne "")
    {
      $logDir = $ts.Value("LogPath")
    }
    Else
    {
      $logDir = $ts.Value("_SMSTSLogPath")
    }
  }
  Catch
  {
    $logDir = $env:TEMP
  }
  Return $logDir
}


# ---------------------------------------------------------------------------
# Invoke-LP: 
# ---------------------------------------------------------------------------

Function Install-LP {

$Files = Get-ChildItem -Path $PSScriptRoot\Source -File
Write-Information "Number off Cab files to process = $($Files.count)"

If ($script:Offline)
    {

    ForEach ($File in $Files)
        {
        Write-Information "Processing $PSScriptRoot\Source\$File Offline"
        Add-WindowsPackage -Path $script:OfflinePath -PackagePath "$PSScriptRoot\Source\$File" -LogPath $LogDir\$File.log
        }
    }
Else{
    ForEach ($File in $Files)
        {
        Write-Information "Processing $PSScriptRoot\Source\$File Online"
        Add-WindowsPackage -Online -PackagePath "$PSScriptRoot\Source\$File" -LogPath $LogDir\$File.log
        }

    }

}

$LogDir = Get-LogDir

Start-Transcript "$logDir\OSD-Install-LP.log"

Write-Information "$(Get-Date -UFormat %R)"

Install-LP

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript