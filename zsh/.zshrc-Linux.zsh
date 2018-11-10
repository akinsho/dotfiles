# Reference: https://bbs.archlinux.org/viewtopic.php?id=163075
# This script runs pacman with sudo only if required
pacman() 
{
    case $1 in
        -S | -D | -S[^sih]* | -R* | -U*)
            /usr/bin/sudo /usr/bin/pacman "$@" ;;
    *)      /usr/bin/pacman "$@" ;;
    esac
}