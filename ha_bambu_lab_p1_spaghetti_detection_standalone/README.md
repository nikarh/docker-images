# [nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone](https://github.com/nikarh/docker-images/tree/main/ha_bambu_lab_p1_spaghetti_detection_standalone)

[![GitHub](https://img.shields.io/github/license/nikarh/docker-images)](https://github.com/nikarh/docker-images/)
[![GitHub Repo stars](https://img.shields.io/github/stars/nikarh/docker-images)](https://github.com/nikarh/docker-images)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone)](https://hub.docker.com/r/nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone)

A patched version of the [Bambu Lab Spaghetti Detection](https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection) standalone ML server for Home Assistant integration.

This image is based on the upstream `Dockerfile.standalone.base` but includes a couple of patches.

## 🔧 Patches Applied

- **Increased connection timeout**: Changed read timeout from `0.1s` to `1s` to prevent TLS handshake failures when Home Assistant is running on different hardware than this ML server
- **Updated base image**: Bumped from `thespaghettidetective/ml_api_base:1.3` to `1.4`

## 🏗️ Usage

### Docker Run

```bash
docker run -d \
  --name bambu_spaghetti_detection \
  --restart unless-stopped \
  -p 3333:3333 \
  -e ML_API_TOKEN=your_secure_token_here \
  nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  bambu-spaghetti-detection:
    image: nikarh/ha_bambu_lab_p1_spaghetti_detection_standalone:latest
    container_name: bambu_spaghetti_detection
    restart: unless-stopped
    ports:
      - "3333:3333"
    environment:
      - ML_API_TOKEN=your_secure_token_here
      - TZ=Europe/London
```

## 🔑 Configuration

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `ML_API_TOKEN` | Authentication token for API access | `obico_api_secret` |
| `TZ` | Timezone | `UTC` |

## 📡 Integration

This ML server integrates with the [Bambu Lab Home Assistant Integration](https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection) to provide real-time spaghetti detection for your Bambu Lab 3D printer.

1. Start this container
2. Configure the Home Assistant integration to point to `http://<your-server-ip>:3333`
3. Use the same `ML_API_TOKEN` value in both the container and the Home Assistant integration


## 📝 Credits

- Original project: [nberktumer/ha-bambu-lab-p1-spaghetti-detection](https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection)
- ML engine: [Obico/TheSpaghettiDetective](https://github.com/TheSpaghettiDetective/obico-server)

## ⚠️ Automated build

This docker image is rebuilt automatically weekly with latest alpine base image and latest dependencies. This can lead to broken images in case the packages installed are not backward compatible in their configs or behavior.

