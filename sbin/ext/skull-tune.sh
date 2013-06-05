#!/sbin/busybox sh

BB="/sbin/busybox"

mount -o remount,rw /system

# Hacked random and urandom for frandom
mv /dev/random /dev/random.ori
mv /dev/urandom /dev/urandom.ori
ln /dev/frandom /dev/random
chmod 666 /dev/random
ln /dev/erandom /dev/urandom
chmod 666 /dev/urandom

mount -o remount,ro /system
