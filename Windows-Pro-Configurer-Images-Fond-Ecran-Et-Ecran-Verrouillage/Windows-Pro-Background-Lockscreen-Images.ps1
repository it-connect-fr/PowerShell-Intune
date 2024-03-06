<#
.SYNOPSIS
        Définir une image de fond d'écran et une image d'écran de verrouillage via les clés de Registre Windows

.DESCRIPTION
        Sur Windows 10 Pro et Windows 11 Pro, il n'est pas possible de configurer une image de fond d'écran et/ou de verrouillage avec les paramètres natifs Intune.
        La solution de contournement consiste à utiliser des valeurs dans le Registre Windows, comme par GPO Active Directory.
        Les images sont téléchargées en local sur la machine dans "C:\Windows\Web\Wallpaper\"
        Indiquez les URL vers vos images en modifiant ces deux variables : $DesktopImageURL et $LockscreenImageURL.

.PARAMETER
.EXAMPLE  
.INPUTS
.OUTPUTS
	
.NOTES
	NAME:	Windows-Pro-Background-Lockscreen-Images.ps1
	AUTHOR:	Florian Burnel
	EMAIL:	florian.burnel@it-connect.fr
	WWW:	www.it-connect.fr

	VERSION HISTORY:

	1.0 	2024.03.06
		    Initial Version

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