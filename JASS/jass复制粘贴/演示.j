//===========================================================================
// Trigger: Int
//===========================================================================
function Trig_IntActions takes nothing returns nothing
	call BJDebugMsg( "TRIGSTR_067")
	call BJDebugMsg( "TRIGSTR_068")
	call BJDebugMsg( "TRIGSTR_069")
	set bj_forLoopAIndex = 1
	set bj_forLoopAIndexEnd = 12
	loop
		exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
		call TriggerRegisterPlayerChatEvent(gg_trg_New, ConvertedPlayer( bj_forLoopAIndex), "-New", true)
		call TriggerRegisterPlayerChatEvent(gg_trg_Save, ConvertedPlayer( bj_forLoopAIndex), "-Save", true)
		call TriggerRegisterPlayerChatEvent(gg_trg_Load, ConvertedPlayer( bj_forLoopAIndex), "-Load", true)
		set bj_forLoopAIndex = bj_forLoopAIndex + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Int takes nothing returns nothing
	set gg_trg_Int = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Int,"Int")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg_Int, 0.00)
	call TriggerAddAction(gg_trg_Int, function Trig_IntActions)
endfunction

//===========================================================================
// Trigger: New
//===========================================================================
function Trig_NewActions takes nothing returns nothing
	set udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())] = CreateUnit( GetTriggerPlayer(), YDWEI2UnitId( YDWE_PreloadSL_Get( GetTriggerPlayer(), "单位ID", 1)), 0, 300.00, 0)
	set udg_filename = "chunxue3C"
	call YDWE_PreloadSL_Set( GetTriggerPlayer(), "单位ID", 1, YDWEConverUnitcodeToInt( 'Hpal'))
	set bj_forLoopBIndex = 1
	set bj_forLoopBIndexEnd = 6
	loop
		exitwhen bj_forLoopBIndex > bj_forLoopBIndexEnd
		call YDWE_PreloadSL_Set( GetTriggerPlayer(), "物品", (bj_forLoopBIndex + 1), 0)
		set bj_forLoopBIndex = bj_forLoopBIndex + 1
	endloop
	call YDWE_PreloadSL_Save( GetTriggerPlayer(), "YDWE", udg_filename, 7)
endfunction

//===========================================================================
function InitTrig_New takes nothing returns nothing
	set gg_trg_New = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_New,"New")
#endif
	call TriggerAddAction(gg_trg_New, function Trig_NewActions)
endfunction

//===========================================================================
// Trigger: Save
//===========================================================================
function Trig_SaveActions takes nothing returns nothing
	set udg_filename = "chunxue3C"
	call YDWE_PreloadSL_Set( GetTriggerPlayer(), "单位ID", 1, YDWEConverUnitcodeToInt( GetUnitTypeId( udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())])))
	set bj_forLoopBIndex = 0
	set bj_forLoopBIndexEnd = 5
	loop
		exitwhen bj_forLoopBIndex > bj_forLoopBIndexEnd
		call YDWE_PreloadSL_Set( GetTriggerPlayer(), "物品", (bj_forLoopBIndex + 2), YDWEConverItemcodeToInt( GetItemTypeId( UnitItemInSlot( udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())], bj_forLoopBIndex))))
		set bj_forLoopBIndex = bj_forLoopBIndex + 1
	endloop
	call YDWE_PreloadSL_Save( GetTriggerPlayer(), "YDWE", udg_filename, 7)
endfunction

//===========================================================================
function InitTrig_Save takes nothing returns nothing
	set gg_trg_Save = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Save,"Save")
#endif
	call TriggerAddAction(gg_trg_Save, function Trig_SaveActions)
endfunction
//===========================================================================
// Trigger: Load
//===========================================================================
function Trig_LoadActions takes nothing returns nothing
	call BJDebugMsg( ("|cFF00FF00玩家" + (I2S( GetConvertedPlayerId( GetTriggerPlayer())) + "开始读档。。。|r")))
	set udg_filename = "chunxue3C"
	call YDWE_PreloadSL_Load( GetTriggerPlayer(), "YDWE", udg_filename, 7)
	if ((bj_lastLoadPreloadSLResult == true)) then
		call RemoveUnit( udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())])
		call BJDebugMsg( ("|cFF00FF00玩家" + (I2S( GetConvertedPlayerId( GetTriggerPlayer())) + "读档完成！|r")))
		set udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())] = CreateUnit( GetTriggerPlayer(), YDWEI2UnitId( YDWE_PreloadSL_Get( GetTriggerPlayer(), "单位ID", 1)), 0, 300.00, 0)
		set bj_forLoopBIndex = 0
		set bj_forLoopBIndexEnd = 5
		loop
			exitwhen bj_forLoopBIndex > bj_forLoopBIndexEnd
			call UnitAddItemToSlotById( udg_Hero[GetConvertedPlayerId( GetTriggerPlayer())], YDWEI2ItemId( YDWE_PreloadSL_Get( GetTriggerPlayer(), "物品", (bj_forLoopBIndex + 2))), bj_forLoopBIndex)
			set bj_forLoopBIndex = bj_forLoopBIndex + 1
		endloop
	else
		call BJDebugMsg( ("|cFFFF0000玩家" + (I2S( GetConvertedPlayerId( GetTriggerPlayer())) + "读档失败！|r")))
	endif
endfunction

//===========================================================================
function InitTrig_Load takes nothing returns nothing
	set gg_trg_Load = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Load,"Load")
#endif
	call TriggerAddAction(gg_trg_Load, function Trig_LoadActions)
endfunction


