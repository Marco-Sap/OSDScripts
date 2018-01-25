<#
.SYNOPSIS
   .
.DESCRIPTION
   .
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   Convert-PNG2Base64 C:\Path\To\Image.png >> base64Image.txt
.EXAMPLE
   Convert-PNG2Base64 -Verbose
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
Param([String]$path)

[convert]::ToBase64String((get-content $path -encoding byte))