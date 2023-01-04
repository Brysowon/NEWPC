#Sets Execution Policy so the Script Can Run
Set-ExecutionPolicy Unrestricted

# List of built-in apps to remove
$UninstallPackages = @(
    "AD2F1837.HPJumpStarts"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSureShieldAI"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "AD2F1837.HPDesktopSupportUtilities"
    "AD2F1837.HPQuickTouch"
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPSystemInformation"
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.RemoteDesktop"
    "Microsoft.SkypeApp"
    "Microsoft.StorePurchaseApp"
    "Microsoft.Office.Todo.List"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "SpotifyAB.SpotifyMusic"
    "Clipchamp.Clipchamp"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxGameCallableUI"
    "Microsoft.GamingApp"
    "Microsoft.MixedReality.Portal"
    "Microsoft.YourPhone"
    "Microsoft.WindowsCamera"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Click Security Browser"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
    "Dell SupportAssist Remediation"
    "Dell Digital Delivery Services"
    "Dell SupportAssist OS Recovery Plugin for Dell Update"
    "Dell Watchdog Timer"
    "Dell Command | Update for Windows 10"
    "Windows Web Experience Pack"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers `
            | Where-Object {($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier")}

$ProvisionedPackages = Get-AppxProvisionedPackage -Online `
            | Where-Object {($UninstallPackages -contains $_.DisplayName) -or ($_.DisplayName -match "^$HPidentifier")}

$InstalledPrograms = Get-Package | Where-Object {$UninstallPrograms -contains $_.Name}

# Remove appx provisioned packages - AppxProvisionedPackage
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages - AppxPackage
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}
}

#Removes Dellbloat
    Get-AppxPackage "*dell*" | Remove-AppxPackage

#Second method of uninstalling packages for the stuff that commonly slips through
    winget uninstall "Microsoft 365 - en-us"
    winget uninstall "Microsoft 365 - es-es"
    winget uninstall "Microsoft 365 - fr-fr"
    winget uninstall "Office 16 Click-to-Run Extensibility Component"
    winget uninstall "Office 16 Click-to-Run Localization Component"
    winget uninstall "Office 16 Click-to-Run Licensing Component"
    winget uninstall "Dell SupportAssist OS Recovery Plugin for Dell Update"
    winget uninstall "Dell Watchdog Timer"
    winget uninstall "Dell SupportAssist Remediation"

#Installs Chrome, Adobe, 7zip, and Office suite
    winget install 7zip.7zip
    winget install google.chrome
    winget install XPDP273C0XHQH2
    winget install microsoft.office
    winget install notepad++.notepad++

# Install Windows updates
Start-Process -FilePath "C:\Windows\System32\wuauclt.exe" -ArgumentList "/detectnow"

#Prompts for restart
$input = Read-Host "Restart computer now [y/n]"
switch($input){
           y{Restart-computer -Force -Confirm:$false}
           n{exit}
     default{write-warning "Skipping reboot."}
 }
