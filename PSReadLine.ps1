if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
    Set-PSReadlineOption -EditMode vi -ViModeIndicator Cursor
}
