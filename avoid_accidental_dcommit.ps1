# inspired by http://stackoverflow.com/questions/9226528/how-can-i-avoid-an-accidental-dcommit-from-a-local-branch
function CallGit
{ 
    if (($args[0] -eq "svn") -And ($args[1] -eq "dcommit")) {
        $curr_branch = &{git branch};
        $curr_branch = [regex]::Match($curr_branch, '\* (\w*)').captures.groups[1].value
        if ($curr_branch -ne "master") {
            $a = (Get-Host).PrivateData;
            $a.WarningForegroundColor = "DarkRed";
            Write-Warning "Committing from branch $curr_branch";
            $choice = ""
            while ($choice -notmatch "[y|n]"){
                $choice = read-host "Do you want to continue? (Y/N)"
            }
            if ($choice -ne "y"){
                return
            }
        }
    }
    &"git.exe" @args
}
Set-Alias -Name git -Value CallGit -Description "Avoid an accidental git svn dcommit on a local branch"
