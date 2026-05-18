//===========================================================================
// Trigger: 准备施法技能类（or有蓄力条）
//===========================================================================
function Trig_________________________or_______________uConditions takes nothing returns boolean
	return ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true))
endfunction

function Trig_________________________or_______________uFunc002Func012Func001Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig_________________________or_______________uFunc002Func012Func001Func005A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), unit, "特效马甲B", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 'e03G', YDLocalGet(GetExpiredTimer(), location, "选取单位点"), YDLocalGet(GetExpiredTimer(), degree, "角度")))
	call YDLocalSet(GetExpiredTimer(), real, "大小", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), "modelScale"))
	call SetUnitScale( YDLocalGet(GetExpiredTimer(), unit, "特效马甲B"), YDLocalGet(GetExpiredTimer(), real, "大小"), YDLocalGet(GetExpiredTimer(), real, "大小"), YDLocalGet(GetExpiredTimer(), real, "大小"))
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), real, "伤害值"), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________or_______________uFunc002Func012T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 25.00)) then
		call RemoveUnit( YDLocalGet(GetExpiredTimer(), unit, "施法进度条"))
		call YDLocalSet(GetExpiredTimer(), real, "伤害值", OperatorRealAdd( 1000.00, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ConvertUnitState(0x15)), 3.00)))
		call YDLocalSet(GetExpiredTimer(), group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 400.00, YDLocalGet(GetExpiredTimer(), location, "目标点"), Condition(function Trig_________________________or_______________uFunc002Func012Func001Func004003003)))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig_________________________or_______________uFunc002Func012Func001Func005A)
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "马甲点"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________or_______________uFunc003Func006Func002003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocal2Get(unit, "技能目标"))) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (IsUnitInGroup( GetFilterUnit(), YDLocal2Get(group, "重复单位组")) == false))))))
endfunction

function Trig_________________________or_______________uFunc003Func006Func003A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "技能目标"), GetEnumUnit(), 200.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl", GetEnumUnit(), "origin"))
endfunction

function Trig_________________________or_______________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetSpellAbilityId() == 'A086')) then
		call YDLocal1Set(location, "马甲点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "目标点", GetUnitLoc( GetSpellTargetUnit()))
		call YDLocal1Set(unit, "施法进度条", CreateUnitAtLoc( Player(0), 'e01O', YDLocal1Get(location, "马甲点"), YDLocal1Get(degree, "角度")))
		call SetUnitFlyHeight( YDLocal1Get(unit, "施法进度条"), OperatorRealAdd( GetUnitFlyHeight( GetTriggerUnit()), 275.00), 0.00)
		call SetUnitTimeScale( YDLocal1Get(unit, "施法进度条"), 2.00)
		call UnitApplyTimedLife( YDLocal1Get(unit, "施法进度条"), 'BHwe', 0.50)
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 1000.00))
		call YDLocal1Set(unit, "特效马甲A", CreateUnitAtLoc( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'e03H', YDLocal1Get(location, "目标点"), YDLocal1Get(degree, "角度")))
		call YDLocal1Set(real, "大小", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( GetTriggerUnit()), "modelScale"))
		call SetUnitScale( YDLocal1Get(unit, "特效马甲A"), YDLocal1Get(real, "大小"), YDLocal1Get(real, "大小"), YDLocal1Get(real, "大小"))
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "伤害值", YDLocal1Get(real, "伤害值"))
		call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
		call YDLocalSet(ydl_timer, real, "大小", YDLocal1Get(real, "大小"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, unit, "施法进度条", YDLocal1Get(unit, "施法进度条"))
		call YDLocalSet(ydl_timer, unit, "特效马甲B", YDLocal1Get(unit, "特效马甲B"))
		call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
		call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
		call YDLocalSet(ydl_timer, location, "马甲点", YDLocal1Get(location, "马甲点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.02, true, function Trig_________________________or_______________uFunc002Func012T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig_________________________or_______________uFunc002Func012T","准备施法技能类（or有蓄力条）")
#endif 
	else
	endif
	if (((GetUnitCurrentOrder( GetTriggerUnit()) == YDWEUOrderId2OrderId( 852092)) or (GetUnitCurrentOrder( GetTriggerUnit()) == YDWEUOrderId2OrderId( 852063)) or (GetUnitCurrentOrder( GetTriggerUnit()) == YDWEUOrderId2OrderId( 852501)) or (GetUnitCurrentOrder( GetTriggerUnit()) == YDWEUOrderId2OrderId( 852160))) and (UnitHasItemOfTypeBJ( GetSpellTargetUnit(), 'I03C') == true)) then
		call YDLocal1Set(unit, "技能目标", GetSpellTargetUnit())
		call YDLocal1Set(abilcode, "技能", GetSpellAbilityId())
		call YDLocal1Set(real, "治疗量", YDWEGetUnitAbilityDataReal( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 108))
		if ((YDLocal1Get(real, "治疗量") >= 50.00)) then
			call YDLocal1Set(location, "马甲点", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 800.00, YDLocal1Get(location, "马甲点"), Condition(function Trig_________________________or_______________uFunc003Func006Func002003003)))
			call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig_________________________or_______________uFunc003Func006Func003A)
			call RemoveLocation( YDLocal1Get(location, "马甲点"))
			call DestroyGroup( YDLocal1Get(group, "判断碰撞单位组"))
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_________________________or_______________u takes nothing returns nothing
	set gg_trg_________________________or_______________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_________________________or_______________u,"准备施法技能类（or有蓄力条）")
#endif
	call TriggerAddCondition(gg_trg_________________________or_______________u, Condition(function Trig_________________________or_______________uConditions))
	call TriggerAddAction(gg_trg_________________________or_______________u, function Trig_________________________or_______________uActions)
endfunction

