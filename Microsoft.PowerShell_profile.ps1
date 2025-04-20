
Write-Host " "
Write-Host "  ██" -NoNewline -ForegroundColor "Red"
Write-Host " ██" -NoNewline -ForegroundColor "Yellow"
Write-Host " ██" -NoNewline -ForegroundColor "Green"
Write-Host " ██" -NoNewline -ForegroundColor "Cyan"
Write-Host " ██" -NoNewline -ForegroundColor "Blue"
Write-Host " ██" -NoNewline -ForegroundColor "Magenta"

Write-Host "`n"

## luarocks
$env:LUA_PATH = 'C:\Users\Nicolas\Stuff\lua\bin\lua\?.lua;C:\Users\Nicolas\Stuff\lua\bin\lua\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\?.lua;C:\Users\Nicolas\Stuff\lua\bin\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?\init.lua;.\?.lua;.\?\init.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?\init.lua'
$env:LUA_CPATH = 'C:\Users\Nicolas\Stuff\lua\bin\?.dll;C:\Users\Nicolas\Stuff\lua\bin\..\lib\lua\5.4\?.dll;C:\Users\Nicolas\Stuff\lua\bin\loadall.dll;.\?.dll;C:\Users\Nicolas\AppData\Roaming\luarocks\lib\lua\5.4\?.dll'

Set-Alias lsc Get-ChildItemColor

function lambster() {
	node "C:\Users\Nicolas\Stuff\lambster\cli.js" $args
}

function oK() {
	node "C:\Users\Nicolas\Stuff\oK\repl.js" $args
}

function make {
	mingw32-make $args
}

function Do-At {
	param(
		[Parameter(Mandatory=$true)] [string]$Where,
		[Parameter(Mandatory=$true)] [ScriptBlock]$What
	)
	Push-Location $Where
	try {
		& $What
	} catch { }
	Pop-Location
}

function dir {
	Get-ChildItem -Force | Sort-Object @{ Expression = { -not $_.PSIsContainer } }, Name
}

function tere {
	$result = . (Get-Command -CommandType Application tere) $args
	if ($result) {
		Set-Location $result
	}
}

function Watchdog {
	param( [Parameter(Mandatory=$true)] [string]$File )

	$ext = ([System.IO.Path]::GetExtension($File)).TrimStart('.').ToLower()

	$resolved = Resolve-Path $File
	$dir = [System.IO.Path]::GetDirectoryName($resolved.Path)
	$name = [System.IO.Path]::GetFileName($File)

	$watcher = New-Object System.IO.FileSystemWatcher
	$watcher.Path = $dir
	$watcher.Filter = $name
	$watcher.NotifyFilter = [System.IO.NotifyFilters]'LastWrite'

	$action = {
		Clear-Host
		try {
			switch ($using:ext) {
				"bqn"  { & bqn $using:File }
				"c"    { & tcc -run $using:File }
				"js"   { & node $using:File }
				"jl"   { & julia $using:File }
				"lil"  { & lilt $using:File }
				"lua"  { & lua $using:File }
				"py"   { & py $using:File }
				"raku" { & raku $using:File }
				"rb"   { & ruby $using:File }
				"ua"   { & uiua $using:File }
				"k"    { & oK $using:File }
				default { Write-Host "Unsupported file extension: $using:ext" }
			}
		} catch { }
	}

	$registration = Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier "FileChanged" -Action $action
	$watcher.EnableRaisingEvents = $true

	Write-Host "Watching file: $File. Press Enter to stop watching."
	Read-Host
	Unregister-Event -SourceIdentifier "FileChanged"
	$watcher.Dispose()
}

function Get-CommandAliases {
	[CmdletBinding()]
	param( [Parameter(Mandatory = $true)] [string]$CommandName )

	$aliases = Get-Alias | Where-Object { $_.Definition -eq $CommandName }

	if ($aliases.Count -eq 0) {
		Write-Warning "No aliases found for command '$CommandName'"
	} else {
		$aliases.Name
	}
}

## default "PS $PWD> "

$_esc   = [char]27
$_reset = "${_esc}[0m"
$ansi = @(
	"${_esc}[91m",
	"${_esc}[92m",
	"${_esc}[93m",
	"${_esc}[94m",
	"${_esc}[95m",
	"${_esc}[96m"
)
$_fc = $ansi | Get-Random
$_sc = $ansi | Get-Random
while ($_fc -eq $_sc) { $_sc = $ansi | Get-Random }

function prompt {
	$currentPath = (Get-Location).Path
	$folders = $currentPath -split '\\'

	$currentPath = $currentPath -replace '\\$', ""
	$currentPath = $currentPath -replace [regex]::Escape($HOME), "~"
	$currentPath = $currentPath -replace '\\', "$_sc\$_fc"
	if ($folders.Count -le 7) {
		"$_fc$currentPath$_sc>$_reset "
	} else {
		$folder = $folders[-2]
		$subfolder = $folders[-1]
		"$_fc*$_sc\$_fc$folder$_sc\$_fc$subfolder$_sc>$_reset "
	}
}
