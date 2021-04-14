function Get-Sequence {
    if ($Args.Count -ge 2) {
        $start = $Args[0]
        $end = $Args[1]
    } elseif ($Args.Count -eq 1) {
        $start = 1
        $end = $Args[0]
    }
    [System.Linq.Enumerable]::Range($start, $end - $start + 1)
}

New-Alias seq Get-Sequence

function Invoke-Xargs {
    begin { $items = @() }
    process { $items += $_ }
    end {
        $emitted = $false
        $cmdline = foreach ($arg in $Args) {
            if ($arg -eq "[]") {
                $emitted = $true
                $items
            } else {
                $arg
            }
        }
        if (-not $emitted) {
            $cmdline += $items
        }

        $cmd = $cmdline[0]
        $rest = $cmdline[1..($cmdline.Count - 1)]
        # Start-Process -FilePath $cmd -ArgumentList $rest -Wait
        & $cmd $rest
    }
}

New-Alias xargs Invoke-Xargs

Export-ModuleMember `
    -Function Get-Sequence, Invoke-Xargs `
    -Alias seq, xargs
