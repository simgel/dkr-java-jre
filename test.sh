#!/bin/bash

(docker build --iidfile build.iid --progress=plain --no-cache -f ./j17/Dockerfile.build ./j17) || exit 1
BIID=$(cat build.iid)

(docker run --cidfile build.cid -i "$BIID") || exit 1
BCID=$(cat build.cid)

(docker cp "$BCID:/opt/docker/image.tar" "./j17") || exit 1

rm build.iid build.cid

docker rm "$BCID"
docker rmi "$BIID"

# create new image

(docker build --iidfile build.iid --progress=plain --no-cache -f ./j17/Dockerfile ./j17) || exit 1
BIID=$(cat build.iid)

rm build.iid
rm -f ./j17/image.tar
# docker rmi "$BIID"