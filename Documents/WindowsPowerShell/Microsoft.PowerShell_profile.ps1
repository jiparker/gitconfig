# Load posh-git example profile
. "$HOME\.poshgit-profile.ps1"
# Load all "auto-load" scripts
$autoLoadDirectory = "~/Documents\WindowsPowerShell\Autoload"
Get-ChildItem "$autoLoadDirectory" | %{. $_.FullName}

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

# Functions

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
		[string] $path,
		[string] $commitId
	)

	tgit log "$path" /endrev:$commitId
}

function mm() {
	cd /Projects/MediaManager
}

function tms() {
	cd /Projects/bw.training-management
}

function cases() {
	cd /Projects/cases
}

function Reset-Branch {
	param(
		[string] $branch
	)
 
	git fetch
	git co $branch
	git clean -fd
	git rhu
}

function Invoke-CaseSetup {
	param(
		[string] $branch,
		[string] $environment = "localhost"
	)
	
	$currentDirectory = $Pwd

	cases

	if ($branch) {
		Reset-Branch -branch $branch
	}

	./build.ps1 $environment
	
	cd $Pwd
}

function Invoke-TmsSetup {
	param(
		[string] $branch,
		[switch] $deploy
	)

	tms

	if ($branch) {
		Reset-Branch -branch $branch
	}

	if ($deploy) {
		./build.asynchrony.dev.web.notest.cmd
		./deploy.asynchrony.dev.web.cmd
	}
	else {
		./build.asynchrony.dev.db.cmd
	}
}

function Invoke-MediaManagerSetup {
	param(
		[string] $branch
	)

	mm

	if ($branch) {
		Reset-Branch -branch $branch
	}

	./build.asynchrony.notest.cmd
	./deploy.asynchrony.cmd
}

function Invoke-AllSetup {
	param(
		[string] $tmsBranch,
		[string] $mediaManagerBranch,
		[string] $casesBranch,
		[string] $casesEnvironment = "localhost"
	)

	Invoke-MediaManagerSetup -branch $mediaManagerBranch
	Invoke-TmsSetup -branch $tmsBranch
	Invoke-CaseSetup -branch $casesBranch -environment $casesEnvironment
}