# [nikarh/mediafire-bulk-downloader](https://github.com/nikarh/docker-images/tree/main/mediafire-bulk-downloader)

[![GitHub](https://img.shields.io/github/license/nikarh/docker-images)](https://github.com/nikarh/docker-images/)
[![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/nikarh/mediafire-bulk-downloader)](https://hub.docker.com/r/nikarh/mediafire-bulk-downloader)

[Mediafire bulk downloader](https://github.com/NicKoehler/mediafire_bulk_downloader) wrapped in a docker image.

## 🏗️ Usage

```
  docker run --rm
    -v folder:/out \ 
    nikarh/mediafire-bulk-downloader \
    <MEDIAFIRE_URL> -t <THREADS> -o /out
```

## ⚠️ Automated build

This docker image is rebuilt automatically weekly with latest alpine base image and latest dependencies. This can lead to broken images in case the packages installed are not backward compatible in their configs or behavior.
