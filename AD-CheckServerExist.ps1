#requires -version 3
#
#  .SYNOPSIS
#
#  AD-CheckServerExist [-InputFile="ScriptDirectory\hosts.csv"] [-OutputFile="ScriptDirectory\ad-hosts.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script based on input CSV file generates output CSV file with additional field which identifies if server exist in AD
#
#  CSV File format: Host
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\hosts.csv file and generate ScriptDirectory\ad-hosts.csv file.
#
#     AD-CheckServerExist.ps1
#
#  2. Parse C:\inputhosts.csv file and generate C:\outputhosts.csv file.
#
#     AD-CheckServerExist.ps1 -InputFile "C:\inputhosts.csv" -OutputFile "C:\outputhosts.csv"
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
   [string]$OutputFile=$PSScriptRoot+"\ad-hosts.csv"
)
#
# End of parameters block
#
#_______________________________________________________
#
# Add AD PowerShell Snap-In
#
#   Add-PSSnapin Microsoft.Windows.AD
#
# Reading input file
#
   write-host "Reading file "$InputFile
   $Hosts = import-csv $InputFile
#
# Prepare output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile “Host,Exist”;
   foreach($Line in $Hosts){
#
# Fetching Server from domain
#
      $HostName = $Line.Host
      $ADHost = Get-ADComputer $HostName
#
# If Server doesnt exist
#
      if($ADHost -eq $null){
         write-host "Host "$Hostname" doesnt exist in AD"
         Add-Content $OutputFile "$Hostname,No”;
      }
#
# If Server exist
#
      Else{
         write-host "Host "$Hostname" exist in AD"
         Add-Content $OutputFile "$Hostname,Yes”;
      }
      $ADHost = $null
   }