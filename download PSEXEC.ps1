Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile 'pstools.zip'  

Expand-Archive -Path 'pstools.zip' -DestinationPath "$env:TEMP\pstools"  

Move-Item -Path "$env:TEMP\pstools\psexec.exe" .  

Remove-Item -Path "$env:TEMP\pstools" -Recurse 