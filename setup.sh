#/bin/bash

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


# Create user.name and user.email values in $XDG_CONFIG_HOME
# This prevents spam crawlers from finding them by scraping GitHub

GITXDGHOME="$HOME/${XDG_CONFIG_HOME:-.config}/git"
[ ! -d "$GITXDGHOME" ] && $MKDIRCMD -p "$GITXDGHOME"

currentgitname=$(git config --file $GITXDGHOME/config user.name)
if [ -z "$currentgitname" ]; then
    read -p "Enter your git user.name:  " name
    $GITCMD config --file "$GITXDGHOME/config" user.name "$name"
fi

currentgitemail=$(git config --file $GITXDGHOME/config user.email)
if [ -z "$currentgitemail" ]; then
    read -p "Enter your git user.email: " email
    $GITCMD config --file "$GITXDGHOME/config" user.email "$email"
fi
