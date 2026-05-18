# [nikarh/fileserver-sftpd-backup](https://github.com/nikarh/docker-images/tree/main/fileserver-sftpd-backup)

[![GitHub](https://img.shields.io/github/license/nikarh/docker-images)](https://github.com/nikarh/docker-images/)
[![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/nikarh/fileserver-sftpd-backup)](https://hub.docker.com/r/nikarh/fileserver-sftpd-backup)

This image can be used to make daily backups of your data.
You can mount something to a `/volumes` folder. Each folder inside will be treated as a candidate for a backup, e.g. if you have `/volumes/A`, `/volumes/B` and `/volumes/C`, then `A`, `B` and `C` will be considered separate entities.
Each candidate for a backup will be tar-zipped, a timestamp will be appended to a filename, and a file will be copied to the SFTP server. This tool will try to keep only the latest N number of backups per candidate.
Backups are scheduled with [Supercronic](https://github.com/aptible/supercronic), using the latest Supercronic release available when the image is built.

## 🏗️ Usage

```yaml
version: '3.8'
secrets:
  SSH_KEY:
    file: my_ssh_key
services:
  samba:
    image: nikarh/fileserver-sftpd-backup
    environment:
      MAXIMUM_BACKUP_NUMBER: 3 # Keep only 3 latest archives per volume
      BACKUP_ALL_CRON: "0 0 * * *" # Run backup_all once a day at midnight
      SFTP_HOST: localhost
      SFTP_PORT: 22
      SFTP_USER: backup
      SFTP_ROOT: /data/server
    volumes:
      # Volumes to backup
      - volume1:/volumes/volume1:ro
      - volume2:/volumes/volume2:ro
    secrets:
      - SSH_KEY
```

## ⏱️ Schedule

`backup_all` runs once a day by default with this cron expression:

```cron
0 0 * * *
```

Set `BACKUP_ALL_CRON` to change the schedule. The value must be a standard five-field cron expression understood by Supercronic.

For example, run every 6 hours:

```yaml
environment:
  BACKUP_ALL_CRON: "0 */6 * * *"
```

## ⚠️ Automated build

This docker image is rebuilt automatically weekly with latest alpine base image and latest dependencies. This can lead to broken images in case the packages installed are not backward compatible in their configs or behavior.
