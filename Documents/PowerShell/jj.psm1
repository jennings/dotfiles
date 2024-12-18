$script:CompletionJobs = @()

function Invoke-StartJJCompletion {
    if (!(Get-Command jj -ErrorAction SilentlyContinue)) {
        $script:CompletionJobs = $null
        return
    }
    if ($null -eq $script:CompletionJobs -or $script:CompletionJobs.Count -gt 0) {
        Write-Warning "jj completion jobs already ran"
        return
    }

    # Static completion
    $script:CompletionJobs += Start-ThreadJob -Name JJCompletionStatic -ScriptBlock {
        jj util completion power-shell | Out-String
    }

    # Dynamic completion - Runs in a regular job so the COMPLETE env var isn't
    # observed by the interactive session
    $script:CompletionJobs += Start-Job -Name JJCompletionDynamic -ScriptBlock {
        $prev = $env:COMPLETE
        $env:COMPLETE = "powershell"
        jj | Out-String
        $env:COMPLETE = $prev
    }
}

function Invoke-EnsureJJCompletion {
    if ($null -eq $script:CompletionJobs -or $script:CompletionJobs.Count -eq 0) { return }
    Receive-Job -Job $script:CompletionJobs | % {
        $_ | Invoke-Expression
    }
    if (
        $script:CompletionJobs[0].State -eq "Completed" -and
        $script:CompletionJobs[0].HasMoreData -eq $false -and
        $script:CompletionJobs[1].State -eq "Completed" -and
        $script:CompletionJobs[1].HasMoreData -eq $false
    ) {
        $script:CompletionJobs | Remove-Job
        $script:CompletionJobs = $null
    }
}

function Invoke-JJCompletion {
  if (Get-Command jj -ErrorAction SilentlyContinue) {
      # Static completion
      jj util completion power-shell | Out-String | Invoke-Expression

      # Dynamic completion
      $prev = $env:COMPLETE
      $env:COMPLETE = "powershell"
      jj | Out-String | Invoke-Expression
      $env:COMPLETE = $prev
  }
}

$jjconfig = "$PSScriptRoot/jjconfig.toml"

function Get-JJPrompt {
    param($Repository)
    jj -R $Repository --ignore-working-copy --config-file $jjconfig log -n 1 -r "@" -T format_prompt --no-graph --color always
}
