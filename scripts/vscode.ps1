$BINARIES = "code", "code-insiders" | ? { Get-Command -ErrorAction SilentlyContinue $_ }

$EXTENSIONS = @(
    # Vim
    "vscodevim.vim",

    # LiveShare
    "ms-vsliveshare.vsliveshare",

    # GitLens
    "eamodio.gitlens",

    # Formatting/linting
    "EditorConfig.EditorConfig",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",

    # Yarn and npm
    "gamunu.vscode-yarn",
    "eg2.vscode-npm-script",

    # Docker
    "ms-azuretools.vscode-docker",

    # Language/framework support
    "ms-python.python",
    "ms-vscode.csharp",
    "octref.vetur",

    # Browser debugging
    "firefox-devtools.vscode-firefox-debug",
    "msjsdiag.debugger-for-chrome",
    "msjsdiag.debugger-for-edge",

    # Remote
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.remote-wsl"
)

foreach ($code in $BINARIES) {
    "*********************************" | Out-Host
    " INSTALLING EXTENSIONS IN '$code'" | Out-Host
    "*********************************" | Out-Host

    foreach ($extension in $EXTENSIONS) {
        & $code --install-extension $extension
        if ($LASTEXITCODE -ne 0) {
            throw "Error installing $extension in $code, exit code $LASTEXITCODE"
        }
    }
}