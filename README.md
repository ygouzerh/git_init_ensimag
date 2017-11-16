# git_init_ensimag

## Description
Automate tool for creating git repositories on depots.ensimag.fr

This script automate the creation of a git on depots.ensimag.fr
Allow you to share a git with other colleagues.
> Add multiple colleague could be done by : '-c pseudo1 -c pseudo1' .....

## Usage
$(basename "$0")  --gitname name_of_the_git [options]
>Example : ./git_init.sh -g tp.git -c dupontj -c dupondj -f our_folder -v

## Required arguments
--gitname | -g       Name of the .git

## Options
--help | -h          Display help message
--foldername | -f    Name of the folder on the server
--colleague | -c     List of the pseudo of your colleague

## Contributions

Feel free to contribute ! All improvements and helps are welcomed.
