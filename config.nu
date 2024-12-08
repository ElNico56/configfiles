# Nushell profile

print $"\n"
print $"                     =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
print $"     \e[31m███   ███████\e[0m            Nushell ($env.NU_VERSION)"
print $"     \e[33m████  ██     \e[0m   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
print $"     \e[32m██ ██ ██ ███ \e[0m    🖥️ Hostname      : (sys host | get hostname)"
print $"     \e[36m██  ████   ██\e[0m    🌐 OS            : (sys host | get name)"
print $"     \e[34m██   ███ ███ \e[0m    ⏲️ Uptime        : (sys host | get uptime)"
print $"                     =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
print $""

# set nushell variables
$env.PROMPT_COMMAND_RIGHT = {||}
#$env.PROMPT_COMMAND = {"\n " + (create_left_prompt) + "\n ┗━━━"}
#$env.PROMPT_INDICATOR = {" "}
#$env.PROMPT_COMMAND = {"\n " + (create_left_prompt)}
$env.config.show_banner = false
$env.config.history.max_size = 5_000
$env.config.ls.clickable_links = false
$env.config.table.index_mode = 'auto'
$env.config.table.mode = 'heavy'

# add luarocks to lua path
$env.LUA_PATH = 'C:\Users\Nicolas\Stuff\lua\bin\lua\?.lua;C:\Users\Nicolas\Stuff\lua\bin\lua\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\?.lua;C:\Users\Nicolas\Stuff\lua\bin\?\init.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?.lua;C:\Users\Nicolas\Stuff\lua\bin\..\share\lua\5.4\?\init.lua;.\?.lua;.\?\init.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?.lua;C:\Users\Nicolas\AppData\Roaming\luarocks\share\lua\5.4\?\init.lua'
$env.LUA_CPATH = 'C:\Users\Nicolas\Stuff\lua\bin\?.dll;C:\Users\Nicolas\Stuff\lua\bin\..\lib\lua\5.4\?.dll;C:\Users\Nicolas\Stuff\lua\bin\loadall.dll;.\?.dll;C:\Users\Nicolas\AppData\Roaming\luarocks\lib\lua\5.4\?.dll'

# silly aliases
alias lambster = node C:\Users\Nicolas\Stuff\lambster\cli.js
alias lamb = lambster -i .lambrc # lambster wrapper
alias c = ^tcc -run # C as scripting language
alias ed = ^ed -p:

# better mkdir
def --env newdir [name:string] {
	mkdir $name
	cd $name
}

# better ls
def dir [] {
	ls -a | sort-by name | sort-by type
}

# raylua wrappers
def 'raylua build' [input:path output:path] { raylua_r $input $output }
def 'raylua run' [arg:path] { raylua_s $arg }

# tere wrapper
def --wrapped --env tere [...args] {
	let result = (^tere ...$args)
	if $result != "" {
		cd $result
	}
}

# Execute command at a specific location
def --env doat [path:path closure:closure] {
	cd $path
	do $closure
	cd -
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
				_      => {print $"Unsupported file extension: ($ext)"}
			}
		} catch {}
	}
}
