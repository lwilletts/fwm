usage() {
	echo "usage: $(basename $0) [-l] [-ad window] group" >&2
}

list_groups() {
	for wid in $(lsw -a); do
		wg=$(atomx GROUP $wid)
		[ -n "$wg" ] && printf 'GROUP_%s\t%s\n' $wg $wid
	done | sort
}

show_group() {
	for wid in $(lsw -u); do
		wg=$(atomx GROUP $wid)
		[ -z "$wg" ] && continue
		[ "$wg" -eq $1 ] && mapw -m $wid
	done
	atomx GROUP_$1=on `lsw -r`
}

hide_group() {
	for wid in $(lsw); do
		wg=$(atomx GROUP $wid)
		[ -z "$wg" ] && continue
		[ "$wg" -eq $1 ] && mapw -u $wid
	done
	atomx GROUP_$1=off `lsw -r` >/dev/null
}

toggle_group() {
	case $(atomx GROUP_$1 `lsw -r`) in
	on)  hide_group $1 ;;
	off) show_group $1 ;;
	*) atomx GROUP_$1=on `lsw -r` >/dev/null
	esac
}

root=`lsw -r`
action=tog
while getopts 'a:d:lh' OPT; do
	case $OPT in
	a) action=add; wid=$OPTARG ;;
	d) action=del; wid=$OPTARG ;;
	l) list_groups; exit 0 ;;
	h) usage; exit 0 ;;
	*) usage; exit 1 ;;
	esac
done
shift $((OPTIND - 1))

[ -z "$1" ] && exit 1

case $action in
add) show_group $1; atomx GROUP=$1 $wid >/dev/null ;;
del) atomx -d GROUP $wid ;;
tog) toggle_group $1 ;;
esac
