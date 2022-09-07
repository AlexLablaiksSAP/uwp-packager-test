# Include with the following syntax, (adjust relative path as appropriate): . ".\Find-Exe.ps1"
# then just fall Find-Exe "<somepath with * wildcards>" "<target exe>"

function Find-Exe {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,mandatory=$true)]
		[string] $SearchPath,
		
		[Parameter(Position=1,mandatory=$true)]
		[string] $ExeName)

	if (!($SearchPath | Test-Path)) {
		throw ("Could not find " + $ExeName + " in " + $SearchPath)
	}

	$pathResult = $SearchPath | Resolve-Path
	if ($pathResult.ToString() -eq "System.Object[]") {
		$pathResult = $pathResult[0].ToString();
	} else {
		$pathResult = $pathResult.ToString();
	}

	$fullExePath = ($pathResult + "\" + $ExeName)
 
	Write-Host ("Successfully found " + $fullExePath) -ForegroundColor green
	
	return $fullExePath
}
