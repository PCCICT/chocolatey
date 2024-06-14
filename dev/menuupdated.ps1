# Function to check if the script is running as admin and relaunch if not
function Ensure-RunAsAdmin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Output "Restarting script with administrative privileges..."
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    }
}

# Ensure the script is running as admin
Ensure-RunAsAdmin

# install Chocolatey
function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    Write-Output "Chocolatey installed successfully."
}

# install specific Chocolatey applications
function Install-ChocoApps {
    param (
        [string[]]$apps
    )
    foreach ($app in $apps) {
        choco install $app -y
        if ($?) {
            Write-Output "$app installed successfully."
        } else {
            Write-Output "Failed to install $app."
        }
    }
}

# upgrade all installed Chocolatey applications
function Upgrade-AllChocoApps {
    choco upgrade all -y
    if ($?) {
        Write-Output "All applications upgraded successfully."
    } else {
        Write-Output "Failed to upgrade some applications."
    }
}

# Main menu
function Main-Menu {
    Clear-Host
    Write-Output "PCC's Chocolatey Management Script"
    Write-Output "1. Install Chocolatey"
    Write-Output "2. Install Chocolatey Applications"
    Write-Output "3. Install Lab Applications"
    Write-Output "4. Install Admin Applications"
    Write-Output "5. Install Library Applications"
    Write-Output "6. Upgrade All Installed Applications"
    Write-Output "7. Exit"
    
    $choice = Read-Host "select an option (1-5)"

    switch ($choice) {
        1 {
            Install-Chocolatey
        }
        2 {
            $apps = Read-Host "Enter the applications to install (comma separated) (e.g., git, vscode, googlechrome)"
            $appList = $apps -split ","
            Install-ChocoApps -apps $appList
        }
        3 {
            Write-Output "Installing Lab Applications"
            Install-ChocoApps -apps 'autodesk-fusion360', 'autocad', 'vscode', 'firefox', 'vlc'
        }
        4 {
            Write-Output "Installing Admin Applications"
            Install-ChocoApps -apps 'firefox', 'vlc'
        }
        5 {
            Write-Output "Installing Library Applications"
            Install-ChocoApps -apps 'firefox', 'vlc'
        }
        6 {
            Upgrade-AllChocoApps
        }
        7 {
            Write-Output "Exiting script."
            Exit
        }
        default {
            Write-Output "Invalid selection. Please try again."
        }
    }

    # Pause then menu again
    Write-Output " -------------------------------------------- "
    Write-Output "| Press any key to return to the main menu...|"
    Write-Output " -------------------------------------------- "
    [void][System.Console]::ReadKey($true)
    Main-Menu
}

# Run DMC the main menu
Main-Menu
