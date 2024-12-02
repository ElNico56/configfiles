# This is a script to update the config files

# Set the working directory
let $work_dir = $env.pwd

cp $nu.config-path $work_dir
cp ~\.config\micro\settings.json ($work_dir | path join "micro")
cp ~\.config\micro\bindings.json ($work_dir | path join "micro")
cp -r ~\.config\micro\colorschemes ($work_dir | path join "micro")
cp ~\AppData\Roaming\Code\User\settings.json ($work_dir | path join "vscode")
