#!/usr/bin/env bash
A=$(i3-msg -t get_workspaces | grep Eclipse)
lengthA=${#A}
i3-msg 'workspace F3:Eclipse;'
if [ $lengthA -lt 1 ]; 
then sleep 0.1
/home/thibf/Ac6/SystemWorkbench/eclipse
fi;

