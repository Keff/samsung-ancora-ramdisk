#!/sbin/busybox sh
#Credits:
# Pikachu01 of his ThunderBolt!
# gokhanmoral
# dorimanx
# simone201

mount -o remount,rw /system

MMC=`ls -d /sys/block/mmc*`;
AWAKE=`cat /sys/power/wait_for_fb_wake`;
SLEEPING=`cat /sys/power/wait_for_fb_sleep`;

# Optimize scheduler and readahead
for i in $MMC;
do
	if [ -e $i/queue/nr_requests ]; then
		echo "1024" > $i/queue/nr_requests;
	fi;
	if [ -e $i/queue/iostats ]; then
		echo "0" > $i/queue/iostats;
	fi;
	if [ -e $i/queue/read_ahead_kb ]; then
		echo "256" > $i/queue/read_ahead_kb;
	fi;

done;

# read_ahead_kb tweaks for SD cards
echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
echo "256" > /sys/devices/virtual/bdi/default/read_ahead_kb;

# best to use 512 for read_ahead_kb since ancora storage is 4 GB
echo "512" > /sys/block/mmcblk0/bdi/read_ahead_kb;

# VM tweaks
sysctl -w kernel.sem="250 256000 32 1024";
sysctl -w vm.page-cluster=3;
sysctl -w vm.laptop_mode=0;
sysctl -w vm.overcommit_memory=1;
sysctl -w vm.oom_kill_allocating_task=0;

if [ $AWAKE = "awake" ]; then
	sleep 2;

	sysctl -w vm.dirty_background_ratio=15;
	sysctl -w vm.dirty_ratio=30;
	echo 3000 > /proc/sys/vm/dirty_expire_centisecs;
	echo 500 > /proc/sys/vm/dirty_writeback_centisecs;
	echo 50 > /proc/sys/vm/vfs_cache_pressure;
elif [ $SLEEPING = "sleeping" ]; then
	sleep 2;

	sysctl -w vm.dirty_background_ratio=30;
	sysctl -w vm.dirty_ratio=60;
	echo 6000 > /proc/sys/vm/dirty_expire_centisecs;
	echo 500 > /proc/sys/vm/dirty_writeback_centisecs;
	echo 100 > /proc/sys/vm/vfs_cache_pressure;
fi;

mount -o remount,ro /system
