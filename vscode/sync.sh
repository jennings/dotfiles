#!/bin/bash

sortedfiltered() {
    grep -v '^#' | grep '.' | sort -f
}

each_cmd() {
    cmd=$1
    if [[ -n $DRY_RUN ]]; then
        cmd="echo $cmd"
    fi
    for ext in $2; do
        $cmd $ext
    done
}

synchronize() {
    cmd=$1
    required=$(sortedfiltered < extensions.txt)
    installed=$($1 --list-extensions | sortedfiltered)

    remove=$(comm -13i <(echo "$required") <(echo "$installed"))
    install=$(comm -23i <(echo "$required") <(echo "$installed"))

    each_cmd "$1 --uninstall-extension" "$remove"
    each_cmd "$1 --install-extension" "$install"
}

while getopts "n" opt; do
    case "$opt" in
    n)
        DRY_RUN=1
        ;;
    esac
done

[[ -x $(which code) ]] && synchronize code
[[ -x $(which code-insiders) ]] && synchronize code-insiders
