' *********************************************************************************
' ** Script Name: IT_APP_VBS_JoinComputertoADSG
' ** Created on: 20.9.2012
' ** Author: Jyri Lehtonen / http://it.peikkoluola.net
' **
' ** Purpose: During a SCCM 2012 Computer Deployment, join the computer to a AD SG
' **
' ** License: This program is free software: you can redistribute it and/or modify
' ** it under the terms of the GNU General Public License as published by
' ** the Free Software Foundation, either version 3 of the License, or
' ** (at your option) any later version.
' **
' ** This program is distributed in the hope that it will be useful,
' ** but WITHOUT ANY WARRANTY; without even the implied warranty of
' ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
' ** GNU General Public License for more details.
' ** 
' ** History: 
' ** 1.0 / Jyri Lehtonen / 20.9.2012 / Initial version.
' ** 1.1 / Jyri Lehtonen / 23.4.2013 / Created better configuration options.
' *********************************************************************************
'Option Explicit

'Dim objSysInfo, objComputer, strComputerDN, strLDAPofADSG
'Dim objComputerGroupPath, objComputerGroup

' *********************************************************************************
' ** Configure the script
' ** Example LDAP path: 
' **    "CN=Your_SecuritGroup,OU=Your_Sub_OU,OU=Your_main_OU,DC=Your_domain,DC=Your_domain_locale"
' *********************************************************************************
' strLDAPofADSG = "CN=ComputerGroup,OU=Groups,OU=Corp,DC=Corp,DC=Contoso,DC=com"
' *********************************************************************************

Set wshNetwork = CreateObject("WScript.Network")
Set oFso = CreateObject("Scripting.FileSystemObject")
Set ArgObj = WScript.Arguments
strLDAPofADSG = ArgObj(0)

'Uncomment this, to receive debug information:
'msgbox(strLDAPofADSG)

' Get the current computer information
Set objSysInfo = CreateObject("ADSystemInfo")
strComputerDN = objSysInfo.ComputerName

'Uncomment this, to receive debug information:
'msgbox(strComputerDN)

' Get the LDAP of the current computer
Set objComputer = GetObject("LDAP://" & strComputerDN)

'Uncomment this, to receive debug information:
'msgbox("LDAP://" & strComputerDN)

' Set the LDAP of the security group
objComputerGroupPath = strLDAPofADSG
Set objComputerGroup = GetObject("LDAP://" & objComputerGroupPath)

'Uncomment this, to receive debug information:
'msgbox("LDAP://" & objComputerGroupPath)

' Add computer to group, if not already member.
If (objComputerGroup.IsMember(objComputer.AdsPath) = False) Then
  objComputerGroup.Add(objComputer.AdsPath)
End If