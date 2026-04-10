//===========================================================================
// Trigger: JLC精灵村001
//===========================================================================
function Trig_JLC_________001Conditions takes nothing returns boolean
	return ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true))
endfunction

function Trig_JLC_________001Func008Func005003002 takes nothing returns boolean
	return (GetUnitTypeId( GetFilterUnit()) == 'etrp')
endfunction

function Trig_JLC_________001Func008Func006Func002Func006A takes nothing returns nothing
	call IssueImmediateOrder( GetEnumUnit(), "stop")
	call SetUnitFacing( GetEnumUnit(), YDLocal2Get(degree, "角度"))
endfunction

function Trig_JLC_________001Func008Func006A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	if ((GetUnitTypeId( YDLocal2Get(unit, "选取单位")) == 'etrp')) then
		call YDLocal2Set(unit, "自然守护者", YDLocal2Get(unit, "选取单位"))
		call YDLocal2Set(location, "目标点", GetUnitLoc( YDLocal2Get(unit, "自然守护者")))
		call YDLocal2Set(degree, "角度", YDWEAngleBetweenUnits( GetTriggerUnit(), YDLocal2Get(unit, "自然守护者")))
		call SetUnitFacing( YDLocal2Get(unit, "自然守护者"), 210.00)
		call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func008Func006Func002Func006A)
	else
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10213")
	endif
endfunction

function Trig_JLC_________001Func010Func001A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct________________QY)
endfunction

function Trig_JLC_________001Func010Func041A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________085)
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________032)
endfunction

function Trig_JLC_________001Func011Func003A takes nothing returns nothing
	call SetUnitInvulnerable( GetEnumUnit(), true)
	call PauseUnit( GetEnumUnit(), true)
endfunction

function Trig_JLC_________001Func011Func009Func046Func004A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	if ((GetOwningPlayer( YDLocal2Get(unit, "选取单位")) == YDLocal2Get(player, "选取玩家"))) then
		call YDLocal2Set(location, "单位点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
		call PanCameraToTimedLocForPlayer( YDLocal2Get(player, "选取玩家"), YDLocal2Get(location, "单位点"), 0.10)
		call RemoveLocation( YDLocal2Get(location, "单位点"))
	else
	endif
endfunction

function Trig_JLC_________001Func011Func009Func046A takes nothing returns nothing
	call YDLocal2Set(player, "选取玩家", GetEnumPlayer())
	call ResetToGameCameraForPlayer( YDLocal2Get(player, "选取玩家"), 0)
	call SetCameraFieldForPlayer( YDLocal2Get(player, "选取玩家"), CAMERA_FIELD_TARGET_DISTANCE, 3250.00, 0)
	call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func011Func009Func046Func004A)
endfunction

function Trig_JLC_________001Func011Func009Func047A takes nothing returns nothing
	call SetUnitInvulnerable( GetEnumUnit(), false)
	call PauseUnit( GetEnumUnit(), false)
endfunction

function Trig_JLC_________001Func011Func009Func048T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "3"))
	call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "4"))
	call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "7"))
	call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "8"))
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

function Trig_JLC_________001Func011Func009Func003A takes nothing returns nothing
	call SetUnitInvulnerable( GetEnumUnit(), false)
	call PauseUnit( GetEnumUnit(), false)
endfunction

function Trig_JLC_________001Func013Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call SetStackedSoundBJ( false, gg_snd_Bossbattle001, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battle01, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBgm002, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBgm003, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBoss001, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBoss2, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBoss3, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBosszuizhong01, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battleBoss2, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_battle01, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_shengliBgm, YDLocalGet(GetExpiredTimer(), rect, "地点"))
	call SetStackedSoundBJ( false, gg_snd_shengliBgm, YDLocalGet(GetExpiredTimer(), rect, "地点"))
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

function Trig_JLC_________001Func014Func014A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________104)
endfunction

function Trig_JLC_________001Func015Func009A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct_____________001)
endfunction

function Trig_JLC_________001Func017Func010A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________030)
endfunction

function Trig_JLC_________001Func018Func017A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________1522)
endfunction

function Trig_JLC_________001Func019Func020003002 takes nothing returns boolean
	return ((IsPlayerInForce( GetOwningPlayer( GetFilterUnit()), YDUserDataGet(string, "玩家","玩家组", force)) == false) and (GetUnitTypeId( GetFilterUnit()) == 'nhea'))
endfunction

function Trig_JLC_________001Func019Func021A takes nothing returns nothing
	call RemoveUnit( GetEnumUnit())
endfunction

function Trig_JLC_________001Func019Func027Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), null, "TRIGSTR_10735", bj_TIMETYPE_SET, 2.50, false)
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

function Trig_JLC_________001Func019Func027T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_WARNING, "TRIGSTR_10628")
	call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_WARNING, "TRIGSTR_10629")
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 5.00, false, function Trig_JLC_________001Func019Func027Func003T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 5.00, false," function Trig_JLC_________001Func019Func027Func003T","JLC精灵村001")
#endif 
	if ((10 >= 10)) then
		call SetStackedSoundBJ( false, gg_snd_zhuchengBGM01, gg_rct________________QY)
		call SetStackedSoundBJ( false, gg_snd_BGM006, gg_rct________________00X)
		call SetStackedSoundBJ( false, gg_snd_BGM007, gg_rct______________084)
		call SetStackedSoundBJ( false, gg_snd_BGM006, gg_rct_007____________u)
		call SetStackedSoundBJ( false, gg_snd_BGM008, gg_rct______________081)
		call SetStackedSoundBJ( false, gg_snd_BGM016, gg_rct______________083)
		call SetStackedSoundBJ( false, gg_snd_BGM016, gg_rct______________055)
		call SetStackedSoundBJ( false, gg_snd_BGM016, gg_rct______________086)
		call SetStackedSoundBJ( false, gg_snd_BGM017, gg_rct______________083)
		call SetStackedSoundBJ( false, gg_snd_BGM017, gg_rct______________055)
		call SetStackedSoundBJ( false, gg_snd_BGM017, gg_rct______________086)
		call SetStackedSoundBJ( false, gg_snd_bgm003, gg_rct_____________001)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct______________055)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct_____________001)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct______________086)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct______________083)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct______________081)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct_007____________u)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct________________00X)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct______________084)
		call SetStackedSoundBJ( true, gg_snd_JQBGM03, gg_rct________________QY)
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
	set ydl_timer = null
endfunction

function Trig_JLC_________001Func020Func008A takes nothing returns nothing
	call PauseUnit( GetEnumUnit(), true)
	call SetUnitInvulnerable( GetEnumUnit(), true)
endfunction

function Trig_JLC_________001Func020Func010003002 takes nothing returns boolean
	return ((IsPlayerInForce( GetOwningPlayer( GetFilterUnit()), YDUserDataGet(string, "玩家","玩家组", force)) == false) and (GetOwningPlayer( GetFilterUnit()) == Player(PLAYER_NEUTRAL_PASSIVE)))
endfunction

function Trig_JLC_________001Func020Func011A takes nothing returns nothing
	call ShowUnit( GetEnumUnit(), false)
endfunction

function Trig_JLC_________001Func020Func046A takes nothing returns nothing
	call CameraSetupApplyForPlayer( true, gg_cam_Camera_014_______u, GetEnumPlayer(), 0)
	call StarOther_PanCameraToTimedForPlayer( GetEnumPlayer(), -26236.20, -28701.70, 5.00)
endfunction

function Trig_JLC_________001Func020Func048A takes nothing returns nothing
	call CameraSetupApplyForPlayer( true, gg_cam_Camera_014, GetEnumPlayer(), 0)
endfunction

function Trig_JLC_________001Func020Func053A takes nothing returns nothing
	call SetUnitX( GetEnumUnit(), -26846.70)
	call SetUnitY( GetEnumUnit(), -27820.80)
	call EXSetUnitFacing( GetEnumUnit(), YDWEAngleBetweenUnits( GetEnumUnit(), YDLocal2Get(unit, "0")))
endfunction

function Trig_JLC_________001Func020Func058A takes nothing returns nothing
	call PauseUnit( GetEnumUnit(), false)
	call SetUnitInvulnerable( GetEnumUnit(), false)
	call IssueTargetOrder( GetEnumUnit(), "attack", YDLocal2Get(unit, "0"))
endfunction

function Trig_JLC_________001Func020Func062A takes nothing returns nothing
	call SetCameraFieldForPlayer( GetEnumPlayer(), CAMERA_FIELD_TARGET_DISTANCE, 3000.00, 0)
	call ResetToGameCameraForPlayer( GetEnumPlayer(), 0)
endfunction

function Trig_JLC_________001Func020Func065Func024Func023T takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), group, "DWZ", CreateGroup())
	set ydl_group = CreateGroup()
	call GroupEnumUnitsInRange(ydl_group, GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "BS")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "BS")), 900.00, null)
	loop
		set ydl_unit = FirstOfGroup(ydl_group)
		exitwhen ydl_unit == null
		call GroupRemoveUnit(ydl_group, ydl_unit)
		if ((IsUnitAliveBJ( ydl_unit) == true) and (IsUnitType( ydl_unit, UNIT_TYPE_ANCIENT) == false) and (IsUnitType( ydl_unit, UNIT_TYPE_MECHANICAL) == false) and (IsUnitType( ydl_unit, UNIT_TYPE_STRUCTURE) == false) and (IsUnitEnemy( ydl_unit, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "BS"))) == true) and (GetOwningPlayer( ydl_unit) != Player(6))) then
			call GroupAddUnit( YDLocalGet(GetExpiredTimer(), group, "DWZ"), ydl_unit)
		else
		endif
	endloop
	call DestroyGroup(ydl_group)
	call YDLocalSet(GetExpiredTimer(), unit, "玩家", GroupPickRandomUnit( YDLocalGet(GetExpiredTimer(), group, "DWZ")))
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "DWZ"))
	if ((YDLocalGet(GetExpiredTimer(), unit, "玩家") == null)) then
	else
		call YDLocalSet(GetExpiredTimer(), integer, "ZS", GetRandomInt( 1, 4))
		if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 1)) then
			call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0LC', "Order"))
		else
			if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 2)) then
				call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0LB', "Order"))
			else
				if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 3)) then
					call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0LA', "Order"))
				else
					if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 4)) then
						call IssueNeutralTargetOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0L9', "Order"), YDLocalGet(GetExpiredTimer(), unit, "玩家"))
					else
					endif
				endif
			endif
		endif
	endif
	if (((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == true) or (IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == false))) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_group = null
	set ydl_unit = null
endfunction

function Trig_JLC_________001Func020Func065Func023T takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), group, "DWZ", CreateGroup())
	set ydl_group = CreateGroup()
	call GroupEnumUnitsInRange(ydl_group, GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "BS")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "BS")), 900.00, null)
	loop
		set ydl_unit = FirstOfGroup(ydl_group)
		exitwhen ydl_unit == null
		call GroupRemoveUnit(ydl_group, ydl_unit)
		if ((IsUnitAliveBJ( ydl_unit) == true) and (IsUnitType( ydl_unit, UNIT_TYPE_ANCIENT) == false) and (IsUnitType( ydl_unit, UNIT_TYPE_MECHANICAL) == false) and (IsUnitType( ydl_unit, UNIT_TYPE_STRUCTURE) == false) and (IsUnitEnemy( ydl_unit, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "BS"))) == true) and (GetOwningPlayer( ydl_unit) != Player(6))) then
			call GroupAddUnit( YDLocalGet(GetExpiredTimer(), group, "DWZ"), ydl_unit)
		else
		endif
	endloop
	call DestroyGroup(ydl_group)
	call YDLocalSet(GetExpiredTimer(), unit, "玩家", GroupPickRandomUnit( YDLocalGet(GetExpiredTimer(), group, "DWZ")))
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "DWZ"))
	if ((YDLocalGet(GetExpiredTimer(), unit, "玩家") == null)) then
	else
		call YDLocalSet(GetExpiredTimer(), integer, "ZS", GetRandomInt( 1, 3))
		if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 1)) then
			call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0L8', "Order"))
		else
			if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 2)) then
				call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0L5', "Order"))
			else
				if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 3)) then
					call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0L7', "Order"))
				else
				endif
			endif
		endif
	endif
	if (((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == true) or (IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == false))) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_group = null
	set ydl_unit = null
endfunction

function Trig_JLC_________001Func020Func079Func001Func006Func002A takes nothing returns nothing
	call ShowUnit( GetEnumUnit(), true)
endfunction

function Trig_JLC_________001Func020Func079Func001Func006T takes nothing returns nothing
	local integer ydul_A
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	set ydul_A = 1
	loop
		exitwhen ydul_A > 20
		call DzDoodadSetOrientMatrixScale( udg_DXZSW/*剧情*/[ydul_A], 0, 0, 0)
		call DzDoodadSetVisible( udg_DXZSW/*剧情*/[ydul_A], false)
		set ydul_A = ydul_A + 1
	endloop
	call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "DWZ"),function Trig_JLC_________001Func020Func079Func001Func006Func002A)
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "DWZ"))
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

function Trig_JLC_________001Func020Func079T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == false) or (IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == true))) then
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "1"))
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "2"))
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "3"))
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "4"))
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "5"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, group, "DWZ", YDLocalGet(GetExpiredTimer(), group, "DWZ"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 90.00, false, function Trig_JLC_________001Func020Func079Func001Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 90.00, false," function Trig_JLC_________001Func020Func079Func001Func006T","JLC精灵村001")
#endif 
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig_JLC_________001Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(location, "单位位置", GetUnitLoc( GetTriggerUnit()))
	if ((RectContainsLoc( gg_rct______________077, YDLocal1Get(location, "单位位置")) == true)) then
		call StopMusic( false)
		call RemoveRect( gg_rct______________077)
		call YDLocal1Set(unit, "演员单位", GetTriggerUnit())
		call YDLocal1Set(group, "单位组", GetUnitsInRectMatching( gg_rct________________QY, Condition(function Trig_JLC_________001Func008Func005003002)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_JLC_________001Func008Func006A)
		call DestroyGroup( YDLocal1Get(group, "单位组"))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10214", null, "TRIGSTR_10216", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10217", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10218", null, "TRIGSTR_10219", bj_TIMETYPE_SET, 3.00, true)
		call ModifyGateBJ( bj_GATEOPERATION_OPEN, gg_dest_LTe3_0298)
		call StopMusic( false)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10220")
		call PingMinimap( -29109.70, -27625.60, 10.00)
	else
	endif
	//长老对话
	if ((YDUserDataGet(string, "剧情进度","整数", integer) < 1) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","精灵村长老", unit), 800.00) == true) and (IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true)) then
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func010Func001A)
		call SetUnitOwner( gg_unit_n025_0372, Player(6), true)
		call RemoveLocation( udg_FHD)
		set udg_FHD = Location( -26218.60, -28632.40)
		call YDLocal1Set(real, "X", OperatorRealAdd( -10112.90, GetRandomReal( -1800.00, 1800.00)))
		call YDLocal1Set(real, "Y", OperatorRealAdd( -26327.30, GetRandomReal( -1800.00, 1800.00)))
		call CreateItem( 'I09S', YDLocal1Get(real, "X"), YDLocal1Get(real, "Y"))
		call YDLocal1Set(unit, "精灵村长老", YDUserDataGet(string, "主线NPC","精灵村长老", unit))
		call StopMusic( false)
		call YDUserDataSet(string, "剧情进度","整数", integer, 1)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call SetUnitFacingToFaceUnitTimed( GetTriggerUnit(), YDLocal1Get(unit, "精灵村长老"), 1.00)
		call SetUnitOwner( YDLocal1Get(unit, "精灵村长老"), Player(6), true)
		call SetUnitFacingTimed( YDLocal1Get(unit, "精灵村长老"), YDWEAngleBetweenUnits( YDLocal1Get(unit, "精灵村长老"), GetTriggerUnit()), 1.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10221", null, "TRIGSTR_10222", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10228", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10230", null, "TRIGSTR_10242", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10243", bj_TIMETYPE_SET, 1.50, true)
		call EC_CreateEffect( "Abilities\\Spells\\Other\\Awaken\\Awaken.mdl", GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0.0, 270.0, 4.00, 1.0, 3.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10247", null, "TRIGSTR_10252", bj_TIMETYPE_SET, 2.50, true)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, (GetUnitName( GetTriggerUnit()) + "受到了远古波动！（|cffff99cc全属性+3|r）"))
		call ModifyHeroStat( bj_HEROSTAT_STR, GetTriggerUnit(), bj_MODIFYMETHOD_ADD, 3)
		call ModifyHeroStat( bj_HEROSTAT_AGI, GetTriggerUnit(), bj_MODIFYMETHOD_ADD, 3)
		call ModifyHeroStat( bj_HEROSTAT_INT, GetTriggerUnit(), bj_MODIFYMETHOD_ADD, 3)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10253", null, "TRIGSTR_10254", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10255", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10258", null, "TRIGSTR_10259", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10263", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10270", null, "TRIGSTR_10275", bj_TIMETYPE_SET, 4.80, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10276", null, "TRIGSTR_10279", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10291", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10292", null, "TRIGSTR_10297", bj_TIMETYPE_SET, 6.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10298", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10299", null, "TRIGSTR_10352", bj_TIMETYPE_SET, 6.00, true)
		call CreateItem( 'I00X', GetUnitX( YDLocal1Get(unit, "精灵族长老")), GetUnitY( YDLocal1Get(unit, "精灵村长老")))
		call CreateItem( 'I04E', GetUnitX( YDLocal1Get(unit, "精灵族长老")), GetUnitY( YDLocal1Get(unit, "精灵村长老")))
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10365")
		call PingMinimap( -29392.70, -20049.20, 20.00)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10371")
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func010Func041A)
		call StopMusic( false)
		call YDUserDataSet(string, "Boss","地精巫师", unit, CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'N00C', -26032.40, -13789.50, 270.00))
		call PauseUnit( YDUserDataGet(string, "Boss","地精巫师", unit), true)
		call SetUnitInvulnerable( YDUserDataGet(string, "Boss","地精巫师", unit), true)
		call SetUnitOwner( YDLocal1Get(unit, "精灵族长老"), Player(6), true)
		call TriggerRegisterUnitInRangeSimple(gg_trg_JLC_________001, 750.00, YDUserDataGet(string, "Boss","地精巫师", unit))
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 1) and (RectContainsLoc( gg_rct______________020, YDLocal1Get(location, "单位位置")) == true)) then
		call YDLocal1Set(unit, "15", YDUserDataGet(string, "Boss","地精巫师", unit))
		call SetTimeOfDay( 0.00)
		call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func011Func003A)
		call YDUserDataSet(string, "剧情进度","整数", integer, 2)
		call CinematicModeBJ( true, GetPlayersAll())
		call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50.00, 50.00, 50.00, 50.00, 0, 0, 0, 0)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10372", null, "TRIGSTR_10375", bj_TIMETYPE_SET, 5.00, true)
		call DisplayCineFilter( false)
		if ((YDUserDataGet(string, "主线剧情","跳过", boolean) == true)) then
			call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func011Func009Func003A)
			call CinematicModeBJ( false, GetPlayersAll())
		else
			call SetStackedSoundBJ( true, gg_snd_JQBGM01, gg_rct______________102)
			call YDLocal1Set(unit, "1", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n009', -26266.80, -14055.60, 45.00))
			call YDLocal1Set(unit, "2", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n009', -25716.80, -14086.20, 135.00))
			call YDLocal1Set(unit, "3", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n008', -26276.10, -13945.20, 45.00))
			call YDLocal1Set(unit, "4", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n008', -25713.50, -13958.60, 135.00))
			call YDLocal1Set(unit, "5", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n01H', -25994.50, -13977.60, 90.00))
			call YDLocal1Set(unit, "6", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'nhef', -25909.90, -14001.30, 90.00))
			call CameraSetupApplyForceDuration( gg_cam___________________005, true, 0)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "15"), "TRIGSTR_10378", null, "TRIGSTR_10379", bj_TIMETYPE_SET, 3.50, true)
			call SetUnitAnimationByIndex( YDUserDataGet(string, "Boss","地精巫师", unit), 4)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10380", null, "TRIGSTR_10381", bj_TIMETYPE_SET, 1.00, true)
			call YDLocal1Set(unit, "100", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'e00U', -25959.40, -14091.00, 90.00))
			call KillUnit( YDLocal1Get(unit, "5"))
			call KillUnit( YDLocal1Get(unit, "6"))
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10382", null, "TRIGSTR_10400", bj_TIMETYPE_SET, 3.00, true)
			call IssuePointOrder( YDLocal1Get(unit, "1"), "move", -25909.90, -14001.30)
			call IssuePointOrder( YDLocal1Get(unit, "2"), "move", -25994.50, -13977.60)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10401", null, "TRIGSTR_10402", bj_TIMETYPE_SET, 4.00, true)
			call RemoveUnit( YDLocal1Get(unit, "1"))
			call RemoveUnit( YDLocal1Get(unit, "2"))
			call YDLocal1Set(unit, "7", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n008', -25909.90, -14001.30, 90.00))
			call YDLocal1Set(unit, "8", CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n008', -25994.50, -13977.60, 90.00))
			call EC_CreateEffect( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", -25959.40, -14091.00, 0.0, 270.0, 2.00, 1.0, 2.00)
			call PlaySoundBJ( gg_snd_GWSY0101)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "15"), "TRIGSTR_10403", null, "TRIGSTR_10418", bj_TIMETYPE_SET, 3.00, true)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "3"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "4"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "7"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "8"), 1)
			call SetUnitFacing( YDUserDataGet(string, "Boss","地精巫师", unit), 90.00)
			call SetUnitAnimationByIndex( YDUserDataGet(string, "Boss","地精巫师", unit), 4)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "15"), "TRIGSTR_10420", null, "TRIGSTR_10421", bj_TIMETYPE_SET, 3.00, true)
			call PlaySoundBJ( gg_snd_GWSY0101)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "3"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "4"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "7"), 1)
			call SetUnitAnimationByIndex( YDLocal1Get(unit, "8"), 1)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10422", null, "TRIGSTR_10423", bj_TIMETYPE_SET, 3.50, true)
			call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50.00, 50.00, 50.00, 50.00, 0, 0, 0, 0)
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10424", null, "TRIGSTR_10425", bj_TIMETYPE_SET, 1.50, true)
			call DisplayCineFilter( false)
			call CinematicModeBJ( false, GetPlayersAll())
			call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func011Func009Func046A)
			call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func011Func009Func047A)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "3", YDLocal1Get(unit, "3"))
			call YDLocalSet(ydl_timer, unit, "4", YDLocal1Get(unit, "4"))
			call YDLocalSet(ydl_timer, unit, "7", YDLocal1Get(unit, "7"))
			call YDLocalSet(ydl_timer, unit, "8", YDLocal1Get(unit, "8"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3.00, false, function Trig_JLC_________001Func011Func009Func048T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig_JLC_________001Func011Func009Func048T","JLC精灵村001")
#endif 
			call SetMusicVolume( 0)
		endif
		call SetStackedSoundBJ( false, gg_snd_JQBGM01, gg_rct______________102)
		call SetStackedSoundBJ( true, gg_snd_BGM002, gg_rct______________025)
	else
	endif
	//这里开启了地精巫师的Boss战
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 2) and (GetOwningPlayer( YDUserDataGet(string, "Boss","地精巫师", unit)) == Player(PLAYER_NEUTRAL_PASSIVE)) and (IsUnitAliveBJ( YDUserDataGet(string, "Boss","地精巫师", unit)) == true) and (IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "Boss","地精巫师", unit), 755.00) == true)) then
		call YDLocal1Set(rect, "地点", gg_rct______________111)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, rect, "地点", YDLocal1Get(rect, "地点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.00, false, function Trig_JLC_________001Func013Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig_JLC_________001Func013Func002T","JLC精灵村001")
#endif 
		call GroupAddUnit( YDUserDataGet(string, "血条Boss","单位组", group), YDUserDataGet(string, "Boss","地精巫师", unit))
		call YDUserDataSet(string, "剧情进度","整数", integer, 3)
		call YDLocal1Set(unit, "地精巫师", YDUserDataGet(string, "Boss","地精巫师", unit))
		call SetUnitOwner( YDLocal1Get(unit, "地精巫师"), Player(PLAYER_NEUTRAL_AGGRESSIVE), true)
		call PauseUnit( YDLocal1Get(unit, "地精巫师"), true)
		call SetUnitInvulnerable( YDLocal1Get(unit, "地精巫师"), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10426", null, "TRIGSTR_10427", bj_TIMETYPE_ADD, 5.00, true)
		call ModifyGateBJ( bj_GATEOPERATION_CLOSE, gg_dest_DTg5_9811)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10428", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10429", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10430", null, "TRIGSTR_10431", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10455", bj_TIMETYPE_SET, 2.50, true)
		call TriggerRegisterUnitEvent(gg_trg_______Boss001, YDLocal1Get(unit, "地精巫师"), EVENT_UNIT_SPELL_EFFECT)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"魔抗", real, 0.30)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"减少控制时间", real, 0.30)
		call YDUserDataSet(string, "Boss战","绑定单位", unit, YDLocal1Get(unit, "地精巫师"))
		call YDUserDataSet(string, "Boss战","触发玩家", unit, GetTriggerUnit())
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"技能数量", integer, 0)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"转换场景", boolean, true)
		call YDUserDataSet(string, "Boss战","BS移动X轴", real, 25203.00)
		call YDUserDataSet(string, "Boss战","BS移动Y轴", real, 13203.70)
		call YDUserDataSet(string, "Boss战","玩家移动X轴", real, 23808.30)
		call YDUserDataSet(string, "Boss战","玩家移动Y轴", real, 12449.70)
		call YDUserDataSet(string, "Boss战","战斗音乐", sound, gg_snd_Bossbattle001)
		call YDUserDataSet(string, "Boss战","胜利音乐", sound, gg_snd_shengliBgm)
		call YDUserDataSet(string, "Boss战","地点", rect, gg_rct______________111)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"弱点数量", integer, udg_R/*弱点数量*/)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"天生弱点数", integer, 2)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"短剑弱", boolean, true)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"光弱", boolean, true)
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"器弱伤害需求", real, OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "Boss"), UNIT_STATE_MAX_LIFE), 0.03))
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"护盾值", integer, R2I( (5.00 + (2.00 * udg_N))))
		call YDUserDataSet(unit, YDLocal1Get(unit, "地精巫师"),"原始护盾值", integer, R2I( (5.00 + (2.00 * udg_N))))
		call ConditionalTriggerExecute( gg_trg_Boss____________u)
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 4) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","精灵村长老", unit), 800.00) == true) and (IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true)) then
		call YDLocal1Set(unit, "精灵村长老", YDUserDataGet(string, "主线NPC","精灵村长老", unit))
		call YDUserDataSet(string, "剧情进度","整数", integer, 5)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call SetUnitFacingToFaceUnitTimed( GetTriggerUnit(), YDLocal1Get(unit, "精灵村长老"), 1.00)
		call SetUnitFacingTimed( YDLocal1Get(unit, "精灵村长老"), YDWEAngleBetweenUnits( YDLocal1Get(unit, "精灵村长老"), GetTriggerUnit()), 1.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10456", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10457", null, "TRIGSTR_10458", bj_TIMETYPE_SET, 7.00, true)
		call UnitAddItem( GetTriggerUnit(), CreateItem( 'I03J', 0.00, 0))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10459", bj_TIMETYPE_SET, 1.50, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10460")
		call PingMinimap( -16003.40, -24617.30, 20.00)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10461")
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func014Func014A)
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 5) and (RectContainsUnit( gg_rct______________098, GetTriggerUnit()) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 6)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10462", bj_TIMETYPE_SET, 3.00, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10463")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10464")
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func015Func009A)
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 6) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","沙漠年轻佣兵", unit), 450.00) == true) and (GetOwningPlayer( YDUserDataGet(string, "主线NPC","沙漠年轻佣兵", unit)) != Player(6))) then
		call SetUnitOwner( YDUserDataGet(string, "主线NPC","沙漠年轻佣兵", unit), Player(6), true)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10465", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10466", null, "TRIGSTR_10467", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10468", bj_TIMETYPE_SET, 3.00, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10470")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10471")
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 6) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","沙漠年长者", unit), 450.00) == true) and (GetOwningPlayer( YDUserDataGet(string, "主线NPC","沙漠年长者", unit)) != Player(6))) then
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call SetUnitOwner( YDUserDataGet(string, "主线NPC","沙漠年长者", unit), Player(6), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10472", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10473", null, "TRIGSTR_10474", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10475", bj_TIMETYPE_SET, 3.00, true)
		call PingMinimap( -7139.30, -26096.70, 20.00)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func017Func010A)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10476")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10477")
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 6) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","沙漠情报商人", unit), 450.00) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 7)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10478", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10479", null, "TRIGSTR_10480", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10481", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10482", null, "TRIGSTR_10509", bj_TIMETYPE_SET, 5.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10516", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10520", null, "TRIGSTR_10540", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10543", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10544", null, "TRIGSTR_10545", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10547", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10548", null, "TRIGSTR_10552", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10554", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10557", null, "TRIGSTR_10558", bj_TIMETYPE_SET, 9.00, true)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func018Func017A)
		call PingMinimap( 1455.70, -21980.00, 20.00)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10560")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10561")
		call RemoveDestructable( gg_dest_Dofw_15095)
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 15) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I0D6') == true) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","沙漠情报商人", unit), 450.00) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 16)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call RemoveItem( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I0D6'))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10562", bj_TIMETYPE_SET, 2.30, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10563", null, "TRIGSTR_10564", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10565", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10566", null, "TRIGSTR_10567", bj_TIMETYPE_SET, 3.00, true)
		call UnitAddItem( GetTriggerUnit(), CreateItem( 'I0D5', 0, 0))
		call EC_CreateEffect( "war3mapImported\\BlueBalllight.mdl", GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0.0, 270.0, 5.00, 1.0, 1.25)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10568", bj_TIMETYPE_SET, 5.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10569", null, "TRIGSTR_10581", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10582", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10587", bj_TIMETYPE_SET, 2.50, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10591")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10627")
		call YDLocal1Set(group, "DWZ", GetUnitsInRectMatching( gg_rct________________QY, Condition(function Trig_JLC_________001Func019Func020003002)))
		call ForGroupBJ( YDLocal1Get(group, "DWZ"),function Trig_JLC_________001Func019Func021A)
		call DestroyGroup( YDLocal1Get(group, "DWZ"))
		call YDUserDataSet(string, "ZXCS","DW", unit, CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'e06W', -27182.10, -25485.20, 0))
		call TriggerRegisterUnitInRangeSimple(gg_trg_JLC_________001, 300.00, YDUserDataGet(string, "ZXCS","DW", unit))
		call YDUserDataSet(string, "ZXCS2","DW", unit, CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'e06W', -24123.40, -26338.80, 0))
		call TriggerRegisterUnitInRangeSimple(gg_trg_JLC_________001, 300.00, YDUserDataGet(string, "ZXCS2","DW", unit))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 4.00, false, function Trig_JLC_________001Func019Func027T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 4.00, false," function Trig_JLC_________001Func019Func027T","JLC精灵村001")
#endif 
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 16) and ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZXCS","DW", unit), 300.00) == true) or (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZXCS2","DW", unit), 300.00) == true))) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 17)
		call RemoveUnit( YDUserDataGet(string, "ZXCS","DW", unit))
		call RemoveUnit( YDUserDataGet(string, "ZXCS2","DW", unit))
		call YDUserDataClearTable(string, "ZXCS")
		call YDUserDataClearTable(string, "ZXCS2")
		call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func020Func008A)
		call SetStackedSoundBJ( false, gg_snd_JQBGM03, gg_rct________________QY)
		call YDLocal1Set(group, "DWZ", GetUnitsInRectMatching( gg_rct________________QY, Condition(function Trig_JLC_________001Func020Func010003002)))
		call ForGroupBJ( YDLocal1Get(group, "DWZ"),function Trig_JLC_________001Func020Func011A)
		call YDLocal1Set(unit, "族长", YDUserDataGet(string, "主线NPC","精灵村长老", unit))
		call SetUnitPosition( YDLocal1Get(unit, "族长"), -26114.40, -28671.30)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10738", bj_TIMETYPE_SET, 3.50, true)
		call SetStackedSoundBJ( true, gg_snd_JQBGM04, gg_rct________________QY)
		call CinematicModeBJ( true, GetPlayersAll())
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_HINT, "TRIGSTR_10739")
		call SetUnitFacing( YDLocal1Get(unit, "族长"), 180.00)
		call YDLocal1Set(unit, "0", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n05H', -26755.10, -28618.60, 0.00))
		call YDLocal1Set(unit, "1", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'nhef', -25907.10, -28413.00, 178.00))
		call YDLocal1Set(unit, "2", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'nhef', -25888.10, -28937.10, 185.47))
		call YDLocal1Set(unit, "3", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n01H', -26119.90, -28926.50, 123.70))
		call YDLocal1Set(unit, "4", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n01H', -25965.70, -29021.40, 180.00))
		call YDLocal1Set(unit, "5", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n01H', -26065.80, -28460.50, 180.00))
		set udg_DXZSW/*剧情*/[0] = DzDoodadCreate( 'YOtf', 1, -27676.50, -26406.00, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[1] = DzDoodadCreate( 'YOtf', 1, -27008.70, -26384.50, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[2] = DzDoodadCreate( 'YOtf', 1, -26437.10, -27038.10, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[3] = DzDoodadCreate( 'YOtf', 1, -27524.20, -27604.20, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[4] = DzDoodadCreate( 'YOtf', 1, -27404.80, -28326.70, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[5] = DzDoodadCreate( 'YOtf', 1, -26557.10, -28108.30, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[6] = DzDoodadCreate( 'YOtf', 1, -24975.30, -28808.40, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[7] = DzDoodadCreate( 'YOtf', 1, -25385.30, -27834.40, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[8] = DzDoodadCreate( 'YOtf', 1, -23911.90, -29142.20, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[9] = DzDoodadCreate( 'YOtf', 1, -22237.80, -28776.70, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[10] = DzDoodadCreate( 'YOtf', 1, -22255.90, -28312.70, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[11] = DzDoodadCreate( 'YOtf', 1, -24574.10, -27746.70, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[12] = DzDoodadCreate( 'YOtf', 1, -23911.90, -29142.20, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[13] = DzDoodadCreate( 'YOtf', 1, -23963.10, -27718.00, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[14] = DzDoodadCreate( 'YOtf', 1, -23632.00, -27698.70, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[15] = DzDoodadCreate( 'YOtf', 1, -25487.60, -26993.60, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[16] = DzDoodadCreate( 'YOtf', 1, -24839.60, -26980.80, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[17] = DzDoodadCreate( 'YOtf', 1, -23963.10, -27718.00, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[18] = DzDoodadCreate( 'YOtf', 1, -24464.30, -26590.10, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[19] = DzDoodadCreate( 'YOtf', 1, -23681.30, -26604.50, 0, GetRandomDirectionDeg(), 1.00)
		set udg_DXZSW/*剧情*/[20] = DzDoodadCreate( 'YOtf', 1, -23665.10, -27128.50, 0, GetRandomDirectionDeg(), 1.00)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func020Func046A)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10740", bj_TIMETYPE_SET, 5.00, true)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func020Func048A)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10741", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "0"), "TRIGSTR_10742", null, "TRIGSTR_10743", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "族长"), "TRIGSTR_10744", null, "TRIGSTR_10745", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "0"), "TRIGSTR_10746", null, "TRIGSTR_10747", bj_TIMETYPE_SET, 5.00, true)
		call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func020Func053A)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10748", bj_TIMETYPE_SET, 1.50, true)
		call EXSetUnitFacing( YDLocal1Get(unit, "0"), 90.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "0"), "TRIGSTR_10749", null, "TRIGSTR_10750", bj_TIMETYPE_SET, 8.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10751", bj_TIMETYPE_SET, 2.00, true)
		call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig_JLC_________001Func020Func058A)
		call EC_CreateEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( YDLocal1Get(unit, "0")), GetUnitY( YDLocal1Get(unit, "0")), 0.0, 270.0, 1.50, 1.0, 1.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocal1Get(unit, "0"), "TRIGSTR_10752", null, "TRIGSTR_10753", bj_TIMETYPE_SET, 1.30, true)
		call CinematicModeBJ( false, GetPlayersAll())
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________001Func020Func062A)
		call SetStackedSoundBJ( false, gg_snd_JQBGM04, gg_rct________________QY)
		call YDLocal1Set(integer, "随机整数", GetRandomInt( 1, 2))
		if ((YDLocal1Get(integer, "随机整数") == 1)) then
			call YDUserDataSet(string, "Boss","蒙面人", unit, CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'N05N', 26474.50, 20889.50, 270.00))
			call YDLocal1Set(unit, "BS", YDUserDataGet(string, "Boss","蒙面人", unit))
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"剑士姿态", boolean, true)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"分身单位组", group, CreateGroup())
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"魔抗", real, 0.20)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"暴击率", real, 0.40)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"暴击伤害", real, 0.25)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"减少控制时间", real, 0.35)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"命中率", real, 0.10)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"闪避率", real, 0.40)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"技能数量", integer, 3)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"1号技能", abilcode, 'A0L7')
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"2号技能", abilcode, 'A0L8')
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"3号技能", abilcode, 'A0L5')
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"弱点数量", integer, udg_R/*弱点数量*/)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"天生弱点数", integer, 2)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"杖弱", boolean, true)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"火弱", boolean, true)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"光弱", boolean, true)
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"器弱伤害需求", real, OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "BS"), UNIT_STATE_MAX_LIFE), 0.03))
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"护盾值", integer, R2I( (8.00 + (2.00 * udg_N))))
			call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"原始护盾值", integer, R2I( (8.00 + (2.00 * udg_N))))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "BS", YDLocal1Get(unit, "BS"))
			call YDLocalSet(ydl_timer, group, "DWZ", YDLocal1Get(group, "DWZ"))
			call YDLocalSet(ydl_timer, integer, "ZS", YDLocal1Get(integer, "ZS"))
			call YDLocalSet(ydl_timer, unit, "玩家", YDLocal1Get(unit, "玩家"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3.50, true, function Trig_JLC_________001Func020Func065Func023T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3.50, true," function Trig_JLC_________001Func020Func065Func023T","JLC精灵村001")
#endif 
		else
			if ((YDLocal1Get(integer, "随机整数") == 2)) then
				call YDUserDataSet(string, "Boss","蒙面人", unit, CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'N05M', 26474.50, 20889.50, 270.00))
				call YDLocal1Set(unit, "BS", YDUserDataGet(string, "Boss","蒙面人", unit))
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"学者姿态", boolean, true)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"魔抗", real, 0.60)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"减少控制时间", real, 0.25)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"命中率", real, 0.50)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"闪避率", real, 0.05)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"魔法伤害吸血", real, 0.75)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"魔法穿透", real, 0.25)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"技能数量", integer, 4)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"1号技能", abilcode, 'A0L9')
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"2号技能", abilcode, 'A0LA')
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"3号技能", abilcode, 'A0LC')
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"4号技能", abilcode, 'A0LC')
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"弱点数量", integer, udg_R/*弱点数量*/)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"天生弱点数", integer, 2)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"剑弱", boolean, true)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"雷弱", boolean, true)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"光弱", boolean, true)
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"器弱伤害需求", real, OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "BS"), UNIT_STATE_MAX_LIFE), 0.03))
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"护盾值", integer, R2I( (8.00 + (2.00 * udg_N))))
				call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"原始护盾值", integer, R2I( (8.00 + (2.00 * udg_N))))
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "BS", YDLocal1Get(unit, "BS"))
				call YDLocalSet(ydl_timer, group, "DWZ", YDLocal1Get(group, "DWZ"))
				call YDLocalSet(ydl_timer, integer, "ZS", YDLocal1Get(integer, "ZS"))
				call YDLocalSet(ydl_timer, unit, "玩家", YDLocal1Get(unit, "玩家"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 1.25, true, function Trig_JLC_________001Func020Func065Func024Func023T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 1.25, true," function Trig_JLC_________001Func020Func065Func024Func023T","JLC精灵村001")
#endif 
			else
			endif
		endif
		call PauseUnit( YDLocal1Get(unit, "BS"), true)
		call SetUnitInvulnerable( YDLocal1Get(unit, "BS"), true)
		call YDUserDataSet(string, "Boss战","绑定单位", unit, YDLocal1Get(unit, "BS"))
		call YDUserDataSet(string, "Boss战","触发玩家", unit, GetTriggerUnit())
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"转换场景", boolean, true)
		call YDUserDataSet(string, "Boss战","BS移动X轴", real, GetUnitX( YDLocal1Get(unit, "BS")))
		call YDUserDataSet(string, "Boss战","BS移动Y轴", real, GetUnitY( YDLocal1Get(unit, "BS")))
		call YDUserDataSet(string, "Boss战","玩家移动X轴", real, 26760.30)
		call YDUserDataSet(string, "Boss战","玩家移动Y轴", real, 17338.30)
		call YDUserDataSet(string, "Boss战","战斗音乐", sound, gg_snd_battleBosszuizhong01)
		call YDUserDataSet(string, "Boss战","胜利音乐", sound, gg_snd_shengliBgm)
		call YDUserDataSet(string, "Boss战","地点", rect, gg_rct______________1522)
		call ConditionalTriggerExecute( gg_trg_Boss____________u)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "1", YDLocal1Get(unit, "1"))
		call YDLocalSet(ydl_timer, unit, "2", YDLocal1Get(unit, "2"))
		call YDLocalSet(ydl_timer, unit, "3", YDLocal1Get(unit, "3"))
		call YDLocalSet(ydl_timer, unit, "4", YDLocal1Get(unit, "4"))
		call YDLocalSet(ydl_timer, unit, "5", YDLocal1Get(unit, "5"))
		call YDLocalSet(ydl_timer, unit, "BS", YDLocal1Get(unit, "BS"))
		call YDLocalSet(ydl_timer, group, "DWZ", YDLocal1Get(group, "DWZ"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_JLC_________001Func020Func079T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_JLC_________001Func020Func079T","JLC精灵村001")
#endif 
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10754", null, "TRIGSTR_10755", bj_TIMETYPE_SET, 2.25, true)
		call RemoveUnit( YDLocal1Get(unit, "0"))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10756", null, "TRIGSTR_10757", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10758", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10759", null, "TRIGSTR_10760", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10761", null, "TRIGSTR_10762", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10763", null, "TRIGSTR_10764", bj_TIMETYPE_SET, 10.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10765", null, "TRIGSTR_10766", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10767", null, "TRIGSTR_10768", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10769", null, "TRIGSTR_10770", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10771", null, "TRIGSTR_10772", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10773", null, "TRIGSTR_10774", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10775", null, "TRIGSTR_10776", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10777", bj_TIMETYPE_SET, 3.00, true)
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 18) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","精灵村长老", unit), 850.00) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 19)
		call YDLocal1Set(unit, "族长", YDUserDataGet(string, "主线NPC","精灵族长老", unit))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10778", null, "TRIGSTR_10779", bj_TIMETYPE_SET, 5.50, true)
		call EC_CreateEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( YDLocal1Get(unit, "族长")), GetUnitY( YDLocal1Get(unit, "族长")), 0.0, 270.0, 2.00, 1.0, 1.50)
		call ShowDestructable( gg_dest_B00X_0013, false)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10780", null, "TRIGSTR_10781", bj_TIMETYPE_SET, 9.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10782", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10783", null, "TRIGSTR_10784", bj_TIMETYPE_SET, 10.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10785", bj_TIMETYPE_SET, 1.75, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10786", bj_TIMETYPE_SET, 8.00, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10787")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10788")
		call SetUnitOwner( gg_unit_n025_0033, Player(6), true)
		call PingMinimap( -23154.70, -14847.90, 20.00)
		call QuestSetCompleted( udg_ZX[1], true)
		call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "TRIGSTR_10789", "TRIGSTR_10790", "ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
		set udg_ZX[2] = GetLastCreatedQuestBJ()
	else
	endif
	call RemoveLocation( YDLocal1Get(location, "单位位置"))
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_JLC_________001 takes nothing returns nothing
	set gg_trg_JLC_________001 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_JLC_________001,"JLC精灵村001")
#endif
	call TriggerRegisterEnterRectSimple(gg_trg_JLC_________001, gg_rct______________031)
	call TriggerRegisterEnterRectSimple(gg_trg_JLC_________001, gg_rct______________077)
	call TriggerRegisterEnterRectSimple(gg_trg_JLC_________001, gg_rct______________020)
	call TriggerRegisterEnterRectSimple(gg_trg_JLC_________001, gg_rct______________098)
	call TriggerRegisterEnterRectSimple(gg_trg_JLC_________001, gg_rct________________QY)
	call TriggerAddCondition(gg_trg_JLC_________001, Condition(function Trig_JLC_________001Conditions))
	call TriggerAddAction(gg_trg_JLC_________001, function Trig_JLC_________001Actions)
endfunction

