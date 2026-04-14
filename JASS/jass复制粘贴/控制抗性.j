//===========================================================================
// Trigger: 眩晕时间减少XYSJ
//===========================================================================
function Trig___________________XYSJConditions takes nothing returns boolean
	return ((GetUnitTypeId( GetTriggerUnit()) != 'e02A'))
endfunction

function Trig___________________XYSJFunc011T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocalGet(GetExpiredTimer(), abilcode, "技能"), "Order") != "ward") and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocalGet(GetExpiredTimer(), abilcode, "技能"), "Order") != "web") and (YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_ABILITY, YDLocalGet(GetExpiredTimer(), abilcode, "技能"), "HeroDur1") > 0.02) and ((YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "目标")),"减少控制时间", real) > 0.01) or (YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标"),"减少控制时间", real) > 0.01)) and ((GetIssuedOrderIdBJ() == String2OrderIdBJ( "stop")) or (GetUnitCurrentOrder( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == YDWEUOrderId2OrderId( 852231)) or (GetUnitCurrentOrder( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == YDWEUOrderId2OrderId( 852252)))) then
		call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), abilcode, "技能"))
		call IssueImmediateOrder( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), "stop")
		call YDLocalSet(GetExpiredTimer(), real, "原始控制时间", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_ABILITY, YDLocalGet(GetExpiredTimer(), abilcode, "技能"), "HeroDur1"))
		if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标"),"减少控制时间", real) > 0.01)) then
			call YDLocalSet(GetExpiredTimer(), real, "减少眩晕时间", YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标"),"减少控制时间", real))
		else
			if ((YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "目标")),"减少控制时间", real) > 0.01)) then
				call YDLocalSet(GetExpiredTimer(), real, "减少眩晕时间", YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "目标")),"减少控制时间", real))
			else
			endif
		endif
		if ((YDLocalGet(GetExpiredTimer(), real, "减少眩晕时间") >= 0.90)) then
			call YDLocalSet(GetExpiredTimer(), real, "减少眩晕时间", 0.90)
		else
		endif
		call YDLocalSet(GetExpiredTimer(), real, "输出控制时间", OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "原始控制时间"), OperatorRealSubtract( 1.00, YDLocalGet(GetExpiredTimer(), real, "减少眩晕时间"))))
		if ((GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "目标")) == 'N05U') and (YDLocalGet(GetExpiredTimer(), real, "输出控制时间") > 1.00)) then
			call YDLocalSet(GetExpiredTimer(), real, "输出控制时间", 1.00)
		else
		endif
		call YDLocalSet(GetExpiredTimer(), location, "点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "目标")))
		call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), YDUserDataGet(string, "辅助马甲（减控用）","单位类型", unitcode), YDLocalGet(GetExpiredTimer(), location, "点"), 0))
		call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A051')
		call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A051', 1, 102, YDLocalGet(GetExpiredTimer(), real, "输出控制时间"))
		call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A051', 1, 103, YDLocalGet(GetExpiredTimer(), real, "输出控制时间"))
		call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "thunderbolt", YDLocalGet(GetExpiredTimer(), unit, "目标"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
	else
		call DoNothing()
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

function Trig___________________XYSJActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
	call YDLocal1Set(abilcode, "技能", GetSpellAbilityId())
	call YDLocal1Set(real, "CD", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "技能"), "Cool1"))
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
	call YDLocalSet(ydl_timer, real, "减少眩晕时间", YDLocal1Get(real, "减少眩晕时间"))
	call YDLocalSet(ydl_timer, real, "原始控制时间", YDLocal1Get(real, "原始控制时间"))
	call YDLocalSet(ydl_timer, abilcode, "技能", YDLocal1Get(abilcode, "技能"))
	call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
	call YDLocalSet(ydl_timer, unit, "目标", YDLocal1Get(unit, "目标"))
	call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
	call YDLocalSet(ydl_timer, real, "输出控制时间", YDLocal1Get(real, "输出控制时间"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.00, false, function Trig___________________XYSJFunc011T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig___________________XYSJFunc011T","眩晕时间减少XYSJ")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig___________________XYSJ takes nothing returns nothing
	set gg_trg___________________XYSJ = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg___________________XYSJ,"眩晕时间减少XYSJ")
#endif
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(0), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(1), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(2), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(3), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(6), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg___________________XYSJ, Player(7), EVENT_PLAYER_UNIT_SPELL_CHANNEL)
	call TriggerAddCondition(gg_trg___________________XYSJ, Condition(function Trig___________________XYSJConditions))
	call TriggerAddAction(gg_trg___________________XYSJ, function Trig___________________XYSJActions)
endfunction

