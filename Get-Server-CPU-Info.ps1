#requires -version 3
#
#  .SYNOPSIS
#
#  Get-Server-CPU-Info [-InputFile="ScriptDirectory\Servers.csv"] [-OutputFile="ScriptDirectory\Servers-CPU.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script based on input CSV file generates output CSV file which contains information about amount of CPU, Cores and logical Cores.
#  Script will prompt you to provide credentials, password will be saved as securestring in C:\Scripts\securestring.txt file. 
#
#  CSV File format: Server
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\Servers.csv file and generate ScriptDirectory\Servers-CPU.csv file.
#
#     Get-Server-CPU-Info.ps1
#
#  2. Parse C:\inputServers.csv file and generate C:\outputServers.csv file.
#
#     Get-Server-CPU-Info.ps1 -InputFile "C:\inputServers.csv" -OutputFile "C:\outputServers.csv"
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Input file
#
   [Parameter(Mandatory=$False)]
   [string]$InputFile=$PSScriptRoot+"\Servers.csv",
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\Servers-CPU.csv"
)
#
# End of parameters block
#
#_______________________________________________________
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
# Reading input file
#
   write-host "Reading file "$InputFile
   $Servers = import-csv $InputFile
#
# Prepare output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile “Server,CPU,Cores,LogicalCores”;
#
# Looping over all Servers in file
#
   foreach($Server in $Servers){
#
# Retrieve information from server
#
     $ServerName = $Server.Server
     write-host "Fetching $ServerName"
     $CpuSetup = Get-WmiObject Win32_Processor -ComputerName $ServerName -Credential $cred | select Name,NumberOfCores,NumberOfLogicalProcessors
     $CPUName = $CpuSetup.Name
     $CPUCores = $CpuSetup.NumberOfCores
     $CPULogicalCores = $CpuSetup.NumberOfLogicalProcessors
#
# Check if single CPU
#
     if($CPUName -isnot [System.Array]){
#
# Writing to file
#
     Add-Content $OutputFile "$ServerName,$CPUName,$CPUCores,$CPULogicalCores”;
     }
#
# If multiple CPUs
#
     else{
       for ($i=0; $i -lt $CPUName.length; $i++) {
#
# Writing to file
#
         $CPUNamePrint = $CPUName[$i]
         $CPUCoresPrint = $CPUCores[$i]
         $CPULogicalCoresPrint = $CPULogicalCores[$i]         
         Add-Content $OutputFile "$ServerName,$CPUNamePrint,$CPUCoresPrint,$CPULogicalCoresPrint"
       }
     }
   }