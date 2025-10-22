# [docker-images](https://github.com/nikarh/docker-images)

![GitHub](https://img.shields.io/github/license/nikarh/docker-images)
![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)

This repository contains a collection of Dockerfiles I use mostly for my home server.
All images are built and pushed to the docker hub on push to main and every Sunday without any caching to make sure that they always have the latest Alpine and dependencies.

Images target the following platforms:

- linux/amd64
- linux/arm64
- linux/arm/v7

## Images

- [nikarh/fileserver-imapsync](fileserver-imapsync/README.md)
- [nikarh/fileserver-libreddit](fileserver-libreddit/README.md)
- [nikarh/fileserver-rclone](fileserver-rclone/README.md)
- [nikarh/fileserver-samba](fileserver-samba/README.md)
- [nikarh/fileserver-sftpd-backup](fileserver-sftpd-backup/README.md)
- [nikarh/mediafire-bulk-downloader](mediafire-bulk-downloader/README.md)
- [nikarh/a9-cam-reverse](a9-cam-reverse/README.md)
- [nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone](ha_bambu_lab_p1_spaghetti_detection_standalone/README.md)

## License

This project is licensed under the [MIT License](LICENSE), except for the `ha_bambu_lab_p1_spaghetti_detection_standalone` component, which is licensed under the [GNU General Public License v3.0](ha_bambu_lab_p1_spaghetti_detection_standalone/LICENSE).
