SET CURDIR=%~dp0
call %CURDIR%findjavahome.cmd

SET STANDALONE_TOOLCHAIN=%CURDIR%ndk\ndk-armeabi

SET ANDROID_SDK=C:\Users\Hakan\AppData\Local\Android\sdk
SET NDK=%ANDROID_SDK%\ndk-bundle
SET ANDROID_NDK=%NDK%

SET PYTHON_HOME=C:\Users\Hakan\AppData\Local\Programs\Python\Python36-32
SET CMAKE_HOME=%ProgramFiles%\CMake

SET OPENCV_SOURCE_CODE_DIR=C:\Users\Hakan\Desktop\opencv-3.2.0

SET CC=clang
SET CXX=clang++
SET CMAKE_C_COMPILER=clang
SET CMAKE_CXX_COMPILER=clang++
SET CMAKE_MAKE_PROGRAM=%STANDALONE_TOOLCHAIN%\bin\make.exe

SET PATH=%PYTHON_HOME%;%NDK%\bin;%JAVA_HOME%\bin;%SystemRoot%\System32;%SystemRoot%
