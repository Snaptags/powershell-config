# powershell-config
This is my Windows powershell config to be used with ConEmu. It features a powerline-like prompt displaying git status and some useful aliases.

![Alt text](/images/powershell.png?raw=true "Basic look of the prompt in ConEmu")

The directory listing uses a fork of https://github.com/Davlind/PSColor/:
![Alt text](/images/powershell_ls.png?raw=true "directory listing")

## Aliases

#### ls -la
List all files in the current directory plus recurse all subdirectories to sum up their size. Sort the output by size:
![Alt text](/images/powershell_ls_la.png?raw=true "directory listing")

#### git svn dcommit
I have to commit to a subversion repository. After my first accidental dcommit from a broken local branch I added this alias, inspired by http://stackoverflow.com/questions/9226528/how-can-i-avoid-an-accidental-dcommit-from-a-local-branch:
![Alt text](/images/git_svn_dcommit.png?raw=true "avoid an accidental dcommit from a local branch")

#### sudo
„sudo“ without any arguments opens a new powershell with admin rights. „sudo application“ starts the application with elevated rights.

#### printcolors
I use a very strange color scheme in ComEmu, optimized to look good when opening vim. To get a matching powerline prompt for the shell I used this alias.
![Alt text](/images/powershell_colors.png?raw=true "shell colors and what they actually look like")
