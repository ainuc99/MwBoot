#!/usr/bin/sh

type getarg > /dev/null 2>&1 || . /lib/dracut-lib.sh

MwVDInfo="/sys/firmware/efi/efivars/MwVDInfo-d5b8d8f4-3ff0-4b43-81d5-4af802412a84"

[ -e ${MwVDInfo} ] || exit 0

GENERATOR_DIR="$2"
[ -z "$GENERATOR_DIR" ] && exit 1

[ -d "$GENERATOR_DIR" ] || mkdir -p "$GENERATOR_DIR"

{
    echo "[Unit]"
    echo "Before=initrd-root-fs.target"
    echo "[Mount]"
    echo "Where=/sysroot"
    echo "What=/dev/root"
} > "$GENERATOR_DIR"/sysroot.mount

exit 0
