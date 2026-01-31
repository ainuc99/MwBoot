#!/usr/bin/bash

# called by dracut
check() {
    require_binaries mwsetup || return 1
    return 255
}

# called by dracut
installkernel() {
    hostonly='' instmods mwvd ntfs3 exfat efivar
    return 0
}

depends() {
#    echo rootfs-block
    return 0
}


install() {
    inst_multiple mwsetup 
#    inst_hook cmdline 90 "$moddir/parse-mwvd.sh"
    inst_hook initqueue/settled 80 "$moddir/mwvd-settled.sh"
#    inst_hook pre-mount 90 "$moddir/mwvd-settled.sh"
#    if dracut_module_included "systemd-initrd"; then
#	inst_script "$moddir/vd-generator.sh" "$systemdutildir"/system-generators/dracut-vd-generator
#    fi
    dracut_need_initqueue
}
