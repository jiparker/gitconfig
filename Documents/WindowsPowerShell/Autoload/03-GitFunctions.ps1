# Git helpers
function gs {
	git status
}

function gdt {
	git difftool
}

function tgl {
	param(
		[string] $path = ".",
		[string] $commitId
	)

	tgit log "$path" /endrev:$commitId
}

function tgb {
	param(
		[string] $commitId
	)
	
	tgit repobrowser . /rev:$commitId
}

function completeQA {
	param(
		[Parameter(Mandatory=$true)] [string] $branch
	)
	
	$masterBranch = 'fakeMaster'
	$masterOrigin = "origin/$masterBranch"
	
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Merge to master"

	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Do not merge to master"

	$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
	$confirmation = $host.ui.PromptForChoice('Confirmation', "Are you sure you want to merge $branch to the master branch?", $options, 0)
	
	If ($confirmation -eq 0) {
		git co $branch
		git pull
		git rhu; git clean -fd;
		git merge $masterOrigin
		Write-Output "Push branch here"
		git co $masterBranch
		git pull
		git rhu; git clean -fd;
		git merge $branch # Should be origin/branch
		Write-Output "Push master here"
		git co design
		git merge $masterOrigin
		Write-Output "Push design here"
		Write-Output "Delete remote branch"
		Write-Output "Push local branch"
	}
}