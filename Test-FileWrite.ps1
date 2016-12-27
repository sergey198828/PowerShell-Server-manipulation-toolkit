#requires -version 4
#
#  .SYNOPSIS
#
#  Test-FileWrite -remoteFile [-LogFile="ScriptDirectory\Test-FileWrite.csv"] [-frequencySec=60]
#
#  .DESCRIPTION
#
#  PowerShell script infinitly try to write to remote file and write result to the log
#
#  CSV File format: DateTime, Origin
#  
#  Log file format: DateTime, RemoteFile, Result
#
#  .EXAMPLE
#
#  1. Write to \\testserver\test.csv log file ScriptDirectory\Test-FileWrite.csv frequency 60 seconds.
#
#     Test-FileWrite -remoteFile "\\testserver\test.csv" 
#
#  2. Write to \\testserver\test.csv log file C:\\Log.csv frequency 10 seconds.
#
#     Test-FileWrite -remoteFile "\\testserver\test.csv" -LogFile "C:\\Log.csv" -frequencySec 10
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Destination file
#
   [Parameter(Mandatory=$True)]
   [string]$remoteFile,
#
#  Log file
#
   [Parameter(Mandatory=$False)]
   [string]$LogFile=$PSScriptRoot+"\Test-FileWrite.csv",
#
#  Frequency in seconds
#
   [Parameter(Mandatory=$False)]
   [int]$frequencySec = 60
)
#
# End of parameters block
#
#_______________________________________________________
#
# Getting origin computer name
#
   $origin = $env:computername
#
# Prompting for Username
#
   Write-host "Please enter your username"
   $username = read-host
#
# Prompting for Password
#
   read-host -assecurestring | convertfrom-securestring | out-file C:\Scripts\securestring.txt
   $password = cat C:\Scripts\securestring.txt | convertto-securestring
#
# Constructing credentials object
#
   $cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password
#
# Preparing remote file
#
   write-host "Writing file "$remoteFile
   Add-Content $remoteFile "DateTime, Origin"
#
# Preparing log file
#
   write-host "Writing log "$LogFile
   Add-Content $LogFile "DateTime, RemoteFile, Result"
#
# Inform frequency time
#
   write-host "Frequency "$frequencySec" seconds"
#
# Infinite loop
#
   $i = 1
   while($i -lt 9999){
#
# Getting date and time
#
     $dateTime = Get-Date
#
# Writing files
#
     $Result = "Success"
     try{
       Add-Content $remoteFile "$dateTime, $origin" -ErrorAction Stop 
     }
     catch{
#
# Writing error to log
#
       $Result = $_.Exception.Message
     }
     Add-Content $LogFile "$dateTime, $remoteFile, $Result" 
#
# Pending
#
     Start-Sleep -s $frequencySec
#
# Finalaze iteration
#
     Write-Host "$i test done"
     $i++
   }