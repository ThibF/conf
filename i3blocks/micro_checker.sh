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

error() {
	echo ""
	# exiting with another value than 0 prevent the bar to comes up
	exit 0
}


trap error EXIT
LOCAL_PACTL="$HOME/configWorkspace/pulseaudio/utils/pactl"
PACTL="$(which pactl)"
if ! ${PACTL} get-source-mute @DEFAULT_SOURCE@ > /dev/null 2>&1; then
	if ! [ -x "${LOCAL_PACTL}" ]; then
		# install pactl > 15.00
		error
	fi
	PACTL="${LOCAL_PACTL}"
fi

# Check if all sources are in sync
sources="$("${PACTL}" list short sources | grep input | cut -d '	' -f 1)"
if [ -z "${sources:-}" ]; then
	error
fi

for i in $sources; do
	state="$("${PACTL}" get-source-mute $i | cut -d ' ' -f 2)"
	if [ "${state}" != "${new_state:-${state}}" ]; then
		# mute all
		"${PACTL}" list short sources | awk -v PACTL="${PACTL}" '/input/ {system(PACTL " set-source-mute " $1 " 1")}'
	fi
	new_state="${state}"
done


if [ -n "${1:-}" ]; then
	BLOCK_BUTTON=1
fi

if [ "${BLOCK_BUTTON:-0}" -eq 1 ]; then
	"${PACTL}" list short sources | awk -v PACTL="${PACTL}" '/input/ {system(PACTL " set-source-mute " $1 " toggle")}'
	state="$("${PACTL}" get-source-mute $i | cut -d ' ' -f 2)"
        if [ "${state}" = "no" ]; then
             playerctl pause
        fi
fi


if [ "${state}" = "yes" ]; then
	echo ""
elif [ "${state}" = "no" ]; then
	echo ""
else
	error
fi

trap EXIT

