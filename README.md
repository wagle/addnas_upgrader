See the README in https://github.com/wagle/addnas for a master index of repos.

This repo contains the source code for the upgrader for the ADDNAS.

The makefile will successfully build a upgrader tarball, but will fail to produce a installer-installer correctly (known bug).

IMPORTANT: you must do a "make unpack-device-files" first to unpack the device-files from a tarball.
