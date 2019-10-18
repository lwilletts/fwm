#!/bin/sh
#
# move

usage() {
    base="$(basename $0)"

    cat >&2 << EOF
Usage: $base [position] <wid> <screen|cycle>
    -t  | top
    -l  | left
    -r  | right
    -b  | bottom
    -c  | center
    -tl | topleft
    -tr | topright
    -bl | bottomleft
    -br | bottomright
    -m  | maximise
    -vm | vmaximise
    -hm | hmaximise
    -dl | double
    -hl | halve
    help | --help
    reset | --reset
EOF

    test $# -eq 0 || exit $1
}

reset() {
    rm $movedir/* 2> /dev/null
    printf '%s\n' "move directory reset..."
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

double() {
    X=$(wattr x "$wid")
    Y=$(wattr y "$wid")
    W=$(($(wattr w "$wid") * 2))
    H=$(($(wattr h "$wid") * 2))
}

halve() {
    X=$(wattr x "$wid")
    Y=$(wattr y "$wid")
    W=$(($(wattr w "$wid") / 2))
    H=$(($(wattr h "$wid") / 2))
}

position() {
    # save old window postion, new window position, mode, and screen
    (wattr xywhi "$wid"; \
    printf '%s\n' "$X $Y $W $H"; \
    printf '%s\n' "$mode"
    printf '%s\n' "$(mattr i $wid)") > "$movedir/$wid"

    # briefly hide mouse
    wmp -a $(wattr wh $(lsw -r))

    # position window
    wtp $X $Y $W $H $wid

    # move mouse to middle of window
    wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
           $(($(wattr y $wid) + $(wattr h $wid) / 2))
}

main() {
    . fwmrc
    wmenv
    wmgaps

    mode="$1"

    case "$mode" in
        --reset|reset) reset ;;
    esac

    case $# in
        0)
            usage 1
            ;;
        1)
            SCR="$(pfm)"
            wid="$PFW"
            ;;
        2)
            SCR="$(pfm)"
            widCheck "$2" && wid="$2" || usage 1
            ;;
        3)
            widCheck "$2" && wid="$2" || usage 1

            case "$3" in
                cycle)
                    # won't work for three screens currently
                    SCR="$(lsm | grep -v $(mattr i $wid))"
                    ;;
                *)
                    mattr "$3" && SCR="$3" || {
                        printf '%s\n' "$3 is not a connected screen."
                        exit 1
                    }
                    ;;
            esac
            ;;
    esac

    # exit if wid is currently fullscreen
    grep -qrw "$wid" "$fsdir" 2> /dev/null && return 1

    # grab screen variables
    SX=$(($(mattr x $SCR) + LGAP))
    SY=$(($(mattr y $SCR) + TGAP))
    SW=$(($(mattr w $SCR) - LGAP - RGAP))
    SH=$(($(mattr h $SCR) - TGAP - BGAP))

    # restore window position
    grep -qrw "$wid" "$movedir" 2> /dev/null && {
        # test if given screen matches new screen
        test "$(sed '4!d' "$movedir/$wid")" = "$SCR" && {
            test "$(sed '3!d' "$movedir/$wid")" = "$mode" && {
                case "$mode" in
                    vmaximise|hmaximise|maximise)
                        # test if window has moved since last run
                        test "$(sed '2!d' "$movedir/$wid")" != "$(wattr xywh $wid)" && {
                            $mode
                            position
                        } || {
                            # briefly hide mouse
                            wmp -a $(wattr wh $(lsw -r))

                            # restore position
                            wtp $(sed '1!d' "$movedir/$wid")

                            # move mouse to middle of window
                            wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
                                   $(($(wattr y $wid) + $(wattr h $wid) / 2))

                            # clean file
                            rm "$movedir/$wid"
                        }

                        exit 0
                        ;;
                esac
            }
        }
    }

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
        -dl|--double|double)            double      ; mode="double"      ;;
        -hl|--halve|halve)              halve       ; mode="halve"       ;;
        -h|--help|help)                 usage 0     ;;
        *)                              usage 1     ;;
    esac

    position
}

main "$@"
