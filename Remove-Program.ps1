<#
.SYNOPSIS
    Remove-Program

.DESCRIPTION
    Programme per Uninstall-Package deinstallieren. Achtung! Muss nicht mit allen Programmen funktionieren. Funktioniert nur, wenn das Programm unter Get-Package gelistet wird.

.NOTES
    Company: IT-Center Engels
    Author: Michael Schönburg
    Website: itc-engels.de
    Phone: +49 2246 92 600 - 0
    Mail: support@itc-engels.de
    Version: v1.1
    Last Edit: 13.10.2023

    This projects code loosely follows the PowerShell Practice and Style guide, as well as Microsofts PowerShell scripting performance considerations.
    Style guide: https://poshcode.gitbook.io/powershell-practice-and-style/
    Performance Considerations: https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations?view=powershell-7.1
#>

#region INITIALIZATION
<# 
    Libraries, Modules, ...
#>



#endregion INITIALIZATION
#region DECLARATIONS
<#
    Declare local variables and global variables
#>



#endregion DECLARATIONS
#region FUNCTIONS
<# 
    Declare Functions
#>



#endregion FUNCTIONS
#region EXECUTION
<# 
    Script entry point
#>

Write-Output "String zur Suche nach Packages (in Anführungszeichen): `"$Programmname`""

Write-Output "Durchsuche Registry..."
$e = (Get-ChildItem -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | ForEach-Object {Get-ItemProperty $_.PSPath}).Where({$_.DisplayName -like "*$Programmname*"})

if ($e) {
    Write-Output "Folgende Hives wurden gefunden:"
    $e | Format-Table DisplayName, InstallLocation, QuietUninstallString, UninstallString, PSPath

    if ($e.QuietUninstallString) {
        Write-Output "QuietUninstallString gefunden. Deinstalliere..."
        Start-Process -Wait -FilePath cmd -ArgumentList "/c $($e.QuietUninstallString)"
    } elseif ($e.UninstallString) {
        Write-Output "UninstallString gefunden. Deinstalliere..."
        Start-Process -Wait -FilePath cmd -ArgumentList "/c $($e.QuietUninstallString)"
    } else {
        Write-Output "Konnte weder QuietUninstallString noch UninstallString finden."
    }
} else {
    Write-Output "Keine Hives gefunden."
}

Write-Output "-----------------------------------------"
Write-Output "Durchsuche Packages..."
$Packages = Get-Package "*$Programmname*"

if ($Packages) {
    Write-Output "Gefundene Packages:"
    $Packages.Name

    if ($Packages) {
        Write-Output "Deinstalliere alle gefunden Packages..."
        $Packages | Uninstall-Package -Force -AllVersions

        Write-Output "Suche nun noch einmal nach denselben Packages. Wenn die Deinstallation erfolgreich war, sollten keine Packages gefunden werden. Gefundene Packages:"
        Get-Package "*$Programmname*"
    }
} else {
    Write-Output "Keine Packages gefunden."
}

#endregion EXECUTION
