LOCAL_PATH :=  $(call my-dir)/../SP/code

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw_cgame.sp

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS) -DCGAMEDLL
LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES +=   cgame/cg_main.c \
                   game/bg_animation.c \
                   game/bg_misc.c \
                   game/bg_pmove.c \
                   game/bg_slidemove.c \
                   game/bg_lib.c \
                   cgame/cg_consolecmds.c \
                   cgame/cg_draw.c \
                   cgame/cg_drawtools.c \
                   cgame/cg_effects.c \
                   cgame/cg_ents.c \
                   cgame/cg_event.c \
                   cgame/cg_flamethrower.c \
                   cgame/cg_info.c \
                   cgame/cg_localents.c \
                   cgame/cg_marks.c \
                   cgame/cg_newdraw.c \
                   cgame/cg_particles.c \
                   cgame/cg_players.c \
                   cgame/cg_playerstate.c \
                   cgame/cg_predict.c \
                   cgame/cg_scoreboard.c \
                   cgame/cg_servercmds.c \
                   cgame/cg_snapshot.c \
                   cgame/cg_sound.c \
                   cgame/cg_trails.c \
                   cgame/cg_view.c \
                   cgame/cg_weapons.c \
                   cgame/cg_syscalls.c \
                   ui/ui_shared.c \
                   qcommon/q_math.c \
                   qcommon/q_shared.c


LOCAL_SRC_FILES := $(PROJECT_FILES)

$(info $(LOCAL_SRC_FILES))

LOCAL_LDLIBS := -ldl -llog
LOCAL_SHARED_LIBRARIES :=

include $(BUILD_SHARED_LIBRARY)