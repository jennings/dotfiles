
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

function JJPrompt {
    jj --ignore-working-copy log -l 1 -r "@" -T 'concat(" [", separate(" ", change_id.shortest(3), render_bookmarks(self), if(empty,"(empty)",""), if(conflict,"(conflict)","")), "]")' --no-graph --color always 2> $null
}

Measure-Command {
    ImportIf-Module -Name Posh-Git -PostImport {
        $global:GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Gold'
        $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '$(JJPrompt)`n'
    } | Out-Default
} | % { "Imported Posh-Git in {0:N0}ms" -f $_.TotalMilliseconds }

Measure-Command {
    import-module (Join-Path $PSScriptRoot "Toolkit.psm1") -DisableNameChecking
} | % { "Imported Toolkit.psm1 in {0:N0}ms" -f $_.TotalMilliseconds }

function dotfiles {
    jj -R $HOME/dotfiles $Args
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

$script:DefaultPrompt = Get-Content Function:\Prompt

Function Reset-Prompt {
    Set-Content Function:\Prompt $script:DefaultPrompt
}

$env:EDITOR = "nvim"

# Set PAGER so delta uses it
$env:PAGER='"C:\Program Files\Git\usr\bin\less.exe" -FRX'

$env:JJ_CONFIG = "${env:USERPROFILE}\.config\jj\"
$env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"

# I never use `sl` and it conflicts with Sapling
Remove-Alias sl -Force

function script:WatchmanMake {
    python (Get-Command -CommandType Application watchman-make)[0].Source @Args
}
Set-Alias watchman-make script:WatchmanMake

New-Alias paste Get-Clipboard
New-Alias docker podman
New-Alias tf Invoke-TerraformWithAutomaticOpen
