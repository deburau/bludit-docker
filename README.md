# deburau/bludit-docker

[![badge1](https://img.shields.io/docker/pulls/deburau/bludit?logo=appveyor)](https://hub.docker.com/r/deburau/grav)
[![badge2](https://github.com/deburau/bludit-docker/workflows/ci/badge.svg)](https://hub.docker.com/r/deburau/grav)

# What is this repository?

This repository is a fork of [laugmanuel/bludit-docker](https://github.com/laugmanuel/bludit-docker) and serves as a base for the `deburau/bludit` Docker image: https://github.com/deburau/bludit-docker

The image uses a sane nginx config from [h5bp](https://github.com/h5bp/server-configs-nginx) and some modified settings based on [Bludit Nginx config](https://docs.bludit.com/en/webservers/nginx).

# Differences from [laugmanuel/bludit-docker](https://github.com/laugmanuel/bludit-docker)

- Does *not* automatically use the latest Bludit version 
- The Bludit source is only extracted once when the container is created and not on every restart
- Updates to new versions and Bludit PRO can be applied
- The command to run in the container can be given on the command line, i.e. you can start a shell in the container

# Information

- `FROM: alpine:stable`
- Nginx
- PHP7 + FPM

The image uses the `nginx` user with id `555`.

# Examples

## Start a new container

```sh
docker run \
  -d \
  --name bludit-test \
  -p 8080:8080 \
  -v $(pwd)/html:/usr/share/nginx/html \
  deburau/bludit:latest
```

## Start a shell in the running container

```sh
docker exec -it bludit-test sh
```

## Start a new container with Bludit PRO

```sh
docker run \
  -d \
  --name bludit-test \
  -p 8080:8080 \
  -v $(pwd)/html:/usr/share/nginx/html \
  deburau/bludit:latest \
  -u <url-of-bludit-pro.zip>
```

## Use cocker-compose to start the container

```yaml
version: '3.7'
services:
  bludit:
    image: deburau/bludit:latest
    container_name: bludit
    restart: unless-stopped
    volumes:
      - ./html:/usr/share/nginx/html
```

```sh
docker-compose up -d
```

## Use cocker-compose to start the container with Bludit PRO

```yaml
version: '3.7'
services:
  bludit:
    image: deburau/bludit:latest
    container_name: bludit
    restart: unless-stopped
    volumes:
      - ./html:/usr/share/nginx/html
    environment:
      - SOURCE_ARCHIVE
      - UPGRADE
```

```sh
UPGRADE=1 SOURCE_ARCHIVE=<url-of-bludit-pro.zip> docker-compose up -d
```

## Running Bludit PRO behind a traefik reverse proxy

```yaml
version: '3.7'
services:
  bludit:
    image: deburau/bludit:latest
    container_name: bludit
    restart: unless-stopped
    networks:
      traefik:
    volumes:
      - ./html:/usr/share/nginx/html
    environment:
      - SOURCE_ARCHIVE
      - UPGRADE
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik"
      - "traefik.http.routers.bludit.rule=Host(`bludit.example.com`)"
      - "traefik.http.routers.bludit.entrypoints=websecure"
      - "traefik.http.routers.bludit.tls=true"
      - "traefik.http.routers.bludit.tls.domains[0].main=bludit.example.com"
      - "traefik.http.routers.bludit.service=bludit"
      - "traefik.http.services.bludit.loadbalancer.server.port=8080"
      - "traefik.http.services.bludit.loadbalancer.server.scheme=http"
      - "traefik.http.services.bludit.loadbalancer.passhostheader=true"

networks:
  traefik:
    external: true
```

```sh
UPGRADE=1 SOURCE_ARCHIVE=<url-of-bludit-pro.zip> docker-compose up -d
```
