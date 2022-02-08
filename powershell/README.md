1. How to run the Powershell script without a physical file?
```
$Script = Invoke-WebRequest https://raw.githubusercontent.com/WeeHong/my-bash-script/main/powershell/download-font.ps1
$ScriptBlock = [Scriptblock]::Create($Script.Content)
Invoke-Command -ScriptBlock $ScriptBlock

Source from:
https://stackoverflow.com/a/43903244/4652307
```
