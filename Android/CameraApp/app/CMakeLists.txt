 cmake_minimum_required(VERSION 3.4.1)

# see https://developer.android.com/studio/projects/add-native-code.html#create-cmake-script ZU FINDEN

message(STATUS "here we should build our jni mushroom lib")

add_library(
             opencvlib


             SHARED


             src/main/openCV/Source.cpp
             )


include("$ENV{OpenCV_DIR}/OpenCVConfig.cmake")

find_library(
              log-lib
              log )

target_include_directories ( opencvlib PUBLIC ${OpenCV_INCLUDE_DIRS} )

target_link_libraries( # Specifies the target library.
                       opencvlib

                       ${log-lib} ${OpenCV_LIBS} )