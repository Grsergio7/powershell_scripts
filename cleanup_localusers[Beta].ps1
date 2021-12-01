New-PSSession -ComputerName AZ000550
cd C:\Users
$who = Get-ChildItem -Path 'C:\Users' -exclude Admin,Public,ad.sergio.ruiz,zi.cho
Remove-Item $who -recurse -force

#$filter =  where-Object { $_.LastWriteTime -lt (Get-Date "1/1/21") -notlike '.\Admin,Public,ad.sergio.ruiz,zi.cho'}