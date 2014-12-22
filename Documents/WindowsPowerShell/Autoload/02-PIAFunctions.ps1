# Functions

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