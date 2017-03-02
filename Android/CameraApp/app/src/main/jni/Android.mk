LOCAL_PATH := $(call my-dir)

include C:/Users/Hakan/Downloads/OpenCV-android-sdk/sdk/native/jni/OpenCV.mk

include $(CLEAR_VARS)
LOCAL_MODULE := CameraApp
LOCAL_SRC_FILES := Source.cpp
LOCAL_SRC_FILES := Markup.cpp

LOCAL_C_INCLUDE := C:/Users/Hakan/Downloads/OpenCV-android-sdk/sdk/native/jni/include/opencv2
include $(BUILD_SHARED_LIBRARY)