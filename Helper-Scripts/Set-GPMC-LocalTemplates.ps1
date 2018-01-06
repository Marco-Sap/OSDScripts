<#
.SYNOPSIS
   Set GMPC to use the local templates only
.DESCRIPTION
   Bypass the central store and instead use the ADMX files
   from the local store:
    To bypass the central store and instead use the ADMX files
    from the local store, set the following registry entry to
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\
    Group Policy\EnableLocalStoreOverride
    Type: REG_DWORD
        Values: 
        0 - Use PolicyDefinitions on Sysvol if present (Default)
        1 - Use local PolicyDefinitions always  
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Set-GPMC-LocalTemplates.ps1
.DISCLAIMER
   This script code is provided as is with no guarantee or waranty
   concerning the usability or impact on systems and may be used,
   distributed, and modified in any way provided the parties agree
   and acknowledge that Microsoft or Microsoft Partners have neither
   accountabilty or responsibility for results produced by use of
   this script.

   Microsoft will not provide any support through any means.
#>

# Mount Registry HK Local Machine
Set-Location -Path HKLM:\

# Set Key
New-Item -Path .\Software\Policies\Microsoft\Windows\ -Name 'Group Policy'
$RegKey = "Software\Policies\Microsoft\Windows\Group Policy"
Set-ItemProperty -path $RegKey -name EnableLocalStoreOverride -value 1