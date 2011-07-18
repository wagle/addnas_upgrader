all:
	(cd opt ; find upgrader -type f -print0 | sort -z | xargs -0 sha1sum > upgrader.MANIFEST)
	(tar cf - dev opt/upgrader opt/upgrader.MANIFEST) | gzip --best > upgrader.$$(date -u +%Y%m%d-%H%M%S).tar.gz
