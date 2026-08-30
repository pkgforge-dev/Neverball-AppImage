#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/neverball.png
export DESKTOP=/usr/share/applications/neverball.desktop
export STARTUPWMCLASS=neverball
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun /usr/bin/neverball /usr/bin/neverputt /usr/bin/mapc

# Turn AppDir into AppImage
quick-sharun --make-appimage
