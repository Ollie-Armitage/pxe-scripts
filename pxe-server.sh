#!/bin/bash

boot_directory="/services/pxe-server/tftpboot"
iso_directory="/services/pxe-server/isos"

sudo su

echo "Downloading Required Packages"
apt install pxelinux dnsmasq syslinux ufw apache2

echo "Applying firewall settings"
ufw allow http
ufw allow ssh
ufw allow 69/udp

echo "Making folder structure"
mkdir -p $boot_directory/pxelinux.cfg/
mkdir -p $iso_directory

echo "Copying from required library files"
cp /lib/syslinux/modules/efi64/ldlinux.e64 $boot_directory
cp /lib/syslinux/modules/efi64/{libutil,menu}.c32 $boot_directory
cp /lib/SYSLINUX.EFI/efi64/systemlinux.efi $boot_directory
echo "Editing dnsmasq.conf"

echo "port=0 # Disable DNS with port 0
log-dhcp
dhcp-range=192.168.0.1,proxy
dhcp-boot=pxelinux.0
pxe-service=x86PC,'Network Boot',pxelinux
pxe-service=x86-64_EFI, 'UEFI Network Boot', syslinux.efi
enable-tftp
tftp-root=services/pxe-server/tftpboot
log-facility=/var/log/dnsmasq.log" > /etc/dnsmasq.conf


echo "default menu.c32
prompt 0
menu resolution 1024 768
menu title Boot Menu
 label localboot
  menu label Boot Local Disk
  localboot 0
" > $boot_directory/pxelinux.cfg/default


exit

