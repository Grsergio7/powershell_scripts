
#Add registry values and keys to Registry to extend internet timeout
function timeout-settings1 {
    $KeepAlive = New-ItemProperty -Path $internetsettings -Name "KeepAliveTimeout" -Value 180000 -PropertyType "DWORD"
    $Receive = New-ItemProperty -Path $internetsettings -Name "ReceiveTimeout" -Value 480000 -PropertyType "DWORD"
    $ServerTImeout = New-ItemProperty -Path $internetsettings -Name "ServerInfoTimeout" -Value 180000 -PropertyType "DWORD"
}
function timeout-settings2 {
    $KeepAlive = New-ItemProperty -Path $Local -Name "KeepAliveTimeout" -Value 180000 -PropertyType "DWORD"
    $Receive = New-ItemProperty -Path $Local -Name "ReceiveTimeout" -Value 480000 -PropertyType "DWORD"
    $ServerTImeout = New-ItemProperty -Path $Local -Name "ServerInfoTimeout" -Value 180000 -PropertyType "DWORD"
}

#Location of registry
$internetsettings = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'
$Local = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings'

#Enter computer name to start
$computer = read-Host "Enter the Computer name"
Enter-PSSession -ComputerName $computer

cd internetsettings| timeout-settings1
cd $Local | timeout-settings2
