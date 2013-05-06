#!/bin/sh

#IMPORTANT PATCH for NDK: kbdwin.c
# include "malloc.h"
# function ff_kbd_window_init()  local_window was malloced, instead allocation of local stack !!!!
#

#edit configure script like this:
#enabled libstagefright && require_cpp libstagefright_h264 "binder/ProcessState.h media/stagefright/MetaData.h

export TMPDIR=D:/android-sdk-windows/temp
NDK=D:/android-sdk-windows/android-ndk-r7
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt/windows
PLATFORM=$NDK/platforms/android-9/arch-arm
SYSROOT=$NDK/platforms/android-9/arch-arm
ANDROID_SOURCE=../android-source
ANDROID_LIBS=../android-libs
TOOLCHAIN=`echo $NDK/toolchains/arm-linux-androideabi-4.6/prebuilt/windows`
export PATH=$TOOLCHAIN/bin:$PATH

FLAGS="--target-os=linux --arch=arm --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- --sysroot=$SYSROOT  --enable-pic --enable-cross-compile "
FLAGS="$FLAGS --disable-avdevice --enable-static --disable-shared --disable-ffplay --disable-doc --disable-ffmpeg --disable-ffprobe --disable-ffserver --disable-avfilter --disable-encoders --disable-muxers --disable-encoders --disable-filters --disable-devices --disable-debug --disable-network --disable-everything"
FLAGS="$FLAGS --enable-decoder=h264 --enable-decoder=aac --enable-decoder=aac_latm --enable-demuxer=mpegts --enable-decoder=mpegvideo --enable-decoder=mpeg1video --enable-decoder=mpeg2video --enable-decoder=mp1 --enable-decoder=mp2 --enable-decoder=mp3 --enable-decoder=dvbsub --enable-decoder=ac3 --enable-parser=ac3 --enable-decoder=eac3 --enable-decoder=dca --enable-parser=dca --enable-parser=mpegvideo --enable-parser=mpegaudio --enable-parser=dvbsub --enable-parser=h264 --enable-parser=aac --enable-parser=aac_latm --enable-protocol=file"

EXTRA_CFLAGS="-I$NDK/sources/cxx-stl/system/include -fPIC -DANDROID"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include -I$ANDROID_SOURCE/system/core/include"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/media/libstagefright"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include/media/stagefright/openmax"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/hardware/libhardware/include"

#Support armv5
#FLAGS="$FLAGS --enable-armv5te"

#Support armv7-a and neon
EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"

#Support armv7-a and non-neon (Tegra 2)
#EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"

#EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS"
#EXTRA_CXXFLAGS="-Wno-multichar -fno-exceptions -fno-rtti"


#echo $SYSROOT $TOOLCHAIN $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" > info.txt
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" | tee configuration.txt
[ $PIPESTATUS == 0 ] || exit 
