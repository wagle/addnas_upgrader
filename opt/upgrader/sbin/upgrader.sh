#!/bin/sh

# exit codes:
#   1	wrong number of arguments
#   2	too few external disks
#   3	too many external disks
#   4	external disk is not /dev/sda1
#   5	unsupported filesystem on disk
#   6	bad mount point path name
#   7	path unpacked in wrong place
#   8	no MANIFEST
#   9	MANIFEST not matched
#  11	couldn't make a backup
#  10	reflash phase 1 had an error

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

###
### argument count
###
echo "counting args"
if [ $# != 0 ]; then
	exit 1
fi

###
### external disk count
###
echo "counting external disks"
set $(df | grep /shares/external | wc -l)
case $1 in
0)	exit 2;;
1)	;;
*)	exit 3;;
esac

###
### partition device, filesystem type, and mount-point
###
# df returns as output:
# /dev/sda1     ext3    7.4G  146M  6.9G   3% /shares/external/Lexar-USB-Flash-Drive/Partition-1
echo "checking partition device/type/mount-point"
set $(df -T $0 | tail -1)
if [ $1 != "/dev/sda1" ] ; then
	exit 4
fi
case $2 in
ext3)	;;
xfs)	;;
*)	exit 5;;
esac
case $7 in
/shares/external/*/Partition-1)
	;;
*)
	exit 6
	;;
esac

###
### check full path name
###
echo "check full path name"
case $0 in
$7/opt/upgrader/sbin/upgrader.sh)
	;;
*)
	exit 7
	;;
esac

###
### find manifest
###
### takes too long on the poor little arm
###
#echo "checking manifest"
#if [ ! -e $7/opt/upgrader.MANIFEST ] ; then
#	exit 8
#fi
#if ! (cd $7/opt ; find upgrader \! -type d -print0 | sort -z | xargs -0 sha1sum | diff - upgrader.MANIFEST); then
#	exit 9
#fi

###
### make a backup
###

/etc/init.d/tsi-archiver /shares/external/*/Partition-1 init

if ! /etc/init.d/tsi-archiver /shares/external/*/Partition-1 backup "[Pre-Upgrade Backup]" ; then
	exit 11	
fi

###
### run the upgrader
###
echo now upgrading stage1, u-boot, and kernel
chroot /shares/external/*/Partition-1/opt/upgrader/phase-0-chroot /do-upgrader
exit 10
