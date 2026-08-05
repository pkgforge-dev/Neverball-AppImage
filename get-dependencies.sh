#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    physfs   \
    sdl2_ttf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    package=neverball-git
else
    package=neverball
fi
make-aur-package "$package"
pacman -Q "$package" | awk '{print $2; exit}' > ~/version
