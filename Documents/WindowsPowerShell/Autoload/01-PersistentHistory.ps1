$MaximumHistoryCount = 31KB
$PoshHistoryPath = "~\.posh-history.xml"

# Load history if history file exists
if (Test-path $PoshHistoryPath)
    { Import-CliXml $PoshHistoryPath | Add-History }

# Save history on exit, remove duplicates
Register-EngineEvent PowerShell.Exiting {
    Get-History -Count $MaximumHistoryCount | Group CommandLine |
    Foreach {$_.Group[0]} | Export-CliXml $PoshHistoryPath
 } -SupportEvent
 
 # Function to search history
function Filter-History {
	param(
		[Parameter(Mandatory=$true)]
		[string] $searchTerm
	)

    Get-History -c $MaximumHistoryCount | out-string -stream |
    select-string $searchTerm
 }
 
 # Importing PSReadline must come AFTER you load your command history
if ($host.Name -eq 'ConsoleHost')
{
	Import-Module PSReadline
}

# Key bindings
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward