#!/usr/bin/bash

umount_vd() {
    warn "Umounting oldroot"
    umount -f /oldroot | (while read l; do warn "$l"; done)
    warn "Umounting nbd device"
    mw-nbd -d "/dev/nbd0" | (while read l; do warn "$l"; done)
    warn "Umounting host mount point"
    umount /oldsys/run/host | (while read l; do warn "$l"; done)
}

umount_vd
