$destDirectory = "$PSScriptRoot\gen\out\packager"
if (Test-Path $destDirectory)
{
	Remove-Item -Force -Recurse $destDirectory
}

New-Item -ItemType Directory -Force -Path $destDirectory

$omissions = [string[]]@("gen", "node_modules", "windows")
Copy-Item $PSScriptRoot\* -Exclude $omissions -Destination $destDirectory -Recurse

Compress-Archive -Force -Path $destDirectory -DestinationPath "$destDirectory.zip"
Remove-Item -Force -Recurse $destDirectory
