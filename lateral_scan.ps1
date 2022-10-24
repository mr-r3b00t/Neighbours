$ports = @("445","3389","5985","5986")
$targetlist = @()
$results_list = @()
$tcpconnectlist = @()

$net_neighbours = Get-NetNeighbor -AddressFamily IPv4

foreach($node in $net_neighbours){
$node.IPAddress
$target = "\\"+$node.IPAddress+"\c$"
$target
#$cred = Get-Credential -Credential Contoso\ServiceAccount
#New-PSDrive -Name "T" -Root $target -Persist -PSProvider "FileSystem"
$nets = $node.IPAddress.ToString() -split "\."
$nets[0]

$ipranges = ("192","172","10")

if($nets[0] -in $ipranges){"ok"}

if($nets[0] -in $ipranges){
    write-host "Local Network Address Found" -ForegroundColor Green
    If($nets -notcontains "255"){
    write-host "Local Unicast Address Found" -ForegroundColor Green

    $node.IPAddress

    $targetlist += $node.IPAddress

    #$targetlist = $targetlist | Sort-Object -Unique



    }
}

}

$targetlist

foreach($destination in $targetlist){

foreach($port in $ports){

write-host "Testing Port: " $port " against: " $destination -ForegroundColor Cyan
$tcpclient = New-Object System.Net.Sockets.TcpClient
$connected = $tcpclient.BeginConnect($destination,$port,$null,$null)
sleep -Milliseconds 20

if($tcpclient.Connected){

write-host "port $port open" -ForegroundColor Red
$results_list += Test-NetConnection -ComputerName $destination -Port $port
$tcpconnectlist += $results_list | Where-Object TcpTestSucceeded -EQ $True

}

$tcpclient.Client.Close()

}

}

#alive hosts
write-host "Alive Hosts"
$alivelist = $tcpconnectlist | Where-Object TcpTestSucceeded -EQ $True | Select-Object -Property ComputerName | Sort-Object -Property ComputerName -Unique


write-host "SMB Hosts"

#smb hosts
$smbhostlist = $tcpconnectlist | Where-Object TcpTestSucceeded -EQ $True | Where-Object RemotePort -EQ 445 | Select-Object -Property ComputerName | Sort-Object -Property ComputerName -Unique


write-host "RDP Hosts"
#rdp hosts
$rdphostlist = $tcpconnectlist | Where-Object TcpTestSucceeded -EQ $True | Where-Object RemotePort -EQ 3389 | Select-Object -Property ComputerName | Sort-Object -Property ComputerName -Unique

$smbhostlist


$rdphostlist

write-host "There are : " $alivelist.count " Hosts Alive based on ARP cache entries." -ForegroundColor Green
