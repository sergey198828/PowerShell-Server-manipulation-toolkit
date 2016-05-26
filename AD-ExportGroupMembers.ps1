#requires -version 3
#
#  .SYNOPSIS
#
#  AD-ExportGroupMembers.ps1 -group [-folder] [-recurcive]
#
#  .DESCRIPTION
#
#  PowerShell script exports list of users of specified AD group to specified CSV file
#
#  .EXAMPLE
#
#  1. Export specified group members to script directory(default) citrix_administrators.csv
#
#     AD-ExportGroupMembers.ps1 -group "citrix_administrators"
#
#  2. Export specified group members to specified directory citrix_admin.csv
#
#     AD-ExportGroupMembers.ps1 -group "citrix_admin" -folder "C:\Scripts\Output"
#
#  3. Export specified group members to specified directory citrix-admin.csv recurcievely
#
#     AD-ExportGroupMembers.ps1 -group "citrix-admin" -folder "C:\Scripts\Output" -r
#
#_______________________________________________________
#  Start of parameters block
#
[CmdletBinding()]
Param(
#
#  AD group
#
   [Parameter(Mandatory=$True)]
   [string]$group,
#
#  Folder, by default script root
#
   [Parameter(Mandatory=$False)]
   [string]$folder=$PSScriptRoot,
#
#  Recursive flag, false by default
#
   [Parameter(Mandatory=$False)]
   [switch]$recursive
)
#
# End of parameters block
#_______________________________________________________

   Write-Host "Exporting group "$group -ForegroundColor Green
   Write-Host "To file "$folder"\"$group".csv" -ForegroundColor Yellow
   If ($recursive -eq $false) {
      Write-Host "Not recursively" -ForegroundColor Red
      Get-ADGroupMember -identity $group | select * |Export-csv -path $folder"\"$group".csv" -NoTypeInformation
      Write-Host "Complete" -ForegroundColor Cyan
   }
   Else 
   {
      Write-Host "Recursively" -ForegroundColor Red
      Get-ADGroupMember -identity $group -recursive | select * | Export-csv -path $folder"\"$group".csv" -NoTypeInformation
      Write-Host "Complete" -ForegroundColor Cyan
   }

