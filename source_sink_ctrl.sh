#!/bin/sh -x



#Speaker | Headset | GoXLR

GOXLR_CHAT_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*HiFi__goxlr_chat_GoXLRMini__sink"
GOXLR_CHAT="$(pactl list short sinks | grep "$GOXLR_CHAT_PATTERN" | awk '{print $2}')"
if [ -z "$GOXLR_CHAT" ]; then
	GOXLR_CHAT_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*6_7.*_sink"
	GOXLR_CHAT="$(pactl list short sinks | grep "$GOXLR_CHAT_PATTERN" | awk '{print $2}')"
fi
GOXLR_MUSIC_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*HiFi__goxlr_music_GoXLRMini__sink"
GOXLR_MUSIC="$(pactl list short sinks | grep "$GOXLR_MUSIC_PATTERN" | awk '{print $2}')"
if [ -z "$GOXLR_MUSIC" ]; then
	GOXLR_MUSIC_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*2_3.*_sink"
	GOXLR_MUSIC="$(pactl list short sinks | grep "$GOXLR_MUSIC_PATTERN" | awk '{print $2}')"
fi
GOXLR_SYSTEM_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*HiFi__goxlr_system_GoXLRMini__sink"
GOXLR_SYSTEM="$(pactl list short sinks | grep "$GOXLR_SYSTEM_PATTERN" | awk '{print $2}')"
if [ -z "$GOXLR_SYSTEM" ]; then
	GOXLR_SYSTEM_PATTERN="alsa_output.usb-TC-Helicon_GoXLRMini-00.*0_1.*_sink"
	GOXLR_SYSTEM="$(pactl list short sinks | grep "$GOXLR_SYSTEM_PATTERN" | awk '{print $2}')"
fi

CONFIG_DIR="/home/$USER/.config/ssc"
target="${1? Missing HP|headset|XLR}"
mkdir -p "$CONFIG_DIR"

store_pref() {
	application="$1"
	sink_pref="$2"
	sink_name="$(pactl list short sinks | grep ^$sink_pref | awk '{print $2}' )"
	echo "$application.$sink_pref.$sink_name"
	if [ "$sink_name" = "${GOXLR_CHAT}" ]; then
		echo "FOUND $1 for chat"
		echo "${GOXLR_CHAT}" > "${CONFIG_DIR}/$application"
	elif [ "$sink_name" = "${GOXLR_MUSIC}" ]; then
		echo "FOUND $1 for music"
		echo "${GOXLR_MUSIC}" > "${CONFIG_DIR}/$application"
	elif [ "$sink_name" = "${GOXLR_SYSTEM}" ]; then
		echo "FOUND $1 for system"
		echo "${GOXLR_SYSTEM}" > "${CONFIG_DIR}/$application"
	else
		echo "OSEF $1"
	fi
}

to_headset() {
	sink_pattern="alsa_output.usb-GN_Netcom_A_S_Jabra_EVOLVE_20_00014A7141DE07-00.*analog-stereo"
	sink="$(pactl list short sinks | grep "$sink_pattern" | awk '{print $2}')"
	sink_id="$(pactl list short sinks | grep $sink | awk '{print $1}')"
	source_pattern="alsa_input.usb-GN_Netcom_A_S_Jabra_EVOLVE_20_00014A7141DE07-00.*mono-fallback"
	source="$(pactl list short sources | grep $source_pattern | awk '{print $2}')"
	pactl_sink_id="$(pactl -fjson list short sinks | \
		             jq --arg pattern "$sink_pattern" '.[] | select(.name|match($pattern))' | \
		             jq '.index' )"
	if [ -z $pactl_sink_id ]; then
		echo "'${sink}' not found"
		exit 1
	fi
	pactl set-default-sink $sink
	pactl set-default-source $source
	sleep 0.1
	pactl -fjson list sink-inputs | jq -c '.[]' | while read -r i; do
		name="$(printf "%s" "$i" | jq -r '.["properties"]["application.name"]')"
		current_sink="$(printf "%s" "$i" | jq '.["sink"]')"
		current_index="$(printf "%s" "$i" | jq '.["index"]')"
		echo $name $current_sink $current_index
		if [ $current_sink -ne $sink_id ]; then
			store_pref $name $current_sink
			pactl move-sink-input $current_index $sink
		fi
	done
}

to_speaker() {
	sink_pattern="alsa_output.usb-0b0e_Jabra_SPEAK_510_USB_501AA5DE8501020A00-00.*analog-stereo"
	sink="$(pactl list short sinks | grep "$sink_pattern" | awk '{print $2}')"
	sink_id="$(pactl list short sinks | grep "$sink" | awk '{print $1}')"
	source_pattern="alsa_input.usb-0b0e_Jabra_SPEAK_510_USB_501AA5DE8501020A00-00.*mono-fallback"
	source="$(pactl list short sources | grep $source_pattern | awk '{print $2}')"
	pactl_sink_id="$(pactl -fjson list short sinks | \
		             jq --arg pattern "$sink_pattern" '.[] | select(.name|match($pattern))' | \
		             jq '.index' )"
	if [ -z $pactl_sink_id ]; then
		echo "'${sink}' not found"
		exit 1
	fi
	pactl set-default-sink $sink
	pactl set-default-source $source
	sleep 0.1
	pactl -fjson list sink-inputs | jq -c '.[]' | while read -r i; do
		name="$(printf "%s" "$i" | jq -r '.["properties"]["application.name"]')"
		current_sink="$(printf "%s" "$i" | jq '.["sink"]')"
		current_index="$(printf "%s" "$i" | jq '.["index"]')"
		echo $name $current_sink $current_index
		if [ $current_sink -ne $sink_id ]; then
			store_pref $name $current_sink
			pactl move-sink-input $current_index $sink
		fi
	done
}

to_XLR() {
	sink_pattern="alsa_output.usb-TC-Helicon_GoXLRMini-00.*0_1.*_sink"
	sink="$(pactl list short sinks | grep "$sink_pattern" | awk '{print $2}')"
	sink_id="$(pactl list short sinks | grep $sink | awk '{print $1}')"
	source_pattern="alsa_input.usb-TC-Helicon_GoXLRMini-00.*0_1.*_source"
	source="$(pactl list short sources | grep $source_pattern | awk '{print $2}')"
	pactl_sink_id="$(pactl -fjson list short sinks | \
		             jq --arg pattern "$sink_pattern" '.[] | select(.name|match($pattern))' | \
		             jq '.index' )"
	if [ -z $pactl_sink_id ]; then
		echo "'${sink}' not found"
		exit 1
	fi
	pactl set-default-sink $sink
	pactl set-default-source $source
	pactl set-sink-volume $GOXLR_CHAT 100%
	pactl set-sink-volume $GOXLR_MUSIC 100%
	pactl set-sink-volume $GOXLR_SYSTEM 100%
	sleep 0.1
	pactl -fjson list sink-inputs | jq -c '.[]' | while read -r i; do
		name="$(printf "%s" "$i" | jq -r '.["properties"]["application.name"]')"
		current_sink="$(printf "%s" "$i" | jq '.["sink"]')"
		current_index="$(printf "%s" "$i" | jq '.["index"]')"
		echo $name $current_sink $current_index
		if [ -f "$CONFIG_DIR/$name" ]; then
			if ! pactl move-sink-input $current_index "$(cat "$CONFIG_DIR/$name")"; then
				rm "$CONFIG_DIR/$name"
			fi
		fi
	done
}


if [ "$target" = HP ]; then
	to_speaker
elif [ "$target" = headset ]; then
    to_headset
elif [ "$target" = XLR ]; then
    to_XLR
fi
