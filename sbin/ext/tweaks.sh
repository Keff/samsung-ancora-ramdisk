#!/sbin/busybox sh
#Credits:
# Pikachu01 of his ThunderBolt!
# gokhanmoral
# dorimanx
# simone201

# set busybox location
BB="/sbin/busybox"

$BB mount -o rw,remount /system

# Miscellaneous Kernel/VM tweaks
echo 300 64000 64 256 > /proc/sys/kernel/sem
echo "1500" > /proc/sys/vm/dirty_writeback_centisecs
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "60" > /proc/sys/vm/dirty_ratio
echo "3" > /proc/sys/vm/page-cluster
echo "0" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/panic_on_oom
echo "1" > /proc/sys/vm/overcommit_memory
 
$BB mount -o ro,remount /system
