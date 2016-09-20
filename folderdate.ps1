#Source: http://www.dslreports.com/forum/r25067225-Solved-How-to-change-folder-date-to-most-recent-file-date
function Set-FolderDate {
    $colFolder = Get-ChildItem -Recurse "." | Where-Object {$_.mode -match "d"} | Sort-Object Fullname -Descending 
    $VerbosePreference = "Continue"
    Foreach ($strFolder In $colFolder)
    {
        Trap [Exception] {
            Write-Debug $("TRAPPED: " + $_.Exception.Message);
            Write-Verbose "Unable to change date on folder $Folder"
            Write-Verbose "Make sure it's not open in Explorer"
            Continue
        }
        $Path = $strFolder.FullName
        $Folder = Get-Item $Path
# Get Newest file in folder
        $strNewestItem = Get-ChildItem $Path | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Change the date to match the newest file if it doesn't already
        If ($strNewestItem.LastWriteTime -ne $Folder.LastWriteTime) {$Folder.LastWriteTime = $strNewestItem.LastWriteTime}
        Write-Verbose "Changed:  $Folder"
    }
}

Set-Alias -Name folderdate -Value Set-FolderDate -Description "Set the folder's date to the most recent file found inside."
