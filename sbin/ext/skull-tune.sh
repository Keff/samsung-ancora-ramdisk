#!/sbin/busybox sh

mount -o remount,rw /system

# remount partitions with noatime
for k in $(mount | grep relatime | cut -d " " -f3);
do
mount -o remount,noatime,nodiratime,noauto_da_alloc,barrier=0 $k
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
/sbin/busybox sh /sbin/ext/tweaks.sh

mount -o remount,ro /system
