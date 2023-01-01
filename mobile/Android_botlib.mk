LOCAL_PATH :=  $(call my-dir)/../SP/code

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw_botlib.sp

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS) -DBOTLIB
LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES += $(wildcard $(LOCAL_PATH)/botlib/*.c)

PROJECT_FILES := $(PROJECT_FILES:$(LOCAL_PATH)/%=%)


LOCAL_SRC_FILES := $(PROJECT_FILES)

$(info $(LOCAL_SRC_FILES))

LOCAL_LDLIBS := -ldl -llog

include $(BUILD_STATIC_LIBRARY)