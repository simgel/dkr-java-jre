#!/bin/bash

( echo "${SCR_GIT_TOKEN}" | docker login -u ${GITHUB_ACTOR} --password-stdin ghcr.io ) || exit 1

./jre.sh 17 jre
./jre.sh 20 jre