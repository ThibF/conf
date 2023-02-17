#!/bin/sh
set -eu
LEFT_CLICK=1
MIDDLE_CLICK=2
RIGHT_CLICK=3
SCROLL_DOWN=4
SCROLL_UP=5
LIGHT_GROUP="${LIGHT_GROUP:-2}}"

error() {
	echo "${1:-}"
	# exiting with another value than 0 prevent the bar to comes up
	exit 0
}

check_current_state() {
	current_state_raw="$(hueadm group -j "${LIGHT_GROUP}" | jq '.action | (.on|tostring) + " " + (.bri|tostring)')"
	if echo "${current_state_raw}" | grep -q false ; then
		current_state="0"
	else
		current_state="$(echo ${current_state_raw} | cut -d ' ' -f 2 | tr -d '"')"
	fi

}

switch_state() {
	if [ "${current_state}" -eq 0 ]; then
		hueadm group "${LIGHT_GROUP}" '=33' > /dev/null
		current_state=33
	elif [ "${current_state}" -lt 200 ]; then
		hueadm group "${LIGHT_GROUP}" '+100' > /dev/null
		current_state=$((current_state+100))
	else
		hueadm group "${LIGHT_GROUP}" off > /dev/null
		current_state=0
	fi
}

print_current_status() {
	if [ "${current_state}" -eq 0 ]; then
		echo '💤'
	elif [ "${current_state}" -lt 100 ]; then
		echo '💡'
	elif [ "${current_state}" -lt 200 ]; then
		echo '💡💡'
	else
		echo '💡💡💡'
	fi
}

main() {

	check_current_state
	if [ "${BLOCK_BUTTON:-0}" -eq ${LEFT_CLICK} ] || [ -n "${1:-}" ]; then
		switch_state
	elif [ "${BLOCK_BUTTON:-0}" -eq ${MIDDLE_CLICK} ]; then
		hueadm group "${LIGHT_GROUP}" lselect > /dev/null
	elif [ "${BLOCK_BUTTON:-0}" -eq ${RIGHT_CLICK} ]; then
		hueadm group "${LIGHT_GROUP}" off > /dev/null
		current_state=0
	elif [ "${BLOCK_BUTTON:-0}" -eq ${SCROLL_DOWN} ] ||
		 [ "${BLOCK_BUTTON:-0}" -eq ${SCROLL_UP} ]; then
		hueadm group "${LIGHT_GROUP}" colorloop > /dev/null
	fi
	print_current_status
}

trap error EXIT
main "$@"
trap EXIT
