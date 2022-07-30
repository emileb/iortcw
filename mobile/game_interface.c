//#include "quakedef.h"

#include "game_interface.h"

#include "SDL.h"
#include "SDL_keycode.h"


#include "..//client/client.h"
//#include "..//renderergl1/tr_local.h"

#include "SmartToggle.h"

static float look_pitch_mouse, look_pitch_joy;
static float look_yaw_mouse, look_yaw_joy;;


int main_android(int c, const char **v);

void PortableInit(int argc, const char **argv)
{
    LOGI("PortableInit");
    main_android(argc, argv);
}


extern int SDL_SendKeyboardKey(Uint8 state, SDL_Scancode scancode);

int PortableKeyEvent(int state, int code, int unitcode)
{
    LOGI("PortableKeyEvent %d %d", state, code);

    if (state)
        SDL_SendKeyboardKey(SDL_PRESSED, (SDL_Scancode) code);
    else
        SDL_SendKeyboardKey(SDL_RELEASED, (SDL_Scancode) code);

    return 0;
}

static const char *quickCommand = 0;

void PortableCommand(const char *cmd)
{
    static char cmdBuffer[256];
    snprintf(cmdBuffer, 256, "%s", cmd);
    quickCommand = cmdBuffer;
}

void KeyUpPort(kbutton_t *b)
{
    b->active = qfalse;
}

void KeyDownPort(kbutton_t *b)
{
    b->active = qtrue;
    b->wasPressed = qtrue;
}

static int KeyIsDown(kbutton_t *b)
{
    return b->active;
}

extern kbutton_t kb[NUM_BUTTONS];


static int zoomed = 0; //toggle zoom
static int scoresShown = 0;

void PortableAction(int state, int action)
{
    LOGI("PortableAction %d %d", state, action);

    if ((action >= PORT_ACT_CUSTOM_0) && (action <= PORT_ACT_CUSTOM_17))
    {
        PortableKeyEvent(state, SDL_SCANCODE_H + action - PORT_ACT_CUSTOM_0, 0);
    }

    if ((PortableGetScreenMode() == TS_MENU) || (PortableGetScreenMode() == TS_BLANK) ||
        (PortableGetScreenMode() == TS_Y_N))
    {
        if (action >= PORT_ACT_MENU_UP && action <= PORT_ACT_MENU_ABORT)
        {
            int sdl_code[] = {SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT,
                              SDL_SCANCODE_RIGHT, SDL_SCANCODE_RETURN, SDL_SCANCODE_ESCAPE,
                              SDL_SCANCODE_Y, SDL_SCANCODE_N};

            PortableKeyEvent(state, sdl_code[action - PORT_ACT_MENU_UP], 0);

            return;
        }
        else if (action == PORT_ACT_CONSOLE)
        {
            if (state)
                PortableCommand("toggleconsole");
        }
        else if (action == PORT_ACT_MOUSE_LEFT || action == PORT_ACT_MOUSE_RIGHT)
        {
            int b = K_MOUSE1;

            if (action == PORT_ACT_MOUSE_LEFT)
                b = K_MOUSE1;
            else if (action == PORT_ACT_MOUSE_RIGHT)
                b = K_MOUSE2;

            Com_QueueEvent(0, SE_KEY, b, state ? qtrue : qfalse, 0, NULL);
        }
    }
    else if (((action >= PORT_ACT_WEAP0) && (action <= PORT_ACT_WEAP9)))
    {
        int code = 0;
        if (action == PORT_ACT_WEAP0)
            code = SDL_SCANCODE_0;
        else
            code = SDL_SCANCODE_1 + action - PORT_ACT_WEAP1;

        PortableKeyEvent(state, code, 0);
    }
    else
    {
        switch (action)
        {
            case PORT_ACT_LEFT:
                (state) ? KeyDownPort(&kb[KB_LEFT]) : KeyUpPort(&kb[KB_LEFT]);
                break;
            case PORT_ACT_RIGHT:
                (state) ? KeyDownPort(&kb[KB_RIGHT]) : KeyUpPort(&kb[KB_RIGHT]);
                break;
            case PORT_ACT_FWD:
                (state) ? KeyDownPort(&kb[KB_FORWARD]) : KeyUpPort(&kb[KB_FORWARD]);
                break;
            case PORT_ACT_BACK:
                (state) ? KeyDownPort(&kb[KB_BACK]) : KeyUpPort(&kb[KB_BACK]);
                break;
            case PORT_ACT_LOOK_UP:
                (state) ? KeyDownPort(&kb[KB_LOOKUP]) : KeyUpPort(&kb[KB_LOOKUP]);
                break;
            case PORT_ACT_LOOK_DOWN:
                (state) ? KeyDownPort(&kb[KB_LOOKDOWN]) : KeyUpPort(&kb[KB_LOOKDOWN]);
                break;
            case PORT_ACT_MOVE_LEFT:
                (state) ? KeyDownPort(&kb[KB_MOVELEFT]) : KeyUpPort(&kb[KB_MOVELEFT]);
                break;
            case PORT_ACT_MOVE_RIGHT:
                (state) ? KeyDownPort(&kb[KB_MOVERIGHT]) : KeyUpPort(&kb[KB_MOVERIGHT]);
                break;
            case PORT_ACT_STRAFE:
                (state) ? KeyDownPort(&kb[KB_STRAFE]) : KeyUpPort(&kb[KB_STRAFE]);
                break;
            case PORT_ACT_SPEED:
                (state) ? KeyDownPort(&kb[KB_SPEED]) : KeyUpPort(&kb[KB_SPEED]);
                break;
            case PORT_ACT_ZOOM_IN:
            {
                static SmartToggle_t smartToggle;
                int activate = SmartToggleAction(&smartToggle, state, zoomed);
                if (activate)
                {
                    zoomed = 1;
                    PortableCommand("+zoom\n");
                }
                else
                {
                    zoomed = 0;
                    PortableCommand("-zoom\n");
                }
            }
                break;
            case PORT_ACT_USE:
                (state) ? KeyDownPort(&kb[KB_BUTTONS2]) : KeyUpPort(&kb[KB_BUTTONS2]);
                break;
            case PORT_ACT_ATTACK:
                (state) ? KeyDownPort(&kb[KB_BUTTONS0]) : KeyUpPort(&kb[KB_BUTTONS0]);
                break;
            case PORT_ACT_JUMP:
                //Jump is same as up
            case PORT_ACT_UP:
                (state) ? KeyDownPort(&kb[KB_UP]) : KeyUpPort(&kb[KB_UP]);
                break;
            case PORT_ACT_DOWN:
            {
                static SmartToggle_t smartToggle;
                int activate = SmartToggleAction(&smartToggle, state, KeyIsDown(&kb[KB_DOWN]));
                (activate) ? KeyDownPort(&kb[KB_DOWN]) : KeyUpPort(&kb[KB_DOWN]);
            }
                break;
                //TODO make fifo, possibly not thread safe!!
            case PORT_ACT_NEXT_WEP:
                if (state)
                    PortableCommand("weapnext\n");
                break;
            case PORT_ACT_PREV_WEP:
                if (state)
                    PortableCommand("weapprev\n");
                break;
            case PORT_ACT_CONSOLE:
                if (state)
                    PortableCommand("toggleconsole");
                break;
            case PORT_ACT_MP_SCORES:
                if (state)
                {
                    if (scoresShown)
                        PortableCommand("-scores\n");
                    else
                        PortableCommand("+scores\n");
                    scoresShown = !scoresShown;
                }
                break;
        }
    }
}


touchscreemode_t PortableGetScreenMode()
{
    if ((Key_GetCatcher() & KEYCATCH_UI) ||
        (Key_GetCatcher() & KEYCATCH_CGAME) ||
        (Key_GetCatcher() & KEYCATCH_CONSOLE) ||
        !cls.cgameStarted
            )
    {
        return TS_MENU;
    }
    else
    {
        return TS_GAME;
    }
}

void PortableBackButton()
{
    LOGI("Back button");
    PortableKeyEvent(1, SDL_SCANCODE_ESCAPE, 0);
    PortableKeyEvent(0, SDL_SCANCODE_ESCAPE, 0);
}

void PortableMouse(float dx, float dy)
{
    dx *= 1500;
    dy *= 1200;

    Com_QueueEvent(0, SE_MOUSE, -dx, -dy, 0, NULL);
}


// =================== FORWARD and SIDE MOVMENT ==============

float forwardmove, sidemove; //Joystick mode

void PortableMoveFwd(float fwd)
{
    if (fwd > 1)
        fwd = 1;
    else if (fwd < -1)
        fwd = -1;

    forwardmove = fwd;
}

void PortableMoveSide(float strafe)
{
    if (strafe > 1)
        strafe = 1;
    else if (strafe < -1)
        strafe = -1;

    sidemove = strafe;
}

void PortableMove(float fwd, float strafe)
{
    PortableMoveFwd(fwd);
    PortableMoveSide(strafe);
}

//======================================================================

//Look up and down
void PortableLookPitch(int mode, float pitch)
{
    switch (mode)
    {
        case LOOK_MODE_MOUSE:
            look_pitch_mouse += pitch;
            break;
        case LOOK_MODE_JOYSTICK:
            look_pitch_joy = pitch;
            break;
    }
}

//left right
void PortableLookYaw(int mode, float yaw)
{
    switch (mode)
    {
        case LOOK_MODE_MOUSE:
            look_yaw_mouse += yaw;
            break;
        case LOOK_MODE_JOYSTICK:
            look_yaw_joy = yaw;
            break;
    }
}

void IN_Android_Commands()
{
    if (quickCommand)
    {
        Cmd_ExecuteString(quickCommand);
        quickCommand = 0;
    }

    if (PortableGetScreenMode() == TS_MENU)
    {
        if (look_yaw_joy || look_pitch_joy)
        {
            Com_QueueEvent(0, SE_MOUSE, -look_yaw_joy * 10, look_pitch_joy * 10, 0, NULL);
        }
    }
}

/////////////////////
// Movement handling
////
void CL_AndroidMove(usercmd_t *cmd, float frame_msec)
{
    int blockGamepad(void);
    int blockMove = blockGamepad() & ANALOGUE_AXIS_FWD;
    int blockLook = blockGamepad() & ANALOGUE_AXIS_PITCH;


    if (!blockMove)
    {
        cmd->forwardmove = ClampChar(cmd->forwardmove + forwardmove * 127);
        cmd->rightmove = ClampChar(cmd->rightmove + sidemove * 127);
    }

    if (!blockLook)
    {
        cl.viewangles[PITCH] += -look_pitch_mouse * 300;
        look_pitch_mouse = 0;
        cl.viewangles[PITCH] +=
                look_pitch_joy * 6 * (frame_msec / 16.f); // Presume was scaled at 60FPS;


        cl.viewangles[YAW] += look_yaw_mouse * 500;
        look_yaw_mouse = 0;
        cl.viewangles[YAW] +=
                look_yaw_joy * 6 * (frame_msec / 16.f); // Presume was scaled at 60FPS;
    }
}
/*
void IN_Move_Android (float *movements, int pnum, float frametime)
{
	if (quickCommand)
	{
		Cmd_ExecuteString(quickCommand, RESTRICT_LOCAL);
		quickCommand = 0;
	}

	if( !movements )
		return;

	movements[0]  += forwardmove * cl_forwardspeed.value;
	movements[1]  += sidemove   * cl_forwardspeed.value;

	//LOGI("movements[0] = %f, movements[1] = %f",movements[0],movements[1]);

	V_StopPitchDrift (&cl.playerview[pnum]);

	cl.playerview[pnum].viewanglechange[PITCH] -= look_pitch_mouse * 150;
	look_pitch_mouse = 0;
	cl.playerview[pnum].viewanglechange[PITCH] += look_pitch_joy * 6;


	cl.playerview[pnum].viewanglechange[YAW] += look_yaw_mouse * 300;
	look_yaw_mouse = 0;
	cl.playerview[pnum].viewanglechange[YAW] += look_yaw_joy * 6;


	if (cl.playerview[pnum].viewanglechange[PITCH] > 80)
		cl.playerview[pnum].viewanglechange[PITCH] = 80;
	if (cl.playerview[pnum].viewanglechange[PITCH]< -70)
		cl.playerview[pnum].viewanglechange[PITCH] = -70;
}

*/