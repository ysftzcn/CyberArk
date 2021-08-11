# CyberArk uzerindeki hesaplarda tanımlı olan RemoteAddress tanımlarını değiştirmek için kullanılır. psPAS module ihtiyac vardir.
# Install-Module -Name psPAS -Scope CurrentUser
# Yusuf TEZCAN
# Domino's Security

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

# CyberArk Login
$cred = Get-Credential

# LDAP ile login islemini gerceklestiriyoruz.
New-PASSession -Credential $cred -BaseURI {CyberArk URL} -type LDAP

# Arama yapılacak grup yada hesap adı girilir.
$search = Read-Host "Aranacak kelimeyi giriniz."

# Toplu degisiklik öncesi arama sonucunu csv kaydedip, kontrol ediyoruz. 
$Accounts = Get-PASAccount -search $search | Export-Csv -Path '{Herhangi bir dosya yolu}\PASAccount.csv'

# Herhangi bir sorun yok ise, ilgili csv dosyasini import edip, hesap id lerine göre adresleri ekliyoruz.

function PAS-UPdateAccount {
    
    $file = Import-Csv -Path '{CSV dosyanın yolu}\PASAccount.csv'

        foreach ($a in $file){
    
        $actions = @{"op"="Replace";"path"="/remoteMachinesAccess/remoteMachines";"value"="{Sunucu Adı - ; ile birden fazla girebilirsiniz}"}

       # $actions += @{"op"="Replace";"path"= "/remoteMachinesAccess/accessRestrictedToRemoteMachines";"value"="true"}

        Set-PASAccount -AccountID $a.id -operations $actions

}}

#Close active CyberArk Session
Close-PASSession
