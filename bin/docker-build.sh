#!/usr/bin/env bash

TAG=$(cat VERSION)

docker build -t mariadb-backup:${TAG} -f Dockerfile .