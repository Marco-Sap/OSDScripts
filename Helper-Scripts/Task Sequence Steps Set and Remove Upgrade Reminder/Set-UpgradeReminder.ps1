$Package = Get-ChildItem -Path C:\ProgramData\Upgrade -Filter "StartSilent.exe" -Recurse | Select -First 1 | Select Directoryname
$PackageDir = $Package.DirectoryName

$SchedService = New-Object -comobject 'Schedule.Service'
$SchedService.Connect()

$Task = $SchedService.NewTask(0)
$Task.RegistrationInfo.Description = 'Windows 10 version 1709 Upgrade Reminder.'
$Task.Settings.Enabled = $True
$Task.Settings.AllowDemandStart = $True

$Trigger = $Task.triggers.Create(9)
$Trigger.Enabled = $True

$Action = $Task.Actions.Create(0)
$Action.Path = $PackageDir + '\StartSilent.exe'
#$action.Arguments = '-arguments -if -any'

$TaskFolder = $SchedService.GetFolder("\")
$TaskFolder.RegisterTaskDefinition('UpgradeReminder', $Task , 6, 'Users', $null, 4)

# More info can be found here: https://powershell.org/forums/topic/create-scheduled-task-run-as-logged-on-usewr/