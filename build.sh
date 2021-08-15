#Set Variables
export CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64

#Install tools
sudo apt-get -y install git build-essential binutils-multiarch crossbuild-essential-arm64 device-tree-compiler fakeroot libncurses5-dev libssl-dev ccache bison flex libelf-dev dwarves

##To build RPM Packages
sudo apt-get -y install rpm

#Download kernel sources
##Master
git clone --depth=1 https://github.com/msm8916-mainline/linux
cd linux

#Apply Patches and fixes
git apply --ignore-whitespace ../patches/*.patch

#Kernel Config
make msm8916_defconfig pmos.config

#Build
# Example : 
#Command : ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make KERNELRELEASE="5.14-sunxi64" KDEB_PKGVERSION="5.14~rc3+sunxi64-0.1" -j64 bindeb-pkg
#Output : linux-image-$(KERNELRELEASE)_$(KDEB_PKGVERSION)_$(ARCH).deb

make KERNELRELEASE="5.14.0-rc4-postmarketos-qcom-msm8916" KDEB_PKGVERSION="5.14.0-rc4-postmarketos-qcom-msm8916-0.1" -j$(nproc) bindeb-pkg
make KERNELRELEASE="5.14.0-rc4-postmarketos-qcom-msm8916" KDEB_PKGVERSION="5.14.0-rc4-postmarketos-qcom-msm8916-0.1" -j$(nproc) binrpm-pkg

#Github artifact
cd ..
tar -cf kernel-deb.tar *.deb *.buildinfo *.changes
tar -cf kernel-rpm.tar ~/rpmbuild/RPMS/aarch64/*
