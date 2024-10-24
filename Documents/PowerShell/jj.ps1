New-Alias jjj C:\src\github.com\martinvonz\jj\target\debug\jj.exe

function script:jjCompleter {
    param($WordToComplete, $CommandAst, $CursorPosition)
    $command = $CommandAst.Find({ $Args[0].GetType().Name -eq "CommandAst" }, $true)
    
    # Find the repo, if not cwd
    $next = $false
    $repo = @()
    foreach ($node in $command.CommandElements) {
        if ($next) {
            $repo = @("-R", $node.Value)
            break
        }
        if ($node.GetType().Name -eq "CommandParameterAst" -and $node.ParameterName -ceq "R") {
            $next = $true
        }
    }
    # all-bookmark-names = bookmark list --all -T ...
    jj $repo --ignore-working-copy all-bookmark-names `
        | where-object { $_.StartsWith($wordToComplete, [StringComparison]::OrdinalIgnoreCase) }
}

# jjj util completion --powershell | Out-String | Invoke-Expression
Register-ArgumentCompleter -Native -CommandName jj -ScriptBlock {
    jjCompleter -WordToComplete $Args[0] -CommandAst $Args[1] -CursorPosition $Args[2]
}

$OriginalWindowTitle = $null

function Reset-WindowTitle {
    $Host.UI.RawUI.WindowTitle = $OriginalWindowTitle
}

function Set-WindowTitle {
    param([scriptblock]$ScriptBlock)
    try {
        # ensure results returned by scriptblock are flattened into a string
        $windowTitleText = "$(& $ScriptBlock)"

        Write-Debug "Setting WindowTitle: $windowTitleText"
        $Host.UI.RawUI.WindowTitle = "$windowTitleText"
    } catch {
        Write-Debug "Error occurred during setting WindowTitle: $windowTitleText"
    }
}

Export-ModuleMember `
    -Alias *
