#/bin/bash
set -euo pipefail

usage()
{
cat << EOF
usage: $0 [-n]

OPTIONS:
    -n      Dry run; displays what would have been executed
EOF
}

DRYRUN=
while getopts "hn" OPTION; do
    case $OPTION in
        n)
            DRYRUN=1
            ;;
        h|*)
            usage
            exit 1
    esac
done

if [ -z "$DRYRUN" ]; then
    LNCMD=ln
    MKDIRCMD=mkdir
    GITCMD=git
else
    LNCMD="echo ln"
    MKDIRCMD="echo mkdir"
    GITCMD="echo git"
fi

HERE=$(python -c "import os.path; print os.path.relpath(os.path.realpath('.'), os.path.expanduser('~'))")

# For each dotfile, create ~/.filename
for f in dotfiles/*; do

    fn=$(basename $f)
    # Don't overwrite a dotfile that already exists
    [[ ( ! -e "$HOME/.$fn" ) || ( -L "$HOME/.$fn" ) ]] && $LNCMD -shf "$HERE/$f" "$HOME/.$fn"

done

# For each binary, create ~/bin/filename
$MKDIRCMD -p "$HOME/bin"
for f in bin/*; do
    [[ ( ! -e "$HOME/$f" ) || ( -L "$HOME/$f" ) ]] && $LNCMD -shf "../$HERE/$f" "$HOME/$f"
done
