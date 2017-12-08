<#
.SYNOPSIS
   Remove unneeded inbox Appx files
.DESCRIPTION
   Removes some or all of the inbox apps on Windows 10 systems. 
   The script supports both offline and online removal.
   By default it will remove all apps, but you can provide a separate
   Remove-Inbox-Apps.txt file with a list of apps that you want to instead remove.
   If this file doesn't exist, the script will recreate one in the log or temp folder,
   so you can run the script once, grab the file, make whatever changes you
   want, then put the file alongside the script and it will remove only the apps
   you specified.

   This script can be added into any MDT or ConfigMgr task sequences.
   It has a few dependencies:
   1.  For offline use in Windows PE, the .NET Framework, PowerShell, DISM Cmdlets,
       and Storage cmdlets must be included in the boot image.
   2.  Script execution must be enabled, e.g. "Set-ExecutionPolicy Bypass".
       This can be done via a separate task sequence step if needed.
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Remove-Inbox-Apps
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

Function Get-LogDir
{
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
# Get-AppList:  Return the list of apps to be removed
# ---------------------------------------------------------------------------

function Get-AppList
{
  begin
  {
    # Look for a config file.
    $configFile = "$PSScriptRoot\Remove-Inbox-Apps.txt"
    if (Test-Path -Path $configFile)
    {
      # Read the list
      Write-Information "Reading list of apps from $configFile"
      $list = Get-Content $configFile
    }
    else
    {
      # No list? Build one with all apps.
      Write-Information "Building list of provisioned apps"
      $list = @()
      if ($script:Offline)
      {
        Get-AppxProvisionedPackage -Path $script:OfflinePath | % { $list += $_.DisplayName }
      }
      else
      {
        Get-AppxProvisionedPackage -Online | % { $list += $_.DisplayName }
      }

      # Write the list to the log path
      $logDir = Get-LogDir
      $configFile = "$logDir\Remove-Inbox-Apps.txt"
      $list | Set-Content $configFile
      Write-Information "Wrote list of apps to $logDir\Remove-Inbox-Apps.txt, edit and place in the same folder as the script to use that list for future script executions"
    }

    $Text = "Apps selected for removal: " + $list.Count

    Write-Information $Text
  }

  process
  {
    $list
  }

}

# ---------------------------------------------------------------------------
# Remove-App:  Remove the specified app (online or offline)
# ---------------------------------------------------------------------------

function Remove-App
{
  [CmdletBinding()]
  param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] $appName
  )

  begin
  {
    # Determine offline or online
    if ($script:Offline)
    {
      $script:Provisioned = Get-AppxProvisionedPackage -Path $script:OfflinePath
    }
    else
    {
      $script:Provisioned = Get-AppxProvisionedPackage -Online
      $script:AppxPackages = Get-AppxPackage
    }
  }

  process
  {
    $app = $_

    # Remove the provisioned package
    Write-Information "Removing provisioned package $_"
    $current = $script:Provisioned | ? { $_.DisplayName -eq $app }
    if ($current)
    {
      if ($script:Offline)
      {
        $a = Remove-AppxProvisionedPackage -Path $script:OfflinePath -PackageName $current.PackageName
      }
      else
      {
        $a = Remove-AppxProvisionedPackage -Online -PackageName $current.PackageName
      }
    }
    else
    {
      Write-Warning "Unable to find provisioned package $_"
    }

    # If online, remove installed apps too
    if (-not $script:Offline)
    {
      Write-Information "Removing installed package $_"
      $current = $script:AppxPackages | ? {$_.Name -eq $app }
      if ($current)
      {
        $current | Remove-AppxPackage
      }
      else
      {
        Write-Warning "Unable to find installed app $_"
      }
    }

  }
}

# ---------------------------------------------------------------------------
# Main logic
# ---------------------------------------------------------------------------

$logDir = Get-LogDir

Start-Transcript "$logDir\OSD-Remove-Inbox-Apps.log"

Write-Information "$(Get-Date -UFormat %R)"

Get-AppList | Remove-App

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript