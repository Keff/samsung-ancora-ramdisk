#!/sbin/busybox sh
#Credits:
#Pikachu01 of his ThunderBolt!

BB="/sbin/busybox"

MMC=`ls -d /sys/block/mmc*`;

$BB mount -o remount,rw /system

# Optimize scheduler and readahead
for i in $MMC;
do
	if [ -e $i/queue/nr_requests ]; then
		echo "1024" > $i/queue/nr_requests;
	fi;
	if [ -e $i/queue/iostats ]; then
		echo "0" > $i/queue/iostats;
	fi;
	if [ -e $i/queue/nomerges ]; then
		echo "1" > $i/queue/nomerges;
	fi;

done;

# read_ahead_kb tweaks for SD cards
echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
echo "256" > /sys/devices/virtual/bdi/default/read_ahead_kb;

# VM tweaks
$BB sysctl -w vm.page-cluster=3;
$BB sysctl -w vm.laptop_mode=0;
$BB sysctl -w vm.overcommit_memory=1;
$BB sysctl -w vm.oom_kill_allocating_task=0;

STATE=`cat /sys/power/wait_for_fb_wake`;
if [ $STATE = "awake" ]; then
	echo 3000 > /proc/sys/vm/dirty_expire_centisecs;
	echo 500 > /proc/sys/vm/dirty_writeback_centisecs;
	echo 50 > /proc/sys/vm/vfs_cache_pressure;
	$BB sysctl -w vm.dirty_background_ratio=15;
	$BB sysctl -w vm.dirty_ratio=30;
elif [ $STATE = "sleep" ]; then
	echo 6000 > /proc/sys/vm/dirty_expire_centisecs;
	echo 500 > /proc/sys/vm/dirty_writeback_centisecs;
	echo 100 > /proc/sys/vm/vfs_cache_pressure;
	$BB sysctl -w vm.dirty_background_ratio=30;
	$BB sysctl -w vm.dirty_ratio=60;
fi;

$BB mount -o remount,ro /system
