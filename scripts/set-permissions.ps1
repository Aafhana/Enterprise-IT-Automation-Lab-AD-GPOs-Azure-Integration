$folders = @(\"C:\\Shared\\HR\", \"C:\\Shared\\IT\")
foreach ($folder in $folders) {
    $acl = Get-Acl $folder
    $permission = \"DOMAIN\\HR-Group\",\"Modify\",\"ContainerInherit,ObjectInherit\",\"None\",\"Allow\"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.AddAccessRule($accessRule)
    Set-Acl $folder $acl
}
