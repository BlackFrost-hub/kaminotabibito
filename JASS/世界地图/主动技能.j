//===========================================================================
// Trigger: 施放技能类触发时间SF
//===========================================================================
function Trig____________________________SFConditions takes nothing returns boolean
	return ((YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_ABILITY, GetSpellAbilityId(), "Cool1") >= 1.00)) and (((GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852008)) and (GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852009)) and (GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852010)) and (GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852011)) and (GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852012)) and (GetUnitCurrentOrder( GetTriggerUnit()) != YDWENOrderId2OrderId( 852013))))
endfunction

function Trig____________________________SFFunc003Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, 4)
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

function Trig____________________________SFFunc004Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, 8)
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

function Trig____________________________SFFunc007Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"JMDJ11", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"JMDJ11", boolean)
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

function Trig____________________________SFActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I03G') == true)) then
		call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, 4)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 6.00, false, function Trig____________________________SFFunc003Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 6.00, false," function Trig____________________________SFFunc003Func002T","施放技能类触发时间SF")
#endif 
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I09Y') == true)) then
		call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, 8)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 10.00, false, function Trig____________________________SFFunc004Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig____________________________SFFunc004Func002T","施放技能类触发时间SF")
#endif 
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I04I') == true) and ((YDWEGetUnitAbilityDataReal( GetTriggerUnit(), GetSpellAbilityId(), 1, 109) == 1.00) or (YDWEGetUnitAbilityDataReal( GetTriggerUnit(), GetSpellAbilityId(), 1, 109) == 3.00))) then
		call YDLocal1Set(unit, "目标单位", GetSpellTargetUnit())
		if ((YDLocal1Get(unit, "目标单位") == null)) then
		else
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A06G')
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "firebolt", YDLocal1Get(unit, "目标单位"))
			call RemoveLocation( YDLocal1Get(location, "点"))
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I06P') == true)) then
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(real, "生命恢复值", OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.10), 200.00))
		call YDLocal1Set(real, "魔法恢复值", OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.05), 100.00))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "治疗马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A080')
		call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 108, YDLocal1Get(real, "生命恢复值"))
		call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 109, YDLocal1Get(real, "魔法恢复值"))
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "rejuvination", GetTriggerUnit())
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	if ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I0CA') == true) and ((YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ABILITY, GetSpellAbilityId(), "DataB1") == 1) and (YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ABILITY, GetSpellAbilityId(), "DataB1") == 3))) then
		call YDUserDataSet(unit, GetTriggerUnit(),"JMDJ11", boolean, true)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, false, function Trig____________________________SFFunc007Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig____________________________SFFunc007Func002T","施放技能类触发时间SF")
#endif 
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________________SF takes nothing returns nothing
	set gg_trg____________________________SF = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________________SF,"施放技能类触发时间SF")
#endif
	call TriggerAddCondition(gg_trg____________________________SF, Condition(function Trig____________________________SFConditions))
	call TriggerAddAction(gg_trg____________________________SF, function Trig____________________________SFActions)
endfunction

