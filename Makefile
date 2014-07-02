ROOT:=/root/addnas_source
VERSION:=$(shell sed "s/^\(.*\) \(.*\)/\2_\1/" ../addnas_source/1470_Firmware_Source/buildroot-patches/target/device/Oxsemi/root/target_skeleton/var/lib/current-version)

all:
	cat ../addnas_source/1470_Firmware_Source/buildroot-patches/target/device/Oxsemi/root/target_skeleton/var/lib/current-version
	cp $(ROOT)/NANDBD-phase-2/output/{uImage,stage1.wrapped,u-boot.wrapped} opt/upgrader/phase-1-chroot/var/images/
	cp $(ROOT)/1470_Firmware_Source/install_7821TSI/rootfs.arm.ubi opt/upgrader/phase-1-chroot/var/images/
	(cd opt ; find upgrader -type f -print0 | sort -z | xargs -0 sha1sum > upgrader.MANIFEST)
###	(tar cf - dev opt/upgrader opt/upgrader.MANIFEST) | gzip --best > upgrader.$$(date -u +%Y%m%d-%H%M%S).tar.gz
	(tar cf - dev opt/upgrader opt/upgrader.MANIFEST) | gzip --best > upgrader.$(VERSION).tar.gz
	mkdir installer-images.$(VERSION)
	cp $(ROOT)/NANDBD-phase-2/output/* installer-images.$(VERSION)
	cp $(ROOT)/1470_Firmware_Source/install_7821TSI/rootfs.arm.ubi installer-images.$(VERSION)



installer-installer:
	cp -a $(ROOT)/NANDBD-phase-2/output/* installer-installer/
	(	cd installer-installer ; \
		mkdir mnt ; \
		mount -o loop mini-rootfs.arm.ext2 mnt ; \
		cp ../opt/upgrader/phase-1-chroot/var/images/{uImage,rootfs.arm.ubi} mnt/var/images ; \
		sync ; \
		umount mnt ; \
		rmdir mnt )
	tar cf - installer-installer | gzip --best > installer-installer.$$(date -u +%Y%m%d-%H%M%S).tar.gz

