#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    physfs   \
    sdl2_ttf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    package=neverball-git
else
    package=neverball
fi
PRE_BUILD_CMDS='sed -i "s/libjpeg/&.so/g" ./PKGBUILD' make-aur-package "$package"
pacman -Q "$package" | awk '{print $2; exit}' > ~/version
