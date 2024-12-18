if (Get-Command jj -ErrorAction SilentlyContinue) {
    # Static completion
    jj util completion power-shell | Out-String | Invoke-Expression

    # Dynamic completion
    $prev = $env:COMPLETE
    $env:COMPLETE = "powershell"
    jj | Out-String | Invoke-Expression
    $env:COMPLETE = $prev
}
