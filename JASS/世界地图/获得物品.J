//===========================================================================
// Trigger: 获得物品触发事件HD
//===========================================================================
function Trig_________________________HDConditions takes nothing returns boolean
	return ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true))
endfunction

function Trig_________________________HDFunc005Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((UnitHasItemOfTypeBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), itemcode, "WPLX")) == false) or (YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"邪恶之心持有", boolean) == false))) then
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"邪恶之心持有", boolean)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "伤害", OperatorRealAdd( 10.00, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.01)))
		call SetUnitLifeBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE), YDLocalGet(GetExpiredTimer(), real, "伤害")))
		if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true) and ((GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE) < 1400.00) or (GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE) < 300.00))) then
			call KillUnit( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
			call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"邪恶之心持有", boolean, false)
			call DisplayTimedTextToPlayer( YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"), 0, 0, 20.00, "TRIGSTR_232")
		else
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________HDFunc007Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((UnitHasItemOfTypeBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), itemcode, "WPLX")) == false) or (YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"祭祀面具持有", boolean) == false))) then
		call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"祭祀面具持有", boolean)
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "伤害", OperatorRealAdd( 10.00, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_MANA), 0.01)))
		call SetUnitManaBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA), YDLocalGet(GetExpiredTimer(), real, "伤害")))
		if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true) and ((GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_MANA) < 1250.00) or (GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA) < 250.00))) then
			call KillUnit( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
			call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"祭祀面具持有", boolean, false)
			call DisplayTimedTextToPlayer( YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer"), 0, 0, 20.00, "TRIGSTR_233")
		else
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________HDFunc010Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItem( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), item, "获取的豺狼皮甲")) == true)) then
		if ((GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE) >= OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.70))) then
			call YDWETimerDestroyEffect( 0.90, AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), "overhead"))
			if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean) == false)) then
				call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real), 20.00))
				call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean, true)
			else
			endif
		else
			if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean) == true) and (GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE) < OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.70))) then
				call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real), -20.00))
				call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean, false)
			else
			endif
		endif
	else
		if (((GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE) >= OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.70)) or (YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean) == true))) then
			call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"生命恢复", real), -20.00))
			call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean, false)
			call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"豺狼皮甲生命获取", boolean)
		else
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

function Trig_________________________HDFunc011Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real) >= 0.50)) then
		call YDLocalSet(GetExpiredTimer(), real, "攻击值", YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real))
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 1, R2I( YDLocalGet(GetExpiredTimer(), real, "攻击值")))
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real, 0.00)
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ConvertUnitState(0x20)), 0.80)))
		call YDLocalSet(GetExpiredTimer(), real, "攻击值2", YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real))
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 0, R2I( YDLocalGet(GetExpiredTimer(), real, "攻击值2")))
	else
		call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ConvertUnitState(0x20)), 0.80)))
		call YDLocalSet(GetExpiredTimer(), real, "攻击值", YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"守护之盾攻击", real))
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3, 0, R2I( YDLocalGet(GetExpiredTimer(), real, "攻击值")))
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

function Trig_________________________HDFunc012Func004Func001Func001Func003003003 takes nothing returns boolean
	return ((IsUnitAlly( GetFilterUnit(), YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer")) == true) and (10 >= 10))
endfunction

function Trig_________________________HDFunc012Func004Func001Func001Func004A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 'e031', YDLocalGet(GetExpiredTimer(), location, "选取单位点"), 0))
	call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A06Q', 1, 108, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), UNIT_STATE_MAX_LIFE), 0.01))
	call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "heal", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________HDFunc012Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItemOfTypeBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'I052') == true)) then
		if ((GetTimeOfDay() >= 6.00) and (GetTimeOfDay() <= 18.00)) then
			call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_MANA), 0.01)))
			call YDLocalSet(GetExpiredTimer(), location, "点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")))
			call YDLocalSet(GetExpiredTimer(), group, "单位组", GetUnitsInRangeOfLocMatching( 700.00, YDLocalGet(GetExpiredTimer(), location, "点"), Condition(function Trig_________________________HDFunc012Func004Func001Func001Func003003003)))
			call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________HDFunc012Func004Func001Func001Func004A)
			call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
			call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
		else
		endif
	else
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

function Trig_________________________HDFunc013Func005Func002Func001Func001Func001Func003003003 takes nothing returns boolean
	return ((IsUnitEnemy( GetFilterUnit(), YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer")) == true) and (10 >= 10))
endfunction

function Trig_________________________HDFunc013Func005Func002Func001Func001Func001Func004A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), location, "选取单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealAdd( 120.00, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.01)), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
	call YDLocalSet(GetExpiredTimer(), effect, "灼烧特效", AddSpecialEffectLoc( "Abilities\\Spells\\Items\\AIfb\\AIfbSpecialArt.mdl", YDLocalGet(GetExpiredTimer(), location, "选取单位点")))
	call YDWETimerDestroyEffect( 1.00, YDLocalGet(GetExpiredTimer(), effect, "灼烧特效"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "选取单位点"))
endfunction

function Trig_________________________HDFunc013Func005Func002Func001T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItem( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), item, "拥有的熔岩宝石")) == true)) then
		if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")) == true)) then
			call YDLocalSet(GetExpiredTimer(), location, "点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")))
			call YDLocalSet(GetExpiredTimer(), group, "单位组", GetUnitsInRangeOfLocMatching( 400.00, YDLocalGet(GetExpiredTimer(), location, "点"), Condition(function Trig_________________________HDFunc013Func005Func002Func001Func001Func001Func003003003)))
			call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "单位组"),function Trig_________________________HDFunc013Func005Func002Func001Func001Func001Func004A)
			call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
			call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "单位组"))
		else
		endif
	else
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

function Trig_________________________HDFunc014Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItem( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), item, "亡之魔杯")) == false)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "数值", OperatorRealMultiply( OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_MANA), GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA)), 0.03))
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA), YDLocalGet(GetExpiredTimer(), real, "数值")))
		call YDWETimerDestroyEffect( 0.80, AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), "overhead"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________HDFunc015Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItem( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), item, "熔墓守卫护符")) == false)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		if ((IsPointBlighted( GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))) == true)) then
			call YDLocalSet(GetExpiredTimer(), location, "点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")))
			call YDLocalSet(GetExpiredTimer(), real, "生命恢复值", OperatorRealAdd( OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_LIFE), 0.01), 0.00))
			call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), YDUserDataGet(string, "治疗马甲","单位类型", unitcode), YDLocalGet(GetExpiredTimer(), location, "点"), 0))
			call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A06Q')
			call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A06Q', 1, 108, YDLocalGet(GetExpiredTimer(), real, "生命恢复值"))
			call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "heal", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
			call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
		else
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________HDFunc016Func004Func004003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig_________________________HDFunc016Func004Func005Func002Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), YDLocalGet(GetExpiredTimer(), real, "消耗值"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_________________________HDFunc016Func004Func005Func002Func003Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "选取单位")) == true)) then
		call YDLocalSet(GetExpiredTimer(), unit, "狱生面具恢复单位", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
		call YDLocalSet(GetExpiredTimer(), real, "HP恢复值", OperatorRealMultiply( OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "狱生面具恢复单位"), UNIT_STATE_MAX_LIFE), GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "狱生面具恢复单位"), UNIT_STATE_LIFE)), 0.30))
		call YDLocalSet(GetExpiredTimer(), real, "MP恢复值", OperatorRealMultiply( OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "狱生面具恢复单位"), UNIT_STATE_MAX_MANA), GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "狱生面具恢复单位"), UNIT_STATE_MANA)), 0.30))
		call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 'e031', GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 0))
		call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A080')
		call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A080', 1, 108, YDLocalGet(GetExpiredTimer(), real, "HP恢复值"))
		call YDWESetUnitAbilityDataReal( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A080', 1, 109, YDLocalGet(GetExpiredTimer(), real, "MP恢复值"))
		call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "rejuvination", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
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

function Trig_________________________HDFunc016Func004Func005Func002Func003A takes nothing returns nothing
	local timer ydl_timer
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "消耗值"), 2.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
	call YDLocalSet(ydl_timer, real, "HP恢复值", YDLocalGet(GetExpiredTimer(), real, "HP恢复值"))
	call YDLocalSet(ydl_timer, real, "MP恢复值", YDLocalGet(GetExpiredTimer(), real, "MP恢复值"))
	call YDLocalSet(ydl_timer, unit, "狱生面具恢复单位", YDLocalGet(GetExpiredTimer(), unit, "狱生面具恢复单位"))
	call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 2.00, false, function Trig_________________________HDFunc016Func004Func005Func002Func003Func003T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 2.00, false," function Trig_________________________HDFunc016Func004Func005Func002Func003Func003T","获得物品触发事件HD")
#endif 
	set ydl_timer = null
endfunction

function Trig_________________________HDFunc016Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), real, "消耗值", OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MAX_MANA), 0.01))
	call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_MANA), YDLocalGet(GetExpiredTimer(), real, "消耗值")))
	call YDLocalSet(GetExpiredTimer(), location, "ysmj点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")))
	call YDLocalSet(GetExpiredTimer(), group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 600.00, YDLocalGet(GetExpiredTimer(), location, "ysmj点"), Condition(function Trig_________________________HDFunc016Func004Func004003003)))
	if ((UnitHasItem( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), item, "狱生面具")) == true)) then
		if ((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "狱生面具")) == 'I078')) then
			call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig_________________________HDFunc016Func004Func005Func002Func003A)
		else
			call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig_________________________HDFunc016Func004Func005Func002Func001A)
			call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), UNIT_STATE_LIFE), YDLocalGet(GetExpiredTimer(), real, "消耗值")))
		endif
	else
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	endif
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "ysmj点"))
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_________________________HDActions takes nothing returns nothing
	local timer ydl_timer
	local integer ydul_a
	YDLocalInitialize()
	//告知ai：使用监听判断物品是否在单位身上的函数，而且这些物品的逻辑都很像，可以抽成一个或者几个通用函数
	//告知ai：注意前置条件，只对英雄触发
	//邪恶之心：每秒损失1%+10生命值（不致死），若携带此物品的单位最大生命值/当前生命值低于1400/300时会直接死亡|r
	if ((GetItemTypeId( GetManipulatedItem()) == 'I01I')) then
		call YDLocal1Set(itemcode, "WPLX", GetItemTypeId( GetManipulatedItem()))
		call YDUserDataSet(unit, GetTriggerUnit(),"邪恶之心持有", boolean, true)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, itemcode, "WPLX", YDLocal1Get(itemcode, "WPLX"))
		call YDLocalSet(ydl_timer, real, "伤害", YDLocal1Get(real, "伤害"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc005Func003T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc005Func003T","获得物品触发事件HD")
#endif 
	else
	endif
	//|cFFFFFFCC邪恶面具：|r|cFFCC99FF每秒损失1%+10魔法值，若最大魔法值/当前魔法值低于1250/150时，佩戴者会直接死亡
	if ((GetItemTypeId( GetManipulatedItem()) == 'I01J')) then
		call YDLocal1Set(itemcode, "WPLX", GetItemTypeId( GetManipulatedItem()))
		call YDUserDataSet(unit, GetTriggerUnit(),"祭祀面具持有", boolean, true)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, itemcode, "WPLX", YDLocal1Get(itemcode, "WPLX"))
		call YDLocalSet(ydl_timer, real, "伤害", YDLocal1Get(real, "伤害"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc007Func003T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc007Func003T","获得物品触发事件HD")
#endif 
	else
	endif
	//物品里已经有史莱姆粘液瓶了，需要额外加这个功能
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I00J') == true) and (GetItemTypeId( GetManipulatedItem()) == 'I00B')) then
		call SetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I00J'), OperatorIntegerAdd( GetItemCharges( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), 'I00J')), 15))
		call RemoveItem( GetManipulatedItem())
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I01U')) then
		//良性皮甲：生命值高于70%时会获得20生命恢复速度，低于70%时候额外获得10%伤害减少%
		//告知ai：直接根据状态，给玩家添加20点生命恢复/10%伤害减少%，看伤害修正，有这个属性，直接给玩家添加减少
		call YDLocal1Set(item, "获取的豺狼皮甲", GetManipulatedItem())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, item, "获取的豺狼皮甲", YDLocal1Get(item, "获取的豺狼皮甲"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc010Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc010Func004T","获得物品触发事件HD")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I048')) then
		//守护之盾：周围800范围的友军受到的10%伤害转移到自身|n（转移的伤害直接扣除自身生命值）|n|r|cffff6800防转攻：增加自身护甲80%的攻击力
		//告知ai：这里没有转移的功能，需要你自己添加
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "攻击值", YDLocal1Get(real, "攻击值"))
		call YDLocalSet(ydl_timer, real, "攻击值2", YDLocal1Get(real, "攻击值2"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.01, false, function Trig_________________________HDFunc011Func003T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.01, false," function Trig_________________________HDFunc011Func003T","获得物品触发事件HD")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I052')) then
		//黑暗之光：|r|cffffcc99每秒固定减少1%最大魔法值，白天每秒恢复周围700范围友军最大生命值1%，夜晚自身受到的伤害减少20%|
		//告知ai：TS\系统\03．技能系统\00．技能模板+函数\02．通用函数\01．便捷短函数集合\05．昼夜状态.ts    这里有便捷白天黑天获取函数
		//告知ai：走doheal/根据白天黑天状态，提升/减少伤害减少%属性就行
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, group, "单位组", YDLocal1Get(group, "单位组"))
		call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc012Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc012Func004T","获得物品触发事件HD")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I05W')) then
		//对周围400码的敌人每秒造成120+自身最大生命值1%的火焰魔法伤害
		call YDLocal1Set(item, "拥有的熔岩宝石", GetManipulatedItem())
		call YDLocal1Set(integer, "循环整数", 0)
		call YDLocal1Set(integer, "数量", 0)
		set ydul_a = 1
		loop
			exitwhen ydul_a > 6
			call YDLocal1Set(item, "物品", UnitItemInSlotBJ( GetTriggerUnit(), ydul_a))
			if ((YDLocal1Get(item, "物品") == YDLocal1Get(item, "拥有的熔岩宝石"))) then
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
				call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
				call YDLocalSet(ydl_timer, group, "单位组", YDLocal1Get(group, "单位组"))
				call YDLocalSet(ydl_timer, item, "拥有的熔岩宝石", YDLocal1Get(item, "拥有的熔岩宝石"))
				call YDLocalSet(ydl_timer, effect, "灼烧特效", YDLocal1Get(effect, "灼烧特效"))
				call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
				call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
				call YDLocalSet(ydl_timer, location, "选取单位点", YDLocal1Get(location, "选取单位点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc013Func005Func002Func001T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc013Func005Func002Func001T","获得物品触发事件HD")
#endif 
			else
				if ((GetItemTypeId( YDLocal1Get(item, "物品")) == 'I05W')) then
					call UnitRemoveItemSwapped( GetManipulatedItem(), GetTriggerUnit())
					call QuestMessageBJ( GetPlayersByMapControl( GetPlayerController( GetOwningPlayer( GetTriggerUnit()))), bj_QUESTMESSAGE_HINT, "TRIGSTR_234")
				else
				endif
			endif
			set ydul_a = ydul_a + 1
		endloop
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I098')) then
		//魔力流淌（被动）：每秒恢复3%已损失魔法值（多个物品不叠加）
		//告知ai：注意，这里一个单位有多个次物品是不叠加的
		call YDLocal1Set(item, "亡之魔杯", GetManipulatedItem())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, item, "亡之魔杯", YDLocal1Get(item, "亡之魔杯"))
		call YDLocalSet(ydl_timer, real, "数值", YDLocal1Get(real, "数值"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc014Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc014Func004T","获得物品触发事件HD")
#endif 
	else
	endif
	if ((GetItemTypeId( GetManipulatedItem()) == 'I08W')) then
		//告知ai：使用监听判断物品是否在单位身上的函数，而且这些物品的逻辑都很像，可以抽成一个或者几个通用函数
		call YDLocal1Set(item, "熔墓守卫护符", GetManipulatedItem())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
		call YDLocalSet(ydl_timer, item, "熔墓守卫护符", YDLocal1Get(item, "熔墓守卫护符"))
		call YDLocalSet(ydl_timer, real, "生命恢复值", YDLocal1Get(real, "生命恢复值"))
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc015Func003T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc015Func003T","获得物品触发事件HD")
#endif 
	else
	endif
	if (((GetItemTypeId( GetManipulatedItem()) == 'I077') or (GetItemTypeId( GetManipulatedItem()) == 'I078'))) then
		//狱生（被动）：每秒消耗1%最大魔法值对附近600码的敌人造成消耗魔法100%比例的暗属性魔法伤害，并且恢复消耗魔法等额生命值（魔法值不足时不会失效）
		//告知ai：走doheal
		call YDLocal1Set(item, "狱生面具", GetManipulatedItem())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "HP恢复值", YDLocal1Get(real, "HP恢复值"))
		call YDLocalSet(ydl_timer, real, "MP恢复值", YDLocal1Get(real, "MP恢复值"))
		call YDLocalSet(ydl_timer, location, "ysmj点", YDLocal1Get(location, "ysmj点"))
		call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
		call YDLocalSet(ydl_timer, real, "消耗值", YDLocal1Get(real, "消耗值"))
		call YDLocalSet(ydl_timer, item, "狱生面具", YDLocal1Get(item, "狱生面具"))
		call YDLocalSet(ydl_timer, unit, "狱生面具恢复单位", YDLocal1Get(unit, "狱生面具恢复单位"))
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig_________________________HDFunc016Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig_________________________HDFunc016Func004T","获得物品触发事件HD")
#endif 
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_________________________HD takes nothing returns nothing
	set gg_trg_________________________HD = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_________________________HD,"获得物品触发事件HD")
#endif
	call TriggerRegisterAnyUnitEventBJ(gg_trg_________________________HD, EVENT_PLAYER_UNIT_PICKUP_ITEM)
	call TriggerAddCondition(gg_trg_________________________HD, Condition(function Trig_________________________HDConditions))
	call TriggerAddAction(gg_trg_________________________HD, function Trig_________________________HDActions)
endfunction

