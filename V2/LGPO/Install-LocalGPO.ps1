<#
.SYNOPSIS
   Set Local Group Policy on Device
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
   Install-LocalLGPO
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

Function Get-LogDir {
  
  Try
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
  Catch
  {
    $LogDir = $env:TEMP
  }

  Return $LogDir
}

# ---------------------------------------------------------------------------
# Invoke-LGPO: Loop through folders and apply LGPO
# ---------------------------------------------------------------------------

Function Install-LGPO {

$Folders = Get-ChildItem -Path $PSScriptRoot -Directory

    ForEach ($Folder in $Folders)
    {

    Write-Information "Processing $PSScriptRoot\$Folder"

    $Arguments = @("/g", "$PSScriptRoot\$Folder", "/v")
    $Process = Start-Process -FilePath `"$PSScriptRoot\LGPO.exe`" -ArgumentList $Arguments -Wait -PassThru -RedirectStandardOutput "$LogDir\$Folder-out.txt" -RedirectStandardError "$LogDir\$Folder-err.txt"
    if ($Process.ExitCode -eq 0) {Write-Information "$Folder Local Policy has been successfully applied"}
    else {Write-Information "Installer Exit Code $($Process.ExitCode) for $Folder";Stop-Transcript;Exit 1}

    }

}

Function Install-LocalSec {

$Files = Get-ChildItem -Path $PSScriptRoot\*.inf -File

    ForEach ($File in $Files)
    {

    Write-Information "Processing $File"

    $ArgumentsLS = @("/s", "$File", "/v")
    $ProcessLS = Start-Process -FilePath `"$PSScriptRoot\LGPO.exe`" -ArgumentList $ArgumentsLS -Wait -PassThru -RedirectStandardOutput "$LogDir\LocalSec-out.txt" -RedirectStandardError "$LogDir\$LocalSec-err.txt"
    if ($ProcessLS.ExitCode -eq 0) {Write-Information "$File Local Security Policy has been successfully applied"}
    else {Write-Information "Installer Exit Code $($ProcessLS.ExitCode) for $File";Stop-Transcript;Exit 1}

    }

}

# ---------------------------------------------------------------------------
# Main Logic
# ---------------------------------------------------------------------------

$LogDir = Get-LogDir

Start-Transcript "$logDir\OSD-Install-LocalGPO.log"

Write-Information "$(Get-Date -UFormat %R)"

Install-LGPO

Install-LocalSec

Write-Information "$(Get-Date -UFormat %R)"

Stop-Transcript