//===========================================================================
// Trigger: 未命名触发器 006
//===========================================================================
function Trig____________________006Func001Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "目标"), 'B01H') == false) or (IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "目标")) == true) or (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00))) then
		call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "目标"), 'A06C')
		call UnitRemoveBuffBJ( 'B01H', YDLocalGet(GetExpiredTimer(), unit, "目标"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'BPSE') == true)) then
		else
			call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________006Func002Func010Conditions takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetTriggeringTrigger())
	set G_LIndex = G_SIndex
	#endif
	if ((GetUnitLifePercent( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾")) >= 1.00) and (IsUnitAliveBJ( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾")) == true) and (IsUnitInRange( GetTriggerUnit(), YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾"), 350.00) == true) and (GetTriggerUnit() != YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾")) and ((IsUnitAlly( GetTriggerUnit(), GetOwningPlayer( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾"))) == true) or (IsUnitOwnedByPlayer( GetTriggerUnit(), GetOwningPlayer( YDLocalGet(GetTriggeringTrigger(), unit, "施法者"))) == true))) then
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), GetEventDamage()))
		call SetUnitState( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾"), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾"), UNIT_STATE_LIFE), GetEventDamage()))
	else
	endif
	if (((IsUnitAliveBJ( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾")) == false) or (GetUnitLifePercent( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾")) < 1.00))) then
		call RemoveUnit( YDLocalGet(GetTriggeringTrigger(), unit, "使者魔轮护盾"))
		call YDLocal4Release()
		call DestroyTrigger(GetTriggeringTrigger())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________006Func002Func011T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "使者魔轮护盾"))
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

function Trig____________________006Actions takes nothing returns nothing
	local timer ydl_timer
	local trigger ydl_trigger
	YDLocalInitialize()
	if ((GetSpellAbilityId() == 'A06C')) then
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		call UnitAddAbility( YDLocal1Get(unit, "目标"), 'A0EN')
		//这里是易伤，原jass用光环模拟的，现在ts里已经在项目里封装好了，改用我们ts的
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, unit, "目标", YDLocal1Get(unit, "目标"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.25, true, function Trig____________________006Func001Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.25, true," function Trig____________________006Func001Func004T","未命名触发器 006")
#endif 
	else
	endif
	if ((GetSpellAbilityId() == 'A0B5')) then
		//魔盾展开（主动）：固定消耗25%最大魔法值，在目标点展开一道半径300码，持续10秒的魔法盾，在魔法盾内部的友军完全免疫伤害，魔法盾的生命值与消耗魔法值相同，冷却时间25秒
		//这里改用特效的方式，而不是单位马甲，特效路径：war3mapImported\Energy Shield.mdl，生命值我们用ts的方式自己记录，尺寸大小5.6
		//这里就是展开一个魔法盾，在魔法盾里的单位免疫伤害，然后魔法盾替代扣血，扣完提前消失，你可以优化的更好点
		call YDLocal1Set(unit, "施法者", GetTriggerUnit())
		call YDLocal1Set(location, "点", GetSpellTargetLoc())
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.25)))
		call YDLocal1Set(unit, "使者魔轮护盾", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), 'e04A', YDLocal1Get(location, "点"), 0))
		call SetUnitState( YDLocal1Get(unit, "使者魔轮护盾"), UNIT_STATE_MAX_LIFE, OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.25))
		call SetUnitLifePercentBJ( YDLocal1Get(unit, "使者魔轮护盾"), 100.00)
		set ydl_trigger = CreateTrigger()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_trigger)
#endif
		call YDLocalSet(ydl_trigger, unit, "使者魔轮护盾", YDLocal1Get(unit, "使者魔轮护盾"))
		call YDLocalSet(ydl_trigger, unit, "施法者", YDLocal1Get(unit, "施法者"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call MNAnyUnitDamaged(ydl_trigger, 5.00)
		call TriggerRegisterTimerEventPeriodic(ydl_trigger, 1.00)
		call TriggerAddCondition( ydl_trigger, Condition(function Trig____________________006Func002Func010Conditions))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "使者魔轮护盾", YDLocal1Get(unit, "使者魔轮护盾"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 10.00, false, function Trig____________________006Func002Func011T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig____________________006Func002Func011T","未命名触发器 006")
#endif 
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig____________________006 takes nothing returns nothing
	set gg_trg____________________006 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________006,"未命名触发器 006")
#endif
	call TriggerAddAction(gg_trg____________________006, function Trig____________________006Actions)
endfunction

