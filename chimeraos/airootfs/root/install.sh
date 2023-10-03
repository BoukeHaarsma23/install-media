#! /bin/bash

if [ $EUID -ne 0 ]; then
    echo "$(basename $0) must be run as root"
    exit 1
fi

dmesg --console-level 1

gamescope -- ./chimeraos-installer.x86_64

bash -i

