#Type Computer you are wanting to transfer

$computer = read-host "Type newly imaged Computer name"

#Newly connected computers are in the "Computer" group, we have to move them to our OU for proper funcionality

Try
{
$moveit = Move-ADObject -Identity "CN=$computer,CN=Computers,DC=covetrus,DC=net" -TargetPath "OU=Computers - New,OU=GPM,OU=Covetrus Business Units,DC=covetrus,DC=net"
}

Catch
{ 
    write-host "Computer not found in OU"
     Break
}
