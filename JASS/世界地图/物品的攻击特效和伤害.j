//===========================================================================
// Trigger: 物品的攻击特效+伤害GJTX
//===========================================================================
function Trig_____________________________GJTXConditions takes nothing returns boolean
	return ((YDWEIsEventDamageType( DAMAGE_TYPE_MIND) == false)) and ((GetEventDamage() >= 1.00)) and ((YDWEIsEventAttackDamage() == true))
endfunction

function Trig_____________________________GJTXFunc007Func005Func002Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), location, "目标点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource")))
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 50.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SLOW_POISON, WEAPON_TYPE_WHOKNOWS)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl", YDLocalGet(GetExpiredTimer(), location, "目标点")))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
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

function Trig_____________________________GJTXFunc018Func005Func003Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func007A takes nothing returns nothing
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), OperatorRealAdd( 3000.00, OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 1.00)), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call YDLocal2Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal2Get(location, "点"), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), 'A0A7')
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "thunderbolt", YDLocal2Get(unit, "选取单位"))
	call RemoveLocation( YDLocal2Get(location, "点"))
	call YDWEFlyEnable( GetEnumUnit())
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func006A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), OperatorRealAdd( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 50.00), 0.00)
	if ((UnitHasBuffBJ( GetEnumUnit(), 'BPSE') == false)) then
		call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), GetUnitDefaultFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 0.00)
		call GroupRemoveUnit( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	else
	endif
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func002Func001Func004A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), OperatorRealSubtract( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 100.00), 0.00)
	if ((UnitHasBuffBJ( GetEnumUnit(), 'BPSE') == false)) then
		call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), GetUnitDefaultFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 0.00)
		call GroupRemoveUnit( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	else
	endif
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数2") >= 10.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数2", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数2"), 1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func002Func001Func004A)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func009Func001T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00)) then
		call YDLocalSet(GetExpiredTimer(), real, "循环实数2", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
		call YDLocalSet(ydl_timer, real, "循环实数2", YDLocalGet(GetExpiredTimer(), real, "循环实数2"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.03, true, function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.03, true," function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func002T","物品的攻击特效+伤害GJTX")
#endif 
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig_____________________________GJTXFunc018Func005Func003Func009Func001Func001Func006A)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig_____________________________GJTXFunc018Func005Func003Func009T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
	call YDLocalSet(ydl_timer, real, "循环实数", YDLocalGet(GetExpiredTimer(), real, "循环实数"))
	call YDLocalSet(ydl_timer, real, "循环实数2", YDLocalGet(GetExpiredTimer(), real, "循环实数2"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.03, true, function Trig_____________________________GJTXFunc018Func005Func003Func009Func001T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.03, true," function Trig_____________________________GJTXFunc018Func005Func003Func009Func001T","物品的攻击特效+伤害GJTX")
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

function Trig_____________________________GJTXFunc018Func005Func003Func010T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"虚空猎锤", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"虚空猎锤", boolean)
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
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

function Trig_____________________________GJTXFunc018Func007Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "伤害值"), 0.80), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
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

function Trig_____________________________GJTXFunc018Func008Func002Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"黑暗猎人手套", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"黑暗猎人手套", boolean)
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

function Trig_____________________________GJTXFunc018Func009Func003Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true) and (UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B00W') == true)) then
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealMultiply( OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE)), 0.02), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
	else
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶魔王爪", boolean, false)
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶魔王爪", boolean)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________________________GJTXFunc018Func010Func004Func001Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"狂暴熔刃CD", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"狂暴熔刃CD", boolean)
	call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 'A09E')
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

function Trig_____________________________GJTXFunc018Func010Func004Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_____________________________GJTXFunc018Func010Func004Func005A takes nothing returns nothing
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), OperatorRealMultiply( YDUserDataGet(unit, GetEventDamageSource(),"暴击伤害", real), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 2.00)), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________________________GJTXFunc018Func011Func006003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (GetFilterUnit() != GetTriggerUnit()))))))
endfunction

function Trig_____________________________GJTXFunc018Func011Func007A takes nothing returns nothing
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), OperatorRealMultiply( GetEventDamage(), 0.50), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________________________GJTXFunc018Func012Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 600.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (GetFilterUnit() != GetTriggerUnit()))))))
endfunction

function Trig_____________________________GJTXFunc018Func012Func005A takes nothing returns nothing
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( GetEnumUnit()))
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), OperatorRealMultiply( GetEventDamage(), 0.50), false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl", YDLocal2Get(location, "选取单位点")))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
endfunction

function Trig_____________________________GJTXFunc020Func003Func002003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 380.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig_____________________________GJTXFunc020Func003Func003A takes nothing returns nothing
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( GetEnumUnit()))
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), 1000.00, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl", YDLocal2Get(location, "选取单位点")))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
endfunction

function Trig_____________________________GJTXFunc021Func003Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B011') == true) and (IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true)) then
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealAdd( 100.00, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), ConvertUnitState(0x15)), 0.20)), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		call YDWETimerDestroyEffect( 0.50, AddSpecialEffectTarget( "Environment\\LargeBuildingFire\\LargeBuildingFire2.mdl", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), "origin"))
	else
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"炽热之弹失", boolean, false)
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"炽热之弹失", boolean)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________________________GJTXFunc027Func006Func010T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 6.00) or (UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B00E') == false))) then
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"沙之猎弓CD", boolean, false)
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"沙之猎弓CD", boolean)
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 2, 0, 15)
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

function Trig_____________________________GJTXFunc028Func003Func005T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"右腿普攻加速时间", real) <= 0.00)) then
		call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 'A06V')
		call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 'B00K')
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"右腿普攻加速时间", real)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"右腿普攻加速时间", real, OperatorRealSubtract( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"),"右腿普攻加速时间", real), 1.00))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________________________GJTXFunc029Func010T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B00E') == false) or (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 3.00))) then
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 2, 0, 2)
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

function Trig_____________________________GJTXActions takes nothing returns nothing
	local integer ydul_a
	local timer ydl_timer
	YDLocalInitialize()
	//受到伤害触发
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I021') == true)) then
		//受到200范围内的近战攻击会反弹敌人10+50%攻击力的物理伤害
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") <= 300.00)) then
			call UnitDamageTarget( GetTriggerUnit(), GetEventDamageSource(), OperatorRealAdd( 10.00, OperatorRealMultiply( 0.50, GetUnitState( GetTriggerUnit(), ConvertUnitState(0x15)))), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I04W') == true)) then
		//毒抗：受到的毒伤害减少25%|n毒性铠甲：受到近战200范围的普通攻击时，反击敌人，使敌人在3秒内每秒受到50点毒属性魔法伤害
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") <= 200.00)) then
			call YDLocal1Set(real, "循环实数", 0.00)
			set ydul_a = 1
			loop
				exitwhen ydul_a > 3
				call YDLocal1Set(real, "循环实数", OperatorRealAdd( YDLocal1Get(real, "循环实数"), 1.00))
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
				call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
				call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, OperatorRealMultiply( 1.00, YDLocal1Get(real, "循环实数")), false, function Trig_____________________________GJTXFunc007Func005Func002Func002T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, OperatorRealMultiply( 1.00, YDLocal1Get(real, "循环实数")), false," function Trig_____________________________GJTXFunc007Func005Func002Func002T","物品的攻击特效+伤害GJTX")
#endif 
				set ydul_a = ydul_a + 1
			endloop
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I06F') == true)) then
		//肩甲：|r|cffffffcc受到300范围内的攻击会反弹敌人50%攻击力的火焰魔法伤害
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") <= 300.00)) then
			call UnitDamageTarget( GetTriggerUnit(), GetEventDamageSource(), OperatorRealAdd( 0.00, OperatorRealMultiply( 0.50, GetUnitState( GetTriggerUnit(), ConvertUnitState(0x15)))), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	//反甲类
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true) and (YDWEIsEventAttackDamage() == true) and ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I086') == true) or (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I0CF') == true))) then
		if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I086') == true)) then
			call UnitDamageTarget( GetTriggerUnit(), GetEventDamageSource(), OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x20)), 2.00), 100.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I0CF') == true)) then
			call UnitDamageTarget( GetTriggerUnit(), GetEventDamageSource(), OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x20)), 2.00), 150.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DIVINE, WEAPON_TYPE_WHOKNOWS)
		else
		endif
	else
	endif
	//以下情况，技能攻击特效跳过
	//告知ai：这里需要加一个额外的配置表，跳过这些类型，这些不触发攻击特效
	if ((((YDWEIsEventDamageType( DAMAGE_TYPE_DIVINE) == true) and (GetUnitTypeId( GetEventDamageSource()) == 'H015')) or (GetUnitTypeId( GetEventDamageSource()) == 'E05V')) and (YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true)) then
		call YDLocal1Release()
	set ydl_timer = null
		return
	else
	endif
	//（纯普攻触发）整理
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I0CG') == true)) then
		//每次普通攻击对目标额外造成攻击力10%+200点光属性伤害，并且治疗自身|r|cffff0000固定|r|cffffffcc100点生命值|
		//告知ai：这里的治疗走doheal
		call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 0.10), 200.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DIVINE, WEAPON_TYPE_WHOKNOWS)
		call YDWETimerDestroyEffect( 0.50, AddSpecialEffectTarget( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetTriggerUnit(), "overhead"))
		call SetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE), 100.00))
		call YDWETimerDestroyEffect( 0.50, AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", GetEventDamageSource(), "origin"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I0C3') == true)) then
		//收割：对最大生命值低于20%/10%的敌人（普通/非普通敌人）普攻后造成秒杀伤害
		//告知ai：这里的判断走TS\系统\03．技能系统\00．技能模板+函数\02．通用函数\01．便捷短函数集合下面的精英判定
		if (((IsUnitRace( GetTriggerUnit(), RACE_DEMON) == true) or (IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true))) then
			if ((GetUnitLifePercent( GetTriggerUnit()) <= 10.00)) then
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 1.10), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
				call KillUnit( GetTriggerUnit())
			else
			endif
		else
			if ((GetUnitLifePercent( GetTriggerUnit()) <= 20.00)) then
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 1.10), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
				call KillUnit( GetTriggerUnit())
			else
			endif
		endif
	else
	endif
	//（近战普攻触发）整理
	if ((YDWEIsEventPhysicalDamage() == true) and (IsUnitType( GetEventDamageSource(), UNIT_TYPE_MELEE_ATTACKER) == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true)) then
		call YDLocal1Set(real, "随机实数", GetRandomReal( 0.01, 1))
		if ((YDUserDataGet(unit, GetEventDamageSource(),"虚空猎锤", boolean) == false) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I08P') == true)) then
			//重击（被动）：普通攻击20%的几率对敌人周围400码的单位造成1.5秒的击飞，并且造成（3000+100%攻击）的强化伤害（CD：5秒）
			//告知ai：这里要走我们封装好的函数
			if ((YDLocal1Get(real, "随机实数") <= 0.20)) then
				call YDUserDataSet(unit, GetEventDamageSource(),"虚空猎锤", boolean, true)
				call YDLocal1Set(unit, "目标", GetTriggerUnit())
				call YDLocal1Set(location, "目标点", GetUnitLoc( YDLocal1Get(unit, "目标")))
				call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 400.00, YDLocal1Get(location, "目标点"), Condition(function Trig_____________________________GJTXFunc018Func005Func003Func004003003)))
				call YDLocal1Set(unit, "特效", CreateUnitAtLoc( GetTriggerPlayer(), 'e01Z', YDLocal1Get(location, "目标点"), 0))
				call RemoveLocation( YDLocal1Get(location, "目标点"))
				call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig_____________________________GJTXFunc018Func005Func003Func007A)
				call YDLocal1Set(real, "循环实数", 0.00)
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
				call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
				call YDLocalSet(ydl_timer, real, "循环实数2", YDLocal1Get(real, "循环实数2"))
				call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 0.05, false, function Trig_____________________________GJTXFunc018Func005Func003Func009T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 0.05, false," function Trig_____________________________GJTXFunc018Func005Func003Func009T","物品的攻击特效+伤害GJTX")
#endif 
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
				call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 5.00, false, function Trig_____________________________GJTXFunc018Func005Func003Func010T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 5.00, false," function Trig_____________________________GJTXFunc018Func005Func003Func010T","物品的攻击特效+伤害GJTX")
#endif 
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07I') == true)) then
			//熔吸（被动）：近战普通攻击有20%/4%（野怪/精英和Boss）的几率偷取目标15%最大生命值和魔法值，并且额外造成300%攻击力的物理伤害
			//告知ai：这里的偷取治疗恢复hp/mp走doheal
			call YDLocal1Set(boolean, "狱之刺刃", false)
			if (((IsHeroUnitId( GetUnitTypeId( GetTriggerUnit())) == true) or (IsUnitRace( GetTriggerUnit(), RACE_DEMON) == true))) then
				if ((YDLocal1Get(real, "随机实数") <= 0.04)) then
					call YDLocal1Set(boolean, "狱之刺刃", true)
				else
				endif
			else
				if ((YDLocal1Get(real, "随机实数") <= 0.20)) then
					call YDLocal1Set(boolean, "狱之刺刃", true)
				else
				endif
			endif
			if ((YDLocal1Get(boolean, "狱之刺刃") == true)) then
				call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.15)))
				call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.15)))
				call SetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.15)))
				call SetUnitState( GetEventDamageSource(), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( GetEventDamageSource(), UNIT_STATE_MANA), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.15)))
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 3.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
				call YDWETimerDestroyEffect( 1.50, AddSpecialEffect( "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", GetUnitX( GetEventDamageSource()), GetUnitY( GetEventDamageSource())))
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07D') == true)) then
			//狱刃转换（被动）：近战物理攻击中的80%转换为火焰魔法伤害
			call YDLocal1Set(real, "伤害值", GetEventDamage())
			call YDWESetEventDamage( 0.)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
			call YDLocalSet(ydl_timer, real, "伤害值", YDLocal1Get(real, "伤害值"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.00, false, function Trig_____________________________GJTXFunc018Func007Func004T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig_____________________________GJTXFunc018Func007Func004T","物品的攻击特效+伤害GJTX")
#endif 
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I08K') == true) and (YDWEDistanceBetweenUnits( GetTriggerUnit(), GetEventDamageSource()) <= 200.00) and (YDUserDataGet(unit, GetEventDamageSource(),"黑暗猎人手套", boolean) == false)) then
			//告知ai：这里走我们封装好的致盲
			if ((YDLocal1Get(real, "随机实数") <= 0.15)) then
				call YDUserDataSet(unit, GetEventDamageSource(),"黑暗猎人手套", boolean, true)
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 2.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
				call YDWETimerDestroyEffect( 1.00, AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl", GetTriggerUnit(), "overhead"))
				call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetEventDamageSource()), 'e00D', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0))
				call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A0EF')
				call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "curse", GetTriggerUnit())
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 8.00, false, function Trig_____________________________GJTXFunc018Func008Func002Func008T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 8.00, false," function Trig_____________________________GJTXFunc018Func008Func002Func008T","物品的攻击特效+伤害GJTX")
#endif 
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I08E') == true)) then
			//恶魔撕裂（物理攻击特效）：攻击会撕裂目标3秒，每秒造成目标已损失2%生命值的真实伤害，并且减少目标15%移速（重复攻击刷新持续时间）
			//这里的魔法效果改成buff表里的D005，只是配置了，没落地效果定义，定义就是在这个物品里单独实现
			if ((YDUserDataGet(unit, GetTriggerUnit(),"恶魔王爪", boolean) == false)) then
				call YDUserDataSet(unit, GetTriggerUnit(),"恶魔王爪", boolean, true)
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
				call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 1.00, true, function Trig_____________________________GJTXFunc018Func009Func003Func003T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_____________________________GJTXFunc018Func009Func003Func003T","物品的攻击特效+伤害GJTX")
#endif 
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07H') == true)) then
			//狱爆（被动）：近战普通攻击有10%的几率在2秒内提高300%攻击速度，并且对目标周围500码的敌人造成一次（200%攻击力×暴击伤害）的物理伤害（持续时间内不会再次触发增加攻速）
			//告知ai：加攻速走属性应用
			call YDLocal1Set(real, "随机实数", GetRandomReal( 0.01, 1))
			if ((YDLocal1Get(real, "随机实数") <= 0.10)) then
				if ((YDUserDataGet(unit, GetEventDamageSource(),"狂暴熔刃CD", boolean) == false)) then
					call UnitAddAbility( GetEventDamageSource(), 'A09E')
					call YDUserDataSet(unit, GetEventDamageSource(),"狂暴熔刃CD", boolean, true)
					set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
					call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
					call TimerStart(ydl_timer, 4.00, false, function Trig_____________________________GJTXFunc018Func010Func004Func001Func003T)
#ifdef StarDebuggerIncluded 
					call  SDR_DebugTimer(ydl_timer, 4.00, false," function Trig_____________________________GJTXFunc018Func010Func004Func001Func003T","物品的攻击特效+伤害GJTX")
#endif 
				else
				endif
				call YDLocal1Set(location, "点A", GetUnitLoc( GetEventDamageSource()))
				call YDLocal1Set(unit, "狂暴熔刃特效", CreateUnitAtLoc( GetOwningPlayer( GetEventDamageSource()), 'e03S', YDLocal1Get(location, "点A"), 0))
				call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 350.00, YDLocal1Get(location, "点A"), Condition(function Trig_____________________________GJTXFunc018Func010Func004Func004003003)))
				call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_____________________________GJTXFunc018Func010Func004Func005A)
				call RemoveLocation( YDLocal1Get(location, "点A"))
				call DestroyGroup( YDLocal1Get(group, "单位组"))
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07U') == true)) then
			//横扫（被动）：近战攻击会对周围500范围内的其他敌人造成50%的扩散
			//告知ai：这里走ts的扩散系统
			call YDLocal1Set(location, "点A", GetUnitLoc( GetEventDamageSource()))
			call YDLocal1Set(effect, "魔古特效", AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetEventDamageSource(), "foot"))
			call YDWETimerDestroyEffect( 0.80, YDLocal1Get(effect, "魔古特效"))
			call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "点A"), Condition(function Trig_____________________________GJTXFunc018Func011Func006003003)))
			call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_____________________________GJTXFunc018Func011Func007A)
			call RemoveLocation( YDLocal1Get(location, "点A"))
			call DestroyGroup( YDLocal1Get(group, "单位组"))
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I06D') == true)) then
			//炽热：近战普攻造成扩散，对周围300码的敌人造成50%的强化伤害，若成功扩散，则主目标额外受到30%的额外强化伤害
			//告知ai：这里走ts的扩散系统，注意，这里没走攻击伤害，所以不会死循环
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 300.00, YDLocal1Get(location, "点"), Condition(function Trig_____________________________GJTXFunc018Func012Func004003003)))
			call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_____________________________GJTXFunc018Func012Func005A)
			if ((IsUnitGroupEmptyBJ( YDLocal1Get(group, "单位组")) == false)) then
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetEventDamage(), 0.30), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
			else
			endif
			call RemoveLocation( YDLocal1Get(location, "点"))
			call DestroyGroup( YDLocal1Get(group, "单位组"))
		else
		endif
	else
	endif
	//（远程普攻触发）整理
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I04L') == true)) then
		//火炮装填：攻击速度降低75%，但是超过400距离的每次普通攻击100%对目标周围300范围的敌人额外造成1000点火属性魔法伤害
		if ((YDWEIsEventAttackDamage() == true) and (YDWEDistanceBetweenUnits( GetTriggerUnit(), GetEventDamageSource()) >= 400.00)) then
			call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 300.00, YDLocal1Get(location, "点"), Condition(function Trig_____________________________GJTXFunc020Func003Func002003003)))
			call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_____________________________GJTXFunc020Func003Func003A)
			call DestroyGroup( YDLocal1Get(group, "单位组"))
		else
		endif
	else
		if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I04K') == true)) then
			//火枪装填：超过300距离的敌人，每次普通攻击100%额外造成200点火属性魔法伤害|
			if ((YDWEIsEventAttackDamage() == true) and (YDWEDistanceBetweenUnits( GetTriggerUnit(), GetEventDamageSource()) >= 400.00)) then
				call DisableTrigger( GetTriggeringTrigger())
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), 200.00, true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
				call EnableTrigger( GetTriggeringTrigger())
			else
			endif
		else
		endif
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I09B') == true)) then
		//炽热之矢（被动）：远程普通攻击能够点燃目标，每秒造成100+20%攻击力的火焰伤害，持续3秒
		//告知ai：这里走buff表里的D002
		if ((YDUserDataGet(unit, GetTriggerUnit(),"炽热之弹失", boolean) == false)) then
			call YDUserDataSet(unit, GetTriggerUnit(),"炽热之弹失", boolean, true)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, true, function Trig_____________________________GJTXFunc021Func003Func002T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_____________________________GJTXFunc021Func003Func002T","物品的攻击特效+伤害GJTX")
#endif 
		else
		endif
	else
	endif
	//（攻击特效）整理
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07V') == true)) then
		//淬血附魔（被动）：普通攻击附带500点火焰伤害（攻击效果）|n淬血战斗（被动）：普通攻击有10%的几率形成一道治疗波，治疗最多3个单位2000点生命值（攻击效果）
		//告知ai：这里走我们的医疗波，最大目标3,0衰减
		call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), 500.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		if ((GetRandomReal( 0.01, 1) <= 0.10)) then
			call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetEventDamageSource()), 'e031', GetUnitX( GetEventDamageSource()), GetUnitY( GetEventDamageSource()), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A064')
			call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A064', 1, 108, 2000.00)
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "healingwave", GetEventDamageSource())
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I08I') == true)) then
		//破朽锋刃（被动）：每次攻击都有（6%+暴击率/2）几率额外造成300%攻击的物理伤害（攻击效果）
		if ((YDLocal1Get(real, "随机实数") <= OperatorRealAdd( 0.06, OperatorRealDivide( YDUserDataGet(player, GetOwningPlayer( GetEventDamageSource()),"暴击率", real), 2.00)))) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetEventDamageSource(), ConvertUnitState(0x15)), 3.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call CreateTextTagLocBJ( "TRIGSTR_9064", YDLocal1Get(location, "点"), 20.00, 12.00, 50.00, 1.00, 1.00, 20.00)
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
			call YDWETimerDestroyTextTag( 0.80, GetLastCreatedTextTag())
			call RemoveLocation( YDLocal1Get(location, "点"))
		else
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I026') == true)) then
		//远程火药：对400范围外的敌人造成普攻伤害额外造成20%金属性魔法伤害
		//告知ai：要避免死循环
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") >= 400.00)) then
			call DisableTrigger( GetTriggeringTrigger())
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealAdd( 0.00, OperatorRealMultiply( 0.20, GetEventDamage())), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ACID, WEAPON_TYPE_WHOKNOWS)
			call YDWETimerDestroyEffect( 0.80, AddSpecialEffectLoc( "Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl", YDLocal1Get(location, "点")))
			call EnableTrigger( GetTriggeringTrigger())
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I04B') == true)) then
		//魔弓：对距离超过400外的敌人造成普攻伤害会减少目标伤害值10%的魔法，并且吸血伤害10%的血量
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") >= 400.00)) then
			call YDLocal1Set(real, "数据", OperatorRealMultiply( GetEventDamage(), 0.10))
			call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), YDLocal1Get(real, "数据")))
			call SetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( GetEventDamageSource(), UNIT_STATE_LIFE), OperatorRealAdd( 0.00, OperatorRealMultiply( YDLocal1Get(real, "数据"), OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( GetEventDamageSource()),"生命恢复属性增幅", real), 1.00)))))
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I04A') == true)) then
		//沙之猎杀：对距离超过500的敌人的首次普攻会在6秒内降低目标15点护甲，且击晕目标1秒（攻击效果）
		//告知ai：这里走我们buff的精灵之火和快速击晕
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDWEIsEventRangedDamage() == true) and (YDLocal1Get(real, "距离") >= 500.00) and (YDUserDataGet(unit, GetEventDamageSource(),"沙之猎弓CD", boolean) == false)) then
			call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetEventDamageSource()), 'e00D', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0))
			call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A01Z')
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "thunderbolt", GetTriggerUnit())
			call YDUserDataSet(unit, GetEventDamageSource(),"沙之猎弓CD", boolean, true)
			call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 2, 1, 15)
			call YDLocal1Set(unit, "魔法效果马甲", CreateUnitAtLoc( GetOwningPlayer( GetEventDamageSource()), 'h00A', YDLocal1Get(location, "点"), 0))
			call UnitAddAbility( YDLocal1Get(unit, "魔法效果马甲"), 'A069')
			call IssueTargetOrder( YDLocal1Get(unit, "魔法效果马甲"), "attack", GetTriggerUnit())
			call YDLocal1Set(real, "循环实数", 0.00)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
			call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, true, function Trig_____________________________GJTXFunc027Func006Func010T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_____________________________GJTXFunc027Func006Func010T","物品的攻击特效+伤害GJTX")
#endif 
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I03O') == true)) then
		//近战普攻后在3秒内提升自身10%移速，重复触发刷新持续时间（攻击效果）
		if ((UnitHasBuffBJ( GetEventDamageSource(), 'B00K') == true)) then
			call YDUserDataSet(unit, GetEventDamageSource(),"右腿普攻加速时间", real, 3.00)
		else
			call UnitAddAbility( GetEventDamageSource(), 'A06V')
			call YDUserDataSet(unit, GetEventDamageSource(),"右腿普攻加速时间", real, 3.00)
			call YDLocal1Set(real, "循环实数", 0.00)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, true, function Trig_____________________________GJTXFunc028Func003Func005T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_____________________________GJTXFunc028Func003Func005T","物品的攻击特效+伤害GJTX")
#endif 
		endif
	else
	endif
	if (((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I09W') == true) or (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I03N') == true))) then
		//普攻在4秒内减少目标2点护甲，重复触发可独立叠加
		call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 2, 1, 2)
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetEventDamageSource()), 'h00A', YDLocal1Get(location, "点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A069')
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "attackonce", GetTriggerUnit())
		call RemoveLocation( YDLocal1Get(location, "点"))
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_____________________________GJTXFunc029Func010T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_____________________________GJTXFunc029Func010T","物品的攻击特效+伤害GJTX")
#endif 
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I060') == true)) then
		//火焰附魔：每次攻击都能造成50/100（攻击特效/普通攻击）点火焰魔法伤害
		//告知ai：避免死循环
		call DisableTrigger( GetTriggeringTrigger())
		if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true)) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), 100.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		else
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), 50.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		endif
		call EnableTrigger( GetTriggeringTrigger())
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I061') == true)) then
		//断刃攻击：每次普通攻击造成自身力量×1.5的物理伤害
		//告知ai：避免死循环
		call DisableTrigger( GetTriggeringTrigger())
		call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( I2R( GetHeroStr( GetEventDamageSource(), true)), 1.50), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
		call EnableTrigger( GetTriggeringTrigger())
	else
	endif
	if ((IsUnitType( GetEventDamageSource(), UNIT_TYPE_RANGED_ATTACKER) == true) and (UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I06C') == true)) then
		//瑟尔之力（远程）：攻击附带目标最大生命值5%/1%（小怪/精英和Boss）的物理伤害（攻击效果）
		//告知ai：避免死循环，条件判断用TS\系统\03．技能系统\00．技能模板+函数\02．通用函数\01．便捷短函数集合\06．精英单位判断.ts
		if (((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true) or (IsUnitRace( GetTriggerUnit(), RACE_DEMON) == true))) then
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
		else
			call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.05), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_____________________________GJTX takes nothing returns nothing
	set gg_trg_____________________________GJTX = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_____________________________GJTX,"物品的攻击特效+伤害GJTX")
#endif
	call MNAnyUnitDamaged(gg_trg_____________________________GJTX, 5.00)
	call TriggerAddCondition(gg_trg_____________________________GJTX, Condition(function Trig_____________________________GJTXConditions))
	call TriggerAddAction(gg_trg_____________________________GJTX, function Trig_____________________________GJTXActions)
endfunction

