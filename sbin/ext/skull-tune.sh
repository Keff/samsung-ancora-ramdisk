#!/sbin/busybox sh

BB="/sbin/busybox"

mount -o remount,rw /system
$BB mount -t rootfs -o remount,rw rootfs

# Run init scripts
if [ -d /system/etc/init.d ]; then
	chmod 755 /system/etc/init.d/*
	$BB run-parts /system/etc/init.d
fi;

# Frandom hack
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 666 /dev/random
ln /dev/erandom /dev/urandom
chmod 666 /dev/urandom

$BB mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
