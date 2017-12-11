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