function ImportIf-Module {
    param(
        $Name,
        [scriptblock]$PostImport
    )
    if (Get-Module $Name -ListAvailable -ErrorAction SilentlyContinue) {
        Import-Module $Name
        if ($PostImport) {
            & $PostImport
        }
    }
}

ImportIf-Module -Name Posh-Git -PostImport {
    $global:GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Gold'
    $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
}
ImportIf-Module -Name ZLocation
import-module (Join-Path $PSScriptRoot "Toolkit.psm1") -DisableNameChecking

function dotfiles {
    git --git-dir=${env:DOTFILES_REPO} --work-tree=$HOME $Args
}

$env:JJ_CONFIG = "${env:USERPROFILE}\.config\jj\"
$env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"

New-Alias paste Get-Clipboard
New-Alias docker podman
