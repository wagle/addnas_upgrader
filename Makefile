all:
	cp /root/proj/TSI-prod/NANDBD-phase-2/output/uImage opt/upgrader/phase-1-chroot/var/images/
	cp /root/proj/TSI-prod/1470_Firmware_Source/install_7821TSI/rootfs.arm.ubi opt/upgrader/phase-1-chroot/var/images/
	(cd opt ; find upgrader -type f -print0 | sort -z | xargs -0 sha1sum > upgrader.MANIFEST)
	(tar cf - dev opt/upgrader opt/upgrader.MANIFEST) | gzip --best > upgrader.$$(date -u +%Y%m%d-%H%M%S).tar.gz
	cp -a /root/proj/TSI-prod/NANDBD-phase-2/output/* installer-installer/
	(	cd installer-installer ; \
		mkdir mnt ; \
		mount -o loop mini-rootfs.arm.ext2 mnt ; \
		cp ../opt/upgrader/phase-1-chroot/var/images/{uImage,rootfs.arm.ubi} mnt/var/images ; \
		sync ; \
		umount mnt ; \
		rmdir mnt )
	tar cf - installer-installer | gzip --best > installer-installer.$$(date -u +%Y%m%d-%H%M%S).tar.gz

