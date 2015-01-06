# Load posh-git example profile
. "$HOME\.poshgit-profile.ps1"

# Load all "auto-load" scripts if the autoload directory exists
if (Test-Path -Path "~/Documents\WindowsPowerShell\Autoload") {
	$autoLoadDirectory = "~/Documents\WindowsPowerShell\Autoload"
	Get-ChildItem "$autoLoadDirectory" | %{. $_.FullName}
}
