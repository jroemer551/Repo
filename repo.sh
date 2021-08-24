#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release

apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
        -o APT::FTPArchive::Release::Origin="Sileo" \
        -o APT::FTPArchive::Release::Label="Sileo" \
        -o APT::FTPArchive::Release::Suite="stable" \
        -o APT::FTPArchive::Release::Version="2.0" \
        -o APT::FTPArchive::Release::Codename="ios" \
        -o APT::FTPArchive::Release::Architectures="iphoneos-arm" \
        -o APT::FTPArchive::Release::Components="main" \
        -o APT::FTPArchive::Release::Description="Sileo for Checkra1n and Unc0ver" \
        release . > Release
git add .
git commit -m "add package"
git push