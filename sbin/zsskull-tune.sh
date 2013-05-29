#!/sbin/busybox sh

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

# Run Init Scripts
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi;

# frandom hack
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 666 /dev/random
ln /dev/frandom /dev/urandom
chmod 666 /dev/urandom

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
