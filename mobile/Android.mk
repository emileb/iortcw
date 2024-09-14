RTCW_LOCAL_PATH:= $(call my-dir)/../SP/code

LOCAL_PATH := $(RTCW_LOCAL_PATH)

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw

RTCW_LOCAL_CFLAGS := -DQUAKE3 -DENGINE_NAME=\"q3lite\" -Wall -fno-strict-aliasing -pipe -DUSE_ICON -DARCH_STRING=\"arm\" -DUSE_OPENGLES -DNO_VM_COMPILED -DNO_GZIP \
                                                       -DUSE_INTERNAL_JPEG -DUSE_FILE32API \
                                                       -DFT2_BUILD_LIBRARY -DUSE_LOCAL_HEADERS -DPRODUCT_VERSION=\"1.51d-SP_GIT_191e8d10-2022-04-09\" -Wformat=2 \
                                                       -Wformat-security -Wno-format-nonliteral -Wstrict-aliasing=2 -Wmissing-format-attribute -Wdisabled-optimization \
                                                       -MMD -DNDEBUG -DHAVE_LRINTF -DFLOATING_POINT -DFLOAT_APPROX \
                                                       -DUSE_ALLOCA -DUSE_RENDERER_DLOPEN  -DIOAPI_NO_64  \

# This is needed to stop 32bit arm crashing. Otherwise unaligned float access.. Not a great fix..
RTCW_LOCAL_CFLAGS +=  -Ofast

#-DIOAPI_NO_64
#-DBUILD_FREETYPE
#-DUSE_FILE32API

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS)


RTCW_LOCAL_C_INCLUDES :=     $(SDL_INCLUDE_PATHS)  \
                        $(TOP_DIR) \
                        $(TOP_DIR)/MobileTouchControls \
                        $(TOP_DIR)/Clibs_OpenTouch \
                        $(TOP_DIR)/Clibs_OpenTouch/alpha \
                        $(LOCAL_PATH)/qcommon \
                        $(LOCAL_PATH)/libvorbis-1.3.6/lib \
                        $(LOCAL_PATH)/libvorbis-1.3.6/include \
                        $(LOCAL_PATH)/zlib-1.2.11 \
                        $(LOCAL_PATH)/jpeg-8c \
                        $(LOCAL_PATH)/freetype-2.9/include \
                        $(LOCAL_PATH)/libogg-1.3.3/include \



LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES += $(wildcard $(LOCAL_PATH)/libogg-1.3.3/src/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/libvorbis-1.3.6/lib/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/jpeg-8c/*.c)

PROJECT_FILES += $(wildcard $(LOCAL_PATH)/client/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/qcommon/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/server/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/splines/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/splines/*.cpp)
#PROJECT_FILES += $(wildcard $(LOCAL_PATH)/rend2/*.c)
#PROJECT_FILES += $(wildcard $(LOCAL_PATH)/renderer/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/sdl/*.c)
PROJECT_FILES += $(wildcard $(LOCAL_PATH)/zlib-1.2.11/*.c)
#PROJECT_FILES += $(wildcard $(LOCAL_PATH)/zlib-1.2.13/*.c)

PROJECT_FILES := $(PROJECT_FILES:$(LOCAL_PATH)/%=%)


PROJECT_FILES +=    sys/con_log.c \
                    sys/sys_main.c \
                    sys/sys_unix.c \
                    ../../mobile/con_android.c \
                    ../../mobile/game_interface.c \
                    ../../mobile/ifaddrs.c \
                    ../../../../Clibs_OpenTouch/alpha/android_jni.cpp \
                    ../../../../Clibs_OpenTouch/alpha/touch_interface_rtcw.cpp \
                    ../../../../Clibs_OpenTouch/touch_interface_base.cpp

EXCLUDE :=  qcommon/vm_x86.c \
            qcommon/vm_armv7l.c \
            qcommon/vm_sparc.c \
            qcommon/vm_none.c \
            qcommon/vm_powerpc.c \
            qcommon/vm_powerpc_asm.c \
            server/sv_rankings.c \
            client/libmumblelink.c \
            server/sv_rankings.c \
            splines/q_shared.cpp \
			libvorbis-1.3.6/lib/psytune.c \
			libvorbis-1.3.6/lib/tone.c \
			libvorbis-1.3.6/lib/barkmel.c \
			sdl/sdl_gamma.c \
			sdl/sdl_glimp.c \

PROJECT_FILES := $(filter-out $(EXCLUDE), $(PROJECT_FILES))

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
   LOCAL_CFLAGS += -DNO_VM_COMPILED
endif

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  PROJECT_FILES +=  qcommon/vm_armv7l.c
endif


LOCAL_SRC_FILES =  $(PROJECT_FILES)


LOCAL_LDLIBS := -lEGL -ldl -llog -lOpenSLES -lz -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := sigc libzip libpng logwritter  SDL2_net iortcw_botlib.sp
LOCAL_SHARED_LIBRARIES := touchcontrols SDL2  SDL2_mixer core_shared saffal


include $(BUILD_SHARED_LIBRARY)

include $(TOP_DIR)/Alpha/iortcw/mobile/Android_renderer.mk
include $(TOP_DIR)/Alpha/iortcw/mobile/Android_ui.mk
include $(TOP_DIR)/Alpha/iortcw/mobile/Android_cgame.mk
include $(TOP_DIR)/Alpha/iortcw/mobile/Android_game.mk
include $(TOP_DIR)/Alpha/iortcw/mobile/Android_botlib.mk

