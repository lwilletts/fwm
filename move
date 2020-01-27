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
    $ $base -f    | full        : Extend window to edges of the screen.
    $ $base -m    | maximise    : Extend window to horizontal and vertical max.
    $ $base -vm   | vmaximise   : Extend window to vertical max.
    $ $base -hm   | hmaximise   : Extend window to horizontal max.
    $ $base -g    | grow        : Increase window size by $JUMP.
    $ $base -gd   | grow_down   : Increase window size down by $JUMP.
    $ $base -gr   | grow_right  : Increase window size right by $JUMP.
    $ $base -s    | shrink      : Decrease window size by $JUMP.
    $ $base -su   | shrink_up   : Decrease window size up by $JUMP.
    $ $base -sl   | shrink_left : Decrease window size left by $JUMP.
    $ $base -hl   | halve       : Halve window in width and height.
    $ $base -dl   | double      : Double window in width and height.
    $ $base help  | --help      : Show this help.
EOF

    test $# -eq 0 || exit "$1"
}

restore() {
    X=$(wattr x "$wid")
    Y=$(wattr y "$wid")
    W=445
    H=262
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

    chwb -s 0 "$wid"
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

grow_down() {
    X=$(($(wattr x "$wid") - JUMP / 2))
    Y=$(($(wattr y "$wid") - JUMP / 2))
    W=$(($(wattr w "$wid") + JUMP))
    H=$(($(wattr h "$wid") + JUMP))

    wtp "$X" "$Y" "$W" "$H" "$wid"
    exit 0
}

grow_right() {
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

shrink_up() {
    X=$(($(wattr x "$wid") + JUMP / 2))
    Y=$(($(wattr y "$wid") + JUMP / 2))
    W=$(($(wattr w "$wid") - JUMP))
    H=$(($(wattr h "$wid") - JUMP))

    wtp "$X" "$Y" "$W" "$H" "$wid"
    exit 0
}

shrink_left() {
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

    # don't overwrite the old window position
    if [ -z "$(atomx OLD_POS "$wid")" ]; then
        atomx OLD_POS="$(wattr xywh "$wid")" "$wid" > /dev/null
    fi

    # briefly hide mouse
    wmp -a $(wattr wh "$(lsw -r)")

    # raise window
    chwso -r "$wid"

    # position window
    wtp "$X" "$Y" "$W" "$H" "$wid"

    # move mouse to middle of window
    wmp -a $(($(wattr x "$wid") + $(wattr w "$wid") / 2)) \
           $(($(wattr y "$wid") + $(wattr h "$wid") / 2))

}

main() {
    . fwmrc
    wmenv
    wmgaps
    wmcolours

    mode="$1"

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
                    # active screen
                    CUR="$(mattr i "$wid")"
                    SCR="$(lsm | grep -v "$CUR")"
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
        test "$(atomx MODE "$wid")" = "$mode" && {
            case "$mode" in
                full|maximise|vmaximise|hmaximise)
                    # test if window has moved since last run
                    test "$(atomx NEW_POS "$wid")" != "$(wattr xywh "$wid")" && {
                        $mode
                        position
                    } || {
                        # briefly hide mouse
                        wmp -a $(wattr wh $(lsw -r))

                        # restore position
                        wtp $(atomx OLD_POS "$wid") "$wid"

                        # restore border
                        chwb -s "$BW" -c "$ACTIVE" "$wid"

                        # move mouse to middle of window
                        wmp -a $(($(wattr x "$wid") + $(wattr w "$wid") / 2)) \
                               $(($(wattr y "$wid") + $(wattr h "$wid") / 2))

                        # clean atoms
                        atomx -d SCR "$wid"
                        atomx -d MODE "$wid"
                        atomx -d OLD_POS "$wid"
                        atomx -d NEW_POS "$wid"
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
        -g|--grow|grow)                 grow        ;;
        -gd|--grow_down|grow_down)      grow_down   ;;
        -gr|--grow_right|grow_right)    grow_right  ;;
        -s|--shrink|shrink)             shrink      ;;
        -su|--shrink_up|shrink_up)      shrink_up   ;;
        -sl|--shrink_left|shrink_left)  shrink_left ;;
        -dl|--double|double)            double      ;;
        -hl|--halve|halve)              halve       ;;
        restore|--restore)              restore     ;;
        -h|--help|help)                 usage 0     ;;
        *)                              usage 1     ;;
    esac

    position
}

main "$@"
