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

    [ $# -eq 0 ] || exit "$1"
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

obs() {
    SX=$(($(mattr x "$PRI") + LGAP))
    SY=$(($(mattr y "$PRI") + TGAP))

    X=$SX
    Y=$SY
    W=1280
    H=720
}


double() {
    W=$(($(wattr w "$wid") * 2))
    H=$(($(wattr h "$wid") * 2))
    X=$(($(wattr x "$wid") - W / 4))
    Y=$(($(wattr y "$wid") - H / 4))

    test "$W" -gt "$SW" && W=$SW
    test "$H" -gt "$SH" && H=$SH

    test "$X" -lt "$SX" && X=$SX
    test "$Y" -lt "$SY" && Y=$SY

    test "$((X + W))" -gt "$((SX + SW))" && X=$((SX + SW - W))
    test "$((Y + H))" -gt "$((SY + SH))" && Y=$((SY + SH - H))
}

halve() {
    W=$(($(wattr w "$wid") / 2))
    H=$(($(wattr h "$wid") / 2))
    X=$(($(wattr x "$wid") + W / 2))
    Y=$(($(wattr y "$wid") + H / 2))

    test "$W" -lt 222 && exit 0
    test "$H" -lt 131 && exit 0
}

grow() {
    wmv -$(($JUMP / 2)) -$((JUMP / 2)) "$wid"
    wrs $JUMP $JUMP "$wid"

    exit 0
}

grow_down() {
    wrs 0 $JUMP "$wid"
    exit 0
}

grow_right() {
    wrs $JUMP 0 "$wid"
    exit 0
}

shrink() {
    wmv $(($JUMP / 2)) $((JUMP / 2)) "$wid"
    wrs -$JUMP -$JUMP "$wid"

    exit 0
}

shrink_up() {
    wrs 0 -$JUMP "$wid"
    exit 0
}

shrink_left() {
    wrs -$JUMP 0 "$wid"
    exit 0
}

position() {
    # save old window position, new window position, mode, and screen
    save_atom "$wid" "$mode"

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
    [ -n "$(atomx OLD_POS "$wid")" ] && {
        [ "$(atomx MODE "$wid")" = "$mode" ] && {
            case "$mode" in
                center|full|maximise|vmaximise|hmaximise|obs)
                    # test if window has moved since last run
                    [ "$(atomx NEW_POS "$wid")" != "$(wattr xywh "$wid")" ] && {
                        $mode
                        position
                    } || {
                        # briefly hide mouse
                        wmp -a $(wattr wh $(lsw -r))

                        # restore position
                        wtp $(atomx OLD_POS "$wid") "$wid"

                        # restore border
                        [ "$mode" = "full" ] && chwb -s "$BW" -c "$ACTIVE" "$wid"

                        # move mouse to middle of window
                        wmp -a $(($(wattr x "$wid") + $(wattr w "$wid") / 2)) \
                               $(($(wattr y "$wid") + $(wattr h "$wid") / 2))

                        # clean atoms
                        del_atom "$wid"
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
        -o|--obs|obs)                   obs         ; mode="obs"         ;;
        -g|--grow|grow)                 grow        ;;
        -gd|--grow_down|grow_down)      grow_down   ;;
        -gr|--grow_right|grow_right)    grow_right  ;;
        -s|--shrink|shrink)             shrink      ;;
        -su|--shrink_up|shrink_up)      shrink_up   ;;
        -sl|--shrink_left|shrink_left)  shrink_left ;;
        -dl|--double|double)            double      ;;
        -hl|--halve|halve)              halve       ;;
        -h|--help|help)                 usage 0     ;;
        *)                              usage 1     ;;
    esac

    position
}

main "$@"
