# Functions

function mklink {
    cmd /c mklink $args[0] $args[1]
}

function runDeltas($deltaDirectory=".", $minDelta=0, $maxDelta=99999, $dbName="TMS") {
	ls | 
	where { $_ -match "(\d+)_.*" } | 
	Select-Object Name, @{Name="DeltaNumber";Expression={ [int]($matches[1])}} | 
	where { ($_.DeltaNumber -ge $minDelta) -and ($_.DeltaNumber -le $maxDelta) } | 
	Sort-Object DeltaNumber | 
	% {
		Write-Host "Running $($_.Name)" -foregroundcolor "cyan";
		$extension = (dir $_.Name | Select Extension);
		echo $extension;
		If($extension -eq ".ref")
		{
			Get-Content $_.Name | % { SQLCMD.EXE -i $_ -s localhost -v dbName $dbName };
		}
		Else
		{
			SQLCMD.EXE -i $_.Name -s localhost -v dbName=$dbName;
		}
	}
}

function np {
	param(
		[string] $filename
	)

	& "/Program Files (x86)/Notepad++/notepad++" $filename
}

function gs {
	git status
}

function tgl {
	param(
		[string] $path = ".",
		[string] $commitId
	)

	tgit log "$path" /endrev:$commitId
}