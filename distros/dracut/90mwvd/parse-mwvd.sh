#!/usr/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

#
# AINUC Multiware is using efivars to identify itself, the envirement under multiware
# MUST have the efivars named "MwVDInfo"
# "MwVDInfo" is both the key and the values
# multiware uses text output to shell for convienence
# the first line named version, but it has four CAN'T see chars
# the second line is the other parameters seperated by one space
#
rootok=1
if [ -z "$root" ]; then
	root=block:/dev/root
fi

need_shutdown
#return 0
