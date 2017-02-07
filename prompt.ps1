# fork of prompt.ps1 for powerline prompt: https://gist.github.com/kadet1090/86023bfad2bdd84d8b1a
$script:bg    = [Console]::BackgroundColor;
$script:admin = $false;
$script:first = $true;
$script:last  = 0;
$script:max_path_length = 40;

If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] “Administrator”))
{
    $script:admin = $true;
}

function Write-PromptFancyEnd {
    Write-Host  -NoNewline -ForegroundColor $script:bg

    $script:bg = [System.ConsoleColor]::Black
}

function Write-PromptSegment {
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )][string]$Text,

        [Parameter(Position=1)][System.ConsoleColor] $Background = [Console]::BackgroundColor,
        [Parameter(Position=2)][System.ConsoleColor] $Foreground = [System.ConsoleColor]::White
    )

    if(!$script:first) {
        Write-Host  -NoNewline -BackgroundColor $Background -ForegroundColor $script:bg
    } else {
        $script:first = $false
    }

    Write-Host $text -NoNewline -BackgroundColor $Background -ForegroundColor $Foreground

    $script:bg = $background;
}

function Get-FancyDir {
    $max = $script:max_path_length;
    $dir = $(Get-Location).ToString();
    if($dir.length -gt $max) {
        $dir = $dir -replace "^([^\\]+)\\([^\\]+)\\.+\\(.*)",'$1\$2\…\$3'
    }
    return $dir.Replace($env:USERPROFILE, '~').Replace('\', ' ⮁ ');
}

function Get-GitBranch {
    $HEAD = Get-Content $(Join-Path $(Get-GitDirectory) HEAD)
    if($HEAD -like 'ref: refs/heads/*') {
        return $HEAD -replace 'ref: refs/heads/(.*?)', "$1";
    } else {
        return $HEAD.Substring(0, 8);
    }
}

function Get-GitStatusText {
    Write-PromptSegment " ⭠ " DarkBlue White
    $global:GitPromptSettings.BeforeText = ""
    $global:GitPromptSettings.BeforeBackgroundColor = [ConsoleColor]::DarkBlue
    $global:GitPromptSettings.DelimForegroundColor = [ConsoleColor]::White
    $global:GitPromptSettings.DelimBackgroundColor = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.AfterText = ''
    $global:GitPromptSettings.FileAddedText                               = '+'
    $global:GitPromptSettings.FileModifiedText                            = '~'
    $global:GitPromptSettings.FileRemovedText                             = '-'
    $global:GitPromptSettings.FileConflictedText                          = '!'

    $global:GitPromptSettings.LocalWorkingStatusSymbol                    = '!'
    $global:GitPromptSettings.LocalWorkingStatusForegroundColor           = [ConsoleColor]::DarkRed
    $global:GitPromptSettings.LocalWorkingStatusForegroundBrightColor     = [ConsoleColor]::Red
    $global:GitPromptSettings.LocalWorkingStatusBackgroundColor           = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.LocalStagedStatusSymbol                     = '~'
    $global:GitPromptSettings.LocalStagedStatusForegroundColor            = [ConsoleColor]::Cyan
    $global:GitPromptSettings.LocalStagedStatusBackgroundColor            = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BranchUntrackedSymbol                       = $null
    $global:GitPromptSettings.BranchForegroundColor                       = [ConsoleColor]::White
    $global:GitPromptSettings.BranchBackgroundColor                       = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BranchIdenticalStatusToSymbol               = [char]0x2261 # Three horizontal lines
    $global:GitPromptSettings.BranchIdenticalStatusToForegroundColor      = [ConsoleColor]::Gray
    $global:GitPromptSettings.BranchIdenticalStatusToBackgroundColor      = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BranchAheadStatusSymbol                     = [char]0x2191 # Up arrow
    $global:GitPromptSettings.BranchAheadStatusForegroundColor            = [ConsoleColor]::Green
    $global:GitPromptSettings.BranchAheadStatusBackgroundColor            = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BranchBehindStatusSymbol                    = [char]0x2193 # Down arrow
    $global:GitPromptSettings.BranchBehindStatusForegroundColor           = [ConsoleColor]::Red
    $global:GitPromptSettings.BranchBehindStatusBackgroundColor           = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BranchBehindAndAheadStatusSymbol            = [char]0x2195 # Up & Down arrow
    $global:GitPromptSettings.BranchBehindAndAheadStatusForegroundColor   = [ConsoleColor]::Yellow
    $global:GitPromptSettings.BranchBehindAndAheadStatusBackgroundColor   = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.BeforeIndexText                             = ""
    $global:GitPromptSettings.BeforeIndexForegroundColor                  = [ConsoleColor]::DarkGreen
    $global:GitPromptSettings.BeforeIndexForegroundBrightColor            = [ConsoleColor]::DarkGreen
    $global:GitPromptSettings.BeforeIndexBackgroundColor                  = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.IndexForegroundColor                        = [ConsoleColor]::Black
    $global:GitPromptSettings.IndexForegroundBrightColor                  = [ConsoleColor]::DarkGray
    $global:GitPromptSettings.IndexBackgroundColor                        = [ConsoleColor]::DarkBlue

    $global:GitPromptSettings.WorkingForegroundColor                      = [ConsoleColor]::White
    $global:GitPromptSettings.WorkingForegroundBrightColor                = [ConsoleColor]::Gray
    $global:GitPromptSettings.WorkingBackgroundColor                      = [ConsoleColor]::DarkBlue

    $(Write-VcsStatus)
}

function Write-PromptStatus {
    if($script:last) {
        Write-PromptSegment ' ✔ ' DarkGreen Black
    } else {
        Write-PromptSegment " ✖ $lastexitcode " DarkRed White
    }
}

function Write-PromptUser {
    if($script:admin) {
        Write-PromptSegment ' ₪ ADMIN → ' Magenta White;
    } else {
        Write-PromptSegment " $env:USERNAME " DarkGray Yellow;
    }
}

function Write-PromptVirtualEnv {
    if($env:VIRTUAL_ENV) {
        Write-PromptSegment " $(split-path $env:VIRTUAL_ENV -leaf) " Cyan Black
    }
}

function Write-PromptDir {
    Write-PromptSegment " $(Get-FancyDir) " Yellow Black
}

# Depends on posh-git
function Write-PromptGit {
    if (Get-Command -Name Get-GitDirectory -errorAction SilentlyContinue) {
        if (Get-GitDirectory) {
            Write-PromptSegment " $(Get-GitStatusText)" DarkBlue White
        }
    }
}

function prompt {
    $script:last  = $?;
    $script:first = $true;

    Write-PromptStatus
    Write-PromptUser
    Write-PromptVirtualEnv
    Write-PromptDir
    Write-PromptGit

    Write-PromptFancyEnd

    return ' '
}
