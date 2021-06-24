#!/bin/bash
export ANDROID_SDK_HOME=/home/xu/Android/Sdk
export ANDROID_NDK_HOME=/home/xu/Android/Sdk/ndk/21.0.6113669

BASE_DIR="$(cd "$(dirname $0)"&& pwd)"
echo "[info] base_dir --> $BASE_DIR"
BUILD_DIR=$BASE_DIR/build
echo "[info] build_dir --> $BUILD_DIR"

TARGET_TRIPLE_BINUTILS=arm-linux-androideabi
TARGET_TRIPLE_COMPILER=armv7a-linux-androideabi
#android 平台最低版本号
API=29
HOST_TAG=linux-x86_64
#二进制接口
ANDROID_ABI=armeabi-v7a

OUTPUT_DIR=$BASE_DIR/output
STATS_DIR=$BASE_DIR/stats
export BUILD_DIR_FFMPEG=$BUILD_DIR/ffmpeg
export BUILD_DIR_EXTERNAL=$BUILD_DIR/external
export INSTALL_DIR=${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}
export PKG_CONFIG_LIBDIR=${INSTALL_DIR}/lib/pkgconfig


# Using Build machine's Make, because Android NDK's Make (before r21) doesn't work properly in MSYS2 on Windows
export MAKE_EXECUTABLE=$(which make)
# Nasm is used for libdav1d and libx264 building. Needs to be installed
export NASM_EXECUTABLE=$(which nasm)
# A utility to properly pick shared libraries by FFmpeg's configure script. Needs to be installed
export PKG_CONFIG_EXECUTABLE=$(which pkg-config)


rm -rf $BUILD_DIR
rm -rf $OUTPUT_DIR
rm -rf $STATS_DIR
mkdir -p $BUILD_DIR
mkdir -p $OUTPUT_DIR
mkdir -p ${STATS_DIR}
echo "[info] current path --> $(pwd)"



export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG
export SYSROOT_PATH=$TOOLCHAIN/sysroot
echo "[info]TOOLCHAIN --> $TOOLCHAIN"
export CC=$TOOLCHAIN/bin/$TARGET_TRIPLE_COMPILER$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET_TRIPLE_COMPILER$API-clang++
export LD=$CC
echo "[info] CC --> $CC"
CROSS_PREFIX_WITH_PATH=$TOOLCHAIN/bin/$TARGET_TRIPLE_BINUTILS-
export AR=${CROSS_PREFIX_WITH_PATH}ar
export NM=${CROSS_PREFIX_WITH_PATH}nm
export RANLIB=${CROSS_PREFIX_WITH_PATH}ranlib
export STRIP=${CROSS_PREFIX_WITH_PATH}strip
export AS=${CROSS_PREFIX_WITH_PATH}as
echo "[info] as --> $AS"
export ADDR2LINE=${CROSS_PREFIX_WITH_PATH}addr2line
export OBJCOPY=${CROSS_PREFIX_WITH_PATH}objcopy
export OBJDUMP=${CROSS_PREFIX_WITH_PATH}objdump
#用于读取可执行文件信息的例如.so库
export READELF=${CROSS_PREFIX_WITH_PATH}readelf
export SIZE=${CROSS_PREFIX_WITH_PATH}size
export STRINGS=${CROSS_PREFIX_WITH_PATH}strings
#禁用汇编关键字asm
EXTRA_BUILD_CONFIGURATION_FLAGS=--disable-asm

function prepareOutput() {
  OUTPUT_LIB=${OUTPUT_DIR}/lib/${ANDROID_ABI}
  mkdir -p ${OUTPUT_LIB}
  cp ${BUILD_DIR_FFMPEG}/${ANDROID_ABI}/lib/*.so ${OUTPUT_LIB}

  OUTPUT_HEADERS=${OUTPUT_DIR}/include/${ANDROID_ABI}
  mkdir -p ${OUTPUT_HEADERS}
  cp -r ${BUILD_DIR_FFMPEG}/${ANDROID_ABI}/include/* ${OUTPUT_HEADERS}
}


function checkTextRelocations() {
  TEXT_REL_STATS_FILE=${STATS_DIR}/text-relocations.txt
  ${READELF} --dynamic ${BUILD_DIR_FFMPEG}/${ANDROID_ABI}/lib/*.so | grep 'TEXTREL\|File' >> ${TEXT_REL_STATS_FILE}

  if grep -q TEXTREL ${TEXT_REL_STATS_FILE}; then
    echo "There are text relocations in output files:"
    cat ${TEXT_REL_STATS_FILE}
    exit 1
  fi
}

export FFMPEG_EXTRA_LD_FLAGS=
DEP_CFLAGS="-I${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/include"
DEP_LD_FLAGS="-L${BUILD_DIR_EXTERNAL}/${ANDROID_ABI}/lib $FFMPEG_EXTRA_LD_FLAGS"

./configure \
  --prefix=${BUILD_DIR_FFMPEG}/${ANDROID_ABI} \
  --enable-cross-compile \
  --target-os=android \
  --arch=arm \
  --sysroot=${SYSROOT_PATH} \
  --cc=${CC} \
  --cxx=${CXX} \
  --ld=${LD} \
  --ar=${AR} \
  --as=${AS} \
  --nm=${NM} \
  --ranlib=${RANLIB} \
  --strip=${STRIP} \
  --extra-cflags="-O3 -fPIC $DEP_CFLAGS" \
  --extra-ldflags="$DEP_LD_FLAGS" \
  --enable-shared \
  --disable-static \
  --pkg-config=${PKG_CONFIG_EXECUTABLE} \
  ${EXTRA_BUILD_CONFIGURATION_FLAGS} \
  --enable-ffmpeg

${MAKE_EXECUTABLE} clean
#开启多个进程编译提高效率
${MAKE_EXECUTABLE} -j$(nproc)
${MAKE_EXECUTABLE} install
checkTextRelocations || exit 1
prepareOutput
