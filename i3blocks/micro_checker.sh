#!/bin/sh
set -eu

# Require pactl > v15.0.0 which isn't shipped in ubuntu 20.04
# To build it, you can use the docker image shipped by freedesktop
#   registry.freedesktop.org/pulseaudio/pulseaudio/ubuntu/20.04:2021-11-03-00
#   git clone https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git
#   cd pulseaudio
#   meson build
#   wget -q https://github.com/mesonbuild/meson/releases/download/0.50.0/meson-0.50.0.tar.gz
#   tar -xf meson-0.50.0.tar.gz
#   (cd meson-0.50.0 && python3 setup.py install)
#   meson build --werror
#   (cd build && ninja)
#   cp --recursive /PULSEAUDIO_CLONE/build/src/* ~/configWorkspace/pulseaudio

PACTL=/home/thibf/configWorkspace/pulseaudio/utils/pactl

error() {
	echo "${1:-}"
	# exiting with another value than 0 prevent the bar to comes up
	exit 0
}

find_pactl() {
	if [ -n "${PACTL:-}" ]; then
		return
	fi
	PACTL="$(which pactl)"
	if ! ${PACTL} get-source-mute @DEFAULT_SOURCE@ > /dev/null 2>&1; then
		if ! [ -x "${LOCAL_PACTL}" ]; then
			# install pactl > 15.00
			error "Update pactl!"
		fi
	fi
}

check_current_state() {
	# Check if all sources are in sync
	sources="$("${PACTL}" list short sources | cut -d '	' -f 1)"
	if [ -z "${sources:-}" ]; then
		error
	fi

	for i in $sources; do
		state="$("${PACTL}" get-source-mute $i | cut -d ' ' -f 2)"
		if [ "${state}" != "${new_state:-${state}}" ]; then
			# mute state inconsistent across all sources -> mute all
			mute_all="1"
		fi
		new_state="${state}"
	done

	if [ -n "${mute_all:-}" ]; then
		for i in $sources; do
			"${PACTL}" set-source-mute "${i}" 1
		done
	fi
}

switch_state() {
	for i in $sources; do
		"${PACTL}" set-source-mute "${i}" toggle
		state="$("${PACTL}" get-source-mute $i | cut -d ' ' -f 2)"
		if [ "${state}" = "no" ]; then
			 if "${PLAYERCTL:--}" pause; then
				:
			fi
		fi
	done
}


print_current_status() {
	if [ "${state}" = "yes" ]; then
		micro_state=""
	elif [ "${state}" = "no" ]; then
		#echo "🔴🔴"
		micro_state=""
	else
		error
	fi
	if is_microphone_active; then
		echo "${micro_state}"
	else
		echo "${micro_state}"
	fi
}

is_microphone_active() {
	source_outputs="${source_outputs:-$("${PACTL}" list source-outputs)}"
	if [ -n "${source_outputs:-}" ]; then
		return 0
	else
		return 1
	fi
}

main() {
	PLAYERCTL="$(which playerctl)"
	find_pactl
	if ! is_microphone_active; then
		echo ""
		return
	fi
	check_current_state
	if [ "${BLOCK_BUTTON:-0}" -eq 1 ] || [ -n "${1:-}" ]; then
		switch_state
	fi
	print_current_status
}



trap error EXIT
main "$@"
trap EXIT

