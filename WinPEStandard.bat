@ECHO Off

SET divider=######################################################################


ECHO %divider%
ECHO #-- Setting Variable for Drive Letter
ECHO %divider%
SET /P DriveLetter=Please Set a Drive Letter. LETTER ONLY!:
IF "%DriveLetter%"=="" GOTO Error
ECHO #-- Drive letter will be %DriveLetter%


ECHO %divider%
ECHO #-- Creating Directory
ECHO %divider%
IF exist %DriveLetter%:\WinPE_amd64\ (
	ECHO #-- Folder already exists
) else (
	ECHO #-- Folder does not exist, creating
	Copype amd64 %DriveLetter%:\WinPE_amd64
)


ECHO %divider%
ECHO #-- Adding PowerShell capabilities
ECHO %divider%

ECHO #-- Mounting Image
Dism /Mount-Image /ImageFile:"%DriveLetter%:\WinPE_amd64\media\sources\boot.wim" /Index:1 /MountDir:"%DriveLetter%:\WinPE_amd64\mount"

Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-StorageWMI_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-DismCmdlets_en-us.cab"
Dism /Add-Package /Image:"%DriveLetter%:WinPE_amd64/mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-EnhancedStorage.cab"
Dism /Add-package /image:"%DriveLetter%:WinPE_amd64/mount" /packagepath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-SecureStartup.cab"

ECHO %divider%
ECHO #-- Customizing Image
ECHO %divider%

ECHO #-- Adding BDE capabilities
xcopy "C:\Windows\System32\en-us\manage-bde.exe.mui" "%DriveLetter%:\winpe_amd64\mount\Windows\System32\en-us\" /s /e

ECHO #-- Other Customizations
SET othercust=Do you have any other Customizations to make? (Y/N):

IF "%othercust%"=="Y" GOTO OtherCustomizations

:OtherCustomizations
ECHO #-- Please add your other customizations now.
ECHO #-- Once complete, please press any key to continue.
PAUSE

GOTO End

:Error
ECHO %divider%
ECHO #-- !ERROR!
ECHO %divider%
ECHO #-- You did not enter a valid input

:END
#-- Registering Manage-BDE
cd "%DriveLetter%:\winpe_amd64\mount\Windows\System32\en-us
manage-bde.exe

ECHO %divider%
ECHO #-- Committing and cleaning up
ECHO %divider%

Pause