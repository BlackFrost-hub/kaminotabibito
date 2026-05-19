//===========================================================================
// Trigger: 伤害类触发技能SH
//===========================================================================
function Trig______________________SHConditions takes nothing returns boolean
	return ((YDWEIsEventDamageType( DAMAGE_TYPE_MIND) == false)) and ((GetEventDamage() >= 1.00))
endfunction

function Trig______________________SHFunc005Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"灵石伤害量", real, 0.00)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"灵石伤害量", real)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"灵石开关", boolean)
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

function Trig______________________SHFunc006Func010T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"傀岩杖开关", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"傀岩杖开关", boolean)
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

function Trig______________________SHFunc010Func011T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(itemcode, 'I03A',"开关", boolean, false)
	call YDUserDataClearTable(itemcode, 'I03A')
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

function Trig______________________SHFunc011Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 5.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "伤害值"), 0.02), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________SHFunc012Func006Func001Func002Conditions takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetTriggeringTrigger())
	set G_LIndex = G_SIndex
	#endif
	if ((YDWEIsTriggerEventId( EVENT_GAME_TIMER_EXPIRED) == true)) then
		call YDLocal4Release()
		call DestroyTrigger(GetTriggeringTrigger())
	else
		if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_SHADOW_STRIKE) == true)) then
			call YDLocalSet(GetTriggeringTrigger(), real, "伤害值银魔手套", GetEventDamage())
			call SetUnitState( YDLocalGet(GetTriggeringTrigger(), unit, "伤害来源"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocalGet(GetTriggeringTrigger(), unit, "伤害来源"), UNIT_STATE_LIFE), OperatorRealMultiply( YDLocalGet(GetTriggeringTrigger(), real, "伤害值银魔手套"), OperatorRealAdd( 1.00, YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetTriggeringTrigger(), unit, "伤害来源")),"生命恢复属性增幅", real)))))
			call YDLocalSet(GetTriggeringTrigger(), location, "点", GetUnitLoc( YDLocalGet(GetTriggeringTrigger(), unit, "伤害来源")))
			call CreateTextTagLocBJ( R2S( OperatorRealMultiply( YDLocalGet(GetTriggeringTrigger(), real, "伤害值银魔手套"), OperatorRealAdd( 1.00, YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetTriggeringTrigger(), unit, "伤害来源")),"生命恢复属性增幅", real)))), YDLocalGet(GetTriggeringTrigger(), location, "点"), 20.00, 11.00, 0.00, 100, 50.00, 0)
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.06)
			call YDWETimerDestroyTextTag( 1.00, GetLastCreatedTextTag())
			call RemoveLocation( YDLocalGet(GetTriggeringTrigger(), location, "点"))
			call YDLocal4Release()
			call DestroyTrigger(GetTriggeringTrigger())
		else
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________SHFunc012Func006T takes nothing returns nothing
	local trigger ydl_trigger
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 3.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		set ydl_trigger = CreateTrigger()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_trigger)
#endif
		call YDLocalSet(ydl_trigger, real, "伤害值银魔手套", YDLocalGet(GetExpiredTimer(), real, "伤害值银魔手套"))
		call YDLocalSet(ydl_trigger, unit, "伤害来源", YDLocalGet(GetExpiredTimer(), unit, "伤害来源"))
		call YDLocalSet(ydl_trigger, location, "点", YDLocalGet(GetExpiredTimer(), location, "点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TriggerRegisterTimerEventSingle(ydl_trigger, 0.20)
		call TriggerRegisterUnitEvent(ydl_trigger, GetTriggerUnit(), EVENT_UNIT_DAMAGED)
		call TriggerAddCondition( ydl_trigger, Condition(function Trig______________________SHFunc012Func006Func001Func002Conditions))
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 20.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_trigger = null
endfunction

function Trig______________________SHFunc013Func003003003 takes nothing returns boolean
	return ((IsUnitAlly( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true) and (IsUnitOwnedByPlayer( GetFilterUnit(), GetTriggerPlayer()) == false))
endfunction

function Trig______________________SHFunc014Func003Func003003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 300.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig______________________SHFunc014Func003Func004A takes nothing returns nothing
	call UnitDamageTarget( GetTriggerUnit(), GetEnumUnit(), 1000.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
	call YDLocal2Set(location, "点2", GetUnitLoc( GetEnumUnit()))
	call YDLocal2Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal2Get(location, "点2"), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), YDUserDataGet(string, "眩晕1秒","技能", abilcode))
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "thunderbolt", GetEnumUnit())
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", YDLocal2Get(location, "点2")))
	call RemoveLocation( YDLocal2Get(location, "点2"))
endfunction

function Trig______________________SHFunc016Func005Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"地狱火卡牌魔法CD", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"地狱火卡牌魔法CD", boolean)
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

function Trig______________________SHFunc017Func007Func001T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 5.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), UNIT_STATE_MANA), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "恢复值"), 0.20)))
		call YDLocalSet(GetExpiredTimer(), location, "特效点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource")))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", YDLocalGet(GetExpiredTimer(), location, "特效点")))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "特效点"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________SHFunc018Func004Func011T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"安恶之鞋", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"安恶之鞋", boolean)
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

function Trig______________________SHFunc019Func011T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"灵墓之戒", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"灵墓之戒", boolean)
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

function Trig______________________SHFunc020Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"汭冥戒指", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"汭冥戒指", boolean)
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

function Trig______________________SHFunc022Func005Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"闪电权杖CD", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"闪电权杖CD", boolean)
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

function Trig______________________SHFunc023Func002Func006Func001T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 25.00)) then
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, 1.00)
		call SetUnitInvulnerable( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), false)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), "origin"))
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE), OperatorRealMultiply( OperatorRealMultiply( 1.20, OperatorRealAdd( 1.00, YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")),"生命恢复属性增幅", real))), YDLocalGet(GetExpiredTimer(), real, "扣除魔法值"))))
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA), YDLocalGet(GetExpiredTimer(), real, "扣除魔法值")))
		call SetUnitInvulnerable( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), true)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________SHFunc023Func002Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"斯尔法袍CD", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"斯尔法袍CD", boolean)
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

function Trig______________________SHFunc024Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true)) then
		call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource")), 'e00D', GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 0))
		call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A0AB')
		call IssueImmediateOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "animatedead")
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

function Trig______________________SHFunc028Func002Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(itemcode, 'I0C9',"CD", boolean, false)
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

function Trig______________________SHFunc030Func006Func009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "法刺弹幕")) == false) or (IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "法刺弹幕")) == true))) then
		if ((IsUnitInRange( YDLocalGet(GetExpiredTimer(), unit, "法刺弹幕"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 50.00) == true)) then
			call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealAdd( OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), ConvertUnitState(0x15)), 0.10), 200.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
		else
		endif
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
endfunction

function Trig______________________SHActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE) < OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.70)) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I01U') == true)) then
		//告知ai：这里走doheal
		call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.10))
		call SetUnitLifeBJ( GetTriggerUnit(), OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), YDLocal1Get(real, "恢复值")))
	else
	endif
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true) and (YDUserDataGet(unit, GetTriggerUnit(),"灵石开关", boolean) == false) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I02Q') == true)) then
		//石灵：在3秒内累计受到的物理伤害超过300时，立即恢复300点生命值，|r|cffccffccCD：3秒
		//告知ai：这里走doheal，带特效true
		call YDUserDataSet(unit, GetTriggerUnit(),"灵石伤害量", real, OperatorRealAdd( YDUserDataGet(unit, GetTriggerUnit(),"灵石伤害量", real), GetEventDamage()))
		if ((YDUserDataGet(unit, GetTriggerUnit(),"灵石伤害量", real) >= 300.00)) then
			call SetUnitLifeBJ( GetTriggerUnit(), OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 300.00))
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call CreateTextTagLocBJ( ("+" + "300"), YDLocal1Get(location, "点"), 15.00, 10, 20.00, 100, 20.00, 0.00)
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.05)
			call YDWETimerDestroyTextTag( 1.00, GetLastCreatedTextTag())
			call RemoveLocation( YDLocal1Get(location, "点"))
			call YDUserDataSet(unit, GetTriggerUnit(),"灵石伤害量", real, 0.00)
			call YDUserDataSet(unit, GetTriggerUnit(),"灵石开关", boolean, true)
		else
		endif
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 3.00, false, function Trig______________________SHFunc005Func007T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig______________________SHFunc005Func007T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((YDUserDataGet(unit, GetTriggerUnit(),"傀岩杖开关", boolean) == false) and (GetEventDamage() >= OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.10)) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I02R') == true)) then
		//傀石：若单次受到了超过最大生命值10%的伤害，则会自动向目标射出一颗岩石，造成100点魔法伤害并且眩晕目标0.5秒，CD：5秒
		//告知ai：这里走封装的贝塞尔，而非jass模拟，模拟从低到高再到低的投掷过程，特效路径：Abilities\Weapons\RockBoltMissile\RockBoltMissile.mdl
		call YDUserDataSet(unit, GetTriggerUnit(),"傀岩杖开关", boolean, true)
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A04I')
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "creepthunderbolt", GetEventDamageSource())
		call RemoveLocation( YDLocal1Get(location, "点"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 5.00, false, function Trig______________________SHFunc006Func010T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 5.00, false," function Trig______________________SHFunc006Func010T","伤害类触发技能SH")
#endif 
	else
	endif
	//沙漠蜥蜴魂
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I02U') == true)) then
		//恢复受到的魔法伤害20%的生命值，doheal
		if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true)) then
			call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.20))
			if (((YDWEIsEventDamageType( DAMAGE_TYPE_DEATH) == true) or (YDWEIsEventDamageType( DAMAGE_TYPE_SHADOW_STRIKE) == true))) then
				call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.40))
			else
			endif
			call YDLocal1Set(real, "治疗值", OperatorRealMultiply( OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE)), 0.10))
			call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e031', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A065')
			call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A065', 1, 108, YDLocal1Get(real, "恢复值"))
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "holybolt", GetTriggerUnit())
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I038') == true)) then
		//水免疫：恢复10%受到的任意伤害，水属性伤害则提高到25%，走doheal
		if ((YDWEIsEventDamageType( DAMAGE_TYPE_COLD) == true)) then
			call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.25))
		else
			call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.10))
		endif
		call SetUnitLifeBJ( GetTriggerUnit(), OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), YDLocal1Get(real, "恢复值")))
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call CreateTextTagLocBJ( ("" + YDWEOperatorString3( "（+", R2S( YDLocal1Get(real, "恢复值")), "）")), YDLocal1Get(location, "点"), 20.00, 15.00, 20.00, 20.00, 100.00, 0)
		call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.05)
		call YDWETimerDestroyTextTag( 1.00, GetLastCreatedTextTag())
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	if ((YDUserDataGet(itemcode, 'I03A',"开关", boolean) == false) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I03A') == true)) then
		//硬壳：每次受到的伤害都会恢复自身最大生命值的1%+等级×1生命值，触发后进入0.2秒CD
		call YDUserDataSet(itemcode, 'I03A',"开关", boolean, true)
		call YDLocal1Set(real, "恢复值", OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01), OperatorRealMultiply( I2R( GetHeroLevel( GetTriggerUnit())), 1.00)))
		call SetUnitLifeBJ( GetTriggerUnit(), OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), YDLocal1Get(real, "恢复值")))
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call CreateTextTagLocBJ( ("" + YDWEOperatorString3( "（+", R2S( YDLocal1Get(real, "恢复值")), "）")), YDLocal1Get(location, "点"), 20.00, 15.00, 20.00, 20.00, 100.00, 0)
		call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.05)
		call YDWETimerDestroyTextTag( 0.80, GetLastCreatedTextTag())
		call RemoveLocation( YDLocal1Get(location, "点"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.20, false, function Trig______________________SHFunc010Func011T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.20, false," function Trig______________________SHFunc010Func011T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_COLD) == false) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I039') == true)) then
		//水枪溃：造成伤害后，在5秒内每秒造成伤害值2%的水属性伤害，可叠加（水属性伤害无法触发此效果）
		call YDLocal1Set(real, "伤害值", GetEventDamage())
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "伤害值", YDLocal1Get(real, "伤害值"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig______________________SHFunc011Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig______________________SHFunc011Func006T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_SHADOW_STRIKE) == false) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I03E') == true)) then
		//黑色吸取：对敌人造成任意伤害都在3秒内对敌人造成总共60点暗属性魔法伤害，且恢复实际伤害等量数值的生命值，走doheal
		call YDLocal1Set(real, "循环实数", 0.00)
		call YDLocal1Set(unit, "伤害来源", GetEventDamageSource())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "伤害值银魔手套", YDLocal1Get(real, "伤害值银魔手套"))
		call YDLocalSet(ydl_timer, unit, "伤害来源", YDLocal1Get(unit, "伤害来源"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig______________________SHFunc012Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig______________________SHFunc012Func006T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((UnitHasBuffBJ( GetEventDamageSource(), 'B00H') == true)) then
		//指挥（主动）：主目标在5秒内收到的伤害提高15%  这里走我们封装好的易伤
		call YDLocal1Set(location, "点", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 1000.00, YDLocal1Get(location, "点"), Condition(function Trig______________________SHFunc013Func003003003)))
		call YDLocal1Set(real, "数量", I2R( CountUnitsInGroup( YDLocal1Get(group, "单位组"))))
		call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), OperatorRealAdd( 1.00, OperatorRealMultiply( 0.02, YDLocal1Get(real, "数量")))))
		call RemoveLocation( YDLocal1Get(location, "点"))
		call DestroyGroup( YDLocal1Get(group, "单位组"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I050') == true)) then
		//异雷护体：每次受到伤害会充能，当累计充能达到30次时，会爆发一股雷电能量，击晕周围500范围敌人1秒，并且造成1000点魔法伤害
		call SetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I050'), OperatorIntegerAdd( GetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I050')), 1))
		if ((GetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I050')) >= 30)) then
			call SetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I050'), 0)
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "点"), Condition(function Trig______________________SHFunc014Func003Func003003003)))
			call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig______________________SHFunc014Func003Func004A)
			call RemoveLocation( YDLocal1Get(location, "点"))
			call DestroyGroup( YDLocal1Get(group, "单位组"))
		else
		endif
	else
	endif
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_ENHANCED) == false) and (YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == false) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I04Y') == true)) then
		//毒之附魔：每次造成高于（目标1%最大生命值+100）的魔法伤害额外附加20%的毒属性魔法伤害
		if ((GetEventDamage() >= OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01), 100.00))) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetEventDamage(), 0.20), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
		else
		endif
	else
	endif
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I06N') == true)) then
		//地狱火附魔（被动）：每次造成超过敌人1%最大生命值的魔法伤害（至少200点），则会额外附带一次伤害数值为自身最大魔法伤害×10%的火焰魔法伤害，CD：1秒
		call YDLocal1Set(real, "伤害值", GetEventDamage())
		call YDLocal1Set(real, "比较值", OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01), 0.00))
		if ((YDUserDataGet(unit, GetEventDamageSource(),"地狱火卡牌魔法CD", boolean) == false) and (YDLocal1Get(real, "伤害值") >= YDLocal1Get(real, "比较值")) and (YDLocal1Get(real, "伤害值") >= 200.00)) then
			call YDUserDataSet(unit, GetEventDamageSource(),"地狱火卡牌魔法CD", boolean, true)
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), UNIT_STATE_MAX_MANA), 0.10), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, false, function Trig______________________SHFunc016Func005Func004T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig______________________SHFunc016Func005Func004T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	if ((GetEventDamage() > 10.00) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07F') == true)) then
		//熔灵：造成伤害在5秒内恢复5%伤害的魔法（全队共用CD5秒）
		//告知ai：jass原文，这里没有CD，需要你实现
		call YDLocal1Set(real, "恢复值", OperatorRealMultiply( GetEventDamage(), 0.05))
		call YDLocal1Set(real, "循环实数", 0.00)
		if (true) then
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
			call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
			call YDLocalSet(ydl_timer, real, "恢复值", YDLocal1Get(real, "恢复值"))
			call YDLocalSet(ydl_timer, location, "特效点", YDLocal1Get(location, "特效点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, true, function Trig______________________SHFunc017Func007Func001T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig______________________SHFunc017Func007Func001T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I073') == true) and (OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.05) <= GetEventDamage()) and (YDUserDataGet(unit, GetEventDamageSource(),"安恶之鞋", boolean) == false)) then
		//惑灵（被动）：每次造成超过目标5%最大生命值的伤害有50%的几率恐惧目标1秒（冷却时间：10秒）
		//告知ai：走我们项目里封装好的恐惧
		call YDLocal1Set(real, "随机实数", GetRandomReal( 0, 1))
		if ((YDLocal1Get(real, "随机实数") <= 0.50)) then
			call YDUserDataSet(unit, GetEventDamageSource(),"安恶之鞋", boolean, true)
			call YDLocal1Set(location, "点A", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetEventDamageSource()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点A"), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A0AU')
			call IssuePointOrderLoc( YDLocal1Get(unit, "辅助马甲"), "silence", YDLocal1Get(location, "点A"))
			call YDLocal1Set(degree, "角度", YDWEAngleBetweenUnits( GetEventDamageSource(), GetTriggerUnit()))
			call YDLocal1Set(location, "移动点", PolarProjectionBJ( YDLocal1Get(location, "点A"), 400.00, YDLocal1Get(degree, "角度")))
			call IssuePointOrderLoc( GetTriggerUnit(), "move", YDLocal1Get(location, "移动点"))
			call RemoveLocation( YDLocal1Get(location, "点A"))
			call RemoveLocation( YDLocal1Get(location, "移动点"))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 10.00, false, function Trig______________________SHFunc018Func004Func011T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig______________________SHFunc018Func004Func011T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I08V') == true) and (YDUserDataGet(unit, GetEventDamageSource(),"灵墓之戒", boolean) == false)) then
		//魔力附加（被动）：对敌人造成伤害时额外造成自身已损失魔法值20%的暗魔法伤害（CD：1秒）
		//告知ai：走我们项目里封装好的闪电效果跳链，常量下面jass有
		call YDUserDataSet(unit, GetEventDamageSource(),"灵墓之戒", boolean, true)
		call YDLocal1Set(location, "点A", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(location, "点B", GetUnitLoc( GetTriggerUnit()))
		call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA)), 0.20), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
		call AddLightningLoc( "LEAS", YDLocal1Get(location, "点B"), YDLocal1Get(location, "点A"))
		call YDWETimerDestroyLightning( 1.00, GetLastCreatedLightningBJ())
		call RemoveLocation( YDLocal1Get(location, "点A"))
		call RemoveLocation( YDLocal1Get(location, "点B"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, false, function Trig______________________SHFunc019Func011T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig______________________SHFunc019Func011T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07P') == true) and (YDUserDataGet(unit, GetEventDamageSource(),"汭冥戒指", boolean) == false)) then
		//告知ai：很简单的逻辑，CD可以被玩家的冷却缩减属性减少
		call YDUserDataSet(unit, GetEventDamageSource(),"汭冥戒指", boolean, true)
		call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), 2000.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, OperatorRealSubtract( 6.00, OperatorRealMultiply( 6.00, YDUserDataGet(player, GetTriggerPlayer(),"冷却缩减", real))), false, function Trig______________________SHFunc020Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, OperatorRealSubtract( 6.00, OperatorRealMultiply( 6.00, YDUserDataGet(player, GetTriggerPlayer(),"冷却缩减", real))), false," function Trig______________________SHFunc020Func004T","伤害类触发技能SH")
#endif 
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07Y') == true)) then
		//远古切断（被动）：对敌人造成任意伤害都会附加敌人当前100%护甲值的强化伤害，若此次伤害为普攻，则有50%固定概率150%暴击
		call DisableTrigger( GetTriggeringTrigger())
		if ((YDWEIsEventAttackDamage() == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true)) then
			call YDLocal1Set(real, "随机实数", GetRandomReal( 0, 1))
			if ((YDLocal1Get(real, "随机实数") <= 0.50)) then
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x20)), 1.50), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
			else
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x20)), 1.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
			endif
		else
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x20)), 1.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
		endif
		call EnableTrigger( GetTriggeringTrigger())
	else
	endif
	if ((GetRandomReal( 0, 1) >= 0.20) and (YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I051') == true) or (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I01E') == true))) then
		//告知ai，走项目里的闪电链，魔力雷锤100，闪电权杖400，伤害值/目标数量：5
		if ((YDUserDataGet(unit, GetEventDamageSource(),"闪电权杖CD", boolean) == false)) then
			call YDUserDataSet(unit, GetEventDamageSource(),"闪电权杖CD", boolean, true)
			call YDLocal1Set(location, "点", GetUnitLoc( GetEventDamageSource()))
			call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetEventDamageSource()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
			if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I01E') == true)) then
				call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A03L')
			else
				if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I051') == true)) then
					call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A06K')
				else
				endif
			endif
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "chainlightning", GetTriggerUnit())
			call RemoveLocation( YDLocal1Get(location, "点"))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 2.00, false, function Trig______________________SHFunc022Func005Func008T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 2.00, false," function Trig______________________SHFunc022Func005Func008T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I06U') == true)) then
		//法袍护体：受到致死时，免疫该次伤害并且无敌0.5秒，随后消耗自身全部魔法值以120%比例恢复自身生命值，最大魔法值低于20%时无效，CD：60秒，恢复走doheal
		if ((GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA) > OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.20)) and (YDUserDataGet(unit, GetTriggerUnit(),"斯尔法袍CD", boolean) == false) and (GetEventDamage() >= GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE))) then
			call YDWESetEventDamage( 0.)
			call YDUserDataSet(unit, GetTriggerUnit(),"斯尔法袍CD", boolean, true)
			call YDLocal1Set(real, "循环实数", 0.00)
			call YDLocal1Set(real, "扣除魔法值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), 0.04))
			if (true) then
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
				call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
				call YDLocalSet(ydl_timer, real, "扣除魔法值", YDLocal1Get(real, "扣除魔法值"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 0.02, true, function Trig______________________SHFunc023Func002Func006Func001T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig______________________SHFunc023Func002Func006Func001T","伤害类触发技能SH")
#endif 
			else
			endif
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 60.00, false, function Trig______________________SHFunc023Func002Func007T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 60.00, false," function Trig______________________SHFunc023Func002Func007T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	if ((GetEventDamage() >= GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE)) and (UnitHasBuffBJ( GetTriggerUnit(), 'B00V') == true)) then
		//暗黑侵蚀（被动）：周围600码的敌人受到伤害时，会额外受到10%暗属性魔法伤害，受此效果影响的敌人死亡后会在8秒内短暂复活为自己所用
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.20, false, function Trig______________________SHFunc024Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.20, false," function Trig______________________SHFunc024Func002T","伤害类触发技能SH")
#endif 
	else
	endif
	//物理伤害触发
	if ((YDWEIsEventPhysicalDamage() == true)) then
		//穿透：造成物理伤害后目标每有1点护甲额外造成3点强化伤害
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I0C8') == true)) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x20)), 3.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
		else
		endif
	else
	endif
	//强化伤害触发
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_ENHANCED) == true)) then
		//每次造成强化伤害附带7%自身最大生命值的强化伤害（CD3秒，全局共享CD，并非各自独立）
		if ((YDUserDataGet(itemcode, 'I0C9',"CD", boolean) == false) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I0C9') == true)) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.07), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
			call YDUserDataSet(itemcode, 'I0C9',"CD", boolean, true)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3.00, false, function Trig______________________SHFunc028Func002Func004T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig______________________SHFunc028Func002Func004T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	//魔法伤害附加伤害
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == false) and (YDWEIsEventDamageType( DAMAGE_TYPE_ENHANCED) == false)) then
		//法术附魔：每次造成技能魔法伤害会额外发送弹幕追踪目标追加攻击力10%+200的精神伤害
		//告知ai：这里走我们的弹幕追踪，参数都有
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I0CH') == true)) then
			call YDLocal1Set(unit, "法刺弹幕", CreateUnit( GetOwningPlayer( GetEventDamageSource()), 'e06L', GetUnitX( GetEventDamageSource()), GetUnitY( GetEventDamageSource()), YDWEAngleBetweenUnits( GetEventDamageSource(), GetTriggerUnit())))
			call YDUserDataSet(unit, YDLocal1Get(unit, "法刺弹幕"),"主人", unit, GetEventDamageSource())
			call YDUserDataSet(unit, YDLocal1Get(unit, "法刺弹幕"),"飞行速度", real, 150.00)
			call YDUserDataSet(unit, YDLocal1Get(unit, "法刺弹幕"),"伤害半径", real, 150.00)
			call YDUserDataSet(unit, YDLocal1Get(unit, "法刺弹幕"),"指定敌人", unit, GetTriggerUnit())
			call UnitApplyTimedLife( YDLocal1Get(unit, "刀光"), 'BHwe', 0.60)
			call GroupAddUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal1Get(unit, "法刺弹幕"))
			if ((IsTriggerEnabled( gg_trg_____________DMXT) == true)) then
			else
				call EnableTrigger( gg_trg_____________DMXT)
			endif
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
			call YDLocalSet(ydl_timer, unit, "法刺弹幕", YDLocal1Get(unit, "法刺弹幕"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.04, true, function Trig______________________SHFunc030Func006Func009T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.04, true," function Trig______________________SHFunc030Func006Func009T","伤害类触发技能SH")
#endif 
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig______________________SH takes nothing returns nothing
	set gg_trg______________________SH = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg______________________SH,"伤害类触发技能SH")
#endif
	call MNAnyUnitDamaged(gg_trg______________________SH, 5.00)
	call TriggerAddCondition(gg_trg______________________SH, Condition(function Trig______________________SHConditions))
	call TriggerAddAction(gg_trg______________________SH, function Trig______________________SHActions)
endfunction

