#requires -version 3
#
#  .SYNOPSIS
#
#  DNS-CheckServerExist [-InputFile="ScriptDirectory\hosts.csv"] [-OutputFile="ScriptDirectory\dns-hosts.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script based on input CSV file generates output CSV file with additional field which identifies if server exist in DNS
#
#  CSV File format: Host
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\hosts.csv file and generate ScriptDirectory\dns-hosts.csv file.
#
#     DNS-CheckServerExist.ps1
#
#  2. Parse C:\inputhosts.csv file and generate C:\outputhosts.csv file.
#
#     DNS-CheckServerExist.ps1 -InputFile "C:\inputhosts.csv" -OutputFile "C:\outputhosts.csv"
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
   [string]$InputFile=$PSScriptRoot+"\hosts.csv",
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\dns-hosts.csv"
)
#
# End of parameters block
#
#_______________________________________________________
#
# Add AD PowerShell Snap-In
#

#
# Reading input file
#
   write-host "Reading file "$InputFile
   $Hosts = import-csv $InputFile
#
# Prepare output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile “Host,Exist,DNSRecord”;
   foreach($Line in $Hosts){
#
# Trying to resolve server dns record
#
      $HostName = $Line.Host
      $DNSRecord = [Net.DNS]::GetHostEntry($HostName) #Windows 8+ can use Resolve-DnsName
#
# If Server doesnt exist
#
      if($DNSRecord -eq $null){
         write-host "Host "$Hostname" doesnt exist in DNS"
         Add-Content $OutputFile "$Hostname,No,”;
      }
#
# If Server exist
#
      Else{
         write-host "Host "$Hostname" exist in DNS"
         $DNSRecordString = $DNSRecord.HostName
         Add-Content $OutputFile "$Hostname,Yes,$DNSRecordString”;
      }
      $DNSRecord = $null
   }