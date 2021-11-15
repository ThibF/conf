#!/bin/sh

if redshift -p | grep Period | grep -q Night; then
	if hueadm group 2 on > /dev/null; then
		echo 
	else
		echo 
	fi
else
	if hueadm group 2 off > /dev/null; then
		echo 
	else
		echo 
	fi
fi