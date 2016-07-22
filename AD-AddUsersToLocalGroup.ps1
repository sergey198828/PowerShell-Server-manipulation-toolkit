#requires -version 3
#
#  .SYNOPSIS
#
#  AD-AddUsersToLocalGroup [-InputFile="ScriptDirectory\users-groups.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script loops over list of servers and adds domain users to specified local groups. 
#  Run this script from user with Admin credentials on remote computers.
#
#  CSV File format: Computer, Group, User
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\users-groups.csv file and do the nessesary.
#
#     AD-AddUsersToLocalGroup.ps1
#
#  2. Parse C:\inputusers.csv file and add all users to Group1 AD group.
#
#     AD-AddUsersToLocalGroup.ps1 "C:\inputusers.csv" 
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
   [string]$InputFile=$PSScriptRoot+"\users-groups.csv"
)
#
# End of parameters block
#
#_______________________________________________________
#
#  Function adds domain users to local group
#
  function Add-LocalUser{
     Param(
        $computer,
        $group,
        $domain="mars-ad.net",
        $user
     )
     $group=[ADSI]"WinNT://$computer/$group,group"
     $group.Add("WinNT://$domain/$user")
  }

#
#  Reading file
#
  write-host "Reading file "$File
  $File = import-csv $InputFile
#
#  Looping over file
#
  foreach($line in $File){
#
#  Adding user to group
#
     Add-LocalUser -computer $line.Computer -group $line.Group -user $line.User
     write-host $line.User" added to "$line.Group" local group on "$line.Computer
  }