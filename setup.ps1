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
            $currentProgram++;
            $programName = $program.Split(" ")[-1].Split(".")[-1];
            $percentComplete = ($currentProgram / $totalPrograms) * 100;
            Write-Progress -Activity "Installing $softwareType" -Status "$programName [$percentComplete%]" -PercentComplete $percentComplete;
            Invoke-Expression $program > $null;
        }

        Write-Progress -Activity "Installing $softwareType" -Status "Done" -Completed;
        return 1
    }

    Write-Host "Not installed $softwareType";
    return 0
}
# Install programs

$GeneralSoftware = "winget install -e --id 7zip.7zip",
"winget install -e --id Mozilla.Firefox";

$MediaSoftware = "winget install -e --id Spotify.Spotify",
"winget install -e --id Spicetify.Spicetify",
"winget install -e --id Discord.Discord",
"winget install -e --id MPC-BE.MPC-BE",
"winget install -e --id Valve.Steam";

$DevSoftware = "winget install -e --id Microsoft.VisualStudioCode",
"winget install -e --id Microsoft.WindowsTerminal",
"winget install -e --id Git.Git",
"winget install -e --id OpenJS.NodeJS"

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
