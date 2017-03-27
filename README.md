# powershell-config
This is my Windows powershell config to be used with [ConEmu](https://github.com/Maximus5/ConEmu). It features a powerline-like prompt displaying git status and some useful aliases.

![Alt text](/images/powershell.png?raw=true "Basic look of the prompt in ConEmu")

## Prompt only
### Requirements
- https://github.com/Snaptags/powershell-config/blob/master/prompt.ps1
- https://github.com/gabrielelana/awesome-terminal-fonts

### Setup
- Copy the prompt.ps1 file to a location of your choice. Make sure it is UTF-8 format.
- allow powershell to execute scripts:  
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```
- Install a powerline enabled font from the second of the links provided above.
- open the ConEmu settings and apply the new font, e.g.:
![Alt text](/images/conemu_main.png?raw=true "ConEmu Settings/Main")
- you have to modify the Startup Task, too:
![Alt text](/images/conemu_startup.png?raw=true "ConEmu Settings/Startup/Tasks")
```
powershell.exe -NoExit -file "d:\prompt.ps1"
```
### Path shortening

I don't like it when the paths are getting too long, especially when working in git folders. So I added a path shortener to prompt.ps1:
![Alt text](/images/pathlength.png?raw=true "Abbreviate too long directories")
You can change the behaviour by editing prompt.ps1:
```
$script:max_path_length = 40;
```
Set this to 0 to turn path shortening OFF. Note beyond: you can always get the full path by entering 'pwd' in the shell prompt:
```
PS > pwd
```

## Advanced features (git status, aliases, etc.)

### Requirements
- https://github.com/lzybkr/PSReadLine
- https://github.com/dahlbyk/posh-git
```
Install-Module PsReadline
Install-Module posh-git -Scope CurrentUser
```

The directory listing uses a fork of https://github.com/Davlind/PSColor/:
![Alt text](/images/powershell_ls.png?raw=true "directory listing")

## Colored directory listing
```
Install-Module PSColor
```

## Aliases

#### ls -la
List all files in the current directory plus recurse all subdirectories to sum up their size. Sort the output by size:
![Alt text](/images/powershell_ls_la.png?raw=true "directory listing")

#### git svn dcommit
I have to commit to a subversion repository. After my first accidental dcommit from a broken local branch I added this alias, inspired by http://stackoverflow.com/questions/9226528/how-can-i-avoid-an-accidental-dcommit-from-a-local-branch:
![Alt text](/images/git_svn_dcommit.png?raw=true "avoid an accidental dcommit from a local branch")

#### sudo
„sudo“ without any arguments opens a new powershell with admin rights. „sudo application“ starts the application with elevated rights.

#### es
Finds files using Voidtools' Everything. Based on https://github.com/DBremen/PowerShellScripts
You need do download and install the commandline tool via http://www.voidtools.com/es.zip
![Alt text](/images/powershell_es.png?raw=true "blazing fast everything search results")

#### printcolors
I use a very strange color scheme in ComEmu, optimized to look good when opening vim. To get a matching powerline prompt for the shell I used this alias.
![Alt text](/images/powershell_colors.png?raw=true "shell colors and what they actually look like")
