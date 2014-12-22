# Load posh-git example profile
. "$HOME\.poshgit-profile.ps1"
# Load all "auto-load" scripts
$autoLoadDirectory = "~/Documents\WindowsPowerShell\Autoload"
Get-ChildItem "$autoLoadDirectory" | %{. $_.FullName}