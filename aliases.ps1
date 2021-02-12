# command aliases
function CallNodeReplace 
{ 
    node $env:USERPROFILE\AppData\Roaming\npm\node_modules\replace\bin\replace.js $args
}

function OpenShellAsAdmin([string]$application = 'pwsh')
{
    $path = (get-command $application).Path
    if ($application -eq "pwsh") {
        ConEmuC -c $path -NoLogo $args -new_console:a
    } else {
        Start-Process $path $args -Verb RunAs
    }
}

function MyLS
{
    if ($args -eq "-la") {
        &{Get-ChildItem -Force | Add-Member -Force -Passthru -Type ScriptProperty -Name Length -Value {Get-ChildItem $this -Recurse -Force | Measure -Sum Length | Select -Expand Sum } | Sort-Object Length -Descending}
    } else {
        &"Get-ChildItem" @args
    }
}

function PrintColors
{
    [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -NoNewLine -ForegroundColor $_; Write-Host " [=$_]"}
}

Set-Alias -Name nreplace -Value CallNodeReplace -Description "RegExp replace tool based on Node.js"
Set-Alias -Name sudo -Value OpenShellAsAdmin -Description "Re-Open ConEmu with admin permissions" -option "Constant,AllScope"
Set-Alias -Name ls -Value MyLS -Description "Display directory listing including hidden files and recursively summing up directory sizes. Results are orderd by size." -option "Constant,AllScope"
Set-Alias -Name colors -Value PrintColors -Description "Print a list of available shell colors"
