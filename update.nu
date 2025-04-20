# This is a script to update the config files

cp $nu.config-path $env.pwd
cp ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 $env.pwd
cp ~\.config\micro\settings.json ($env.pwd | path join "micro")
cp ~\.config\micro\bindings.json ($env.pwd | path join "micro")
cp -r ~\.config\micro\colorschemes ($env.pwd | path join "micro")
cp ~\AppData\Roaming\Code\User\settings.json ($env.pwd | path join "vscode")
