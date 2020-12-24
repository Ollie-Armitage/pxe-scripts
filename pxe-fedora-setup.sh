#!/bin/bash

iso_directory=/services/pxe-server/isos
boot_directory=/services/pxe-server/tftpboot

echo "Making ISO Directory"

mkdir -p /services/pxe-server/isos

cd $iso_directory

echo "Downloading Image"

wget "https://download.fedoraproject.org/pub/fedora/linux/releases/33/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-33-1.2.iso"

echo "Mounting Image"

mount Fedora-Workstation-Live-x86_64-33-1.2.iso /mnt

echo "Make Image folders in apache folder and tftpboot"

mkdir -p /services/pxe-server/tftpboot/fedora
mkdir -p /var/www/html/fedora

echo "Copy Image files to folder"

cp /mnt/images/pxeboot/* $boot_directory/fedora
cp /mnt/LiveOS/* /var/www/html/fedora

echo "Update menu"



echo "label fedora
  menu label Fedora Workstation Live
  kernel fedora/vmlinuz
  append initrd=fedora/initrd.img boot=live union=overlay components noswap noprompt keyboard-layouts=en locales=en_GB.UTF-8 root=live:http://192.168.0.192/fedora/squashfs.img
" >> $boot_directory/pxelinux.cfg/default

systemctl restart dnsmasq.service
