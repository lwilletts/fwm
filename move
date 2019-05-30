#!/bin/sh
#
# move

ARGS="$@"

usage() {
    cat >&2 << EOF
Usage: $(basename $0) [-lrvfeRh] <wid> <screen>
    -l | --left:    Make current or given window half of the screen positioned on the left.
    -r | --right:   Make current or given window half of the screen positioned on the right.
    -f | --fuller:  Make current or given window fullscreen minus border gaps.
    -e | --extend:  Extend current or given window to the maximum screen height.
    -b | --bottom:  Extend current or given window to the bottom edge of the screen.
    -s | --screen:  Position current or given window on to given screen.
    -Q | --quarter: Make current or given window quartar of the screen.
    -R | --restore: Restore current or given window to minW and minH values.
    -h | --help:    Show this help.
EOF

    test $# -eq 0 || exit $1
}

screen() {
    X=$(wattr x "$wid" 2> /dev/null)
    Y=$(wattr y "$wid" 2> /dev/null)
    W=$(wattr w "$wid" 2> /dev/null)
    H=$(wattr h "$wid" 2> /dev/null)

    X=$((SX + X))
    Y=$((SY + Y))
}

restore() {
    W=$minW
    H=$minH
}

extend() {
    W=$minW
    Y=$((TGAP + SY))
    H=$((eSH - (VGAP / ROWS) * BW))
}

bottom() {
    H=$((eSH - (VGAP / ROWS) * BW - Y + TGAP))
}

quarter() {
    W=$((eSW/2 - IGAP/2 - (IGAP / COLS) * BW))
    H=$((eSH/2 - VGAP/2 - (VGAP / ROWS) * BW))
}

left() {
    X=$((XGAP + SX))
    Y=$((TGAP + SY))
    W=$((eSW/2 - IGAP/2 - (IGAP / COLS) * BW))
    H=$((eSH - (VGAP / ROWS) * BW))
}

right() {
    Y=$((TGAP + SY))
    W=$((eSW/2 - IGAP/2 - (IGAP / COLS) * BW))
    H=$((eSH - (VGAP / ROWS) * BW))
    X=$((W + XGAP + IGAP + (IGAP / COLS) * BW))
}

full() {
    X=$((XGAP + SX))
    Y=$((TGAP + SY))
    W=$((eSW - (IGAP / COLS) * BW))
    H=$((eSH - (VGAP / ROWS) * BW))
}

moveMouse() {
    . mouse

    mouseStatus=$(getMouseStatus)
    test ! -z $mouseStatus && test $mouseStatus -eq 1 && moveMouseEnabled "$wid"
}

main() {
    test $# -eq 0 && usage 1

    . fwmrc

    case $# in
        1)
            wattr "$PFW" && wid=$PFW || return 1
            ;;
        2)
            wattr "$2" && wid="$2" || {
                wid="$PFW"
                intCheck $2 && retrieveScreenValues $2
            }
            ;;
        3)
            wattr "$2" && wid="$2" || wid="$PFW"
            retrieveScreenValues $3
            ;;
    esac

    echo $SX $SY $SW $SH

    # exit if wid is currently fullscreen
    grep -qw "$wid" "$FSFILE" 2> /dev/null && return 1

    case "$1" in
        -l|--left)    left    ;;
        -r|--right)   right   ;;
        -f|--fuller)  full    ;;
        -e|--extend)  extend  ;;
        -b|--bottom)  bottom  ;;
        -s|--screen)  screen  ;;
        -Q|--quarter) quartar ;;
        -R|--restore) restore ;;
        *)            usage 1 ;;
    esac

    echo $X $Y $W $H
    wtp $X $Y $W $H "$wid"
    test "$MOUSE" = "true" && moveMouse
}

main $ARGS
