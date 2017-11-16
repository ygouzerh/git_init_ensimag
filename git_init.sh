#!/bin/bash

# title : git_init.sh
# author : ygouzerh
# description : Automation tool for creating git repositories on depots.ensimag.fr
# date : 16 November 2017
# version : 1.0

# ---------- CONSTANTS ----------

# List of the colleagues. Could be empty
COLLEAGUE=""
# Name of the .git
GITNAME=""
# Name of the folder
FOLDER_NAME=""
# Print what the script does if verbose is on
VERBOSE=false
# Current year. Ex : 2017
YEAR=$(date +"%Y")

# ---------- FUNCTIONS ----------

# Usage : DISPLAY THE HELP
usage () {
    cat << EOF
HELP -- '$(basename "$0")' :

This script automates the creation of a git on depots.ensimag.fr
Allows you to share a git with other colleagues.
>> Adding multiple colleagues could be done by : '-c pseudo1 -c pseudo1' .....

Usage: $(basename "$0")  --gitname name_of_the_git [options]
Example : ./git_init.sh -g tp.git -c dupontj -c dupondj -f our_folder -v

Required arguments :
         --gitname | -g       Name of the .git
Options: --help | -h          Display help message
         --foldername | -f    Name of the folder on the server
         --colleague | -c     List of the pseudo of your colleague
EOF
}

# Verbose print is the first argument if verbose is on
verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "$(basename "$0") > $1"
    fi
}

# ---------- RECOVERY OF ARGUMENTS ----------
while test $# -ne 0; do
    case "$1" in
        "--help"|"-h") # Display help and quit
            usage
            exit 0
            ;;
        "--gitname" | "-g") # Name of the git
            shift;
            if [ ! "$1" = "" ]; then
                GITNAME="$1"
            else
                echo "You need to pass the name of your git. Ex : --gitname | -g tp.git"
                exit
            fi
            ;;
        "--colleague" | "-c") # List of the colleagues
            shift;
            # Test if have colleagues or not
            if [ ! "$1" = "" ]; then
                if [ "$COLLEAGUE" = "" ]; then
                    COLLEAGUE="$1"
                else
                    COLLEAGUE="$COLLEAGUE"" ""$1"
                fi
            else
                echo "You need to pass the pseudo of your colleague. Ex : --colleague | -c dupontj martinl"
                exit
            fi
            ;;
        "--foldername" | "-f") # Name of the folder
            shift;
            # Test if have colleagues or not
            if [ ! "$1" = "" ]; then
                FOLDER_NAME="$1"
            else
                echo "You need to pass the name of the folder. Ex : --foldername | -f folder_of_my_git"
                exit
            fi
            ;;
        "--verbose" | "-v") # Details the script execution
            VERBOSE=true
        ;;
        *) # if an argument is not recognized, it will show the help and kill the program
            echo "Argument is not recognized : $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# The name of the git is mandatory
if [ "$GITNAME" = "" ]; then
    echo "You need to pass the name of your git. Ex : --gitname | -g tp.git"
    exit;
fi

# Possibility to give a folder name by default
if [ "$FOLDER_NAME" = "" ]; then
    # Folder name (default): of the form : 'user_pseudo1_pseudo2'. Could be only 'user'
    FOLDER_NAME=$USER
    if [ ! "$COLLEAGUE" = "" ]; then
        FOLDER_NAME=$FOLDER_NAME"_""${COLLEAGUE// /_}"
    fi
fi

verbose "Constants : "
verbose "   YEAR : $YEAR";
verbose "   COLLEAGUE : $COLLEAGUE";
verbose "   GITNAME : $GITNAME";
verbose "   FOLDER_NAME : $FOLDER_NAME"

# ---------- CREATION ----------

# LOGIN TO THE SERVER

# EOF allow to exit the ssh connection
ssh "$USER@depots.ensimag.fr" << EOF

    # CREATION OF THE FOLDER
    cd "/depots/$YEAR" || exit
    mkdir "$FOLDER_NAME"
    echo "$(basename "$0") > Create the folder"

    cd "$FOLDER_NAME" || exit
    echo "$(basename "$0") > Go into the folder"

    # GIVE THE RIGHTS
    chmod go-rwx .
    echo "$(basename "$0") > Restrict the access to the folder to others"
    autoriser-equipe . $COLLEAGUE


    # CREATION OF THE GIT
    git init --shared --bare "$GITNAME"
    echo "$(basename "$0") > Git created."

    exit

EOF

URL="ssh://$USER@depots.ensimag.fr/depots/$YEAR/$FOLDER_NAME/$GITNAME"
verbose "Exit the server"
verbose "End creation of the git."
echo "URL : $URL"
