#!/sbin/busybox sh
#Credits:
# Pikachu01 of his ThunderBolt!
# gokhanmoral
# simone201

MMC=`ls -d /sys/block/mmc*`;

mount -o remount,rw /system

# Optimize scheduler and readahead
for i in $MMC;
do
	if [ -e $i/queue/nr_requests ]; then
		echo "2048" > $i/queue/nr_requests;
	fi;
	if [ -e $i/queue/iostats ]; then
		echo "0" > $i/queue/iostats;
	fi;
	if [ -e $i/queue/read_ahead_kb ]; then
		echo "256" > $i/queue/read_ahead_kb;
	fi;

done;

echo "256" > /sys/block/mmcblk0/bdi/read_ahead_kb;
echo "256" > /sys/block/mmcblk1/bdi/read_ahead_kb;

# read_ahead_kb tweaks for SD cards
echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
echo "256" > /sys/devices/virtual/bdi/default/read_ahead_kb;

mount -o remount,ro /system
