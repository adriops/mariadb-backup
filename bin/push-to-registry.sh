#!/usr/bin/env bash

source bin/.env

buildah push mariadb-backup:${TAG} docker://${REGISTRY}/mariadb-backup:${TAG}
