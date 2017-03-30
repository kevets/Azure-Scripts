#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#          Connect to office 365 and exchange online using a script
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Use at your own risk 

$Loop = $true
While ($Loop)
{
write-host 
write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write-host       Connect to Office 365 and Exchange online    -foregroundcolor green
write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write-host 
write-host '    Connect PowerShell session to Office 365 and Exchange on-line' -ForegroundColor green
write-host '    ---------------------------------------------------------------' -ForegroundColor green
write-host '1)  Login using your Office365 Administrator credentials' -ForegroundColor Yellow
write-host 'SC)  Login to Office365 Security and Compliance powershell' -ForegroundColor Yellow
write-host "XG)  Export group reports to current folder" -ForegroundColor green
write-host "XU)  Export user details to current folder" -ForegroundColor green
write-host "XA)  Export online archive reports to current folder" -ForegroundColor green
write-host "XP)  Export phishing/filter policy report to current folder" -ForegroundColor green
write-host "XM)  Export mailbox reports to current folder" -ForegroundColor green
write-host "EA)  Enable Online archive for all mailboxes" -ForegroundColor green
write-host "EAU)  Enable auditing for all mailboxes" -ForegroundColor green
write-host "DA)  Disable Online archive for all mailboxes" -ForegroundColor red
write-host "DAU)  Disable auditing for all mailboxes" -ForegroundColor red
write-host "EJ)  Enable Junk filtering for all mailboxes" -ForegroundColor green
write-host "DJ)  Disable Junk filtering for all mailboxes" -ForegroundColor green
write-host "L)  Display licenses, domains" -ForegroundColor green
write-host 'AX)  Admin Export last 48 hours of administrator activity to current folder' -ForegroundColor Yellow
write-host
write-host "2)  Disconnect from the Remote PowerShell session" -ForegroundColor Red
write-host
write-host "3)  Exit to Powershell" -ForegroundColor Red
write-host

$opt = Read-Host "Select an option [1-3]"
write-host $opt
switch ($opt) 

{


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Step -00 connect PowerShell session to Office 365 and Exchange online
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



1{

#  administrative user credentials 

$user = $null

# Display authentication pop out windows

$cred = Get-Credential -Credential $user

#——– Import office 365 Cmdlets  ———–

Import-Module MSOnline

#———— Establish an Remote PowerShell Session to office 365 ———————

Connect-MsolService -Credential $cred

#———— Establish an Remote PowerShell Session to Exchange Online ———————

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection


#———— This command that we use for implicit remoting feature of PowerShell 2.0 ———————


Import-PSSession $session

#———— Indication ———————
write-host 
if ($lastexitcode -eq 1)
{
	
	
	
	write-host "The command Failed :-(" -ForegroundColor red
	write-host "Try to connect again and check your credentials" -ForegroundColor red
	
	
}
else

{
	
	clear-host

	write-host
    write-host  -ForegroundColor green	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
                                                     
    write-host  -ForegroundColor white  	"The command complete successfully !" 
	write-host  -ForegroundColor white  	"You are now connected to office 365 and Exchnage online"
	write-host  -ForegroundColor white  	"You can chose the option “3” to leave the menu screen and start managing: "
	write-host  -ForegroundColor white  	"Office 365 + Exchange online environments"
	write-host  -ForegroundColor white	    --------------------------------------------------------------------   
	write-host  -ForegroundColor white  	"Test the connection to Exchange online by using the command  Get-mailbox"
	write-host  -ForegroundColor white  	"Test the connection to Office 365 by using the command  Get-Msoluser".
	
	write-host  -ForegroundColor green	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                         
	write-host
    write-host
	
	
	
	write-host  -ForegroundColor Yellow
	write-host  -ForegroundColor Yellow
}

#———— End of Indication ———————

}





 
 
#+++++++++++++++++++
#  Finish  
##++++++++++++++++++
 
SC{

# Connect to Security and Compliance Center Powershell
# Get login credentials 
$UserCredential = Get-Credential 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $UserCredential -Authentication Basic -AllowRedirection 
Import-PSSession $Session -AllowClobber -DisableNameChecking 
$Host.UI.RawUI.WindowTitle = $UserCredential.UserName + " (Office 365 Security & Compliance Center)" 
} 
 
 
XG{

#  Report stuff goes here

#Constant Variables 
$OutputFile = "DistributionGroupMembers.csv"   #The CSV Output file that is created, change for your purposes 
$arrDLMembers = @{} 
     
 
#Prepare Output file with headers 
Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Member DisplayName, Member Email, Member Type" -Encoding UTF8 
 
#Get all Distribution Groups from Office 365 
$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited 
 
#Iterate through all groups, one at a time     
Foreach ($objDistributionGroup in $objDistributionGroups) 
{     
	
	write-host "Processing $($objDistributionGroup.DisplayName)..." 
 
	#Get members of this group 
	$objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress) 
	 
	write-host "Found $($objDGMembers.Count) members..." 
	 
	#Iterate through each member 
	Foreach ($objMember in $objDGMembers) 
	{ 
		Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)" -Encoding UTF8 -append 
		write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),$($objMember.RecipientType)"
	} 
} 



}

 
#+++++++++++++++++++
#  Finish  
##++++++++++++++++++
 
EA{

#  Report stuff goes here
Get-Mailbox -Filter {ArchiveStatus -Eq "None" -AND RecipientTypeDetails -eq "UserMailbox"} | Enable-Mailbox -Archive
}
EAU{

#  Enable all mailboxes for auditing!!!
Get-Mailbox -Filter {RecipientTypeDetails -eq "UserMailbox"} | Set-Mailbox -Identity -AuditEnabled $true
}
DA{
Echo "ARE YOU SURE?"
ECHO "DISABLE ARCHIVE?"
echo  "Disable archiving can go here. This does nothing."
PAUSE
}
DAU{

#  Enable all mailboxes for auditing!!!
Get-Mailbox -Filter {RecipientTypeDetails -eq "UserMailbox"} | Set-Mailbox -Identity -AuditEnabled $false
}


EJ{

#  Enables junk filtering setting on all
get-mailbox | Set-MailboxJunkEmailConfiguration -enabled $true
}
DJ{

#  Disables junk filtering - to use where other filter is in play
get-mailbox | Set-MailboxJunkEmailConfiguration -enabled $false
}

 
#+++++++++++++++++++
#  Finish  
##++++++++++++++++++
 
XU{
#  Report stuff goes here
Get-MsolUser -All |Where {$_.IsLicensed -eq $true } | select displayname, signinname, title, office, PhoneNumber, MobilePhone, Fax, @{n="License Type";e={$_.Licenses.AccountSKUid}}, @{Name="PrimaryEmailAddress";Expression={$_.ProxyAddresses }}| sort-object signinname | export-csv .\User_Detail_Export.csv -notypeinfo

#exit

}

XA{
#  Report stuff goes here
get-mailbox |Get-MailboxStatistics -archive|select displayname, itemcount, totalitemsize,DatabaseProhibitSendQuota | export-csv .\Archive_Size.csv -notypeinfo
#exit

}

XP{
#  Report stuff goes here
Get-PhishFilterPolicy –SpoofAllowBlockList –Detailed | Export-CSV .\DetailedSpoofingSenders.csv
#exit

}

XM{
#  Report stuff goes here
get-mailbox |Get-MailboxStatistics |select displayname, itemcount, totalitemsize | export-csv .\Mailbox_Size.csv -notypeinfo
#exit

}


L{

# Show license, domain info
get-msolaccountsku | export-csv .\OrgLicenseSKUs.csv -notypeinfo
Get-MsolDomain | export-csv .\OrgDomainList.csv -notypeinfo
.\get-mailboxlocations.ps1 | export-csv .\OrgMboxLocale.csv -notypeinfo
}

AX{

# Admin export
Search-AdminAuditLog -StartDate (Get-Date).AddHours(-48) -EndDate (Get-Date).AddHours(24) | export-csv .\Admin_Export.csv -notypeinfo

}

 
#+++++++++++++++++++
#  Finish  
##++++++++++++++++++

 
2{

##########################################
# Disconnect PowerShell session  
##########################################


Get-PSsession | Remove-PSsession

#Function Disconnect-ExchangeOnline {Get-PSSession | Where-Object {$_.ConfigurationName -eq "Microsoft.Exchange"} | Remove-PSSession}
#Disconnect-ExchangeOnline -confirm



#———— Indication ———————
write-host 
if ($lastexitcode -eq 1)
{
	
	
	write-host "The command Failed :-(" -ForegroundColor red
	write-host "Try to connect again and check your credentials" -ForegroundColor red
	
	
}
else

{
	write-host "The command complete successfully !" -ForegroundColor Yellow
	write-host "The remote PowerShell session to Exchange online was disconnected" -ForegroundColor Yellow
	
}

#———— End of Indication ———————



}

3{

##########################################
# Exit 
##########################################


$Loop = $true

exit

}

}


}
