//===========================================================================
// Trigger: world精灵村
//===========================================================================
function Trig_world_________uFunc003Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call DisplayCineFilter( false)
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

function Trig_world_________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(player, "玩家", DzGetTriggerUIEventPlayer())
	call YDLocal1Set(unit, "英雄", YDUserDataGet(player, YDLocal1Get(player, "玩家"),"英雄", unit))
	if ((YDUserDataGet(string, "剧情进度","整数", integer) != 16) and (UnitHasBuffBJ( YDLocal1Get(unit, "英雄"), 'B001') == true)) then
		if ((YDLocal1Get(player, "玩家") == GetLocalPlayer())) then
			call DzFrameShow( YDUserDataGet(string, "worldmap","frame", frame), false)
			call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 15.00, 15.00, 15.00, 15.00, 0, 0, 0, 0)
		else
		endif
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 2.50, false, function Trig_world_________uFunc003Func003T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 2.50, false," function Trig_world_________uFunc003Func003T","world精灵村")
#endif 
		call Sound3DII_Mp3Play( "XT\\YX-CS.mp3", YDLocal1Get(player, "玩家"))
		call SetUnitPosition( YDLocal1Get(unit, "英雄"), -25675.10, -27139.60)
		call StarOther_PanCameraToTimedForPlayer( YDLocal1Get(player, "玩家"), -25675.10, -27139.60, 0.03)
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_world_________u takes nothing returns nothing
	set gg_trg_world_________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_world_________u,"world精灵村")
#endif
	call TriggerAddAction(gg_trg_world_________u, function Trig_world_________uActions)
endfunction

