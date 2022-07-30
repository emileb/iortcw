LOCAL_PATH :=  $(call my-dir)/../SP/code

include $(CLEAR_VARS)

LOCAL_MODULE := iortcw_qagame.sp

LOCAL_CFLAGS := $(RTCW_LOCAL_CFLAGS) -DGAMEDLL
LOCAL_C_INCLUDES := $(RTCW_LOCAL_C_INCLUDES)

PROJECT_FILES :=

PROJECT_FILES +=    game/g_main.c \
                    game/ai_cast.c \
                    game/ai_cast_characters.c \
                    game/ai_cast_debug.c \
                    game/ai_cast_events.c \
                    game/ai_cast_fight.c \
                    game/ai_cast_func_attack.c \
                    game/ai_cast_func_boss1.c \
                    game/ai_cast_funcs.c \
                    game/ai_cast_script_actions.c \
                    game/ai_cast_script.c \
                    game/ai_cast_script_ents.c \
                    game/ai_cast_sight.c \
                    game/ai_cast_think.c \
                    game/ai_chat.c \
                    game/ai_cmd.c \
                    game/ai_dmnet.c \
                    game/ai_dmq3.c \
                    game/ai_main.c \
                    game/ai_team.c \
                    game/bg_animation.c \
                    game/bg_misc.c \
                    game/bg_pmove.c \
                    game/bg_slidemove.c \
                    game/bg_lib.c \
                    game/g_active.c \
                    game/g_alarm.c \
                    game/g_bot.c \
                    game/g_client.c \
                    game/g_cmds.c \
                    game/g_combat.c \
                    game/g_items.c \
                    game/g_mem.c \
                    game/g_misc.c \
                    game/g_missile.c \
                    game/g_mover.c \
                    game/g_props.c \
                    game/g_save.c \
                    game/g_script_actions.c \
                    game/g_script.c \
                    game/g_session.c \
                    game/g_spawn.c \
                    game/g_svcmds.c \
                    game/g_target.c \
                    game/g_team.c \
                    game/g_tramcar.c \
                    game/g_trigger.c \
                    game/g_utils.c \
                    game/g_weapon.c \
                    qcommon/q_math.c \
                    qcommon/q_shared.c \
                    game/g_syscalls.c


LOCAL_SRC_FILES := $(PROJECT_FILES)

$(info $(LOCAL_SRC_FILES))

LOCAL_LDLIBS := -ldl -llog
LOCAL_SHARED_LIBRARIES :=

include $(BUILD_SHARED_LIBRARY)