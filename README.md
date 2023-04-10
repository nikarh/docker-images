# docker-images

This repository contains a collection of Dockerfiles I use mostly for my home server.
All images are built and pushed to the docker hub on push to main and every Sunday without any caching to make sure that they always have the latest Alpine and dependencies.

Images target the following platforms:

- linux/amd64
- linux/arm64
- linux/arm/v7

## Images

- [nikarh/fileserver-imapsync](imapsync/README.md)
- [nikarh/fileserver-rclone](rclone/README.md)
- [nikarh/fileserver-samba](samba/README.md)
- [nikarh/fileserver-sftpd-backup](sftpd-backup/README.md)
- [nikarh/mediafire-bulk-downloader](mediafire-bulk-downloader/README.md)
