
SET ANDROID_SDK=%HOMEDRIVE%\Android\sdk\
SET ANDROID_NDK=%HOMEDRIVE%%HOMEPATH%\Documents\swdev\ndk\android-ndk-r14
SET NDK=%ANDROID_NDK%
<<<<<<< HEAD
SET PYTHON_HOME=C:\Users\aberger\AppData\Local\Programs\Python\Python36
SET STANDALONE_TOOLCHAIN=%HOMEPATH%\Desktop\ndk
=======
SET PYTHON_HOME=C:\Users\Hakan\AppData\Local\Programs\Python\Python36-32
SET STANDALONE_TOOLCHAIN=C:\Users\Hakan\Desktop\ndk
>>>>>>> env variable changes
SET CMAKE_HOME=C:\Program Files\CMake

SET CC=clang
SET CXX=clang++
SET CMAKE_CXX_COMPILER=clang
SET CMAKE_CXX_COMPILER=clang38++
SET CMAKE_MAKE_PROGRAM=%STANDALONE_TOOLCHAIN%\bin\make.exe

SET PATH=%STANDALONE_TOOLCHAIN%\bin;%CMAKE_HOME%\bin;%PYTHON_HOME%;%NDK%\bin;%SystemRoot%\System32;%SystemRoot%
