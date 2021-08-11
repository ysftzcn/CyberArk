# CyberArk üzerinde Suspended olan hesapları açmak için kullanılır. psPAS module ihtiyac vardir.
# Install-Module -Name psPAS -Scope CurrentUser
# Yusuf TEZCAN

# Check psPAS module

$module = Get-InstalledModule | Where-Object {$_.Name -eq "psPAS"}
 
 if ($module.Name -eq "psPAS"){
        
        Write-Host "psPAS module is already installed" -ForegroundColor DarkRed -BackgroundColor White
 }
 else {
        Write-Warning "psPAS module not installed"
        Write-Host "psPAS module will install automatically ..."
        Install-Module -Name psPAS -Scope CurrentUser -Force

 }

# CyberArk Proses
$cred = Get-Credential

# Open a new session on CyberArk PVWA
New-PASSession -Credential $cred -BaseURI {CyberArk PVWA URL} -type LDAP

$username = Read-Host "Kullanici Adi : xxxxxxx "

$user = Get-PASUser -Search $username

#Account ID for unlock process 
Unblock-PASUser -id $user.id
Write-Host $user.username "is unlocked" -ForegroundColor DarkRed -BackgroundColor White

#Close active CyberArk Session
Close-PASSession
