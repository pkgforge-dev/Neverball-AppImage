#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    physfs    \
    sdl2_ttf  \
    xdg-utils

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Neverball..."
echo "---------------------------------------------------------------"
REPO="https://github.com/Neverball/neverball"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of Neverball..."
    echo "---------------------------------------------------------------"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone "$REPO" ./Neverball
else
    echo "Making stable build of Neverball..."
    echo "---------------------------------------------------------------"
    VERSION=1.6.0
    wget https://neverball.org/neverball-$VERSION.tar.gz
    mkdir -p ./Neverball && tar -xvf neverball-$VERSION.tar.gz --strip-components=1 -C ./Neverball
fi
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Neverball
if [ "${DEVEL_RELEASE-}" != 1 ]; then
    sed -i 's/^char text_input\[MAXSTR\];/extern char text_input[MAXSTR];/' share/text.h
    sed -i '/^ifeq ($(ENABLE_FS),stdio)/iENABLE_FS := stdio' Makefile
fi
make CPPFLAGS="${CPPFLAGS:-} -DNDEBUG" CFLAGS="${CFLAGS:-} -fcommon" -j$(nproc)
mv -v neverball neverputt mapc locale data ../AppDir/bin
