# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

 cmake_minimum_required(VERSION 3.4.1)

 add_definitions( -Wall -O2 -fexceptions )

# Specifies a library name, specifies whether the library is STATIC or
# SHARED, and provides relative paths to the source code. You can
# define multiple libraries by adding multiple add.library() commands,
# and CMake builds them for you. When you build your app, Gradle
# automatically packages shared libraries with your APK.

# ERKLÄRUNG FÜR EINZELNE SCHRITTE ALLE UNTER https://developer.android.com/studio/projects/add-native-code.html#create-cmake-script ZU FINDEN

add_library( # Sets the name of the library.
             openlib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             # Associated headers in the same location as their source
             # file are automatically included.
             src/main/openCV/Source.cpp )


include("$ENV{OpenCV_DIR}/OpenCVConfig.cmake")

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

target_include_directories ( openlib PUBLIC ${OpenCV_INCLUDE_DIRS} "C:/Program Files/boost/boost_1_60_0" )

target_link_libraries( # Specifies the target library.
                       openlib

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib} ${OpenCV_LIBS} "C:/Program Files/boost/boost_1_60_0/stage/lib" )
