#!/bin/sh

sudo apt-get install git gcc g++ build-essential libssl-dev bc

git clone --depth 1 https://github.com/hardkernel/linux -b odroidxu4-4.14.y
cd linux
make odroidxu4_defconfig
make -j8
sudo make modules_install
sudo cp -f arch/arm/boot/zImage /media/boot
sudo cp -f arch/arm/boot/dts/exynos5422-odroid*dtb /media/boot
sync

sudo cp .config /boot/config-`make kernelrelease`
sudo update-initramfs -c -k `make kernelrelease`
sudo mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-`make kernelrelease` /boot/uInitrd-`make kernelrelease`
sudo cp /boot/uInitrd-`make kernelrelease` /media/boot/uInitrd
sync

sudo sync
reboot