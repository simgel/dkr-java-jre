#!/bin/bash

IMAGE="ghcr.io/simgel/dkr-java-jre:$1-$2"

(docker build --iidfile build.iid --progress=plain --no-cache -f "./j$1/Dockerfile.build" "./j$1") || exit 1
BIID=$(cat build.iid)

(docker run --cidfile build.cid -i "$BIID") || exit 1
BCID=$(cat build.cid)

(docker cp "$BCID:/opt/docker/image.tar" "./j$1") || exit 1

rm build.iid build.cid

docker rm "$BCID"
docker rmi "$BIID"

# create new image

(docker build --iidfile build.iid --progress=plain --no-cache -t "$IMAGE" -f "./j$1/Dockerfile" "./j$1") || exit 1
BIID=$(cat build.iid)""

rm build.iid
rm -f "./j$1/image.tar"

( docker push "$IMAGE" ) || exit 1
docker rmi "$BIID"