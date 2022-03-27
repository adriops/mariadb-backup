#!/usr/bin/env bash

TAG=$(cat VERSION)

docker tag -t mariadb-backup:${TAG} sevenops/mariadb-backup:${TAG}
docker push sevenops/mariadb-backup:${TAG}
docker rmi mariadb-backup:${TAG}
