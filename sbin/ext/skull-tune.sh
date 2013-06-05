#!/sbin/busybox sh

BB="/sbin/busybox"

$BB mount -o remount,rw /system

# Remount all partitions with noatime
for k in $($BB mount | grep relatime | cut -d " " -f3);
do
#	sync;
	$BB mount -o remount,noatime $k;
done;

mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /cache /cache;
mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /data /data;

# Hacked random and urandom for frandom
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 666 /dev/random
ln /dev/erandom /dev/urandom
chmod 666 /dev/urandom

# Setting the right script permissions
$BB chmod 755 /system/etc/init.d/*

# Enable good tweaks now, hopefully
$BB sh /sbin/ext/tweaks.sh

$BB mount -o remount,ro /system
