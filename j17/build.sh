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

# setting up links
mkdir -p /opt/image/etc/alternatives
cd /opt/image/etc/alternatives
ln -s /usr/lib/jvm/temurin/bin/java ./java
ln -s /usr/lib/jvm/temurin/bin/keytool ./keytool
ln -s /usr/lib/jvm/temurin/bin/rmiregistry ./rmiregistry
ln -s /usr/lib/jvm/temurin/bin/jrunscript ./jrunscript
cd -

mkdir /opt/image/usr/bin
cd /opt/image/usr/bin
ln -s /etc/alternatives/java ./java
ln -s /etc/alternatives/keytool ./keytool
ln -s /etc/alternatives/rmiregistry ./rmiregistry
ln -s /etc/alternatives/jrunscript ./jrunscript
cd -

# creatig output tar
echo "# creating image tar"
cd /opt/image
tar -cf /opt/docker/image.tar ./
cd -

echo "# tar content"
tar -tvf /opt/docker/image.tar