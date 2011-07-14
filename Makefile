all:
	(cd opt ; find upgrader \! -type d -print0 | sort -z | xargs -0 sha1sum > upgrader.MANIFEST)
	(cd opt ; tar cf - upgrader upgrader.MANIFEST) | gzip --best > upgrader.$$(date -u +%Y%m%d-%H%M%S).tar.gz
