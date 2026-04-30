//===========================================================================
// Trigger: UI创建1
//===========================================================================
function Trig_UI______1Func002Func015FT takes nothing returns nothing
	call YDLocal6Set("Trig_UI______1Func002Func015", integer, "标志", YDUserDataGet(integer, DzF2I( DzGetTriggerUIEventFrame()),"标志", integer))
	call DzSyncData( "UI交互", I2S( YDLocal6Get("Trig_UI______1Func002Func015", integer, "标志")))
endfunction

function Trig_UI______1Actions takes nothing returns nothing
	YDLocalInitialize()
	set udg_BACKDROP[0] = DzCreateFrameByTagName( "FRAME", "name", DzGetGameUI(), "template", 0)
	set bj_forLoopAIndex = 1
	set bj_forLoopAIndexEnd = 3
	loop
		exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
		set udg_BACKDROP[bj_forLoopAIndex] = DzCreateFrameByTagName( "BACKDROP", "name", udg_BACKDROP[0], "template", 0)
		call DzFrameSetSize( udg_BACKDROP[bj_forLoopAIndex], 0.15, 0.30)
		call DzFrameSetPoint( udg_BACKDROP[bj_forLoopAIndex], 4, DzGetGameUI(), 4, (-0.40 + (0.20 * I2R( bj_forLoopAIndex))), 0)
		call DzFrameSetTexture( udg_BACKDROP[bj_forLoopAIndex], "Textures\\Black32.blp", 0)
		set udg_TEXT[bj_forLoopAIndex] = DzCreateFrameByTagName( "TEXT", "name", udg_BACKDROP[bj_forLoopAIndex], "template", 0)
		call DzFrameSetSize( udg_TEXT[bj_forLoopAIndex], 0.13, 0.00)
		call DzFrameSetPoint( udg_TEXT[bj_forLoopAIndex], 3, udg_BACKDROP[bj_forLoopAIndex], 3, 0.01, 0)
		call DzFrameSetText( udg_TEXT[bj_forLoopAIndex], "测试文本\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")
		call DzFrameSetFont( udg_TEXT[bj_forLoopAIndex], "Fonts\\dfst-m3u.ttf", 0.011, 0)
		call DzFrameSetEnable( udg_TEXT[bj_forLoopAIndex], false)
		set udg_BUTTON[bj_forLoopAIndex] = DzCreateFrameByTagName( "BUTTON", "name", udg_BACKDROP[bj_forLoopAIndex], "template", 0)
		call DzFrameSetSize( udg_BUTTON[bj_forLoopAIndex], 0.15, 0.30)
		call DzFrameSetPoint( udg_BUTTON[bj_forLoopAIndex], 0, udg_BACKDROP[bj_forLoopAIndex], 0, 0, 0)
		call YDUserDataSet(integer, DzF2I( udg_BUTTON[bj_forLoopAIndex]),"标志", integer, bj_forLoopAIndex)
		call YDLocal6Set("Trig_UI______1Func002Func015", integer, "标志", YDLocal1Get(integer, "标志"))
		if GetLocalPlayer() == GetLocalPlayer() then
			call DzFrameSetScriptByCode( udg_BUTTON[bj_forLoopAIndex], 1, function Trig_UI______1Func002Func015FT, false)
		endif
		set bj_forLoopAIndex = bj_forLoopAIndex + 1
	endloop
	call DzFrameShow( udg_BACKDROP[0], false)
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_UI______1 takes nothing returns nothing
	set gg_trg_UI______1 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_UI______1,"UI创建1")
#endif
	call TriggerAddAction(gg_trg_UI______1, function Trig_UI______1Actions)
endfunction

//===========================================================================
// Trigger: 交互同步1
//===========================================================================
function Trig_____________1Actions takes nothing returns nothing
	YDLocalInitialize()
	call YDLocal1Set(string, "同步的数据", DzGetTriggerSyncData())
	call YDLocal1Set(player, "同步的玩家", DzGetTriggerSyncPlayer())
	if ((YDLocal1Get(string, "同步的数据") == "1")) then
		call DisplayTextToPlayer( Player(0), 0, 0, YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( LoadItemHandle( udg_Hx, GetConvertedPlayerId( YDLocal1Get(player, "同步的玩家")), 1)), "Name"))
	else
	endif
	if ((YDLocal1Get(string, "同步的数据") == "2")) then
		call DisplayTextToPlayer( Player(0), 0, 0, YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( LoadItemHandle( udg_Hx, GetConvertedPlayerId( YDLocal1Get(player, "同步的玩家")), 2)), "Name"))
	else
	endif
	if ((YDLocal1Get(string, "同步的数据") == "3")) then
		call DisplayTextToPlayer( Player(0), 0, 0, YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( LoadItemHandle( udg_Hx, GetConvertedPlayerId( YDLocal1Get(player, "同步的玩家")), 3)), "Name"))
	else
	endif
	if ((GetLocalPlayer() == YDLocal1Get(player, "同步的玩家"))) then
		call DzFrameShow( udg_BACKDROP[0], false)
	else
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_____________1 takes nothing returns nothing
	set gg_trg_____________1 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_____________1,"交互同步1")
#endif
	call DzTriggerRegisterSyncData(gg_trg_____________1, "UI交互", false)
	call TriggerAddAction(gg_trg_____________1, function Trig_____________1Actions)
endfunction//===========================================================================
// Trigger: 三选一1
//===========================================================================
function Trig__________1Actions takes nothing returns nothing
	set udg_Hx = YDWEInitHashtable()
	set udg_D = CreateItemPool()
	call ItemPoolAddItemType( udg_D, 'ratf', 1)
	call ItemPoolAddItemType( udg_D, 'ckng', 1)
	call ItemPoolAddItemType( udg_D, 'desc', 1)
	call ItemPoolAddItemType( udg_D, 'tkno', 1)
	call ItemPoolAddItemType( udg_D, 'rde4', 1)
endfunction

//===========================================================================
function InitTrig__________1 takes nothing returns nothing
	set gg_trg__________1 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg__________1,"三选一1")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg__________1, 0.00)
	call TriggerAddAction(gg_trg__________1, function Trig__________1Actions)
endfunction

//===========================================================================
// Trigger: Esc显示
//===========================================================================
function Trig_Esc______uActions takes nothing returns nothing
	YDLocalInitialize()
	set bj_forLoopAIndex = 1
	set bj_forLoopAIndexEnd = 3
	loop
		exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
		call YDLocal1Set(item, "Wp", PlaceRandomItem( udg_D, 0, 0))
		call SaveItemHandle( udg_Hx, GetConvertedPlayerId( Player(0)), bj_forLoopAIndex, YDLocal1Get(item, "Wp"))
		if ((GetLocalPlayer() == Player())) then
			call DzFrameSetText( udg_TEXT[bj_forLoopAIndex], YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( YDLocal1Get(item, "Wp")), "Name"))
			call DzFrameShow( udg_BACKDROP[0], true)
		else
		endif
		set bj_forLoopAIndex = bj_forLoopAIndex + 1
	endloop
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_Esc______u takes nothing returns nothing
	set gg_trg_Esc______u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Esc______u,"Esc显示")
#endif
#define YDTRIGGER_COMMON_LOOP(n) 	call TriggerRegisterPlayerEventEndCinematic(gg_trg_Esc______u, Player(n))
#define YDTRIGGER_COMMON_LOOP_LIMITS (0, 15)
#include <YDTrigger/Common/loop.h>
	call TriggerAddAction(gg_trg_Esc______u, function Trig_Esc______uActions)
endfunction  会异步吗