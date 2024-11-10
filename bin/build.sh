#!/usr/bin/env bash

source bin/.env

buildah build -f Containerfile -t mariadb-backup:${TAG} .
