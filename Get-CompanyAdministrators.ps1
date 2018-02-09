# Modified from get administrators list located at GCITS.com#
# https://gcits.com/knowledge-base/get-list-every-customers-office-365-administrators-via-powershell-delegated-administration/
cls
 
$Cred = get-credential
 
#This script is looking for unlicensed Company Administrators. Though you can update the role here to look for another role type.
 
$RoleName = "Company Administrator"
 
Connect-MSOLService -Credential $Cred
 
Import-Module MSOnline
 
$Customers = Get-MsolPartnerContract -All
 
$msolUserResults = @()
 
# This is the path of the exported CSV. You'll need to create a C:\temp folder. You can change this, though you'll need to update the next script with the new path.
 
$msolUserCsv = "C:\temp\CSPAdminUserList.csv"
 
 
ForEach ($Customer in $Customers) {
 
    Write-Host "----------------------------------------------------------"
    Write-Host "Getting Company Admins for $($Customer.Name)"
    Write-Host " "
 
 
    $CompanyAdminRole = Get-MsolRole | Where-Object{$_.Name -match $RoleName}
    $RoleID = $CompanyAdminRole.ObjectID
    $Admins = Get-MsolRoleMember -TenantId $Customer.TenantId -RoleObjectId $RoleID
 
    foreach ($Admin in $Admins){
         
        if($Admin.EmailAddress -ne $null){
 
            $MsolUserDetails = Get-MsolUser -UserPrincipalName $Admin.EmailAddress -TenantId $Customer.TenantId

                $userProperties = @{
 
                    TenantId = $Customer.TenantID
                    CompanyName = $Customer.Name
                    PrimaryDomain = $Customer.DefaultDomainName
                    DisplayName = $Admin.DisplayName
                    EmailAddress = $Admin.EmailAddress
                    IsLicensed = $MsolUserDetails.IsLicensed
                    BlockCredential = $MsolUserDetails.BlockCredential
                    MobilePhone = $MsolUserDetails.MobilePhone
                    AlternateEmailAddresses = $MsolUserDetails.AlternateEmailAddresses
                    AlternateMobilePhones = $MsolUserDetails.AlternateMobilePhones
                } 
                $msolUserResults += New-Object psobject -Property $userProperties
        }
    }
 
    Write-Host " "
 
}
 
$msolUserResults | Select-Object TenantId,CompanyName,PrimaryDomain,DisplayName,EmailAddress,IsLicensed,BlockCredential,MobilePhone,@{Name='RecoveryEmail';Expression={[string]::join(";",($_.AlternateEmailAddresses))}},@{Name='RecoveryPhone';Expression={[string]::join(";",($_.AlternateMobilePhones))}} | Export-Csv -notypeinformation -Path $msolUserCsv
 
Write-Host "Export Complete"