# [nikarh/a9-cam-reverse](https://github.com/nikarh/docker-images/tree/main/a9-cam-reverse)

[![GitHub](https://img.shields.io/github/license/nikarh/docker-images)](https://github.com/nikarh/docker-images/)
[![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/nikarh/a9-cam-reverse)](https://hub.docker.com/r/nikarh/a9-cam-reverse)

A `node:alpine` image running [cam-reverse](https://github.com/DavidVentura/cam-reverse) - a reverse engineered implementation of the A9 camera protocol, allowing you to control A9 cameras and stream video from them without relying on vendor apps or cloud services.

## 🏗️ Usage

`config.yaml`
```yaml
cameras:
  - name: "Camera 1"
    uid: "XXXX-XXXXXX-XXXXX"
    ip: "192.168.1.100"
```

For detailed configuration options, see the [cam-reverse settings documentation](https://github.com/DavidVentura/cam-reverse/tree/master?tab=readme-ov-file#settings).

`docker-compose.yaml`
```yaml
version: '3.8'
services:
  a9-cam-reverse:
    image: nikarh/a9-cam-reverse
    ports:
      - 8080:8080
    volumes:
      - ./config.yaml:/cam-reverse/config.yaml:ro
```

After starting the container, the web interface will be available at `http://localhost:8080`.

## ⚠️ Automated build

This docker image is rebuilt automatically weekly with latest alpine base image and latest dependencies. This can lead to broken images in case the packages installed are not backward compatible in their configs or behavior.

