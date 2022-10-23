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

if($nets[0] -in $ipranges){
write-host "Local Network Address Found" -ForegroundColor Green
If($nets -notcontains "255"){
write-host "Local Unicast Address Found" -ForegroundColor Green

$node.IPAddress

$targetlist += $node.IPAddress

foreach($destination in $targetlist){

foreach($port in $ports){

$results_list += Test-NetConnection -ComputerName $destination -Port $port
$tcpconnectlist += $results_list | Where-Object TcpTestSucceeded -EQ $True
}

}

}
}

}

$tcpconnectlist
