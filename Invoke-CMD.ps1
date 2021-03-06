﻿#requires -version 3
#
#  .SYNOPSIS
#
#  Invoke-CMD -ScriptFile [-InputFile="ScriptDirectory\hosts.csv"] [-OutputFile="ScriptDirectory\results.csv"] [-User]
#
#  .DESCRIPTION
#
#  PowerShell script executes specified script on CSV specified servers with specified credentials 
#
#  .EXAMPLE
#
#  1. Execute C:\Scripts\test.ps1 script on ScriptDirectory\hosts.csv hosts from $kiaynser credentials
#
#     Invoke-CMD -ScriptFile "C:\Scripts\test.ps1"
#
#  2. Execute C:\Scripts\test.ps1 script on C:\hosts.csv hosts from $testaccount credentials
#
#     Invoke-CMD -ScriptFile "C:\Scripts\test.ps1" -InputFile "C:\Scripts\test.ps1" -User "`$testaccount"
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Script File
#
   [Parameter(Mandatory=$True)]
   [string]$ScriptFile,
#
#  Input file
#
   [Parameter(Mandatory=$False)]
   [string]$InputFile=$PSScriptRoot+"\hosts.csv",
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\results.csv",
#
#  User
#
   [Parameter(Mandatory=$False)]
   [string]$user=''
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
# Reading input file
#
   Write-Host "Reading file "$InputFile
   $Hosts = import-csv $InputFile
#
# Prepare output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile “Server,Result”;
#
# Looping over servers
#
   Foreach($Line in $Hosts){
   $server = $Line.Host
#
# Executing command
#
     Write-Host "Executing on "$server
     $output = Invoke-Command -ComputerName $server -FilePath $ScriptFile -Credential $credential 4>&1
#
# Writing to file
#
     Add-Content $OutputFile "$server,$output”;
   }