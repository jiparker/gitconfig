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