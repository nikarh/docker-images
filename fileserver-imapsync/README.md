# [nikarh/fileserver-imapsync](https://github.com/nikarh/docker-images/tree/main/fileserver-imapsync)

[![GitHub](https://img.shields.io/github/license/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/nikarh/fileserver-imapsync)](https://hub.docker.com/r/nikarh/fileserver-imapsync)

An `alpine` image with `imapnotify` and `mbsync`, configured specifically to backup emails from Gmail using OAUTH2.

## 🏗️ Usage

`imap.env`
```yaml
USERNAME=myaccount@gmail.com
CLIENT_ID="oauth client id"
CLIENT_SECRET="oauth secret"
REFRESH_TOKEN="oauth refresh token"
```

`docker-compose.yaml`
```yaml
version: '3.8'
secrets:
  IMAP_AUTH:
    file: imap.env
services:
  imapsync:
    image: nikarh/fileserver-imapsync
    user: 1000:1000
    environment:
      # Mail will be synced to /home/${USERNAME}/mail
      # Useful if the volume is also used with dovecot and multiple user mailboxes
      USERNAME: test
    volumes:
      - mail-data:/home
    secrets:
      - IMAP_AUTH

```

## ⚠️ Automated build

This docker image is rebuilt automatically weekly with latest alpine base image and latest dependencies. This can lead to broken images in case the packages installed are not backward compatible in their configs or behavior.

