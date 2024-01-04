#!/bin/sh -ex

cd externals/dynarmic/
git apply --reject --whitespace=fix ../dynarmic-win-arm64.patch
cd ../..

cd externals/cryptopp
git apply --reject --whitespace=fix ../cryptopp-win-arm64.patch
cd ../..

mkdir build
cd build
cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_QT_TRANSLATION=ON \
    -DCITRA_ENABLE_COMPATIBILITY_REPORTING=ON \
    -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON \
    -DUSE_DISCORD_PRESENCE=ON
ninja
ninja bundle

ccache -s -v

ctest -VV -C Release || echo "::error ::Test error occurred on Windows build"
