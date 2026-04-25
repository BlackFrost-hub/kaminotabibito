//===========================================================================
// Trigger: worldmapbutton
//===========================================================================
function Trig_worldmapbuttonFunc003A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	if ((GetOwningPlayer( YDLocal2Get(unit, "选取单位")) == YDLocal2Get(player, "玩家"))) then
		call YDLocal2Set(unit, "英雄", GetEnumUnit())
	else
	endif
endfunction

function Trig_worldmapbuttonFunc004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((RectContainsUnit( gg_rct______________038, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map1","4", frame), true)
		else
		endif
	else
	endif
	if (((RectContainsUnit( gg_rct________________QY, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________032, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true))) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map2","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct________________00X, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map3","4", frame), true)
		else
		endif
	else
	endif
	if (((RectContainsUnit( gg_rct______________0734354, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________025, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true))) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map4","4", frame), true)
		else
		endif
	else
	endif
	if (((RectContainsUnit( gg_rct______________067, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________007, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true))) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map5","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct_007____________u, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map6","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________084, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map7","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________064, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map8","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________081, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map9","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct_____________001, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map10","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________066, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map11","4", frame), true)
		else
		endif
	else
	endif
	if (((RectContainsUnit( gg_rct______________107, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________108, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true))) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map12","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________086, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map14","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct______________073, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map15","4", frame), true)
		else
		endif
	else
	endif
	if ((RectContainsUnit( gg_rct_____________002, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true)) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map16","4", frame), true)
		else
		endif
	else
	endif
	if (((RectContainsUnit( gg_rct________________RYEMC, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________003, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true) or (RectContainsUnit( gg_rct______________097, YDLocalGet(GetExpiredTimer(), unit, "英雄")) == true))) then
		if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "map17","4", frame), true)
		else
		endif
	else
	endif
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_worldmapbuttonFunc005Func002Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), player, "玩家") == GetLocalPlayer())) then
		call DzFrameShow( YDUserDataGet(string, "worldmap","放大", frame), false)
		call DzFrameShow( YDUserDataGet(string, "worldmap","frame", frame), true)
	else
	endif
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_worldmapbuttonActions takes nothing returns nothing
	local integer ydul_A
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(player, "玩家", DzGetTriggerKeyPlayer())
	if (((YDLocal1Get(player, "玩家") == GetLocalPlayer()))) then
		set ydul_A = 1
		loop
			exitwhen ydul_A > 28
			call DzFrameShow( YDUserDataGet(string, ("map" + I2S( ydul_A)),"4", frame), false)
			set ydul_A = ydul_A + 1
		endloop
	else
	endif
	call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_worldmapbuttonFunc003A)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "英雄", YDLocal1Get(unit, "英雄"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.00, false, function Trig_worldmapbuttonFunc004T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig_worldmapbuttonFunc004T","worldmapbutton")
#endif 
	call Sound3DII_Mp3Play( "XT\\YX-FY.mp3", YDLocal1Get(player, "玩家"))
	if ((YDUserDataGet(player, YDLocal1Get(player, "玩家"),"世界地图", boolean) == false)) then
		call YDUserDataSet(player, YDLocal1Get(player, "玩家"),"世界地图", boolean, true)
		if ((YDLocal1Get(player, "玩家") == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "worldmap","放大", frame), true)
		else
		endif
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "玩家", YDLocal1Get(player, "玩家"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.30, false, function Trig_worldmapbuttonFunc005Func002Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.30, false," function Trig_worldmapbuttonFunc005Func002Func006T","worldmapbutton")
#endif 
	else
		call YDUserDataSet(player, YDLocal1Get(player, "玩家"),"世界地图", boolean, false)
		if ((YDLocal1Get(player, "玩家") == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "worldmap","frame", frame), false)
		else
		endif
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_worldmapbutton takes nothing returns nothing
	set gg_trg_worldmapbutton = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_worldmapbutton,"worldmapbutton")
#endif
	call DzTriggerRegisterKeyEventTrg(gg_trg_worldmapbutton, 0, 'M')
	call TriggerAddAction(gg_trg_worldmapbutton, function Trig_worldmapbuttonActions)
endfunction

