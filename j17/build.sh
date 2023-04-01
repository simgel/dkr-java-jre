#!/bin/bash

apt update -qq
apt install -qqy binutils

# use jlink to create jre

mkdir -p /opt/image
mkdir -p /opt/image/usr/lib/jvm

MODS=$(cat modules.$1.txt | tr '\n' ',')

echo "# creating jlink version"
echo "mods $MODS"

jlink --verbose \
    --add-modules "$MODS" \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /opt/image/usr/lib/jvm/temurin


echo "# temurin image size: "
du -h -d 1 /opt/image/usr/lib/jvm

echo "# creating image tar"
cd /opt/image
tar -cf /opt/docker/image.tar ./
cd -

echo "# tar content"
tar -tvf /opt/docker/image.tar