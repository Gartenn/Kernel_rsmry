#!/bin/bash
function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 120G
export ARCH=arm64
export KBUILD_BUILD_HOST=GearCI
export KBUILD_BUILD_USER="Gartenn"
git clone --depth=1 https://gitlab.com/clangsantoni/zyc_clang.git clang

make O=out ARCH=arm64 rosemary_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/los-4.9-32/bin:${PATH}:${PWD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/Gartenn/Anykernel3.git -b moon AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Drgnprjktrosemary.zip *
}

compile
zupload
