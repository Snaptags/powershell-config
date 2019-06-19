using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
    Set-PSReadlineOption -EditMode vi -ViModeIndicator Cursor
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadlineKeyHandler -Key UpArrow `
                             -BriefDescription HistorySearchBackward `
                             -LongDescription "search history backwards and enter vi normal mode" `
                             -ScriptBlock {
                                 [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
                                 [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
                             }
    Set-PSReadlineKeyHandler -Key DownArrow `
                             -BriefDescription HistorySearchForward `
                             -LongDescription "search history forward and enter vi normal mode" `
                             -ScriptBlock {
                                 [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
                                 [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
                             }

    # exit shell using <ctrl>+<d>
    Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

    # This key handler shows the entire or filtered history using Out-GridView. The
    # typed text is used as the substring pattern for filtering. A selected command
    # is inserted to the command line without invoking. Multiple command selection
    # is supported, e.g. selected by Ctrl + Click.
    Set-PSReadLineKeyHandler -Key F7 `
        -BriefDescription History `
        -LongDescription 'Show command history' `
        -ScriptBlock {
            $pattern = $null
                [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
                if ($pattern)
                {
                    $pattern = [regex]::Escape($pattern)
                }

            $history = [System.Collections.ArrayList]@(
                    $last = ''
                    $lines = ''
                    foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath))
                    {
                    if ($line.EndsWith('`'))
                    {
                    $line = $line.Substring(0, $line.Length - 1)
                    $lines = if ($lines)
                    {
                    "$lines`n$line"
                    }
                    else
                    {
                    $line
                    }
                    continue
                    }

                    if ($lines)
                    {
                        $line = "$lines`n$line"
                            $lines = ''
                    }

                    if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
                    {
                        $last = $line
                            $line
                    }
                    }
            )
                $history.Reverse()

                $command = $history | Out-GridView -Title History -PassThru
                if ($command)
                {
                    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
                        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
                }
        }

    # F1 for help on the command line - naturally
    Set-PSReadLineKeyHandler -Key F1 `
        -BriefDescription CommandHelp `
        -LongDescription "Open the help window for the current command" `
        -ScriptBlock {
            param($key, $arg)

                $ast = $null
                $tokens = $null
                $errors = $null
                $cursor = $null
                [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

                $commandAst = $ast.FindAll( {
                        $node = $args[0]
                        $node -is [CommandAst] -and
                        $node.Extent.StartOffset -le $cursor -and
                        $node.Extent.EndOffset -ge $cursor
                        }, $true) | Select-Object -Last 1

            if ($commandAst -ne $null)
            {
                $commandName = $commandAst.GetCommandName()
                    if ($commandName -ne $null)
                    {
                        $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
                            if ($command -is [AliasInfo])
                            {
                                $commandName = $command.ResolvedCommandName
                            }

                        if ($commandName -ne $null)
                        {
                            Get-Help $commandName -ShowWindow
                        }
                    }
            }
        }
}
