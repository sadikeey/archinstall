#!/bin/bash

printf '\033c'
echo "#######################################################"
echo "##    Welcome to SDK's arch linux install script.    ##"
echo "#######################################################"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 5/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true

lsblk
echo "###############################################################################################################"
echo "##    Enter drive(/dev/drive_name) and create root(50G+), efi(512M+), home(rest), swap(RAMx2G+) partition:   ##"
echo "###############################################################################################################"
read drive
cfdisk $drive
sleep 2
lsblk -f

echo "######################################################"
echo "##    Enter Root partition as (/dev/drive_name):    ##"
echo "######################################################"
read partition
mkfs.ext4 $partition

echo "#####################################################"
echo "##    Enter EFI partition as (/dev/drive_name):    ##"
echo "#####################################################"
read efipartition
mkfs.vfat -F 32 $efipartition

echo "######################################################"
echo "##    Enter Home partition as (/dev/drive_name):    ##"
echo "######################################################"
read homepartition
mkfs.ext4 $homepartition

echo "######################################################"
echo "##    Enter Swap partition as (/dev/drive_name):    ##"
echo "######################################################"
read swappartition
mkswap $swappartition
swapon $swappartition

mount $partition /mnt
mkdir -p /mnt/boot/EFI
mkdir -p /mnt/home
mount $efipartition /mnt/boot/EFI
mount $homepartition /mnt/home

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cp pkglist.txt /mnt
cp arch_install2.sh /mnt
cp arch_install3.sh /mnt
echo "########################################"
echo "##    Now execute arch_install2.sh    ##"
echo "########################################"
arch-chroot /mnt
exit
