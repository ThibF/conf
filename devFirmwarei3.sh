#!/usr/bin/env bash
A=$(i3-msg -t get_workspaces | grep DevFirmware)
lengthA=${#A}
i3-msg 'workspace F2:DevFirmware;'
if [ $lengthA -lt 1 ]; 
then i3-msg 'append_layout ~/.i3/workspaceFirmware.json;'
sleep 0.2
urxvt -e bash -c "sleep 1 && cd /home/thibf/ && /bin/bash && minicom -D /dev/ttyUSB0 -b 115200 -c on" &
sleep 0.1 
urxvt -e bash -c "sleep 1 && cd /home/thibf/drust_tools/embedded/BBNPy/Behave/testSeries && /bin/bash" &
sleep 0.1
urxvt -e bash -c "sleep 1 && cd /home/thibf/drust_tools/embedded/freematics && /bin/bash" &
sleep 0.1
urxvt -e bash -c "sleep 1 && cd /home/thibf/drust_firmware/DRUST/mcu && /bin/bash" &
sleep 0.1
i3-msg 'focus left'
i3-msg 'focus left'
i3-msg 'focus left'
i3-msg 'move up'
fi;

