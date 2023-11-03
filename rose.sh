#!/bin/bash
function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 120G
export ARCH=arm64
export KBUILD_BUILD_HOST=GearCI
export KBUILD_BUILD_USER="Gartenn"
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang

make O=out ARCH=arm64 rosemary_defconfig

PATH="${PWD}/clang/bin:${PATH}"
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabihf- \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/Gartenn/Anykernel3.git -b moon AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Drgnprjkt-rosemary.zip *
}

compile
zupload
