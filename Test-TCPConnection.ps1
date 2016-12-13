#requires -version 3
#
#  .SYNOPSIS
#
#  Test-TCPConnection -destinationHost -destinationPort [-OutputFile="ScriptDirectory\Server-Availability.csv"] [-frequencySec=60]
#
#  .DESCRIPTION
#
#  PowerShell script infinitly test TCP connection to specified server port with specified frequency and write result to specified CSV file
#
#  CSV File format: DateTime, Server, RemotePort, Result
#
#  .EXAMPLE
#
#  1. Test connection to testserver1 port 80 with frequency 60 seconds and write to ScriptDirectory\Server-Availability.csv
#
#     Test-TCPConnection -destinationHost "testserver1" -destinationPort 80
#
#  2. Test connection to testserver1 port 80 with frequency 10 seconds and write to C:\testserver1-Availability.csv
#
#     Test-TCPConnection -destinationHost "testserver1" -destinationPort 80 -OutputFile "C:\outputServers.csv" -frequencySec 10
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Destination host
#
   [Parameter(Mandatory=$True)]
   [string]$destinationHost,
#
#  Destination port
#
   [Parameter(Mandatory=$True)]
   [int]$destinationPort,
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\Servers-Availability.csv",
#
#  Frequency in seconds
#
   [Parameter(Mandatory=$False)]
   [int]$frequencySec = 6
)
#
# End of parameters block
#
#_______________________________________________________
#
#Preparing output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile "DateTime, Server, RemotePort, Result"
#
#Infinite loop
#
   $i = 1
   while($i -lt 9999){

# Getting date and time

     $dateTime = Get-Date

# Testing RDP connection to server deuntp096

     $test = Test-NetConnection -ComputerName $destinationHost  -Port $destinationPort 

# Writing to file
     $Result = $test.TcpTestSucceeded
     Add-Content $OutputFile "$dateTime, $destinationHost, $destinationPort, $Result"
# Pending
     Start-Sleep -s $frequencySec
# Finalaze iteration
     Write-Host "$i sample collected"
     $i++
   }