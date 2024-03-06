<#
    .SYNOPSIS Definir une image de fond d'ecran et d'ecran de verrouillage via les cles de Registre Windows
#>
# Fond ecran - URL en ligne et en local
$DesktopImageURL = "https://itconnectintunedemo.blob.core.windows.net/images/IT-Connect_Wallpaper_052020-V2.png"
$DesktopLocalImage = "C:\Windows\Web\Wallpaper\ITC_Wallpaper.png"

# Ecran verrouillage - URL en ligne et en local
$LockscreenImageURL = "https://itconnectintunedemo.blob.core.windows.net/images/IT-Connect_Wallpaper_052020-V2.png"
$LockscreenLocalImage = "C:\Windows\Web\Wallpaper\ITC_Lockscreen.png"

# Registre - Chemin vers la cle (qui doit accueillir les valeurs)
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

# Telecharger les images en local
if(!(Test-Path $DesktopLocalImage)){
    Start-BitsTransfer -Source $DesktopImageURL -Destination $DesktopLocalImage
}

if(!(Test-Path $LockscreenLocalImage)){
    Start-BitsTransfer -Source $LockscreenImageURL -Destination $LockscreenLocalImage
}

# Modifier les cles de Registre (seulement si l'on parvient a acceder aux images en local)
if((Test-Path $DesktopLocalImage) -and (Test-Path $LockscreenLocalImage)){

    # Creer la cle PersonalizationCSP si elle n'existe pas
    if (!(Test-Path $RegKeyPath))
    {
        New-Item -Path $RegKeyPath -Force | Out-Null
    }

    # Registre Windows - Configurer l'image de fond d'ecran (wallpaper)
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImagePath -Value $DesktopLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name DesktopImageUrl -Value $DesktopLocalImage -PropertyType String -Force | Out-Null

    # Registre Windows - Configurer l'image de l'ecran de verrouillage (lockscreen)
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImagePath -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name LockScreenImageUrl -Value $LockscreenLocalImage -PropertyType String -Force | Out-Null

}