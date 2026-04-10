//===========================================================================
// Trigger: SRZ蛇人族002
//===========================================================================
function Trig_SRZ_________002Conditions takes nothing returns boolean
	return ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true))
endfunction

function Trig_SRZ_________002Func002Func014A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________108)
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________107)
endfunction

function Trig_SRZ_________002Func004Func015T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_WARNING, "TRIGSTR_10029")
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

function Trig_SRZ_________002Func005Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call SetStackedSoundBJ( false, gg_snd_Bossbattle001, YDLocalGet(GetExpiredTimer(), rect, "地点"))
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

function Trig_SRZ_________002Func005Func004A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________047)
endfunction

function Trig_SRZ_________002Func005Func041T takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), group, "DWZ", CreateGroup())
	set ydl_group = CreateGroup()
	call GroupEnumUnitsInRange(ydl_group, GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "BS")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "BS")), 1020.00, null)
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
	call YDLocalSet(GetExpiredTimer(), integer, "ZS", GetRandomInt( 1, 3))
	if ((YDLocalGet(GetExpiredTimer(), unit, "玩家") == null)) then
	else
		if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 1)) then
			call IssueNeutralTargetOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0KV', "Order"), YDLocalGet(GetExpiredTimer(), unit, "玩家"))
		else
			if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 2)) then
				call IssueNeutralImmediateOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0KY', "Order"))
			else
				if ((YDLocalGet(GetExpiredTimer(), integer, "ZS") == 3)) then
					call IssueNeutralTargetOrderById( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocalGet(GetExpiredTimer(), unit, "BS"), YDWEAbilityId2OrderId( 'A0KX', "Order"), YDLocalGet(GetExpiredTimer(), unit, "玩家"))
				else
				endif
			endif
		endif
	endif
	if ((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "BS")) == true)) then
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

function Trig_SRZ_________002Actions takes nothing returns nothing
	local timer ydl_timer
	local integer ydul_A
	YDLocalInitialize()
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 7) and (RectContainsUnit( gg_rct______________106, GetTriggerUnit()) == true)) then
		call RemoveRect( gg_rct______________106)
		call YDUserDataSet(string, "剧情进度","整数", integer, 8)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call PauseUnit( GetTriggerUnit(), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_9968", null, "TRIGSTR_9969", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_9970", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_9971", null, "TRIGSTR_9972", bj_TIMETYPE_SET, 6.00, true)
		call PauseUnit( GetTriggerUnit(), false)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_9973", bj_TIMETYPE_SET, 3.00, true)
		call AdjustPlayerStateBJ( -233, GetOwningPlayer( GetTriggerUnit()), PLAYER_STATE_RESOURCE_GOLD)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_SRZ_________002Func002Func014A)
		call PingMinimap( -20880.70, 3186.40, 20.00)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_9974")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_9975")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","蛇人族藏品管家", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 8)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 9)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_9976", null, "TRIGSTR_9979", bj_TIMETYPE_SET, 3.20, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_9980", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_9986", null, "TRIGSTR_9989", bj_TIMETYPE_SET, 3.20, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_9990", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_9998", null, "TRIGSTR_10023", bj_TIMETYPE_SET, 7.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10024", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10025", null, "TRIGSTR_10026", bj_TIMETYPE_SET, 4.00, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10027")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10028")
		call AddItemToStockBJ( 'I0D0', YDUserDataGet(string, "主线NPC","蛇人族藏品管家", unit), 1, 1)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 2.00, false, function Trig_SRZ_________002Func004Func015T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 2.00, false," function Trig_SRZ_________002Func004Func015T","SRZ蛇人族002")
#endif 
	else
	endif
	if ((YDUserDataGet(string, "剧情进度","整数", integer) == 10) and (GetOwningPlayer( YDUserDataGet(string, "Boss","沙漠食人魔", unit)) == Player(PLAYER_NEUTRAL_PASSIVE)) and (IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "Boss","沙漠食人魔", unit), 1000.00) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 11)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, rect, "地点", YDLocal1Get(rect, "地点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.00, false, function Trig_SRZ_________002Func005Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig_SRZ_________002Func005Func002T","SRZ蛇人族002")
#endif 
		call GroupAddUnit( YDUserDataGet(string, "血条Boss","单位组", group), YDUserDataGet(string, "Boss","沙漠食人魔", unit))
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_SRZ_________002Func005Func004A)
		call YDLocal1Set(unit, "沙漠食人魔", YDUserDataGet(string, "Boss","沙漠食人魔", unit))
		call YDLocal1Set(unit, "BS", YDLocal1Get(unit, "沙漠食人魔"))
		call SetUnitOwner( YDLocal1Get(unit, "沙漠食人魔"), Player(PLAYER_NEUTRAL_AGGRESSIVE), true)
		call PauseUnit( YDLocal1Get(unit, "沙漠食人魔"), true)
		call SetUnitInvulnerable( YDLocal1Get(unit, "沙漠食人魔"), true)
		call StarOther_PanCameraToTimedUnitForPlayer( GetOwningPlayer( GetTriggerUnit()), YDLocal1Get(unit, "沙漠食人魔"), 0.75)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10030", bj_TIMETYPE_SET, 2.50, true)
		call YDLocal1Set(degree, "角度", YDWEAngleBetweenUnits( YDLocal1Get(unit, "沙漠食人魔"), GetTriggerUnit()))
		call SetUnitFacing( YDLocal1Get(unit, "沙漠食人魔"), YDLocal1Get(degree, "角度"))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10031", null, "TRIGSTR_10033", bj_TIMETYPE_ADD, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10035", null, "TRIGSTR_10055", bj_TIMETYPE_ADD, 4.00, true)
		call EC_CreateEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( YDLocal1Get(unit, "沙漠食人魔")), GetUnitY( YDLocal1Get(unit, "沙漠食人魔")), 0.0, 270.0, 2.50, 1.0, 1.00)
		set ydul_A = 1
		loop
			exitwhen ydul_A > 6
			call YDLocal1Set(location, "D", GS_PolarProjectionBJ( GetUnitLoc( YDLocal1Get(unit, "沙漠食人魔")), 150.00, OperatorDegreeMultiply( 60.00, I2R( ydul_A))))
			call EC_CreateEffect( "war3mapImported\\blood2022720203813.mdl", GetLocationX( YDLocal1Get(location, "D")), GetLocationY( YDLocal1Get(location, "D")), 0.0, 270.0, 2.00, 1.0, 1.00)
			call RemoveLocation( YDLocal1Get(location, "D"))
			set ydul_A = ydul_A + 1
		endloop
		call PlaySoundBJ( gg_snd_GWSY05)
		call IssuePointOrder( YDLocal1Get(unit, "沙漠食人魔"), "patrol", 0, 0)
		call SetUnitInvulnerable( YDLocal1Get(unit, "沙漠食人魔"), false)
		call PauseUnit( YDLocal1Get(unit, "沙漠食人魔"), false)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"魔抗", real, 0.30)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"暴击率", real, 0.20)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"暴击伤害", real, 0.25)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"减少控制时间", real, 0.30)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"命中率", real, 0.05)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"闪避率", real, 0.05)
		call YDUserDataSet(string, "Boss战","绑定单位", unit, YDLocal1Get(unit, "沙漠食人魔"))
		call YDUserDataSet(string, "Boss战","战斗音乐", sound, gg_snd_Bossbattle001)
		call YDUserDataSet(string, "Boss战","胜利音乐", sound, gg_snd_shengliBgm)
		call YDUserDataSet(string, "Boss战","地点", rect, gg_rct______________047)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"弱点数量", integer, udg_R/*弱点数量*/)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"天生弱点数", integer, 2)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"弓弱", boolean, true)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"暗弱", boolean, true)
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"器弱伤害需求", real, OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "BS"), UNIT_STATE_MAX_LIFE), 0.03))
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"护盾值", integer, R2I( (7.00 + (2.00 * udg_N))))
		call YDUserDataSet(unit, YDLocal1Get(unit, "BS"),"原始护盾值", integer, R2I( (7.00 + (2.00 * udg_N))))
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
		call TimerStart(ydl_timer, 2.50, true, function Trig_SRZ_________002Func005Func041T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 2.50, true," function Trig_SRZ_________002Func005Func041T","SRZ蛇人族002")
#endif 
		call ConditionalTriggerExecute( gg_trg_Boss____________u)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","蛇人族藏品管家", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 13) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I0D4') == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 14)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call PauseUnit( GetTriggerUnit(), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10056", bj_TIMETYPE_SET, 2.50, true)
		call RemoveItem( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I0D4'))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10057", null, "TRIGSTR_10058", bj_TIMETYPE_SET, 3.20, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10059", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10060", null, "TRIGSTR_10061", bj_TIMETYPE_SET, 3.20, true)
		call UnitAddItem( GetTriggerUnit(), CreateItem( 'I0D6', 0, 0))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10062", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10063", null, "TRIGSTR_10064", bj_TIMETYPE_SET, 2.50, true)
		call SetStackedSoundBJ( false, gg_snd_BGM019, gg_rct______________107)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10065", bj_TIMETYPE_SET, 2.50, true)
		call YDUserDataSet(string, "主线NPC","蛇人族卫队长", unit, CreateUnit( Player(6), 'h01D', -22935.90, 3154.30, 0))
		call YDLocal1Set(unit, "队长", YDUserDataGet(string, "主线NPC","蛇人族卫队长", unit))
		call IssuePointOrderById( YDLocal1Get(unit, "队长"), 851971, -21023.40, 3259.50)
		call SetStackedSoundBJ( true, gg_snd_JQBGM02, gg_rct______________107)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10143", null, "TRIGSTR_10144", bj_TIMETYPE_SET, 2.00, true)
		call SetUnitFacing( GetTriggerUnit(), 200.00)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10148", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10150", null, "TRIGSTR_10166", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10167", null, "TRIGSTR_10195", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10196", null, "TRIGSTR_10206", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_10207", null, "TRIGSTR_10208", bj_TIMETYPE_SET, 4.50, true)
		call PauseUnit( GetTriggerUnit(), false)
		call SetUnitOwner( YDLocal1Get(unit, "队长"), Player(PLAYER_NEUTRAL_PASSIVE), true)
		call SetUnitPosition( YDLocal1Get(unit, "队长"), -21023.40, 3259.50)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_10209", bj_TIMETYPE_SET, 5.00, true)
		call QuestSetDescription( udg_ZX[1], "TRIGSTR_10210")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_10212")
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_SRZ_________002 takes nothing returns nothing
	set gg_trg_SRZ_________002 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_SRZ_________002,"SRZ蛇人族002")
#endif
	call TriggerRegisterEnterRectSimple(gg_trg_SRZ_________002, gg_rct______________106)
	call TriggerAddCondition(gg_trg_SRZ_________002, Condition(function Trig_SRZ_________002Conditions))
	call TriggerAddAction(gg_trg_SRZ_________002, function Trig_SRZ_________002Actions)
endfunction

