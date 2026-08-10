#!/bin/bash

cd "$(dirname "$0")" || exit

echo "📦 Scanning debs/ ..."
dpkg-scanpackages -m ./debs /dev/null > Packages

echo "📦 Compressing Packages ..."
gzip -c Packages > Packages.gz
bzip2 -c Packages > Packages.bz2
xz -c Packages > Packages.xz
lzma -c Packages > Packages.lzma

echo "📦 Calculating checksums ..."
MD5_PKG=$(md5sum Packages | cut -d' ' -f1)
MD5_GZ=$(md5sum Packages.gz | cut -d' ' -f1)
MD5_BZ2=$(md5sum Packages.bz2 | cut -d' ' -f1)
MD5_XZ=$(md5sum Packages.xz | cut -d' ' -f1)
MD5_LZMA=$(md5sum Packages.lzma | cut -d' ' -f1)

SHA256_PKG=$(sha256sum Packages | cut -d' ' -f1)
SHA256_GZ=$(sha256sum Packages.gz | cut -d' ' -f1)
SHA256_BZ2=$(sha256sum Packages.bz2 | cut -d' ' -f1)
SHA256_XZ=$(sha256sum Packages.xz | cut -d' ' -f1)
SHA256_LZMA=$(sha256sum Packages.lzma | cut -d' ' -f1)

SIZE_PKG=$(wc -c < Packages | tr -d ' ')
SIZE_GZ=$(wc -c < Packages.gz | tr -d ' ')
SIZE_BZ2=$(wc -c < Packages.bz2 | tr -d ' ')
SIZE_XZ=$(wc -c < Packages.xz | tr -d ' ')
SIZE_LZMA=$(wc -c < Packages.lzma | tr -d ' ')

# ✅ Tạo Release với định dạng giống jjolano
cat > Release << EOF
Origin: KidsDev Repo
Label: KidsDev Repo
Suite: stable
Version: 4.0
Codename: ios
Architectures: iphoneos-arm iphoneos-arm64 iphoneos-arm64e
Components: main
Description: KidsDev Repository
Date: $(date -u +"%a, %d %b %Y %H:%M:%S +0000")

MD5Sum:
 $MD5_PKG $SIZE_PKG Packages
 $MD5_GZ $SIZE_GZ Packages.gz
 $MD5_BZ2 $SIZE_BZ2 Packages.bz2
 $MD5_XZ $SIZE_XZ Packages.xz
 $MD5_LZMA $SIZE_LZMA Packages.lzma

SHA256:
 $SHA256_PKG $SIZE_PKG Packages
 $SHA256_GZ $SIZE_GZ Packages.gz
 $SHA256_BZ2 $SIZE_BZ2 Packages.bz2
 $SHA256_XZ $SIZE_XZ Packages.xz
 $SHA256_LZMA $SIZE_LZMA Packages.lzma
EOF

echo "✅ Done."
cd ..