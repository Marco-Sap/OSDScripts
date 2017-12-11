' Add Computer to Security Group
' Place in Scripts Package
' Create Commandline Task Sequence step, Use Package
' Use Commandline: cscript.exe AddToGroup.vbs "CN=ExampleGroup,OU=Groups,OU=Corp,DC=Contoso,DC=Com"
' Run with Account that has the right permissions in AD

' Get group value
Set wshNetwork = CreateObject("WScript.Network")
Set oFso = CreateObject("Scripting.FileSystemObject")
Set ArgObj = WScript.Arguments
strLDAPofADSG = ArgObj(0)

' Get the current computer information
Set objSysInfo = CreateObject("ADSystemInfo")
strComputerDN = objSysInfo.ComputerName

' Get the LDAP of the current computer
Set objComputer = GetObject("LDAP://" & strComputerDN)

' Set the LDAP of the security group
objComputerGroupPath = strLDAPofADSG
Set objComputerGroup = GetObject("LDAP://" & objComputerGroupPath)

' Add computer to group, if not already member.
If (objComputerGroup.IsMember(objComputer.AdsPath) = False) Then
  objComputerGroup.Add(objComputer.AdsPath)
End If