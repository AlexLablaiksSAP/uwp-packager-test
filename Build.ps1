param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]] $SlnDir,
	[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]] $SlnName,
	[Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]] $ProjectDir,
	[Parameter(Mandatory=$false, ValueFromPipeline=$true)] [string[]] $ZipDir
)

# Include with the following syntax, (adjust relative path as appropriate): . ".\Find-Exe.ps1"
# then just fall Find-Exe "<somepath with * wildcards>" "<target exe>"
. "$PSScriptRoot\Find-Exe.ps1"

$msBuildSearchPath = "C:\*\Microsoft Visual Studio\2019\*\MSBuild\Current\Bin"
$msBuild = Find-Exe $msBuildSearchPath "MSBuild.exe"

Write-Host ("Pre-requisites met, proceeding to build") -ForegroundColor green

$slnFile = "$SlnDir\$SlnName.sln"
$configuration = "Release"
$platform = "x64"

# if NuGet fails with "<some DLL> because it is being used by another process.", try to run `net session /delete` in an administrator console
& $msbuild $slnFile -t:restore -p:RestorePackagesConfig=true -p:Configuration=$configuration -p:Platform=$platform -p:DisableParallelProcessing=true -p:RestoreNoCache=true
if ($LastExitCode -ne 0) {
	throw ('Nuget restore failed on ' + $slnFile)
	exit $LastExitCode
}

& $msBuild $slnFile /property:Configuration=$configuration /property:Platform=$platform
if ($LastExitCode -ne 0) {
	throw ($slnFile + ' failed to build')
	exit $LastExitCode
}

$zipOutDir = "$PSScriptRoot\gen\out"
if (!(test-path $zipOutDir))
{
	New-Item -ItemType Directory -Force -Path $zipOutDir
}

if ($ZipDir.Length -eq 0)
{
	$ZipDir = "$ProjectDir\bin\$platform\$configuration"
}

Compress-Archive -Force -Path $ZipDir -DestinationPath $zipOutDir\$SlnName.zip
if ($LastExitCode -ne 0) {
	throw ('Failed to create $zipOutDir\$SlnName.zip')
	exit $LastExitCode
}
