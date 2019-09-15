#!/bin/sh
#
# move

usage() {
    base="$(basename $0)"

    cat >&2 << EOF
Usage:
    $base -t  | top <wid> <screen>
    $base -l  | left <wid> <screen>
    $base -r  | right <wid> <screen>
    $base -b  | bottom <wid> <screen>
    $base -c  | center <wid> <screen>
    $base -tl | topleft <wid> <screen>
    $base -tr | topright <wid> <screen>
    $base -bl | bottomleft <wid> <screen>
    $base -br | bottomright <wid> <screen>
    $base -m  | maximise <wid> <screen>
    $base -vm | vmaximise <wid> <screen>
    $base -hm | hmaximise <wid> <screen>
EOF

    test $# -eq 0 || exit $1
}

reset() {
    rm $movedir/* 2> /dev/null
    exit 0
}

center() {
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW/2 - W/2))
    Y=$((SY + SH/2 - H/2))
}

left() {
    X=$SX
    Y=$(wattr y "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
}

right() {
    Y=$(wattr y "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW - W))
}

top() {
    X=$(wattr x "$wid")
    Y=$SY
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
}

topleft() {
    X=$SX
    Y=$SY
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
}

topright() {
    Y=$SY
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW -W))
}

bottom() {
    X=$(wattr x "$wid")
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    Y=$(($SY + $SH - $H))
}

bottomleft() {
    X=$SX
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    Y=$((SY + SH - H))
}

bottomright() {
    W=$(wattr w "$wid")
    H=$(wattr h "$wid")
    X=$((SX + SW - W))
    Y=$((SY + SH - H))
}

maximise() {
    X=$SX
    Y=$SY
    W=$SW
    H=$SH
}

vmaximise() {
    X=$(wattr x "$wid")
    Y=$SY
    W=$(wattr w "$wid")
    H=$SH

}

hmaximise() {
    X=$SX
    Y=$(wattr y "$wid")
    W=$SW
    H=$(wattr h "$wid")
}

main() {
    test $# -eq 0 && usage 1

    . fwmrc
    wmenv
    wmgaps

    mode="$1"

    case "$mode" in
        --reset|reset) reset ;;
    esac

    case $# in
        1)
            wid=$PFW
            ;;
        2)
            widCheck "$2" && wid="$2" || usage 1
            ;;
        3)
            mattr "$3" && SCR="$3" || {
                printf '%s\n' "$3 is not a connected screen."
                exit 1
            }
            ;;
    esac

    # exit if wid is currently fullscreen
    grep -qrw "$wid" "$fsdir" 2> /dev/null && return 1

    # restore window position
    grep -qrw "$wid" "$movedir" 2> /dev/null && {
        test "$(tail -n 1 "$movedir/$wid")" = "$mode" && {
            case "$mode" in
                vmaximise|hmaximise|maximise)
                    # move mouse to middle of window
                    wtp $(head -n 1 "$movedir/$wid")

                    wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
                           $(($(wattr y $wid) + $(wattr h $wid) / 2))

                    # clean file
                    rm "$movedir/$wid"
                    exit 0
                    ;;
            esac
        }
    }

    SCR="$(pfm)"
    SX=$(($(mattr x $SCR) + LGAP))
    SY=$(($(mattr y $SCR) + TGAP))
    SW=$(($(mattr w $SCR) - LGAP - RGAP))
    SH=$(($(mattr h $SCR) - TGAP - BGAP))

    case "$mode" in
        -t|--top|top)                   top         ; mode="top"         ;;
        -l|--left|left)                 left        ; mode="left"        ;;
        -r|--right|right)               right       ; mode="right"       ;;
        -b|--bottom|bottom)             bottom      ; mode="bottom"      ;;
        -c|--center|center)             center      ; mode="center"      ;;
        -tl|--topleft|topleft)          topleft     ; mode="topleft"     ;;
        -tr|--topright|topright)        topright    ; mode="topright"    ;;
        -bl|--bottomleft|bottomleft)    bottomleft  ; mode="bottomleft"  ;;
        -br|--bottomright|bottomright)  bottomright ; mode="bottomright" ;;
        -m|--maximise|maximise)         maximise    ; mode="maximise"    ;;
        -vm|--vmaximise|vmaximise)      vmaximise   ; mode="vmaximise"   ;;
        -hm|--hmaximise|hmaximise)      hmaximise   ; mode="hmaximise"   ;;
        -h|--help)                      usage 0     ;;
        *)                              usage 1     ;;
    esac

    # save window postion and mode
    (wattr xywhi "$wid"; printf '%s\n' "$mode") > "$movedir/$wid"

    wtp $X $Y $W $H $wid

    # move mouse to middle of window
    wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
           $(($(wattr y $wid) + $(wattr h $wid) / 2))
}

main "$@"
