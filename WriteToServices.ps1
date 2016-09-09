Enable-PSRemoting -Force

$exist = Select-string -path "c:\windows\System32\Drivers\Etc\Services" “sapmsBEP `t3626/tcp”
if($exist -eq $null){
    "`nsapmsBEP `t3626/tcp”| Out-File "c:\windows\System32\Drivers\Etc\Services" -Append utf8
    Write-Host "Written successful"
}Else{
    Write-Host "Already Exist"
}
