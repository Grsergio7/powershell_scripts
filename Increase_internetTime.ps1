
#Add registry values and keys to Registry to extend internet timeout
function Set-timeout1 {
    New-ItemProperty -Path $internetsettings -Name "KeepAliveTimeout" -Value 180000 -PropertyType "DWORD"
    New-ItemProperty -Path $internetsettings -Name "ReceiveTimeout" -Value 480000 -PropertyType "DWORD"
    New-ItemProperty -Path $internetsettings -Name "ServerInfoTimeout" -Value 180000 -PropertyType "DWORD"
}
function Set-timeout2{
    New-ItemProperty -Path $Local -Name "KeepAliveTimeout" -Value 180000 -PropertyType "DWORD"
    New-ItemProperty -Path $Local -Name "ReceiveTimeout" -Value 480000 -PropertyType "DWORD"
    New-ItemProperty -Path $Local -Name "ServerInfoTimeout" -Value 180000 -PropertyType "DWORD"
}

#Location of registry
$internetsettings = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'
$Local = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'

#Enter computer name to start
$computer = read-Host "Enter the Computer name"
Enter-PSSession -ComputerName $computer

Set-Location $internetsettings| Set-timeout1
Set-Location $Local | Set-timeout2
