' Move Computer to right OU
' Place in Scripts Package
' Create Commandline Task Sequence step, Use Package
' Use Commandline: cscript.exe MoveOU.vbs "OU=Example,OU=Corp,DC=Contoso,DC=Com"
' Run with Account that has the right permissions in AD

'Get machine object OU value
Set wshNetwork = CreateObject("WScript.Network")
Set oFso = CreateObject("Scripting.FileSystemObject")
Set objSysInfo = CreateObject( "ADSystemInfo" )
Set ArgObj = WScript.Arguments

'Use Argument as target OU
strMachineObjectOU = ArgObj(0)
strComputerDN = objSysInfo.ComputerName
nComma = InStr(strComputerDN,",")
strCurrentOU = Mid(strComputerDN,nComma+1)
strComputerName = Left(strComputerDN,nComma - 1)

'If current OU is different than target OU. Move object
If UCase(strCurrentOU) <> UCase(strMachineObjectOU) Then
	Set objNewOU = GetObject("LDAP://" & strMachineObjectOU)
	Set objMoveComputer = objNewOU.MoveHere("LDAP://" & strComputerDN, strComputerName)
End If