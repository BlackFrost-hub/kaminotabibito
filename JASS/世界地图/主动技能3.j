//===========================================================================
// Trigger: 指定技能类物品ZDJN
//===========================================================================
function Trig______________________ZDJNFunc001Func006003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetEnumUnit()) <= 99999.00) and ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (IsUnitInGroup( GetFilterUnit(), YDLocal2Get(group, "重复单位组")) == false))))))
endfunction

function Trig______________________ZDJNFunc001Func007A takes nothing returns nothing
	call UnitDamageTarget( GetTriggerUnit(), GetEnumUnit(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x15)), 2.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig______________________ZDJNFunc006Func015T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标单位"),"命中率", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标单位"),"命中率", real), 1.00))
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

function Trig______________________ZDJNFunc008Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 30.00)) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call EXSetEffectSize( YDLocalGet(GetExpiredTimer(), effect, "特效光"), OperatorRealMultiply( 1.00, OperatorRealAdd( 0.20, YDLocalGet(GetExpiredTimer(), real, "循环实数"))))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________ZDJNFunc008Func005003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig______________________ZDJNFunc008Func006A takes nothing returns nothing
	call YDUserDataSet(unit, GetEnumUnit(),"命中率", real, OperatorRealAdd( YDUserDataGet(unit, YDLocal2Get(unit, "目标单位"),"命中率", real), -1.00))
endfunction

function Trig______________________ZDJNFunc008Func007Func001A takes nothing returns nothing
	call YDUserDataSet(unit, GetEnumUnit(),"命中率", real, OperatorRealAdd( YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "目标单位"),"命中率", real), 1.00))
endfunction

function Trig______________________ZDJNFunc008Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig______________________ZDJNFunc008Func007Func001A)
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
	call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
	call DestroyEffect( YDLocalGet(GetExpiredTimer(), effect, "特效光"))
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

function Trig______________________ZDJNFunc009Func006003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig______________________ZDJNFunc009Func007A takes nothing returns nothing
	call UnitDamageTarget( GetTriggerUnit(), GetEnumUnit(), GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MAX_LIFE), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig______________________ZDJNFunc010Func002Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataClear(unit, YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"),"使者精神魔杖", unitcode)
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

function Trig______________________ZDJNFunc012Func008Func001Func010003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), YDLocalGet(GetExpiredTimer(), player, "GetTriggerPlayer")) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (IsUnitInGroup( GetFilterUnit(), YDLocalGet(GetExpiredTimer(), group, "重复单位组")) == false))))))
endfunction

function Trig______________________ZDJNFunc012Func008Func001Func011A takes nothing returns nothing
	call GroupAddUnit( YDLocalGet(GetExpiredTimer(), group, "重复单位组"), GetEnumUnit())
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ConvertUnitState(0x15)), 3.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
	call YDLocalSet(GetExpiredTimer(), location, "点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocalGet(GetExpiredTimer(), location, "点"), 0))
	call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A04L')
	call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "thunderbolt", GetEnumUnit())
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "点"))
endfunction

function Trig______________________ZDJNFunc012Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 33.33)) then
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "重复单位组"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDLocalSet(GetExpiredTimer(), location, "马甲点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲")))
		call YDLocalSet(GetExpiredTimer(), location, "马甲移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "马甲点"), 33.33, GetUnitFacing( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"))))
		call YDLocalSet(GetExpiredTimer(), unit, "特效马甲", CreateUnitAtLoc( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 'e03S', YDLocalGet(GetExpiredTimer(), location, "马甲点"), YDLocalGet(GetExpiredTimer(), degree, "角度")))
		call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), YDLocalGet(GetExpiredTimer(), location, "马甲移动点"))
		call YDLocalSet(GetExpiredTimer(), group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 333.00, YDLocalGet(GetExpiredTimer(), location, "马甲点"), Condition(function Trig______________________ZDJNFunc012Func008Func001Func010003003)))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"),function Trig______________________ZDJNFunc012Func008Func001Func011A)
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "判断碰撞单位组"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "马甲点"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "马甲移动点"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________ZDJNFunc014Func007T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "目标"), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "目标"), UNIT_STATE_MAX_LIFE), 0.03), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
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

function Trig______________________ZDJNFunc015Func005T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 5.00)) then
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocalGet(GetExpiredTimer(), unit, "目标"), 3, 1, YDLocalGet(GetExpiredTimer(), integer, "攻击力"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "目标")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "目标"))))
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "目标"), 250.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________ZDJNActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetSpellAbilityId() == 'A0F0')) then
		call YDLocal1Set(location, "马甲点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "目标点", GetSpellTargetLoc())
		call YDLocal1Set(degree, "角度", AngleBetweenPoints( YDLocal1Get(location, "马甲点"), YDLocal1Get(location, "目标点")))
		call YDLocal1Set(unit, "特效A", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e073', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), YDLocal1Get(degree, "角度")))
		call YDLocal1Set(unit, "特效B", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e073', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), OperatorDegreeAdd( YDLocal1Get(degree, "角度"), 180.00)))
		call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 350.00, YDLocal1Get(location, "马甲点"), Condition(function Trig______________________ZDJNFunc001Func006003003)))
		call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig______________________ZDJNFunc001Func007A)
		call RemoveLocation( YDLocal1Get(location, "马甲点"))
		call RemoveLocation( YDLocal1Get(location, "目标点"))
		call DestroyGroup( YDLocal1Get(group, "判断碰撞单位组"))
	else
	endif
	if ((GetSpellAbilityId() == 'A03I')) then
		call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( GetTriggerUnit()), 'e00D', GetUnitX( GetSpellTargetUnit()), GetUnitY( GetSpellTargetUnit()), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A0AV')
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "slow", GetSpellTargetUnit())
	else
	endif
	if ((IsDestructableInvulnerableBJ( GetSpellTargetDestructable()) == false) and (GetSpellAbilityId() == 'A0EO')) then
		call YDLocal1Set(destructable, "大门", GetSpellTargetDestructable())
		call ModifyGateBJ( bj_GATEOPERATION_OPEN, YDLocal1Get(destructable, "大门"))
		call SetDestructableInvulnerable( YDLocal1Get(destructable, "大门"), true)
	else
	endif
	if ((GetSpellAbilityId() == 'A03G')) then
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), 200.00))
	else
	endif
	if ((GetSpellAbilityId() == 'A09G')) then
		call YDLocal1Set(unit, "目标单位", GetSpellTargetUnit())
		if ((OperatorRealMultiply( GetUnitState( YDLocal1Get(unit, "目标单位"), UNIT_STATE_MAX_LIFE), 0.10) >= GetUnitState( YDLocal1Get(unit, "目标单位"), UNIT_STATE_LIFE))) then
			call KillUnit( YDLocal1Get(unit, "目标单位"))
			call YDLocal1Set(effect, "幽冥法杖特效", AddSpecialEffectTarget( "war3mapImported\\blood2022720203813.mdx", YDLocal1Get(unit, "目标单位"), "overhead"))
			call EXSetEffectSize( YDLocal1Get(effect, "幽冥法杖特效"), YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocal1Get(unit, "目标单位")), "modelScale"))
			call YDWETimerDestroyEffect( 2.00, YDLocal1Get(effect, "幽冥法杖特效"))
		else
		endif
	else
	endif
	if ((GetSpellAbilityId() == 'A0AE')) then
		call YDLocal1Set(unit, "目标单位", GetSpellTargetUnit())
		call YDLocal1Set(location, "单位点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "目标点", GetUnitLoc( YDLocal1Get(unit, "目标单位")))
		call AddLightningLoc( "MBUR", YDLocal1Get(location, "单位点"), YDLocal1Get(location, "目标点"))
		call YDWETimerDestroyLightning( 1.00, GetLastCreatedLightningBJ())
		call AddLightningLoc( "AFOD", YDLocal1Get(location, "单位点"), YDLocal1Get(location, "目标点"))
		call YDWETimerDestroyLightning( 1.00, GetLastCreatedLightningBJ())
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.30)))
		call YDLocal1Set(effect, "特效", AddSpecialEffectTarget( "war3mapImported\\[AKE]war3AKE.com - 2477249006985228464610934.mdx", YDLocal1Get(unit, "目标单位"), "overhead"))
		call YDWETimerDestroyEffect( 2.50, YDLocal1Get(effect, "特效"))
		call YDUserDataSet(unit, YDLocal1Get(unit, "目标单位"),"命中率", real, OperatorRealAdd( YDUserDataGet(unit, YDLocal1Get(unit, "目标单位"),"命中率", real), -1.00))
		call UnitDamageTarget( GetTriggerUnit(), YDLocal1Get(unit, "目标单位"), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 2.00), false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
		call RemoveLocation( YDLocal1Get(location, "单位点"))
		call RemoveLocation( YDLocal1Get(location, "目标点"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "目标单位", YDLocal1Get(unit, "目标单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, false, function Trig______________________ZDJNFunc006Func015T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig______________________ZDJNFunc006Func015T","指定技能类物品ZDJN")
#endif 
	else
	endif
	if ((GetSpellAbilityId() == 'A0AG')) then
		call YDLocal1Set(real, "转移值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), 0.20))
		call SetUnitState( GetSpellTargetUnit(), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MANA), YDLocal1Get(real, "转移值")))
		call YDWETimerDestroyEffect( 2.00, AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Drain\\ManaDrainCaster.mdl", GetSpellTargetUnit(), "origin"))
		call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), YDLocal1Get(real, "转移值")))
	else
	endif
	if ((GetSpellAbilityId() == 'A0AN')) then
		call YDLocal1Set(effect, "特效光", AddSpecialEffectTarget( "Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl", GetSpellTargetUnit(), "overhead"))
		call YDLocal1Set(location, "目标点", GetUnitLoc( GetSpellTargetUnit()))
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, effect, "特效光", YDLocal1Get(effect, "特效光"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.02, true, function Trig______________________ZDJNFunc008Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig______________________ZDJNFunc008Func004T","指定技能类物品ZDJN")
#endif 
		call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "目标点"), Condition(function Trig______________________ZDJNFunc008Func005003003)))
		call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig______________________ZDJNFunc008Func006A)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
		call YDLocalSet(ydl_timer, effect, "特效光", YDLocal1Get(effect, "特效光"))
		call YDLocalSet(ydl_timer, unit, "目标单位", YDLocal1Get(unit, "目标单位"))
		call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, false, function Trig______________________ZDJNFunc008Func007T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig______________________ZDJNFunc008Func007T","指定技能类物品ZDJN")
#endif 
	else
	endif
	if ((IsUnitRace( GetSpellTargetUnit(), RACE_DEMON) == false) and (IsHeroUnitId( GetUnitTypeId( GetSpellTargetUnit())) == false) and (((GetSpellAbilityId() == 'A0AP') and (GetUnitLevel( GetSpellTargetUnit()) <= 30)) or ((GetSpellAbilityId() == 'A0AQ') and (GetUnitLevel( GetSpellTargetUnit()) <= 35)))) then
		if ((GetSpellAbilityId() == 'A0AQ')) then
			call YDLocal1Set(real, "生命恢复值", OperatorRealMultiply( GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MAX_LIFE), 1.00))
			call YDLocal1Set(real, "魔法恢复值", OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), 0.35))
		else
			call YDLocal1Set(real, "生命恢复值", OperatorRealMultiply( GetUnitState( GetSpellTargetUnit(), UNIT_STATE_MAX_LIFE), 0.50))
			call YDLocal1Set(real, "魔法恢复值", 0.00)
		endif
		call YDLocal1Set(location, "目标点", GetUnitLoc( GetSpellTargetUnit()))
		call YDLocal1Set(effect, "血特效", AddSpecialEffectTarget( "war3mapImported\\CorpseBomb.mdx", GetSpellTargetUnit(), "overhead"))
		call EXSetEffectSize( YDLocal1Get(effect, "血特效"), YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( GetSpellTargetUnit()), "modelScale"))
		call YDWETimerDestroyEffect( 2, YDLocal1Get(effect, "血特效"))
		call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 400.00, YDLocal1Get(location, "目标点"), Condition(function Trig______________________ZDJNFunc009Func006003003)))
		call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig______________________ZDJNFunc009Func007A)
		call KillUnit( GetSpellTargetUnit())
		call DestroyGroup( YDLocal1Get(group, "判断碰撞单位组"))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "治疗马甲","单位类型", unitcode), YDLocal1Get(location, "目标点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A080')
		call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 108, YDLocal1Get(real, "生命恢复值"))
		call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A080', 1, 109, YDLocal1Get(real, "魔法恢复值"))
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "rejuvination", GetTriggerUnit())
		call RemoveLocation( YDLocal1Get(location, "目标点"))
	else
	endif
	if ((IsUnitRace( GetSpellTargetUnit(), RACE_DEMON) == false) and (IsHeroUnitId( GetUnitTypeId( GetSpellTargetUnit())) == false) and (GetSpellAbilityId() == 'A0AR') and (YDUserDataHas(unit, GetTriggerUnit(),"使者精神魔杖", unitcode) == false)) then
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		if ((YDLocal1Get(unit, "目标") == null)) then
		else
			call KillUnit( YDLocal1Get(unit, "目标"))
			call YDUserDataSet(unit, GetTriggerUnit(),"使者精神魔杖", unitcode, GetUnitTypeId( YDLocal1Get(unit, "目标")))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3600.00, false, function Trig______________________ZDJNFunc010Func002Func003T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3600.00, false," function Trig______________________ZDJNFunc010Func002Func003T","指定技能类物品ZDJN")
#endif 
		endif
	else
	endif
	if ((IsUnitRace( GetSpellTargetUnit(), RACE_DEMON) == false) and (IsHeroUnitId( GetUnitTypeId( GetSpellTargetUnit())) == false) and (GetSpellAbilityId() == 'A0AR') and (YDUserDataHas(unit, GetTriggerUnit(),"使者精神魔杖", unitcode) == true)) then
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		if ((YDLocal1Get(unit, "目标") == null)) then
			call YDLocal1Set(location, "出现点", GetSpellTargetLoc())
		else
			call YDLocal1Set(location, "出现点", GetUnitLoc( YDLocal1Get(unit, "目标")))
		endif
		call CreateNUnitsAtLoc( 1, YDUserDataGet(unit, GetTriggerUnit(),"使者精神魔杖", unitcode), GetOwningPlayer( GetTriggerUnit()), YDLocal1Get(location, "出现点"), GetUnitFacing( GetTriggerUnit()))
		call UnitApplyTimedLife( GetLastCreatedUnit(), 'BHwe', 20.00)
		call RemoveLocation( YDLocal1Get(location, "出现点"))
	else
	endif
	if ((GetSpellAbilityId() == 'A0B0')) then
		call YDLocal1Set(location, "马甲点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "目标点", GetSpellTargetLoc())
		call YDLocal1Set(degree, "角度", AngleBetweenPoints( YDLocal1Get(location, "马甲点"), YDLocal1Get(location, "目标点")))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( Player(PLAYER_NEUTRAL_AGGRESSIVE), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "马甲点"), YDLocal1Get(degree, "角度")))
		call RemoveLocation( YDLocal1Get(location, "马甲点"))
		call YDLocal1Set(real, "循环实数", 0.00)
		call YDLocal1Set(group, "重复单位组", CreateGroup())
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "GetTriggerPlayer", GetTriggerPlayer())
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, group, "判断碰撞单位组", YDLocal1Get(group, "判断碰撞单位组"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, location, "点", YDLocal1Get(location, "点"))
		call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
		call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
		call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
		call YDLocalSet(ydl_timer, group, "重复单位组", YDLocal1Get(group, "重复单位组"))
		call YDLocalSet(ydl_timer, location, "马甲点", YDLocal1Get(location, "马甲点"))
		call YDLocalSet(ydl_timer, location, "马甲移动点", YDLocal1Get(location, "马甲移动点"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.02, true, function Trig______________________ZDJNFunc012Func008T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig______________________ZDJNFunc012Func008T","指定技能类物品ZDJN")
#endif 
	else
	endif
	if ((GetSpellAbilityId() == 'A0B2')) then
		call YDWETimerDestroyEffect( 2, AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl", GetTriggerUnit(), "overhead"))
		call EXSetEffectSize( GetLastCreatedEffectBJ(), 2.00)
		call UnitRemoveBuffsEx( GetSpellTargetUnit(), false, true, false, false, false, false, true)
	else
	endif
	if ((GetSpellAbilityId() == 'A0B4')) then
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		call YDLocal1Set(location, "点", GetUnitLoc( YDLocal1Get(unit, "目标")))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "war3mapImported\\[AKE]war3AKE.com - 0207194794849369616067742.mdx", YDLocal1Get(location, "点")))
		call YDLocal1Set(unit, "辅助马甲", CreateUnitAtLoc( GetOwningPlayer( GetTriggerUnit()), YDUserDataGet(string, "辅助马甲","单位类型", unitcode), YDLocal1Get(location, "点"), 0))
		call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), YDUserDataGet(string, "眩晕0.5秒","技能", abilcode))
		call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "thunderbolt", YDLocal1Get(unit, "目标"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, unit, "目标", YDLocal1Get(unit, "目标"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.21, false, function Trig______________________ZDJNFunc014Func007T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.21, false," function Trig______________________ZDJNFunc014Func007T","指定技能类物品ZDJN")
#endif 
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	if ((GetSpellAbilityId() == 'A0HF')) then
		call YDLocal1Set(unit, "目标", GetSpellTargetUnit())
		call YDLocal1Set(integer, "攻击力", OperatorIntegerDivide( R2I( GetUnitState( YDLocal1Get(unit, "目标"), ConvertUnitState(0x15))), 10))
		call YDWEGeneralBounsSystemUnitSetBonus( YDLocal1Get(unit, "目标"), 3, 0, YDLocal1Get(integer, "攻击力"))
		call YDLocal1Set(real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
		call YDLocalSet(ydl_timer, integer, "攻击力", YDLocal1Get(integer, "攻击力"))
		call YDLocalSet(ydl_timer, unit, "目标", YDLocal1Get(unit, "目标"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, true, function Trig______________________ZDJNFunc015Func005T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig______________________ZDJNFunc015Func005T","指定技能类物品ZDJN")
#endif 
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig______________________ZDJN takes nothing returns nothing
	set gg_trg______________________ZDJN = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg______________________ZDJN,"指定技能类物品ZDJN")
#endif
	call TriggerAddAction(gg_trg______________________ZDJN, function Trig______________________ZDJNActions)
endfunction

