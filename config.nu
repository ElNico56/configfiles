# Nushell profile


print $"Nushell ($env.NU_VERSION)\n"
print " "
print -n $"(ansi lr)  ██"
print -n $"(ansi ly) ██"
print -n $"(ansi lg) ██"
print -n $"(ansi lc) ██"
print -n $"(ansi lu) ██"
print -n $"(ansi lm) ██"
print "\n"

# set nushell variables

let ansi = [(ansi lr) (ansi ly) (ansi lg) (ansi lc) (ansi lu) (ansi lm)]
let fc = ($ansi | shuffle | first)
let sc = ($ansi | filter {$in != $fc } | shuffle | first)
def create_left_prompt [] {
	let path = pwd | str replace $"($env.HOMEDRIVE)($env.HOMEPATH)" '~'
	let folders = $path | split row $"\\"
	let colored = $folders | each {$"($fc)($in)"} | str join $"($sc)\\"

	if ($folders | length) <= 7 {
		$"($colored)($sc)"
	} else {
		let folder = ($folders | last 2 | first)
		let subfolder = ($folders | last)
		$"($fc)*($sc)\\($fc)($folder)($sc)\\($fc)($subfolder)($sc)"
	}
}
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_COMMAND = {create_left_prompt}
$env.PROMPT_INDICATOR = $"($sc)> "
$env.config.show_banner = false
$env.config.history.max_size = 5_000
$env.config.table.index_mode = 'auto'
$env.config.table.mode = 'heavy'

# add luarocks to lua path
$env.LUA_PATH = 'C:\Users\Nicolas\Stuff\lua\bin\lua\?.lua;C:\Users\Nicolas\Stuff\lua\bin\lua\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\?.lua;C:\Users\Nicolas\Stuff\lua\bin\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?\init.lua;.\?.lua;.\?\init.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?\init.lua'
$env.LUA_CPATH = 'C:\Users\Nicolas\Stuff\lua\bin\?.dll;C:\Users\Nicolas\Stuff\lua\bin\..\lib\lua\5.4\?.dll;C:\Users\Nicolas\Stuff\lua\bin\loadall.dll;.\?.dll;C:\Users\Nicolas\AppData\Roaming\luarocks\lib\lua\5.4\?.dll'

# silly aliases
alias lambster = ^node 'C:\Users\Nicolas\Stuff\lambster\cli.js'
alias ok = ^node 'C:\Users\Nicolas\Stuff\oK\repl.js'
alias oK = ^node 'C:\Users\Nicolas\Stuff\oK\repl.js'
alias make = ^mingw32-make # make wrapper
alias raku = ^rakudo 'C:\Users\Nicolas\Stuff\repl.raku'
alias nimr = ^nim --verbosity:0 r
alias pup = ^pip

# do at location
def --env doat [where:path what:closure] {
	cd $where
	try {do $what} catch {}
	cd -
}

# better ls
def dir [] {
	ls -a | sort-by name | sort-by type
}

# tere wrapper
def --wrapped --env tere [...args] {
	let result = (^tere ...$args)
	if $result != "" {
		cd $result
	}
}

# Execute file on file change
def watchdog [file:path] {
	let ext = $file | path parse | get extension
	watch $file {
		try {
			match $ext {
				"bqn"  => {cls; ^bqn $file}
				"c"    => {cls; ^tcc -run $file}
				"js"   => {cls; ^node $file}
				"jl"   => {cls; ^julia $file}
				"lil"  => {cls; ^lilt $file}
				"lua"  => {cls; ^lua $file}
				"py"   => {cls; ^py $file}
				"raku" => {cls; ^raku $file}
				"rb"   => {cls; ^ruby $file}
				"ua"   => {cls; ^uiua $file}
				"k"    => {cls; ok $file}
				_      => {print $"Unsupported file extension: ($ext)"}
			}
		} catch {}
	}
}
