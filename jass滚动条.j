//===========================================================================
// Trigger: 创建UI部分
//===========================================================================
function Trig_______UI______uFunc075WT takes nothing returns nothing
	if ((DzF2I( DzGetMouseFocus()) != 0)) then
		if ((YDUserDataGet(integer, DzF2I( DzGetMouseFocus()),"类型", string) == "限制滚动区域")) then
			set udg_Z = DzGetWheelDelta()
			if ((udg_Z > 0)) then
				if ((udg_Dq/*滚动条当前值*/ > 0)) then
					set udg_Dq/*滚动条当前值*/ = (udg_Dq/*滚动条当前值*/ - R2I( (I2R( (udg_Z / 50)) * udg_SD/*滚动速度*/)))
					if ((udg_Dq/*滚动条当前值*/ >= 0)) then
					else
						set udg_Dq/*滚动条当前值*/ = 0
					endif
					call DzFrameSetPoint( udg_UI2/*滚动条UI*/[2], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, ((0.00 - udg_Cs/*滚动条参数*/) * I2R( udg_Dq/*滚动条当前值*/)))
					call DzFrameSetPoint( udg_UI1/*背景UI*/[2], 0, udg_UI1/*背景UI*/[0], 0, 0.00, (udg_CS2/*滚轮参数*/ * I2R( udg_Dq/*滚动条当前值*/)))
				else
				endif
			else
				if ((udg_Dq/*滚动条当前值*/ < 100)) then
					set udg_Dq/*滚动条当前值*/ = (udg_Dq/*滚动条当前值*/ - R2I( (I2R( (udg_Z / 50)) * udg_SD/*滚动速度*/)))
					if ((udg_Dq/*滚动条当前值*/ <= 100)) then
					else
						set udg_Dq/*滚动条当前值*/ = 100
					endif
					call DzFrameSetPoint( udg_UI2/*滚动条UI*/[2], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, ((0.00 - udg_Cs/*滚动条参数*/) * I2R( udg_Dq/*滚动条当前值*/)))
					call DzFrameSetPoint( udg_UI1/*背景UI*/[2], 0, udg_UI1/*背景UI*/[0], 0, 0.00, (udg_CS2/*滚轮参数*/ * I2R( udg_Dq/*滚动条当前值*/)))
				else
				endif
			endif
		else
		endif
	else
	endif
endfunction

function Trig_______UI______uFunc077MT takes nothing returns nothing
	if ((DzF2I( DzGetMouseFocus()) != 0)) then
		if ((DzF2I( DzGetMouseFocus()) == DzF2I( udg_UI2/*滚动条UI*/[3]))) then
			set udg_DianJi/*点击鼠标*/ = true
			set udg_Y[1] = YDUserDataGet(integer, DzF2I( DzGetMouseFocus()),"Y坐标", real)
		else
		endif
	else
	endif
endfunction

function Trig_______UI______uFunc078MT takes nothing returns nothing
	if ((udg_DianJi/*点击鼠标*/ == true)) then
		set udg_DianJi/*点击鼠标*/ = false
	else
	endif
endfunction

function Trig_______UI______uActions takes nothing returns nothing
	call DzFrameEnableClipRect( false)
	call DisplayTimedTextToPlayer( Player(0), 0, 0, 30, "TRIGSTR_007")
	//--------------------------
	set udg_ZdXian/*可视最大范围内容高度*/ = 0.80
	//UI滚动条的高度
	set udg_Gd/*滚动条高*/ = 0.20
	//模拟原生，用值控制滚动条
	set udg_Dq/*滚动条当前值*/ = 0
	//加快滚动条的数值移动速度
	set udg_SD/*滚动速度*/ = 2.00
	//不用修改的值，只是记录一下最终用到的参数
	set udg_Cs/*滚动条参数*/ = (udg_Gd/*滚动条高*/ / 100.00)
	set udg_CS2/*滚轮参数*/ = (udg_ZdXian/*可视最大范围内容高度*/ / 100.00)
	//--------------------------
	//创建UI背景
	set udg_UI1/*背景UI*/[0] = DzCreateFrameByTagName( "BACKDROP", "name", DzGetGameUI(), "template", 0)
	call DzFrameSetPoint( udg_UI1/*背景UI*/[0], 4, DzGetGameUI(), 4, 0, 0)
	call DzFrameSetTexture( udg_UI1/*背景UI*/[0], "war3mapImported\\1.tga", 0)
	call DzFrameSetSize( udg_UI1/*背景UI*/[0], 0.30, (udg_Gd/*滚动条高*/ + 0.04))
	//创建一个视窗，用来限制窗口范围
	set udg_UI1/*背景UI*/[1] = DzCreateFrameByTagName( "FRAME", "name", udg_UI1/*背景UI*/[0], "template", 0)
	call DzFrameSetPoint( udg_UI1/*背景UI*/[1], 0, udg_UI1/*背景UI*/[0], 0, 0.01, -0.02)
	call DzFrameSetSize( udg_UI1/*背景UI*/[1], 0.27, (udg_Gd/*滚动条高*/ + 0.01))
	call DzFrameSetClip( udg_UI1/*背景UI*/[1], true)
	//创建一个控制点
	set udg_UI1/*背景UI*/[2] = DzCreateFrameByTagName( "FRAME", "name", udg_UI1/*背景UI*/[0], "template", 0)
	call DzFrameSetPoint( udg_UI1/*背景UI*/[2], 0, udg_UI1/*背景UI*/[0], 0, 0.00, 0.00)
	call DzFrameSetSize( udg_UI1/*背景UI*/[2], 0.01, 0.01)
	//创建一个按钮，为了控制滚动范围
	set udg_UI1/*背景UI*/[10] = DzCreateFrameByTagName( "BUTTON", "name", udg_UI1/*背景UI*/[0], "template", 0)
	call DzFrameSetPoint( udg_UI1/*背景UI*/[10], 0, udg_UI1/*背景UI*/[0], 0, 0.00, 0.00)
	call DzFrameSetSize( udg_UI1/*背景UI*/[10], 0.30, (udg_Gd/*滚动条高*/ + 0.04))
	//预设一下按钮的类型
	call YDUserDataSet(integer, DzF2I( udg_UI1/*背景UI*/[10]),"类型", string, "限制滚动区域")
	//-------------------------------
	call DzFrameShow( udg_UI1/*背景UI*/[0], false)
	//-------------------------------
	//创建滚动条背景
	set udg_UI2/*滚动条UI*/[1] = DzCreateFrameByTagName( "BACKDROP", "name", udg_UI1/*背景UI*/[0], "template", 0)
	call DzFrameSetPoint( udg_UI2/*滚动条UI*/[1], 2, udg_UI1/*背景UI*/[0], 2, -0.005, -0.02)
	call DzFrameSetTexture( udg_UI2/*滚动条UI*/[1], "Textures\\Black32.blp", 0)
	call DzFrameSetSize( udg_UI2/*滚动条UI*/[1], 0.005, (udg_Gd/*滚动条高*/ + 0.01))
	//滚动条亮点
	set udg_UI2/*滚动条UI*/[2] = DzCreateFrameByTagName( "BACKDROP", "name", udg_UI2/*滚动条UI*/[1], "template", 0)
	call DzFrameSetPoint( udg_UI2/*滚动条UI*/[2], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, 0.00)
	call DzFrameSetTexture( udg_UI2/*滚动条UI*/[2], "Textures\\white.blp", 0)
	call DzFrameSetSize( udg_UI2/*滚动条UI*/[2], 0.005, 0.01)
	//滚动条点击
	set udg_UI2/*滚动条UI*/[3] = DzCreateFrameByTagName( "BUTTON", "name", udg_UI2/*滚动条UI*/[1], "template", 0)
	call DzFrameSetPoint( udg_UI2/*滚动条UI*/[3], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, 0.00)
	call DzFrameSetSize( udg_UI2/*滚动条UI*/[3], 0.005, (udg_Gd/*滚动条高*/ + 0.02))
	//设置Y轴为滚动条的最高点，你最好知道最高点在哪
	call YDUserDataSet(integer, DzF2I( udg_UI2/*滚动条UI*/[3]),"Y坐标", real, (0.30 + (udg_Gd/*滚动条高*/ / 2.00)))
	//下面为窗口里面的内容
	//-------------------------------
	//-------------------------------
	//创建一个测试文本
	set udg_UI3/*内容*/[0] = DzCreateFrameByTagName( "TEXT", "name", udg_UI1/*背景UI*/[0], "template", 0)
	call DzFrameSetPoint( udg_UI3/*内容*/[0], 0, udg_UI1/*背景UI*/[0], 0, 0.01, -0.005)
	call DzFrameSetText( udg_UI3/*内容*/[0], "滚动条演示")
	//-------------------------------------
	//跟随控制点移动,创建10个窗口测试
	set bj_forLoopAIndex = 1
	set bj_forLoopAIndexEnd = 10
	loop
		exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
		//记得设置父节点为开启视窗的UI
		set udg_UI3/*内容*/[bj_forLoopAIndex] = DzCreateFrameByTagName( "BACKDROP", "name", udg_UI1/*背景UI*/[1], "template", 0)
		//跟随选择刚刚上面创建的点
		call DzFrameSetPoint( udg_UI3/*内容*/[bj_forLoopAIndex], 0, udg_UI1/*背景UI*/[2], 0, 0.01, (0.03 - (0.05 * I2R( bj_forLoopAIndex))))
		call DzFrameSetSize( udg_UI3/*内容*/[bj_forLoopAIndex], 0.04, 0.04)
		set bj_forLoopAIndex = bj_forLoopAIndex + 1
	endloop
	call DzFrameSetTexture( udg_UI3/*内容*/[1], "ReplaceableTextures\\CommandButtons\\BTNPeasant.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[2], "ReplaceableTextures\\CommandButtons\\BTNFootman.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[3], "ReplaceableTextures\\CommandButtons\\BTNKnight.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[4], "ReplaceableTextures\\CommandButtons\\BTNRifleman.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[5], "ReplaceableTextures\\CommandButtons\\BTNMortarTeam.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[6], "ReplaceableTextures\\CommandButtons\\BTNFlyingMachine.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[7], "ReplaceableTextures\\CommandButtons\\BTNGryphonRider.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[8], "ReplaceableTextures\\CommandButtons\\BTNPriest.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[9], "ReplaceableTextures\\CommandButtons\\BTNSorceress.blp", 0)
	call DzFrameSetTexture( udg_UI3/*内容*/[10], "ReplaceableTextures\\CommandButtons\\BTNSeigeEngine.blp", 0)
	if GetLocalPlayer() == GetLocalPlayer() then
		call DzTriggerRegisterMouseWheelEventByCode( null, false, function Trig_______UI______uFunc075WT)
	endif
	//注册点击滚动条
	if GetLocalPlayer() == GetLocalPlayer() then
		call DzTriggerRegisterMouseEventByCode( null, 1, 1, false, function Trig_______UI______uFunc077MT)
	endif
	if GetLocalPlayer() == GetLocalPlayer() then
		call DzTriggerRegisterMouseEventByCode( null, 1, 0, false, function Trig_______UI______uFunc078MT)
	endif
endfunction

//===========================================================================
function InitTrig_______UI______u takes nothing returns nothing
	set gg_trg_______UI______u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_______UI______u,"创建UI部分")
#endif
	call TriggerAddAction(gg_trg_______UI______u, function Trig_______UI______uActions)
endfunction

//===========================================================================
// Trigger: 滚动条计时器跟随
//===========================================================================
function Trig_________________________uConditions takes nothing returns boolean
	return ((udg_DianJi/*点击鼠标*/ == true))
endfunction

function Trig_________________________uActions takes nothing returns nothing
	set udg_Y[2] = (udg_Y[1] - MouseY())
	set udg_Y[3] = (udg_Y[2] / udg_Cs/*滚动条参数*/)
	set udg_Dq/*滚动条当前值*/ = R2I( udg_Y[3])
	if ((udg_Dq/*滚动条当前值*/ >= 0)) then
		if ((udg_Dq/*滚动条当前值*/ <= 100)) then
		else
			set udg_Dq/*滚动条当前值*/ = 100
		endif
		call DzFrameSetPoint( udg_UI2/*滚动条UI*/[2], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, ((0.00 - udg_Cs/*滚动条参数*/) * I2R( udg_Dq/*滚动条当前值*/)))
		call DzFrameSetPoint( udg_UI1/*背景UI*/[2], 0, udg_UI1/*背景UI*/[0], 0, 0.00, (udg_CS2/*滚轮参数*/ * I2R( udg_Dq/*滚动条当前值*/)))
	else
		set udg_Dq/*滚动条当前值*/ = 0
		call DzFrameSetPoint( udg_UI2/*滚动条UI*/[2], 1, udg_UI2/*滚动条UI*/[1], 1, 0.00, ((0.00 - udg_Cs/*滚动条参数*/) * I2R( udg_Dq/*滚动条当前值*/)))
		call DzFrameSetPoint( udg_UI1/*背景UI*/[2], 0, udg_UI1/*背景UI*/[0], 0, 0.00, (udg_CS2/*滚轮参数*/ * I2R( udg_Dq/*滚动条当前值*/)))
	endif
endfunction

//===========================================================================
function InitTrig_________________________u takes nothing returns nothing
	set gg_trg_________________________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_________________________u,"滚动条计时器跟随")
#endif
	call TriggerRegisterTimerEventPeriodic(gg_trg_________________________u, 0.03)
	call TriggerAddCondition(gg_trg_________________________u, Condition(function Trig_________________________uConditions))
	call TriggerAddAction(gg_trg_________________________u, function Trig_________________________uActions)
endfunction
//===========================================================================
// Trigger: Esc
//===========================================================================
function Trig_EscActions takes nothing returns nothing
	if ((udg_ESC == false)) then
		set udg_ESC = true
		call DzFrameShow( udg_UI1/*背景UI*/[0], true)
	else
		set udg_ESC = false
		call DzFrameShow( udg_UI1/*背景UI*/[0], false)
	endif
endfunction

//===========================================================================
function InitTrig_Esc takes nothing returns nothing
	set gg_trg_Esc = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Esc,"Esc")
#endif
#define YDTRIGGER_COMMON_LOOP(n) 	call TriggerRegisterPlayerEventEndCinematic(gg_trg_Esc, Player(n))
#define YDTRIGGER_COMMON_LOOP_LIMITS (0, 15)
#include <YDTrigger/Common/loop.h>
	call TriggerAddAction(gg_trg_Esc, function Trig_EscActions)
endfunction

