Param([switch]$cleanupSourceFiles)

# Install PSGet, PSUrl, and PSReadLine
If (!(Get-Module PsGet)) {
	(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
	Import-Module PsGet
	Write-Output "Installed PsGet"
}
Else {
	Write-Output "Already have PsGet"
}

$requiredModules = 'PsUrl', 'PsReadLine'
foreach ($requiredModule in $requiredModules) {
	If (!(Get-Module $requiredModule)) {
		Install-Module $requiredModule
		Write-Output "Installed $requiredModule"
	}
	Else {
		Write-Output "Already have $requiredModule"
	}
}

# Copy config files
Copy-Item .\.* ~\ -force
Copy-Item .\Documents\* ~\Documents\ -recurse -container -force
Write-Output "Copied all configuration & script files"

# Clean-up source files (if requested)
If ($cleanupSourceFiles) {
	Remove-Item -Path (Split-Path $MyInvocation.MyCommand.Definition) -Force -Recurse
	Write-Output "Cleaned up source files"
}