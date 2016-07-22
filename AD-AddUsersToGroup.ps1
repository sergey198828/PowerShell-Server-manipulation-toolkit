#requires -version 3
#
#  .SYNOPSIS
#
#  AD-AddUsersToGroup -Group="GroupName" [-InputFile="ScriptDirectory\users.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script adds to specified group users from specified CSV file.
#  Script will prompt you to provide credentials, password will be saved as securestring in C:\Scripts\securestring.txt file.
#
#  CSV File format: User
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\users.csv file and add all users to Group1 AD group.
#
#     AD-AddUsersToGroup.ps1 "Group1"
#
#  2. Parse C:\inputusers.csv file and add all users to Group1 AD group.
#
#     AD-AddUsersToGroup.ps1 "Group1" "C:\inputusers.csv" 
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  Group Name
#
   [Parameter(Mandatory=$True)]
   [string]$GroupName,
#
#  Input file
#
   [Parameter(Mandatory=$False)]
   [string]$InputFile=$PSScriptRoot+"\users.csv"
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
# Check if Group exist
#
   $Group = Get-ADGroup $GroupName
   if($Group -eq $null){
     write-host "Group doesnt exist, please check and try again" -ForegroundColor DarkYellow
     return
   }
   Else{
     write-host "Group "$GroupName" found" -ForegroundColor Green
   }
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
# Reading input file
#
   write-host "Reading file "$InputFile
   $Users = import-csv $InputFile
#
# Looping each user in file
#
   foreach($Line in $Users){
#
# Fetching User from domain
#
     $UserName = $Line.User
     $User = Get-ADUser $UserName
#
# If User doesnt exist
#
     if($User -eq $null){
       write-host "User "$UserName" doesnt exist in AD"
       continue
     }
#
# If user already belongs to group (Stuck on large groups)
#
     $Exist = $False
     $GroupMembers = Get-ADGroupMember $GroupName
     foreach($member in $GroupMembers){
       if($member.name -eq $UserName){
         Write-Host "User "$UserName" already exist in "$GroupName" group"
         $Exist = $True
         break
       }
     }
#
# Adding user to Group
#
     if(-not $Exist){
       Add-ADGroupMember $Group -Members $User -Credential $credentials
       Write-Host "User "$UserName" added to group "$GroupName
     }

     $User = $null
   }