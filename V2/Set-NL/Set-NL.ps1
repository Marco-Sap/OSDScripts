$XML = $PSScriptRoot + "\NL.xml"

& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$XML`""

start-sleep -seconds 2

& tzutil /s "W. Europe Standard Time"