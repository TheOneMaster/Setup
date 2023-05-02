Install-Module PSMenu

$choices = @("General", "Media", "Admin", "Developer");
Write-Output "Use arrow keys to navigate, spacebar to select, and enter to confirm selection";
$selected = Show-Menu -MenuItems $choices -MultiSelect;

$softwareMap = @{
    general   = @("7zip.7zip", "Mozilla.Firefox");
    media     = @("Spotify.Spotify", "Spicetify.Spicetify", "Discord.Discord", "MPC-BE.MPC-BE", "Valve.Steam", "qBittorrent.qBittorrent");
    developer = @("Microsoft.VisualStudioCode", "Microsoft.WindowsTerminal", "Git.Git", "OpenJS.NodeJS");
    admin     = @("AntibodySoftware.WizTree", "CPUID.HWMonitor", "KDE.KDEConnect", "Nvidia.GeForceExperience", "Guru3D.Afterburner");
}



if (-Not $selected) {

    Write-Output "No programs installed";
    Uninstall-Module PSMenu;
    return 0
}

# List of programs to be installed
$softwareList = @();
foreach ($type in $selected) {
    $currentSoftware = $softwareMap[$type];
    $softwareList += $currentSoftware;
}

# Install each program
$totalPrograms = $softwareList.Count;
for ($index = 0; $index -lt $totalPrograms; $index++) {
    $program = $softwareList[$index];
    $naturalIndex = $index + 1;
    $percentComplete = [Math]::floor(($index / $totalPrograms) * 100)
    $programName = $program.Split(".")[-1];

    Write-Progress -Activity "Installing programs" -Status "$programName [$percentComplete%][$naturalIndex of $totalPrograms]" -PercentComplete $percentComplete;
    # Invoke-Expression "winget install -e --id $program"
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "Installing programs" -Completed

# Config for programs

Write-Output "Configuring installed programs"

if ($softwareList.Contains("Spicetify.Spicetify")) {

    Write-Output "Configuring Spicetify"

    spicetify config > $null;

    spicetify config extensions bookmark.js > $null;
    spicetify config extensions fullAppDisplay.js > $null;
    spicetify config extensions loopyLoop.js > $null;
    spicetify config extensions shuffle+.js > $null;

    spicetify config custom_apps new-releases > $null;
    spicetify config custom_apps lyrics-plus > $null;

    spicetify backup apply > $null;

    Write-Output "Finished configuring spicetify"
}

Write-Output "Finished configuration"

# End script
Uninstall-Module PSMenu
