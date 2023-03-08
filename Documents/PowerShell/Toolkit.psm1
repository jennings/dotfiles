New-Alias seq Get-Sequence
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

New-Alias xargs Invoke-Xargs
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

New-Alias env Invoke-EnvironmentChooser
function Invoke-EnvironmentChooser {
    $files = (dir ~/env).FullName | fzf -m
    foreach ($line in (Get-Content $files | op inject -f)) {
        if ($line[0] -in @($null, "#", " ", "`t")) { continue }
        $parts = $line -split "=",2
        Set-Content Env:\$($parts[0]) $parts[1]
        Write-Host "Set environment variable: $($parts[0])"
    }
}

New-Alias terraform Invoke-TerraformWithAutomaticOpen
function Invoke-TerraformWithAutomaticOpen {
    # .exe to avoid the alias below
    terraform.exe $Args | foreach-object {
        if ($_ -like "https://app.terraform.io/app/*/runs/run-*") {
            $esc = [char]0x1B
            $url = if ($_ -match "(.*)$esc") {
                $Matches[1]
            } else {
                $_
            }
            Start-Process $url
        }
        $_
    }
}

Add-Type @'
    using System;
    using System.Runtime.InteropServices;
    public class WinAp {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    }
'@

function Invoke-ForegroundWindowChanges {
    $prev = $null
    while ($true) {
        $h = [WinAp]::GetForegroundWindow()
        if ($h -ne $prev) {
            $p = Get-Process | ? { $_.MainWindowHandle -eq $h }
            "{0:u} foreground window: {1}" -f (Get-Date), (@($p.Name) -join ",")
            $prev = $h
        }
        Start-Sleep -milliseconds 10
    }
}

New-Alias fg Invoke-ForegroundWindowChanges

function Invoke-GatherWindows {
    param($ProcessName = $null)
    if ($ProcessName -eq $null) {
        return
    }

    $hs = (Get-Process -Name $ProcessName | ? MainWindowTitle).MainWindowHandle
    if ($hs -eq $null) { return }

    $offset = 0
    foreach ($h in $hs) {
        [WinAp]::MoveWindow($h, $offset, $offset, 600, 400, $true)
        [WinAp]::SetForegroundWindow($h)
        $offset += 25
    }
}

function Login-PodmanAcr {
    param($Name = (Read-Host -Prompt "Registry name"))
    $json = az acr login --name $Name --expose-token | ConvertFrom-Json
    podman login $json.loginServer -u 00000000-0000-0000-0000-000000000000 -p $json.accessToken
}

Export-ModuleMember `
    -Function * `
    -Alias *
