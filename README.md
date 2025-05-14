# Project:Enterprise IT-Automation Lab:AD, GPOs, Azure-Integration

This project simulates a real-world IT infrastructure with domain services, user/group management, file sharing, and patch management using Windows Server environments.

## 🔧 Technologies Used
- Windows Server 2019 (Domain Controller)
- Windows Server 2022 (File Server)
- Windows 10/11 Clients
- PowerShell
- Group Policy Management
- WSUS (Windows Server Update Services)
- VirtualBox or Hyper-V

---

## 🧱 VM Setup

### Domain Controller (Windows Server 2019)
- Install AD DS, DNS
- Promote to Domain Controller (Domain: `EY.local`)
- Set static IP (e.g., `10.0.2.15`)

### File Server (Windows Server 2022)
- Join domain `EY.local`
- Set static IP (e.g., `10.0.2.16`)

### Clients (Windows 10/11)
- Join domain `EY.local`

---

## 📁 File Server Setup

### Create Directories
```powershell
New-Item -Path "C:\Shared\HR" -ItemType Directory
New-Item -Path "C:\Shared\IT" -ItemType Directory
```

### Set NTFS Permissions
```powershell
$acl = Get-Acl "C:\Shared\HR"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("EY\HR","FullControl","Allow")
$acl.AddAccessRule($rule)
Set-Acl "C:\Shared\HR" $acl
```

Repeat for IT folder.

### Create SMB Shares
```powershell
New-SmbShare -Name "HR" -Path "C:\Shared\HR" -FullAccess "EY\HR"
New-SmbShare -Name "IT" -Path "C:\Shared\IT" -FullAccess "EY\IT"
```

### GPO Mapped Drives
- Create a GPO per department to map drives:
- `\FileServer\HR` → `H:`
- `\FileServer\IT` → `I:`

---

## 🔄 User & Group Management (from CSV)
```powershell
Import-Csv .\users.csv | ForEach-Object {
    New-ADUser -Name $_.Name -SamAccountName $_.Username -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -Force) -Enabled $true -Path $_.OU
    Add-ADGroupMember -Identity $_.Group -Members $_.Username
}
```

---

## 🛠️ Patch Management (WSUS)

### On Domain Controller:
1. Install WSUS
2. Configure Products, Classifications, and Sync Schedule
3. Create OUs: `WSUS-Test`, `WSUS-Pilot`, `WSUS-Production`
4. Link GPOs to apply WSUS server IP to client VMs

### Testing & Rollback
- Take VM snapshots before patching
- Approve updates for Test OU
- Monitor success, then roll out to Pilot and Production

---

## 🧪 PowerShell Automation Samples
### Join Domain
```powershell
Add-Computer -DomainName "EY.local" -Credential EY\Administrator -Restart
```

### Create Organizational Units
```powershell
New-ADOrganizationalUnit -Name "HR" -Path "DC=EY,DC=local"
New-ADOrganizationalUnit -Name "IT" -Path "DC=EY,DC=local"
```

---




