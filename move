#!/bin/sh
# shellcheck disable=SC2015
#
# move

usage() {
    base="$(basename "$0")"
cat >&2 << EOF
Usage: $base [position] <wid> <screen|cycle>
    $ $base -t    | top         : Move window to top of screen.
    $ $base -l    | left        : Move window to left of screen.
    $ $base -r    | right       : Move window to right of screen.
    $ $base -b    | bottom      : Move window to bottom of screen.
    $ $base -c    | center      : Move window to center of screen.
    $ $base -tl   | topleft     : Move window to top left of screen.
    $ $base -tr   | topright    : Move window to top right of screen.
    $ $base -bl   | bottomleft  : Move window to bottom left of screen.
    $ $base -br   | bottomright : Move window to bottom right of screen.
    $ $base -hl   | halve       : Halve window in width and height.
    $ $base -dl   | double      : Double window in width and height.
    $ $base -m    | maximise    : Extend window to horizontal and vertical max.
    $ $base -vm   | vmaximise   : Extend window to vertical max.
    $ $base -hm   | hmaximise   : Extend window to horizontal max.
    $ $base -g    | grow        : Increase window size by $JUMP.
    $ $base -s    | shrink      : Decrease window size by $JUMP.
    $ $base reset | --reset     : Delete all stored window positions.
    $ $base help  | --help      : Show this help.
EOF

    test $# -eq 0 || exit "$1"
}

reset() {
    rm "$movedir"/* 2> /dev/null
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
    Y=$((SY + SH - H))
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

full() {
    X=$(mattr x "$SCR")
    Y=$(mattr y "$SCR")
    W=$(mattr w "$SCR")
    H=$(mattr h "$SCR")
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
    W=$(($(wattr w "$wid") * 2))
    H=$(($(wattr h "$wid") * 2))
    X=$(($(wattr x "$wid") - W / 4))
    Y=$(($(wattr y "$wid") - H / 4))

    test "$X" -le "$SX" && exit 1
    test "$Y" -le "$SY" && exit 1
    test "$W" -ge "$SW" && exit 1
    test "$H" -ge "$SH" && exit 1
}

halve() {
    W=$(($(wattr w "$wid") / 2))
    H=$(($(wattr h "$wid") / 2))
    X=$(($(wattr x "$wid") + W / 2))
    Y=$(($(wattr y "$wid") + H / 2))
}

grow() {
    X=$(($(wattr x "$wid") - JUMP / 2))
    Y=$(($(wattr y "$wid") - JUMP / 2))
    W=$(($(wattr w "$wid") + JUMP))
    H=$(($(wattr h "$wid") + JUMP))

    wtp "$X" "$Y" "$W" "$H" "$wid"
    exit 0
}

shrink() {
    X=$(($(wattr x "$wid") + JUMP / 2))
    Y=$(($(wattr y "$wid") + JUMP / 2))
    W=$(($(wattr w "$wid") - JUMP))
    H=$(($(wattr h "$wid") - JUMP))

    wtp "$X" "$Y" "$W" "$H" "$wid"
    exit 0
}

position() {
    # save old window position, new window position, mode, and screen
    atomx MODE="$mode" "$wid" > /dev/null
    atomx NEW_POS="$X $Y $W $H" "$wid" > /dev/null
    atomx SCR="$(mattr i "$wid")" "$wid" > /dev/null
    atomx OLD_POS="$(wattr xywh "$wid")" "$wid" > /dev/null

    # briefly hide mouse
    wmp -a $(wattr wh "$(lsw -r)")

    # position window
    wtp "$X" "$Y" "$W" "$H" "$wid"

    # move mouse to middle of window
    wmp -a $(($(wattr x "$wid") + $(wattr w "$wid") / 2)) \
           $(($(wattr y "$wid") + $(wattr h "$wid") / 2))

    chwso -r "$wid"
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
            SCR="$PFM"
            wid="$PFW"
            ;;
        2)
            SCR="$PFM"
            widCheck "$2" && wid="$2" || usage 1
            ;;
        3)
            widCheck "$2" && wid="$2" || usage 1

            case "$3" in
                cycle)
                    # file to store the stack
                    cycle="$movedir/cycle"

                    # active screen
                    CUR="$(mattr i "$wid")"

                    # create FILO stack
                    test -s "$cycle" || {
                        lsm | grep -v "$CUR" > "$cycle"
                        printf '%s\n' "$CUR" >> "$cycle"
                    }

                    # get the oldest screen that was not used.
                    SCR="$(head -n 1 "$cycle")"

                    # delete oldest screen
                    sed -i -n '/'"$SCR"'/!p' "$cycle"
                    # make it the active screen
                    printf '%s\n' "$SCR" >> "$cycle"
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

    # grab screen variables
    SX=$(($(mattr x "$SCR") + LGAP))
    SY=$(($(mattr y "$SCR") + TGAP))
    SW=$(($(mattr w "$SCR") - LGAP - RGAP))
    SH=$(($(mattr h "$SCR") - TGAP - BGAP))

    # restore window position
    test -n "$(atomx OLD_POS "$wid")" && {
        test "$(atomx SCR "$wid")" = "$SCR" && {
            case "$mode" in
                full|maximise|vmaximise|hmaximise)
                    test "$(atomx MODE "$wid")" = "$mode" && {
                        # test if window has moved since last run
                        test "$(atomx NEW_POS "$wid")" != "$(wattr xywh "$wid")" && {
                            $mode
                            position
                        } || {
                            # briefly hide mouse
                            wmp -a $(wattr wh $(lsw -r))

                            # restore position
                            wtp $(atomx OLD_POS "$wid") "$wid"

                            # move mouse to middle of window
                            wmp -a $(($(wattr x "$wid") + $(wattr w "$wid") / 2)) \
                                   $(($(wattr y "$wid") + $(wattr h "$wid") / 2))

                            # clean atoms
                            atomx -d SCR "$wid"
                            atomx -d MODE "$wid"
                            atomx -d OLD_POS "$wid"
                            atomx -d NEW_POS "$wid"
                        }
                    }

                exit 0
                ;;
            esac
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
        -f|--full|full)                 full        ; mode="full"        ;;
        -m|--maximise|maximise)         maximise    ; mode="maximise"    ;;
        -vm|--vmaximise|vmaximise)      vmaximise   ; mode="vmaximise"   ;;
        -hm|--hmaximise|hmaximise)      hmaximise   ; mode="hmaximise"   ;;
        -dl|--double|double)            double      ;;
        -hl|--halve|halve)              halve       ;;
        -g|--grow|grow)                 grow        ;;
        -s|--shrink|shrink)             shrink      ;;
        -h|--help|help)                 usage 0     ;;
        *)                              usage 1     ;;
    esac

    position
}

main "$@"
