#include $(call all-subdir-makefiles)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := substrate
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
    LOCAL_SRC_FILES := armpatch_src/libsubstrate-armv7a_Cydia.a # Cydia Substrate
else
    ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
        LOCAL_SRC_FILES := armpatch_src/libsubstrate-armv8a.a # And64InlineHook
    endif
endif
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libz
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	LOCAL_SRC_FILES := libcurl/armv7a/libz.a
else
	ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
		LOCAL_SRC_FILES := libcurl/armv8a/libz.a
	endif
endif
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := wolfssl
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
    LOCAL_SRC_FILES := libcurl/armv7a/libwolfssl.a
else
    ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
        LOCAL_SRC_FILES := libcurl/armv8a/libwolfssl.a
    endif
endif
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := curl
LOCAL_SHARED_LIBRARIES := wolfssl libz
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
    LOCAL_SRC_FILES := libcurl/armv7a/libcurl.a
else
    ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
        LOCAL_SRC_FILES := libcurl/armv8a/libcurl.a
    endif
endif
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CPP_EXTENSION := .cpp .cc
LOCAL_SHARED_LIBRARIES := substrate
LOCAL_MODULE    := armpatch
LOCAL_SRC_FILES := armpatch_src/ARMPatch.cpp
LOCAL_CFLAGS += -O2 -mfloat-abi=softfp -DNDEBUG -mthumb
 ## xDL ##
LOCAL_C_INCLUDES += $(LOCAL_PATH)/xdl/xdl/src/main/cpp $(LOCAL_PATH)/xdl/xdl/src/main/cpp/include
LOCAL_SRC_FILES += xdl/xdl/src/main/cpp/xdl.c xdl/xdl/src/main/cpp/xdl_iterate.c \
                   xdl/xdl/src/main/cpp/xdl_linker.c xdl/xdl/src/main/cpp/xdl_lzma.c \
                   xdl/xdl/src/main/cpp/xdl_util.c
LOCAL_CFLAGS += -D__XDL
LOCAL_CXXFLAGS += -D__XDL

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CPP_EXTENSION := .cpp .cc
LOCAL_SHARED_LIBRARIES := armpatch curl
LOCAL_MODULE    := AML
LOCAL_SRC_FILES := main.cpp interface.cpp aml.cpp modpaks.cpp \
                   modslist.cpp icfg.cpp vtable_hooker.cpp \
                   mod/logger.cpp mod/config_inih.cpp

 ## FLAGS ##
LOCAL_CFLAGS += -O2 -mfloat-abi=softfp -DNDEBUG -D__AML -std=c17 -mthumb
LOCAL_CXXFLAGS += -O2 -mfloat-abi=softfp -DNDEBUG -D__AML -std=c++17 -mthumb -fexceptions
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include
LOCAL_LDLIBS += -llog -ldl -landroid

# Uncomment these two lines to add IL2CPP support! (NOT WORKING)
#	LOCAL_SRC_FILES += il2cpp/gc.cpp il2cpp/functions.cpp
#	LOCAL_CFLAGS += -D__IL2CPPUTILS
# Uncomment these two lines to add IL2CPP support! (NOT WORKING)

 ## BUILD ##
include $(BUILD_SHARED_LIBRARY)
