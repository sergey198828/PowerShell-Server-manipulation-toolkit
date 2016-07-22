#requires -version 3
#
#  .SYNOPSIS
#
#  AD-CheckUserExist [-InputFile="ScriptDirectory\users.csv"] [-OutputFile="ScriptDirectory\ad-users.csv"]
#
#  .DESCRIPTION
#
#  PowerShell script based on input CSV file generates output CSV file with additional field which identifies if user is exist in AD
#
#  CSV File format: User
#
#  .EXAMPLE
#
#  1. Parse ScriptDirectory\users.csv file and generate ScriptDirectory\ad-users.csv file.
#
#     AD-CheckUserExist.ps1
#
#  2. Parse C:\inputusers.csv file and generate C:\outputusers.csv file.
#
#     AD-CheckUserExist.ps1 -InputFile "C:\inputusers.csv" -OutputFile "C:\outputusers.csv"
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
   [string]$InputFile=$PSScriptRoot+"\users.csv",
#
#  Output file
#
   [Parameter(Mandatory=$False)]
   [string]$OutputFile=$PSScriptRoot+"\ad-users.csv"
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
   $Users = import-csv $InputFile
#
# Prepare output file
#
   write-host "Writing file "$OutputFile
   Add-Content $OutputFile “User,Exist”;
   foreach($Line in $Users){
#
# Fetching User from domain
#
      $UserName = $Line.User
      $ADUser = Get-ADUser $UserName
#
# If User doesnt exist
#
      if($ADUser -eq $null){
         write-host "User "$UserName" doesnt exist in AD"
         Add-Content $OutputFile "$UserName,No”;
      }
#
# If User exist
#
      Else{
         write-host "User "$UserName" exists in AD"
         Add-Content $OutputFile "$UserName,Yes”;
      }
      $ADUser = $null
   }