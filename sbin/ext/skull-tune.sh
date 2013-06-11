#!/sbin/busybox sh

# set busybox location
BB="/sbin/busybox"

$BB mount -o rw,remount /system

# remount partitions with noatime
for k in $($BB mount | grep relatime | cut -d " " -f3);
do
	$BB mount -o remount,noatime $k;
done;

# Setting the right script permissions
chmod 755 /system/etc/init.d/*

# Hacked random and urandom for frandom
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 666 /dev/random
ln /dev/erandom /dev/urandom
chmod 666 /dev/urandom

# Early-init phase tweaks
$BB sh /sbin/ext/tweaks.sh

$BB mount -o ro,remount /system
