LOCAL_PATH :=  $(call my-dir)/../SP/code

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw_renderer

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS)
LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES := $(wildcard $(LOCAL_PATH)/renderer/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/jpeg-8c/*.c)

PROJECT_FILES := $(PROJECT_FILES:$(LOCAL_PATH)/%=%)

PROJECT_FILES += 	sdl/sdl_gamma.c \
					sdl/sdl_glimp.c \
					qcommon/q_shared.c \
					qcommon/q_math.c \
					qcommon/puff.c \
					#freetype-2.9/src/truetype/truetype.c \
					freetype-2.9/src/psaux/psaux.c \
					freetype-2.9/src/sfnt/sfnt.c \
					freetype-2.9/src/pcf/pcf.c \

#PROJECT_FILES := $(filter-out $(EXCLUDE), $(PROJECT_FILES))

LOCAL_SRC_FILES := $(PROJECT_FILES)

$(info $(LOCAL_SRC_FILES))

LOCAL_LDLIBS := -lEGL -ldl -llog -lGLESv1_CM
LOCAL_SHARED_LIBRARIES := SDL2

include $(BUILD_SHARED_LIBRARY)