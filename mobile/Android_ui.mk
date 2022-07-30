LOCAL_PATH :=  $(call my-dir)/../SP/code

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw_ui.sp

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS)
LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES += 	  ui/ui_main.c \
                      ui/ui_atoms.c \
                      ui/ui_gameinfo.c \
                      ui/ui_players.c \
                      ui/ui_shared.c \
                      ui/ui_syscalls.c \
                      game/bg_misc.c \
                      game/bg_lib.c \
                      qcommon/q_math.c \
                      qcommon/q_shared.c


LOCAL_SRC_FILES := $(PROJECT_FILES)

$(info $(LOCAL_SRC_FILES))

LOCAL_LDLIBS := -ldl -llog
LOCAL_SHARED_LIBRARIES :=

include $(BUILD_SHARED_LIBRARY)