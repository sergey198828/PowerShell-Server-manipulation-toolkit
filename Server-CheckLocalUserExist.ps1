#requires -version 3
#
#  .SYNOPSIS
#
#  Server-CheckLocalUserExist -User [-InputFile="ScriptDirectory\hosts.csv"] [-OutputFile="ScriptDirectory\ad-hosts.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script based on input CSV file generates output CSV file with additional field which identifies if local user exist on the server
#
#  CSV File format: Host
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\hosts.csv file and generate ScriptDirectory\ad-hosts.csv file.
#
#     Server-CheckLocalUserExist.ps1 -User "W1ndows`$upport"
#
#  2. Parse C:\inputhosts.csv file and generate C:\outputhosts.csv file.
#
#     Server-CheckLocalUserExist.ps1 -User "W1ndows`$upport" -InputFile "C:\inputhosts.csv" -OutputFile "C:\outputhosts.csv"
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Local account
#
   [Parameter(Mandatory=$True)]
   [string]$User,
#
#  Input file
#
   [Parameter(Mandatory=$False)]
   [string]$InputFile=$PSScriptRoot+"\hosts.csv",
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\server-localuserexist.csv"
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
#
# Prompting for Username
#
   Write-host "Please enter your username"
   $login = read-host
#
# Prompting for Password
#
   read-host -assecurestring | convertfrom-securestring | out-file C:\Scripts\securestring.txt
   $password = cat C:\Scripts\securestring.txt | convertto-securestring
#
# Constructing credentials object
#
   $credentials = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $login, $password
#
# Looping each server in list
#
   foreach($Line in $Hosts){
#
# Fetching local accounts from server
#
      $HostName = $Line.Host
      $accounts = Get-WmiObject -Class Win32_UserAccount -ComputerName $HostName -Credential $credentials -Filter "LocalAccount='$True'" | Select Name
#
# Looking for desired account
#
      $Exist = $false
      foreach($account in $accounts){
        if($account.Name -eq $User){
          $Exist = $True
        }
      }
#
# If user exist
#
      if($Exist){
         write-host "$User account found on $HostName"
         Add-Content $OutputFile "$Hostname,Yes”;
      }
#
# If user does not exist
#
      Else{
         write-host "$User account not found on $HostName"
         Add-Content $OutputFile "$Hostname,No”;
      }
      $accounts = $null
   }