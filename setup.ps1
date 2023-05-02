# General logic
$choices = '&Yes', '&No';

function Install-Software {
    param (
        [string[]]$softwareList,
        [string]$softwareType
    )

    $decision = $Host.UI.PromptForChoice("Install $softwareType", $null, $choices, 1);

    if ($decision -eq 0) {

        $totalPrograms = $softwareList.Length;
        $currentProgram = 0;

        foreach ($program in $softwareList) {
            $programName = $program.Split(".")[-1];
            $percentComplete = ($currentProgram / $totalPrograms) * 100;
            $listPlacement = $currentProgram + 1;
            Write-Progress -Activity "Installing $softwareType" -Status "$programName [$percentComplete%][$listPlacement of $totalPrograms]" -PercentComplete $percentComplete;
            Invoke-Expression "winget install -e --id $program" > $null;
            $currentProgram++;
        }

        Write-Progress -Activity "Installing $softwareType" -Status "Done" -Completed;
        return 1
    }

    Write-Host "Not installed $softwareType";
    return 0
}
# Install programs

$GeneralSoftware = "7zip.7zip", "Mozilla.Firefox";
$MediaSoftware = "Spotify.Spotify", "Spicetify.Spicetify", "Discord.Discord", "MPC-BE.MPC-BE", "Valve.Steam";
$DevSoftware = "Microsoft.VisualStudioCode", "Microsoft.WindowsTerminal", "Git.Git", "OpenJS.NodeJS";

$installedGeneral = Install-Software $GeneralSoftware "General software";
$installedMedia = Install-Software $MediaSoftware "Media";
$installedDev = Install-Software $DevSoftware "Developer software";


# Setup commands

if ($installedMedia -eq 1) {
    spicetify config > $null;

    spicetify config extensions bookmark.js > $null;
    spicetify config extensions fullAppDisplay.js > $null;
    spicetify config extensions loopyLoop.js > $null;
    spicetify config extensions shuffle+.js > $null;

    spicetify config custom_apps new-releases > $null;
    spicetify config custom_apps lyrics-plus > $null;

    spicetify backup apply > $null;

}
