New-GPO -Name \"MapDrives-HR\" -Comment \"Maps H: drive for HR\" | New-GPLink -Target \"OU=HR,DC=EY,DC=local\"

Set-GPPrefRegistryValue -Name \"MapDrives-HR\" -Context User -Key \"HKCU\\Network\\H\" -ValueName \"RemotePath\" -Type String -Value \"\\\\FileServer\\HR\"
