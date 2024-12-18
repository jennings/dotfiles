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
