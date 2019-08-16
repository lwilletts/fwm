#!/bin/sh
#
# move

ARGS="$@"

usage() {
    base="$(basename $0)"
    cat >&2 << EOF
Usage:

left
right
top
topleft
topright
bottom
bottomleft
bottomright
jumpup
jumpdown
jumpleft
jumpright
center
maximise
vmaximise
hmaximise

EOF

    test $# -eq 0 || exit $1
}

clean() {
    # search all files for matching wid
    return 0
}

center() {
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW/2 - W/2))
    Y=$((SY + SH/2 - H/2))
    wtp $X $Y $W $H $wid
}

left() {
    sh -c "wtp $SX $(wattr ywhi "$wid")"
}

right() {
    Y=$(wattr y "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW - W))
    wtp $X $Y $W $H $wid
}

top() {
    X=$(wattr x "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    Y=$((SY + SH - H))
    wtp $X $Y $W $H $wid
}

topleft() {
    return 0
}

topright() {
    return 0
}

bottom() {
    X=$(wattr x "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    Y=$(echo "$SY + $SH - $H" | bc )
    wtp $X $Y $W $H $wid
}

bottomleft() {
    return 0
}

bottomright() {
    return 0
}

jumpleft() {
    return 0
}

jumpright() {
    return 0
}

jumpup() {
    return 0
}

jumpdown() {
    return 0
}

maximise() {
    wtp $SX $SY $SW $SH $wid
}

vmaximise() {
    return 0
}

hmaximise() {
    return 0
}

main() {
    test $# -eq 0 && usage 1

    . fwmrc
    wmenv
    wmgaps

    widCheck "$2" && wid="$2" || usage 1

    case $# in
        3)
            mattr "$3" && SCR="$3" || {
                printf '%s\n' "$3 is not a connected screen."
                exit 1
            }
            ;;
    esac

    # exit if wid is currently fullscreen
    grep -qrw "$wid" "$fsdir" 2> /dev/null && return 1

    SCR="$(pfm)"
    SX=$(($(mattr x $SCR) + LGAP))
    SY=$(($(mattr y $SCR) + TGAP))
    SW=$(($(mattr w $SCR) - LGAP - RGAP))
    SH=$(($(mattr h $SCR) - TGAP - BGAP))

    # save window postion


    case "$1" in
        -l|--left|left)                 left        ;;
        -r|--right|right)               right       ;;
        -t|--top|top)                   top         ;;
        -b|--bottom|bottom)             bottom      ;;
        -tl|--topleft|topleft)          topleft     ;;
        -tr|--topright|topright)        topright    ;;
        -bl|--bottomleft|bottomleft)    bottomleft  ;;
        -br|--bottomright|bottomright)  bottomright ;;
        -c|--center|center)             center      ;;
        -m|--maximise|maximise)         maximise    ;;
        -jl|--jumpleft|jumpleft)        jumpleft    ;;
        -jr|--jumpright|jumpright)      jumpright   ;;
        -ju|--jumpup|jumpup)            jumpup      ;;
        -jd|--jumpdown|jumpdown)        jumpdown    ;;
        -vm|--vmaximised|vmaximised)    vmaximise   ;;
        -hm|--hmaximised|hmaximised)    hmaximise   ;;
        -h|--help)         usage 0                  ;;
        *)                 usage 1                  ;;
    esac

    # move mouse to middle of window
    wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
           $(($(wattr y $wid) + $(wattr h $wid) / 2))
}

main $ARGS
