![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)

# Craft 3 Docker

This is a [Craft 3](https://craftcms.com) base running on Apache with PostgreSQL and Memcached. Much of it has been ported from [wyveo/craftcms-docker](https://github.com/wyveo/craftcms-docker) which runs on NGINX.

## Versioning

| Docker Tag | Git Branch | Craft Release | Database | Caching |
|-----|-------|-----|--------|--------|
| latest | master | 3.0.1 | PostgreSQL 10.0 | Memcached 1.5.0 |

## Features:

 - Apache, PHP 7.2.x, Git 2.11.0
 - imageMagick image manipulation library

## Clone repo and run

To run, clone the git repo and run `docker-compose up`:
```
$ git clone https://github.com/gruner/craftcms3-docker.git
$ cd craftcms3-docker
$ docker-compose up
```

## Craft installation

navigate to `http://<HOSTNAME>/admin` to begin installing Craft.

When asked for the DB Server, enter `postgres`. This is the the network alias defined in `docker-compose.yaml`.
