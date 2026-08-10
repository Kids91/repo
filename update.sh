#!/bin/bash
# ✅ Vào thư mục repo

echo Scan tất cả .deb files trong thư mục deb/
dpkg-scanpackages -m ./debs /dev/null > Packages

echo Nén thành Packages.gz
bzip2 -c Packages > Packages.bz2

echo Nén thành Packages.bz2
gzip -c Packages > Packages.gz

echo "MD5Sum:" >> Release
md5sum Packages.gz >> Release

echo "SHA256:" >> Release
sha256sum Packages.gz >> Release

echo ✅ Done.
cd ..
