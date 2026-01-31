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

### STEP.1 Read MwVDInfo

if ! ismounted /sys/firmware/efi/efivars; then
	mount -t efivarfs none /sys/firmware/efi/efivars
fi

MwVDInfo="/sys/firmware/efi/efivars/MwVDInfo-d5b8d8f4-3ff0-4b43-81d5-4af802412a84"
#[ -e ${MwVDInfo} ] || sleep 3

if [ -e ${MwVDInfo} ]; then
	VdInfo=""
	while IFS= read -r -d '' substring || [[ $substring ]]; do
		VdInfo+="$substring"
	done < /sys/firmware/efi/efivars/MwVDInfo-d5b8d8f4-3ff0-4b43-81d5-4af802412a84
	for x in $VdInfo; do
		case $x in
		ver=*)
			ver=${x#ver=}
			;;
		partguid=*)
			partguid=$(echo ${x#partguid=} | tr 'A-Z' 'a-z')
			;;
		vdisk=*)
			vdisk=$(echo ${x#vdisk=} | sed -e 's#\\#/#g' | sed -e 's/[[:space:]]*//g')
			;;
		vdtype=*)
			vdtype=${x#vdtype=}
			;;
		fstype=*)
			fstype=${x#fstype=}
			;;
		*)
			;;
		esac
	done

	HOSTDEV=$(blkid -t PARTUUID=${partguid} -o device)
#	HOSTFSTYPE=${fstype}
	VDISKFILE=${vdisk}
	VDTYPE=${vdtype}

### STEP.2 Check HOSTDEV and Mount to /run/initramfs/vds

	if [ -n "$VDISKFILE" ]; then
		NEWROOT="${rootmnt}"
		mkdir -p /run/initramfs/vds
		if [ -z "$HOSTFSTYPE" ]; then
			HOSTFSTYPE="$(blkid -s TYPE -o value "${HOSTDEV}")"
		fi
		if [ ${HOSTFSTYPE} == "ntfs" ]; then
			modprobe ntfs3
			HOSTFSTYPE="ntfs3"
		fi
		mount -t ${HOSTFSTYPE} -o force -o rw ${HOSTDEV} /run/initramfs/vds
#		mount -o rw -o force ${HOSTDEV} /run/initramfs/vds

### STEP.3 Connect vdisk file

#		if [ "${VDISKFILE#/}" != "${VDISKFILE}" ]; then
			modprobe mwvd
#			if [ -z /dev/mwvd0p1 ]; then
				mwsetup -c /dev/mwvd0 /run/initramfs/vds${VDISKFILE}
#			fi
#		fi
	fi
fi

rootok=1
#if [ -z "$root" ]; then
#	root=block:/dev/root
#fi

#need_shutdown
#return 0
