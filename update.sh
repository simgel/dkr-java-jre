#!/bin/bash

( echo "${SCR_GIT_TOKEN}" | docker login -u ${GITHUB_ACTOR} --password-stdin ghcr.io ) || exit 1

IMAGE="ghcr.io/simgel/dkr-java-jre"
BASEI="ghcr.io/simgel/dkr-java-adoptium"


BASEID=$(docker run --rm "$BASEI:17" cat /opt/dkr-image/simgel/dkr-java-adoptium.id)
IMGID=$(docker run --rm "$IMAGE:17-jre" cat /opt/dkr-image/simgel/dkr-java-adoptium.id)

if [[ "$BASEID" == "$IMGID" ]]; then
    echo ">> no update required for java 17"
else
    echo ">> update required for java 17"
    ./jre.sh 17 jre
fi



BASEID=$(docker run --rm "$BASEI:21" cat /opt/dkr-image/simgel/dkr-java-adoptium.id)
IMGID=$(docker run --rm "$IMAGE:21-jre" cat /opt/dkr-image/simgel/dkr-java-adoptium.id)

if [[ "$BASEID" == "$IMGID" ]]; then
    echo ">> no update required for java 21"
else
    echo ">> update required for java 21"
    ./jre.sh 21 jre
fi
