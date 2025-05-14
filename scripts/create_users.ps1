# Import Active Directory module
Import-Module ActiveDirectory

# Path to CSV
$csvPath = "C:\Users\afreed\Desktop\users.csv"

# Import CSV data
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    # User properties
    $username = $user.Username
    $password = ConvertTo-SecureString $user.Password -AsPlainText -Force
    $ou = $user.OU
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $displayName = "$firstName $lastName"
    $email = "$username@EY.local"

    # Create user
    New-ADUser -GivenName $firstName `
               -Surname $lastName `
               -SamAccountName $username `
               -UserPrincipalName $email `
               -Name $displayName `
               -DisplayName $displayName `
               -AccountPassword $password `
               -Enabled $true `
               -Path $ou `
               -ChangePasswordAtLogon $true `
               -PasswordNeverExpires $false

    Write-Host "Created user: $username in OU: $ou"
}

Write-Host "All users created successfully!"
