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
}
