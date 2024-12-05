
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

# Press Ctrl+. to insert filenames into the current command
Set-PSReadLineKeyHandler -Key "Ctrl+." -ScriptBlock {
    $results = fzf -m
    if ($LASTEXITCODE -eq 0) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($results -join " ") + " ")
    }
}

<#
.Description
Press Ctrl+/ to run a command written as the last token in the buffer, pass
it into fzf, and replace the token with the result.

.Example

    PS> jj split "jj diff --name-only"<CTRL+/>

Opens fzf to pick files, then replaces the string in the buffer with the selection:

    PS> jj split a.txt b.txt c.txt
#>
Set-PSReadLineKeyHandler -Key "Ctrl+/" -ScriptBlock {
    $ast = $null
    $tokens = $null
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)
    $commandToken  = $tokens[-2]
    $command = if ($commandToken.Value) { $commandToken.Value } else { $commandToken.Text }
    $results = (Invoke-Expression $command) | fzf -m
    if ($LASTEXITCODE -eq 0) {
        $offset = $commandToken.Extent.StartOffset
        $length = $commandToken.Extent.EndOffset - $offset
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($offset, $length, ($results -join " ") + " ")
    }
}

$env:JJ_CONFIG = "${env:USERPROFILE}\.config\jj\"
$env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"

New-Alias paste Get-Clipboard
New-Alias docker podman
