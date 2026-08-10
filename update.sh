#!/bin/bash

echo "Scan tất cả .deb files trong thư mục debs/"
dpkg-scanpackages -m ./debs /dev/null > Packages

echo "Nén thành Packages.bz2"
bzip2 -c Packages > Packages.bz2

echo "Nén thành Packages.gz"
gzip -c Packages > Packages.gz

# ✅ Lấy checksum
MD5=$(md5sum Packages.gz | cut -d' ' -f1)
SHA256=$(sha256sum Packages.gz | cut -d' ' -f1)
SIZE=$(stat -f%z Packages.gz)

echo "MD5: $MD5"
echo "SHA256: $SHA256"
echo "Size: $SIZE"

# ✅ Ghi Release - Nếu file chưa có, tạo mới
if [ ! -f Release ]; then
    echo "Origin: KidsDev Repo" > Release
    echo "Label: KidsDev Repo" >> Release
    echo "Suite: stable" >> Release
    echo "Version: 4.0" >> Release
    echo "Codename: kidsdev" >> Release
    echo "Architectures: iphoneos-arm" >> Release
    echo "Components: main" >> Release
    echo "Description: KidsDev Repository" >> Release
    echo "Icon: file://CydiaIcon.png" >> Release
    echo "Acquire-By-Hash: yes" >> Release
fi

# ✅ Thêm checksum (ghi đè phần cũ nếu có)
echo "" >> Release
echo "MD5Sum:" >> Release
echo " $MD5 $SIZE Packages.gz" >> Release
echo "" >> Release
echo "SHA256:" >> Release
echo " $SHA256 $SIZE Packages.gz" >> Release

echo "✅ Done."
cd ..