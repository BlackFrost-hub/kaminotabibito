//===========================================================================
// Trigger: 累计伤害类触发new
//===========================================================================
function Trig______________________newConditions takes nothing returns boolean
	return ((YDWEIsEventDamageType( DAMAGE_TYPE_MIND) == false)) and ((GetEventDamage() >= 1.00))
endfunction

function Trig______________________newFunc002Func005Func005Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"免疫伤害", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"伤害免疫", boolean)
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

function Trig______________________newFunc002Func005Func005T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"免疫伤害", boolean, true)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 1.25, false, function Trig______________________newFunc002Func005Func005Func002T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 1.25, false," function Trig______________________newFunc002Func005Func005Func002T","累计伤害类触发new")
#endif 
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

function Trig______________________newFunc002Func005Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"回沙之书CD", boolean, false)
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

function Trig______________________newActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I046') == true)) then
		call YDLocal1Set(real, "伤害值", GetEventDamage())
		call YDLocal1Set(real, "魔法回复值", OperatorRealMultiply( YDLocal1Get(real, "伤害值"), 0.12))
		call YDUserDataSet(unit, GetTriggerUnit(),"回沙之书恢复叠加", real, OperatorRealAdd( YDUserDataGet(unit, GetTriggerUnit(),"回沙之书恢复叠加", real), YDLocal1Get(real, "魔法回复值")))
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), YDLocal1Get(real, "魔法回复值")))
		if ((YDUserDataGet(unit, GetTriggerUnit(),"回沙之书恢复叠加", real) >= 400.00)) then
			call YDUserDataSet(unit, GetTriggerUnit(),"回沙之书恢复叠加", real, 0.00)
			call YDLocal1Set(effect, "沙子特效", AddSpecialEffectTarget( "war3mapImported\\SandAura.mdl", GetTriggerUnit(), "overhead"))
			call YDWETimerDestroyEffect( 2.50, YDLocal1Get(effect, "沙子特效"))
			call YDUserDataSet(unit, GetTriggerUnit(),"回沙之书CD", boolean, true)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.50, false, function Trig______________________newFunc002Func005Func005T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.50, false," function Trig______________________newFunc002Func005Func005T","累计伤害类触发new")
#endif 
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 8.00, false, function Trig______________________newFunc002Func005Func006T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 8.00, false," function Trig______________________newFunc002Func005Func006T","累计伤害类触发new")
#endif 
		else
		endif
	else
	endif
	if (((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I075') == true) or (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I076') == true))) then
		call YDUserDataSet(unit, GetTriggerUnit(),"女妖头饰", real, OperatorRealAdd( YDUserDataGet(unit, GetTriggerUnit(),"女妖头饰", real), GetEventDamage()))
		if ((YDUserDataGet(unit, GetTriggerUnit(),"女妖头饰", real) >= 1500.00)) then
			call YDUserDataSet(unit, GetTriggerUnit(),"女妖头饰", real, 0.00)
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A0AO')
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "shadowstrike", GetEventDamageSource())
			call RemoveLocation( YDLocal1Get(location, "点"))
			if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I076') == true)) then
				call YDUserDataSet(unit, GetTriggerUnit(),"女妖头饰hit", real, OperatorRealAdd( YDUserDataGet(unit, GetTriggerUnit(),"女妖头饰hit", real), 1.00))
				if ((YDUserDataGet(unit, GetTriggerUnit(),"女妖头饰hit", real) >= 5.00)) then
					call YDUserDataSet(unit, GetTriggerUnit(),"女妖头饰hit", real, 0.00)
					call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "治疗马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
					call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A06Q')
					call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A06Q', 1, 108, 1000.00)
				else
				endif
			else
			endif
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig______________________new takes nothing returns nothing
	set gg_trg______________________new = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg______________________new,"累计伤害类触发new")
#endif
	call MNAnyUnitDamaged(gg_trg______________________new, 5.00)
	call TriggerAddCondition(gg_trg______________________new, Condition(function Trig______________________newConditions))
	call TriggerAddAction(gg_trg______________________new, function Trig______________________newActions)
endfunction

