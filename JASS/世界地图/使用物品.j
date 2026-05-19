//===========================================================================
// Trigger: 使用物品触发事件SY
//===========================================================================
function Trig_________________________SYConditions takes nothing returns boolean
	return ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true))
endfunction

function Trig_________________________SYFunc005Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 5.00)) then
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 20.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
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

function Trig_________________________SYFunc007Func004003003 takes nothing returns boolean
	return ((IsUnitAlly( GetFilterUnit(), GetTriggerPlayer()) == true) and (IsUnitOwnedByPlayer( GetFilterUnit(), GetTriggerPlayer()) == false))
endfunction

function Trig_________________________SYFunc007Func006Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B007') == true)) then
	else
		if ((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "GetManipulatedItem")) == 'I0CB')) then
			call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 0, OperatorIntegerMultiply( 20, YDLocalGet(GetExpiredTimer(), integer, "数量")))
		else
			call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, OperatorIntegerMultiply( 5, YDLocalGet(GetExpiredTimer(), integer, "数量")))
		endif
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

function Trig_________________________SYFunc008Func005003003 takes nothing returns boolean
	return ((IsUnitAlly( GetFilterUnit(), GetTriggerPlayer()) == true) and (10 >= 10))
endfunction

function Trig_________________________SYFunc008Func006Func004A takes nothing returns nothing
	call UnitRemoveBuffsEx( GetEnumUnit(), false, true, false, false, false, false, true)
endfunction

function Trig_________________________SYFunc009Func004Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"伤害提高", real, OperatorRealAdd( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"伤害提高", real), -0.40))
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"斯尔之心", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"斯尔之心", boolean)
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

function Trig_________________________SYFunc010Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 1000.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc010Func005A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call YDLocal2Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal2Get(location, "选取单位点"), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), 'A07Z')
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "slow", YDLocal2Get(unit, "选取单位"))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
endfunction

function Trig_________________________SYFunc010Func006Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( I2R( GetHeroInt( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), true)), 10.00), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocalGet(GetExpiredTimer(), location, "选取单位点"), 0))
	call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A01N')
	call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "thunderbolt", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________SYFunc010Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________SYFunc010Func006Func001A)
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________SYFunc011Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 1000.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc011Func005Func009Func001Func003A takes nothing returns nothing
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( I2R( GetHeroInt( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), true)), 10.00), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocalGet(GetExpiredTimer(), location, "选取单位点"), 0))
	call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A01Z')
	call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "thunderbolt", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________SYFunc011Func005Func009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), 'B00P') == false) or (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00))) then
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "选取单位"),"造成伤害降低", real, OperatorRealSubtract( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "选取单位"),"造成伤害降低", real), 0.30))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________SYFunc011Func005Func009Func001Func003A)
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
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

function Trig_________________________SYFunc011Func005A takes nothing returns nothing
	local timer ydl_timer
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call YDLocal2Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal2Get(location, "选取单位点"), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), 'S003')
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "cripple", YDLocal2Get(unit, "选取单位"))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
	call YDUserDataSet(unit, YDLocal2Get(unit, "选取单位"),"造成伤害降低", real, OperatorRealAdd( YDUserDataGet(unit, YDLocal2Get(unit, "选取单位"),"造成伤害降低", real), 0.30))
	call YDLocal2Set(real, "循环实数", 0.00)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
	call YDLocalSet(ydl_timer, group, "单位组", YDLocal2Get(group, "单位组"))
	call YDLocalSet(ydl_timer, real, "循环实数", YDLocal2Get(real, "循环实数"))
	call YDLocalSet(ydl_timer, location, "点", YDLocal2Get(location, "点"))
	call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal2Get(unit, "辅助马甲"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal2Get(unit, "选取单位"))
	call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal2Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.10, true, function Trig_________________________SYFunc011Func005Func009T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.10, true," function Trig_________________________SYFunc011Func005Func009T","使用物品触发事件SY")
#endif 
	set ydl_timer = null
endfunction

function Trig_________________________SYFunc012Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "目标"), 'B00Q') == false) and (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 32.00)) then
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "目标"), 3, 1, R2I( YDLocalGet(GetExpiredTimer(), real, "增加数值")))
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

function Trig_________________________SYFunc013Func010T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B00R') == false) and (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00)) then
		call UnitRemoveAbility( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'A084')
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

function Trig_________________________SYFunc014Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶斯胸甲", boolean) == true)) then
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶斯胸甲", boolean, false)
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶斯胸甲", boolean)
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"恶斯胸甲伤害值", real)
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

function Trig_________________________SYFunc015Func005003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc015Func006Func009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 33.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
		call YDLocalSet(GetExpiredTimer(), location, "马甲点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
		call YDLocalSet(GetExpiredTimer(), location, "马甲移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "马甲点"), 12.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
		if ((IsTerrainPathableBJ( YDLocalGet(GetExpiredTimer(), location, "马甲移动点"), PATHING_TYPE_WALKABILITY) == true)) then
		else
			call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), location, "马甲移动点"))
		endif
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "马甲点"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "马甲移动点"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________SYFunc015Func006A takes nothing returns nothing
	local timer ydl_timer
	call UnitDamageTarget( GetTriggerUnit(), GetEnumUnit(), OperatorRealMultiply( I2R( GetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I07G'))), 3.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call YDLocal2Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e00D', GetUnitX( YDLocal2Get(unit, "选取单位")), GetUnitY( YDLocal2Get(unit, "选取单位")), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), YDUserDataGet(string, "眩晕2秒","技能", abilcode))
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "thunderbolt", YDLocal2Get(unit, "选取单位"))
	call RemoveLocation( YDLocal2Get(location, "点"))
	call YDLocal2Set(real, "循环实数", 0.00)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
	call YDLocalSet(ydl_timer, real, "循环实数", YDLocal2Get(real, "循环实数"))
	call YDLocalSet(ydl_timer, degree, "角度", YDLocal2Get(degree, "角度"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal2Get(unit, "选取单位"))
	call YDLocalSet(ydl_timer, location, "马甲点", YDLocal2Get(location, "马甲点"))
	call YDLocalSet(ydl_timer, location, "马甲移动点", YDLocal2Get(location, "马甲移动点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.03, true, function Trig_________________________SYFunc015Func006Func009T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.03, true," function Trig_________________________SYFunc015Func006Func009T","使用物品触发事件SY")
#endif 
	set ydl_timer = null
endfunction

function Trig_________________________SYFunc015Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"狱妖魔盾CD", boolean, false)
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"狱妖魔盾CD", boolean)
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

function Trig_________________________SYFunc016Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_DEAD) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == false) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc016Func005A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", YDLocal2Get(location, "选取单位点")))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
endfunction

function Trig_________________________SYFunc017Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetTriggerUnit())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc017Func010Func001Func002A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), location, "移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "选取单位点"), 250.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), 'BNsi') == true)) then
		call IssuePointOrderLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), "move", YDLocalGet(GetExpiredTimer(), location, "移动点"))
	else
	endif
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "移动点"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________SYFunc017Func010T takes nothing returns nothing
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
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________SYFunc017Func010Func001Func002A)
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________SYFunc018Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 999999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetTriggerUnit())) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (0 == 0))))))
endfunction

function Trig_________________________SYFunc018Func005A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(location, "选取单位点", GetUnitLoc( YDLocal2Get(unit, "选取单位")))
	call UnitDamageTarget( GetTriggerUnit(), GetEnumUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x15)), OperatorRealAdd( 1.00, YDUserDataGet(player, GetTriggerPlayer(),"暴击伤害", real))), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
	call IssueTargetOrder( GetEnumUnit(), "attack", GetTriggerUnit())
	call YDLocal2Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal2Get(location, "选取单位点"), 0))
	call UnitAddAbility( YDLocal2Get(unit, "辅助马甲"), 'A0AV')
	call IssueTargetOrder( YDLocal2Get(unit, "辅助马甲"), "slow", YDLocal2Get(unit, "选取单位"))
	call RemoveLocation( YDLocal2Get(location, "选取单位点"))
endfunction

function Trig_________________________SYFunc018Func007Func001Func002A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")))
	call YDLocalSet(GetExpiredTimer(), location, "移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "选取单位点"), OperatorRealDivide( YDWEDistanceBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 40.00), YDLocalGet(GetExpiredTimer(), degree, "角度")))
	call SetUnitPositionLocFacingBJ( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), location, "移动点"), YDLocalGet(GetExpiredTimer(), degree, "角度"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "移动点"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________SYFunc018Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 25.00)) then
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点A"))
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________SYFunc018Func007Func001Func002A)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________SYFunc019Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔法伤害", real, OperatorRealSubtract( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔法伤害", real), 0.25))
	call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE, 1.00)
	call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, 1.00)
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

function Trig_________________________SYFunc021Func001Func001Func004Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔抗", real, OperatorRealSubtract( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔抗", real), 0.10))
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

function Trig_________________________SYFunc021Func001Func001Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔法伤害", real, OperatorRealSubtract( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"),"魔法伤害", real), 0.05))
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

function Trig_________________________SYFunc021Func001Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, 20)
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

function Trig_________________________SYFunc023Func009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00) or (UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B00Q') == false))) then
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, R2I( YDLocalGet(GetExpiredTimer(), real, "增加值")))
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

function Trig_________________________SYFunc024Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")),"魔抗", real, OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")),"魔抗", real), -0.20))
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

function Trig_________________________SYActions takes nothing returns nothing
	local integer ydul_a
	local timer ydl_timer
	YDLocalInitialize()
	//↓消耗性物品↓
	if ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true)) then
		if ((GetItemTypeId( GetManipulatedItem()) == 'I09Q')) then
			//告知ai，项目里有主属性类型读取，dz函数也有，可以简化
			if ((YDUserDataGet2(unit, GetTriggerUnit(),"商人之书", boolean) == false) and (GetHeroInt( GetTriggerUnit(), false) > GetHeroStr( GetTriggerUnit(), false)) and (GetHeroInt( GetTriggerUnit(), false) > GetHeroAgi( GetTriggerUnit(), false))) then
				call YDUserDataSet2(unit, GetTriggerUnit(),"商人之书", boolean, true)
				set ydul_a = 1
				loop
					exitwhen ydul_a > 10
					call AddHeroXP( GetTriggerUnit(), 500, true)
					set ydul_a = ydul_a + 1
				endloop
				call ModifyHeroStat( bj_HEROSTAT_INT, GetTriggerUnit(), bj_MODIFYMETHOD_ADD, 10)
			else
				//此书有点深奥...看来我没法参悟。这里使用广播系统，本地玩家可见
				call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_9051", bj_TIMETYPE_ADD, 0, true)
			endif
		else
		endif
	else
	endif
	//↑消耗性物品↑
	if ((GetItemTypeId( GetManipulatedItem()) == 'I00O')) then
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl", YDLocal1Get(location, "点")))
		call RemoveLocation( YDLocal1Get(location, "点"))
		call YDLocal1Set(real, "循环实数", 0.00)
		call YDLocal1Set(real, "循环实数", OperatorRealAdd( YDLocal1Get(real, "循环实数"), 1.00))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________SYFunc005Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________SYFunc005Func006T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I01H')) then
		call UnitDamageTarget( GetTriggerUnit(), GetTriggerUnit(), 200.00, false, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
	else
	endif
	if (((GetItemTypeId( GetManipulatedItem()) == 'I01R') or (GetItemTypeId( GetManipulatedItem()) == 'I0CB'))) then
		//告知ai，项目里有攻击力加成封装，（不要用心灵之火），下面的魔法效果我们不需要了，直接用我们自己ts里定义的判断就行了
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 1000.00, YDLocal1Get(location, "点"), Condition(function Trig_________________________SYFunc007Func004003003)))
		call YDLocal1Set(integer, "数量", CountUnitsInGroup( YDLocal1Get(group, "单位组")))
		if ((YDLocal1Get(integer, "数量") >= 1)) then
			if ((GetItemTypeId( GetManipulatedItem()) == 'I0CB')) then
				call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, OperatorIntegerMultiply( 20, YDLocal1Get(integer, "数量")))
			else
				call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 1, OperatorIntegerMultiply( 5, YDLocal1Get(integer, "数量")))
				call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, OperatorIntegerMultiply( 5, YDLocal1Get(integer, "数量")))
			endif
			if ((GetItemTypeId( GetManipulatedItem()) == 'I0CB')) then
				call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, OperatorIntegerMultiply( 20, YDLocal1Get(integer, "数量")))
			else
				call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, OperatorIntegerMultiply( 5, YDLocal1Get(integer, "数量")))
			endif
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, item, "GetManipulatedItem", GetManipulatedItem())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
			call YDLocalSet(ydl_timer, integer, "数量", YDLocal1Get(integer, "数量"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.30, true, function Trig_________________________SYFunc007Func006Func003T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.30, true," function Trig_________________________SYFunc007Func006Func003T","使用物品触发事件SY")
#endif 
		else
		endif
		call DestroyGroup( YDLocal1Get(group, "单位组"))
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I043')) then
		//守卫（主动）：为周围500范围友军清除一次不利状态，若没有则恢复自身400生命值
		//告知ai，清楚不利状态走项目里的封装TS\系统\03．技能系统\00．技能模板+函数\02．通用函数\01．控制与Buff.ts，恢复生命值都doheal
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "点"), Condition(function Trig_________________________SYFunc008Func005003003)))
		if ((IsUnitGroupEmptyBJ( YDLocal1Get(group, "单位组")) == true)) then
			call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), 'e031', YDLocal1Get(location, "点"), 0))
			call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A065', 1, 108, 500.00)
			call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "holybolt", GetTriggerUnit())
		else
			call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc008Func006Func004A)
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call DestroyGroup( YDLocal1Get(group, "单位组"))
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06H')) then
		//斯尔能量：每次击杀敌人都会充能2层，达到100层时可以主动使用使自身接下来3秒内造成的所有伤害提高40%
		//告知ai，jass里没有击杀敌人充能，你需要额外添加这个语义，然后伤害提高就走项目里的yduserdata的玩家属性提升就行
		call YDLocal1Set(integer, "层数", GetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I06H')))
		if ((YDLocal1Get(integer, "层数") >= 100)) then
			call SetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I06H'), 0)
			call YDUserDataSet(unit, GetTriggerUnit(),"斯尔之心", boolean, true)
			call YDUserDataSet(player, GetTriggerPlayer(),"伤害提高", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"伤害提高", real), 0.40))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3.00, false, function Trig_________________________SYFunc009Func004Func006T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig_________________________SYFunc009Func004Func006T","使用物品触发事件SY")
#endif 
		else
			//|cffffff00系统提示：物品充能层数不足！|r
			call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 15.00, "TRIGSTR_9052")
		endif
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06I')) then
		//地狱敲钟（主动）：对周围800范围内的敌人造成持续2秒的40%减速，时间结束后造成智力×10的魔法伤害，并眩晕它们2秒
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.10), 100.00)))
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 800.00, YDLocal1Get(location, "点"), Condition(function Trig_________________________SYFunc010Func004003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc010Func005A)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, group, "单位组", YDLocal1Get(group, "单位组"))
		call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 2.00, false, function Trig_________________________SYFunc010Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 2.00, false," function Trig_________________________SYFunc010Func006T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06J')) then
		//地狱敲钟（主动）：800范围内的敌人3秒内造成的伤害降低30%，结束后造成智力×10的魔法伤害，眩晕他们1秒
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.10), 100.00)))
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 800.00, YDLocal1Get(location, "点"), Condition(function Trig_________________________SYFunc011Func004003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc011Func005A)
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06O')) then
		//地狱火攻击（主动）：使用后在5秒内增加总攻击20%的攻击力和50%攻速
		//告知ai：这里走底层的属性应用，额外添加jass原文没有的攻速
		call YDLocal1Set(real, "循环实数", 0.00)
		call YDLocal1Set(real, "增加数值", OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "目标"), ConvertUnitState(0x15)), 0.15))
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocal1Get(unit, "目标"), 3, 0, R2I( YDLocal1Get(real, "增加数值")))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, real, "增加数值", YDLocal1Get(real, "增加数值"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, unit, "目标", YDLocal1Get(unit, "目标"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.16, true, function Trig_________________________SYFunc012Func007T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.16, true," function Trig_________________________SYFunc012Func007T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06Q')) then
		//混焰（主动）：使用后在5秒内提高300%攻速，持续10次普通攻击
		//告知ai：持续最多10次普攻的逻辑，你要自动写一个
		call YDLocal1Set(location, "选取单位点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "选取单位点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A082')
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "innerfire", GetTriggerUnit())
		call RemoveLocation( YDLocal1Get(location, "选取单位点"))
		call YDLocal1Set(real, "循环实数", 0.00)
		call UnitAddAbility( GetTriggerUnit(), 'A084')
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.25, true, function Trig_________________________SYFunc013Func010T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.25, true," function Trig_________________________SYFunc013Func010T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06W')) then
		//祭血攻击|r|cffffff00（主动）：|r|cffffcc99对消耗自身20%当前生命值（至少500点），3秒内下一次造成的单次超过500的伤害提高100%，随后在3秒内对目标造成消耗生命值×150%的火焰魔法伤害
		//告知ai，这个至少500点你要自己添加
		call YDUserDataSet(unit, GetTriggerUnit(),"恶斯胸甲伤害值", real, OperatorRealMultiply( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 0.20), 0.33))
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 0.20)))
		call YDUserDataSet(unit, GetTriggerUnit(),"恶斯胸甲", boolean, true)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 3.00, false, function Trig_________________________SYFunc014Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig_________________________SYFunc014Func006T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I07G')) then
		//血魔之盾（被动/主动）：|r|cffffffcc为自身提供一个可以抵挡伤害的护盾，护盾会每2秒吸取持有者2%最大生命值为护盾充能，该效果提供的护盾的最大生命值不会超过40%自身最大生命值。可以主动使用让该护盾爆发后对周围400码敌人造成（护盾剩余生命值×300%）强化伤害后击退且眩晕2秒，但此技能会失效30秒
		//告知ai，这里使用我们的护盾系统
		call YDUserDataSet(unit, GetTriggerUnit(),"狱妖魔盾CD", boolean, true)
		call YDLocal1Set(location, "点A", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 400.00, YDLocal1Get(location, "点A"), Condition(function Trig_________________________SYFunc015Func005003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc015Func006A)
		call SetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I07G'), 1)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 30.00, false, function Trig_________________________SYFunc015Func008T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 30.00, false," function Trig_________________________SYFunc015Func008T","使用物品触发事件SY")
#endif 
		call DestroyGroup( YDLocal1Get(group, "单位组"))
		call RemoveLocation( YDLocal1Get(location, "点A"))
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I08S')) then
		//亡灵吸取（主动）：|r若附近有尸体，每个尸体为自己额外恢复15%最大生命值，在荒芜之地上使用时恢复20%最大魔法值
		//告知ai：恢复效果走doheal
		call YDLocal1Set(location, "点A", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 1000.00, YDLocal1Get(location, "点A"), Condition(function Trig_________________________SYFunc016Func004003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc016Func005A)
		call YDLocal1Set(integer, "尸体数量", CountUnitsInGroup( YDLocal1Get(group, "单位组")))
		call YDLocal1Set(real, "生命恢复值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), OperatorRealMultiply( I2R( YDLocal1Get(integer, "尸体数量")), 0.15)))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "治疗马甲","单位类型", unitcode), YDLocal1Get(location, "点A"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A080')
		call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 108, YDLocal1Get(real, "生命恢复值"))
		if ((IsPointBlighted( GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())) == true)) then
			call YDLocal1Set(real, "魔法恢复值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.20))
			call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 109, YDLocal1Get(real, "魔法恢复值"))
		else
		endif
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "rejuvination", GetTriggerUnit())
		call RemoveLocation( YDLocal1Get(location, "点A"))
		call DestroyGroup( YDLocal1Get(group, "单位组"))
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I084')) then
		//魔铃铛（主动）：|r|cffcc99ff降低周围敌人5%攻击力，使用后使得周围1000码的敌人恐惧2秒/0.5秒（普通/Boss），并且降低30%攻击力，持续5秒
		//告知ai：这里的2个buff走我们封装好的buff，攻击力降低走残废，不降低攻速移速，boss判断→是否为英雄单位
		call YDLocal1Set(location, "点A", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 800.00, YDLocal1Get(location, "点A"), Condition(function Trig_________________________SYFunc017Func004003003)))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点A"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A0AJ')
		call IssuePointOrderLoc( YDLocal1Get(unit, "辅助马甲"), "silence", YDLocal1Get(location, "点A"))
		call RemoveLocation( YDLocal1Get(location, "点A"))
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, group, "单位组", YDLocal1Get(group, "单位组"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, location, "移动点", YDLocal1Get(location, "移动点"))
		call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.40, true, function Trig_________________________SYFunc017Func010T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.40, true," function Trig_________________________SYFunc017Func010T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I07U')) then
		//横扫（被动）：近战攻击会对周围500范围内的其他敌人造成50%的扩散|n威压（主动）：使周围500范围内的敌人向自身拉拢一定距离后攻击自己，并且对他们造成（100%×暴击伤害）%攻击力的物理伤害B
		//告知ai：这里可以走我们的吸引封装，速率你可以看jass原文去推断
		call YDLocal1Set(location, "点A", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "点A"), Condition(function Trig_________________________SYFunc018Func004003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig_________________________SYFunc018Func005A)
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, group, "单位组", YDLocal1Get(group, "单位组"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, location, "点A", YDLocal1Get(location, "点A"))
		call YDLocalSet(ydl_timer, location, "移动点", YDLocal1Get(location, "移动点"))
		call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.02, true, function Trig_________________________SYFunc018Func007T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig_________________________SYFunc018Func007T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I07K')) then
		call YDUserDataSet(player, GetTriggerPlayer(),"魔法伤害", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"魔法伤害", real), 0.25))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 15.00, false, function Trig_________________________SYFunc019Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 15.00, false," function Trig_________________________SYFunc019Func002T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I07C')) then
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), OperatorRealMultiply( 1000.00, OperatorRealAdd( 1.00, YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"魔法伤害", real)))))
	else
	endif
	if (((GetItemTypeId( GetManipulatedItem()) == 'I09J') or (GetItemTypeId( GetManipulatedItem()) == 'I09I') or (GetItemTypeId( GetManipulatedItem()) == 'I09K'))) then
		if ((GetItemTypeId( GetManipulatedItem()) == 'I09J')) then
			call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, 20)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 10.00, false, function Trig_________________________SYFunc021Func001Func003T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig_________________________SYFunc021Func001Func003T","使用物品触发事件SY")
#endif 
		else
			if ((GetItemTypeId( GetManipulatedItem()) == 'I09I')) then
				call YDUserDataSet(player, GetTriggerPlayer(),"魔法伤害", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"魔法伤害", real), 0.05))
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 10.00, false, function Trig_________________________SYFunc021Func001Func001Func002T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig_________________________SYFunc021Func001Func001Func002T","使用物品触发事件SY")
#endif 
			else
				if ((GetItemTypeId( GetManipulatedItem()) == 'I09K')) then
					call YDUserDataSet(player, GetTriggerPlayer(),"魔抗", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"魔抗", real), 0.10))
					set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
					call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
					call TimerStart(ydl_timer, 10.00, false, function Trig_________________________SYFunc021Func001Func001Func004Func002T)
#ifdef StarDebuggerIncluded 
					call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig_________________________SYFunc021Func001Func001Func004Func002T","使用物品触发事件SY")
#endif 
				else
				endif
			endif
		endif
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I07E')) then
		call UnitDamageTarget( GetTriggerUnit(), GetTriggerUnit(), 2000.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06O')) then
		//地狱火攻击（主动）：使用后在5秒内增加总攻击20%的攻击力和50%攻速
		//告知ai：恢复效果走攻击力提升的封装（不要用心灵之火）
		call YDLocal1Set(unit, "魔法效果马甲", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e02N', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0))
		call UnitAddAbility( YDLocal1Get(unit, "魔法效果马甲"), 'A081')
		call IssueTargetOrder( YDLocal1Get(unit, "魔法效果马甲"), "bloodlust", GetTriggerUnit())
		call YDLocal1Set(real, "循环实数", 0.00)
		call YDLocal1Set(real, "增加值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x15)), 0.20))
		call YDWEGeneralBounsSystemUnitSetBonus( GetTriggerUnit(), 3, 0, R2I( YDLocal1Get(real, "增加值")))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "增加值", YDLocal1Get(real, "增加值"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.25, true, function Trig_________________________SYFunc023Func009T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.25, true," function Trig_________________________SYFunc023Func009T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I01B')) then
		call YDUserDataSet(player, GetOwningPlayer( GetTriggerUnit()),"魔抗", real, OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"魔抗", real), 0.20))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 10.00, false, function Trig_________________________SYFunc024Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 10.00, false," function Trig_________________________SYFunc024Func002T","使用物品触发事件SY")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'azhr')) then
		//告知ai：这里优化，改成物品使用的上下文，然后召唤物走我们的封装
		call YDLocal1Set(real, "X", GetUnitX( GetTriggerUnit()))
		call YDLocal1Set(real, "Y", GetUnitY( GetTriggerUnit()))
		call YDLocal1Set(real, "X2", DzGetMouseTerrainX())
		call YDLocal1Set(real, "Y2", DzGetMouseTerrainY())
		call YDLocal1Set(real, "JD", X_GAFC( YDLocal1Get(real, "X"), YDLocal1Get(real, "Y"), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
		//不能超过800距离
		if ((X_GDBC( YDLocal1Get(real, "X"), YDLocal1Get(real, "Y"), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")) >= 800.00)) then
			call YDLocal1Set(unit, "火把", CreateUnit( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "技能马甲","单位类型2", unitcode), OperatorRealAdd( YDLocal1Get(real, "X"), OperatorRealMultiply( 800.00, CosBJ( YDWER2Deg( YDLocal1Get(real, "JD"))))), OperatorRealAdd( YDLocal1Get(real, "Y"), OperatorRealMultiply( 800.00, CosBJ( YDWER2Deg( YDLocal1Get(real, "JD"))))), 0))
		else
			call YDLocal1Set(unit, "火把", CreateUnit( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "技能马甲","单位类型2", unitcode), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"), 0))
		endif
		call SetUnitScale( YDLocal1Get(unit, "火把"), 1.00, 1.00, 1.00)
		call UnitApplyTimedLife( YDLocal1Get(unit, "火把"), 'BHwe', 10.00)
		call DzSetUnitModel( YDLocal1Get(unit, "火把"), "war3mapImported\\Wall Torch.mdl")
		call SetUnitInvulnerable( YDLocal1Get(unit, "火把"), true)
		call SetUnitFacing( GetTriggerUnit(), YDWER2Deg( YDLocal1Get(real, "JD")))
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_________________________SY takes nothing returns nothing
	set gg_trg_________________________SY = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_________________________SY,"使用物品触发事件SY")
#endif
	call SU_AddItemAbilityEvent(gg_trg_________________________SY)
	call TriggerAddCondition(gg_trg_________________________SY, Condition(function Trig_________________________SYConditions))
	call TriggerAddAction(gg_trg_________________________SY, function Trig_________________________SYActions)
endfunction

