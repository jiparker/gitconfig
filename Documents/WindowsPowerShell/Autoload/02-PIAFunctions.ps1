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
	
	$startDirectory = $Pwd

	cases

	if ($branch) {
		Reset-Branch -branch $branch
	}

	./build.ps1 $environment
	
	cd $startDirectory
}

function Invoke-TmsSetup {
	param(
		[string] $branch,
		[switch] $deploy,
		[switch] $withCases = $true,
		[string] $caseEnvironment = 'localhost'
	)
	
	$startDirectory = $Pwd
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
	
	if ($withCases) {
		Invoke-CaseSetup -environment $caseEnvironment
	}
	
	cd $startDirectory
}

function Invoke-MediaManagerSetup {
	param(
		[string] $branch
	)

	$startDirectory = $Pwd
	mm

	if ($branch) {
		Reset-Branch -branch $branch
	}

	./build.asynchrony.notests.ps1
	./deploy.asynchrony.cmd
	
	cd $startDirectory
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