PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Unrestricted -File ""$HOME\Downloads\installzoomplugin_v1.ps1""' -Verb RunAs}"
clear-host
write-host "******************************************"
write-host "            Remote Installation           "
write-host "******************************************"

function install-bgar {
    # Check to see if program download file is already installed
    $computer = read-host "Enter Remote Computer Name"
    #Test-WSMan -ComputerName $computer
    $file = Get-ChildItem -path $home -Recurse -Include "bomgar*.exe"
    $pa = Test-Path -path $file

    if ($pa -eq 'True') {
        $file = Get-ChildItem -Path $Home -recurse -include bomgar*.exe
        psexec \\$computer -c $file }
    } else {write-host "You need to download the .exe file from sharepoint first"}


$check = Get-Command psexec -ErrorAction SilentlyContinue
if ($check) {
    install-bgar 
} 
else {
    write-host '***** installing PSEXEC for remote installation *****'
    Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile 'pstools.zip'
    Expand-Archive -Path 'pstools.zip' -DestinationPath "C:\Windows\System32\"  
    Move-Item -Path "$env:TEMP\pstools\psexec.exe" 
    Remove-Item -Path "$env:TEMP\pstools" -Recurse
    write-host '***** Installation completed *****'
    install-bgar
}






