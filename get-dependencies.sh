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

# Comment this out if you need an AUR package
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#    package=neverball-git
#else
#    package=neverball
#fi
#PRE_BUILD_CMDS='sed -i "s/libjpeg/&.so/g" ./PKGBUILD' make-aur-package "$package"
#pacman -Q "$package" | awk '{print $2; exit}' > ~/version

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
    wget https://neverball.org/neverball-1.6.0.tar.gz
    tar -xvf neverball-1.6.0.tar.gz -C ./Neverball
fi
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
