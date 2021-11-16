#****************ALL FUNCTIONS *********************


function Engage-PSRemote {
    Psexec \\$computer -h -s powershell.exe Enable-PSRemoting -Force
    psexec \\$computer -h -s winrm.cmd quickconfig /q
}

#Install Bomgar
function Install-Bomgar {
    $file = Get-ChildItem -Path $Home -recurse -include bomgar*.exe
    try { psexec \\$computer -c $file }
    catch { "Bomgar executable not found in $Home" }

}

#Install Global Protect
function Install-GP {
    $file = Get-ChildItem -Path $Home -recurse -include GlobalProtect64.msi
    $session = New-PSSession -computername $computer
    Copy-Item -path $file -Destination 'C:\' -ToSession $session -Recurse
    Invoke-Command -ScriptBlock {Set-Location 'C:\' | cmd /c 'GlobalProtect64.msi'} -Computername $computer
    Remove-PSSession -Session $session
    
}

#Copy Tanium from local to remote computer and running install
function Copy-Tanium {
    $file = Get-ChildItem -Path $Home -recurse -include Tanium_install
    $session = New-PSSession -computername $computer
    Copy-Item -path $file -Destination 'C:\' -ToSession $session -Recurse
    Invoke-Command -ScriptBlock {Set-Location 'C:\Tanium_install' | cmd /c 'SetupClient.exe /S'} -Computername $computer
    Remove-PSSession -Session $session

}

#Chrome Install
function Install-Chrome {
    Invoke-Command -ScriptBlock {$Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer} -Computername $computer
}

Function Install-CrowdStrike {
    $file = Get-ChildItem -Path $Home -recurse -include 'Crowdstrike Falcon Sensor'
    $session = New-PSSession -ComputerName $computer
    Copy-Item -path $file -Destination 'C:\' -recurse -ToSession $session
    Invoke-Command -ScriptBlock {Set-Location C:\'Crowdstrike Falcon Sensor'\ | cmd /c .\crowdstrike.cmd} -Computername $computer
    Remove-PSSession -Session $session
    Break
}

# Copy File from local to remote computer
<#
$from = 'C:\Users\ad.sergio.ruiz\Downloads\onexc_6.2.14.13-sp14p5.zip'
$goingto = 'C:\'

$session = New-PSSession -computername $computer

Copy-Item -path $from -Destination 'C:\' -recurse -ToSession $session

$session | Remove-PSSession

#>

#Remove users EXCEPT
<#
New-PSSession $Computer
$other = read-host "Enter the Profiles you do NOT want to DELETE"
cd C:\Users
$who = Get-ChildItem -Path 'C:\Users' -exclude Admin,Public,$other
Remove-Item $who -recurse -force

#$filter =  where-Object { $_.LastWriteTime -lt (Get-Date "1/1/21") }
#>

#************************************************

#Start Winrm Service on remote computer
PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Unrestricted -File ""$HOME\Downloads\installzoomplugin_v1.ps1""' -Verb RunAs}"
Clear-Host
write-host "******************************************"
write-host "          Manual Re-Image Script         "
write-host "******************************************"
$computer = read-host "Enter Computer Name"
$newcomputer = read-host "Moving New computer to GV OU? [Y] Yes or [N] No"

if ($newcomputer -eq "Y") {
#transfer new computer to GV OU
Move-ADObject -Identity "CN=$computer,CN=Computers,DC=covetrus,DC=net" -targetPath "OU=Grandview,OU=Computers,OU=GPM,OU=Covetrus Business Units,DC=covetrus,DC=net"
write-warning "Please run Gpupdate /force on Computer and restart to proceed"
write-warning "Make sure to restart new computer after Gpdate /force"
read-host -Prompt "Press any key to continue or CTRL+C to quit"
;
}
else{
write-host "Not a new Computer"
}

$Start = read-host "Enable PSRemote? [Y] or [N]"
if ($Start -eq "Y") {
    Engage-PSRemote
} else {
    write-warning "Installation Failed"
    }

$Bomgar = read-host "Do you want to install Bomgar (AZ Client)? [Y] or [N]"
if ($Bomgar -eq "Y") {
    Install-Bomgar 
    write-host "Bomgar Installed" -BackgroundColor Green
} else {
    write-warning "Insallation Failed"
}

$Tanium = read-host "Do you want to install Tanium Client? [Y] or [N]"
if ($Tanium -eq "Y") {
    Copy-Tanium
    write-host "Tanium Installed" -BackgroundColor Green
} else {
    write-warning "Insallation Failed"
}

$GP = read-host "Do you want to install Global Protect? [Y] or [N]"
if ($GP -eq "Y") {
    Install-GP 
    write-host "GP Installed" -BackgroundColor Green
} else {
    write-warning "Insallation Failed"
}

$Chrome = read-host "Do you want to install Chrome? [Y] or [N]"
if ($Chrome -eq "Y") {
    Install-Chrome 
    write-Host "Chrome Installed" -BackgroundColor Green
} else {
    write-warning "Insallation Failed"
}

$CS = read-host "Do you want to install CrowdStrike? [Y] or [N]"
if ($CS -eq "Y") {
    Install-CrowdStrike 
    Write-host "Crowdstrike Installed" -BackgroundColor Green
} else {
    write-warning "Insallation Failed"
}
write-host "Installation Completed" -BackgroundColor Gray
read-host -Prompt "Press any key to continue or CTRL+C to quit"
;

