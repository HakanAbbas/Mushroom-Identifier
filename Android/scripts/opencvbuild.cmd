
SET OPENCV_DIR=C:\Users\Hakan\Desktop\5AHIF\Diplomarbeit_MushroomIdentifier\opencv-3.2.0

pushd %OPENCV_DIR%
mkdir build
pushd build
cmake -G"MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=%OPENCV_DIR%\platforms\android\android.toolchain.cmake -DCMAKE_MAKE_PROGRAM=%STANDALONE_TOOLCHAIN%\bin\make.exe ..
cmake --build . -- -j8
cmake --build . --target install
popd
popd
