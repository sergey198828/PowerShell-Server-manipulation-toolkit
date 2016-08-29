#requires -version 3
#
#  .SYNOPSIS
#
#  Invoke-CMD -Server -Command [-User=$kiyanser]
#
#  .DESCRIPTION
#
#  PowerShell script executes specified command on specifies server with specified credentials 
#
#  .EXAMPLE
#
#  1. Execute ipconfig /all on issw4100 from $kiyanser
#
#     Invoke-CMD -Server "issw4100" -Command {ipconfig /all}
#
#  2. Execute ipconfig /all on issw4100 from user1
#
#     Invoke-CMD -Server "issw4100" -Command {ipconfig /all"} -User "user1"
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Server
#
   [Parameter(Mandatory=$True)]
   [string]$server,
#
#  Command
#
   [Parameter(Mandatory=$True)]
   [System.Management.Automation.ScriptBlock]$command,
#
#  User
#
   [Parameter(Mandatory=$False)]
   [string]$user='$kiyanser'
)
#
# End of parameters block
#
#_______________________________________________________
#
# Prompting for Username if required
#
   if($user -eq ""){
     Write-host "Please enter your username"
     $username = read-host
   }
   else{
     $username = $user  
   }
#
# Prompting for Password
#
   read-host -assecurestring | convertfrom-securestring | out-file C:\Scripts\securestring.txt
   $password = cat C:\Scripts\securestring.txt | convertto-securestring
#
# Constructing credentials object
#
   $credential = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password
#
# Executing command
#
   Invoke-Command -ComputerName $server -ScriptBlock $command -Credential $credential