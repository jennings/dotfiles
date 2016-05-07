#/bin/bash
set -e

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

# For each file in this repository, create a symlink in $HOME

for f in *; do

    # Don't do anything with the setup file
    [ "$f" == "setup.sh" ] && continue

    # Don't overwrite a dotfile that already exists
    [ ! -e "$HOME/.$f" ] && $LNCMD -s "$HERE/$f" "$HOME/.$f"

done
