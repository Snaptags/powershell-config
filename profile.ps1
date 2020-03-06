# My PowerShell Profile
. "$PSScriptRoot\aliases.ps1"
. "$PSScriptRoot\avoid_accidental_dcommit.ps1"
. "$PSScriptRoot\folderdate.ps1"
. "$PSScriptRoot\Get-ESSearchResult.ps1"
. "$PSScriptRoot\PSReadLine.ps1"
Import-Module TabExpansionPlusPlus
Import-Module NPMTabCompletion
Import-Module PSColor
Import-Module ZLocation
Import-Module posh-git
Import-Module oh-my-posh
$DefaultUser = 'LAM'
$ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = [char]0x2261 # Three horizontal lines
Set-Theme Agnoster
$Env:LESSCHARSET="utf8"
