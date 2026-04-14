//===========================================================================
// Trigger: 冷却缩减与蓝耗
//===========================================================================
function Trig______________________uActions takes nothing returns nothing
	YDLocalInitialize()
	if ((GetSpellAbilityId() != 'A0FW') and (GetSpellAbilityId() != 'A01W') and (GetUnitTypeId( GetTriggerUnit()) != 'E001') and (GetSpellAbilityId() != 'A0IN') and (GetSpellAbilityId() != 'A0IO') and (GetSpellAbilityId() != 'A0J8') and (GetSpellAbilityId() != 'A0K5') and (GetSpellAbilityId() != 'A0JP') and (GetSpellAbilityId() != 'A0J3') and (GetSpellAbilityId() != 'A0K6') and (GetSpellAbilityId() != 'A0KR') and (GetSpellAbilityId() != '0005')) then
		call YDLocal1Set(abilcode, "技能", GetSpellAbilityId())
		call YDLocal1Set(unit, "YX", GetTriggerUnit())
		call YDLocal1Set(integer, "等级", GetUnitAbilityLevel( GetTriggerUnit(), YDLocal1Get(abilcode, "技能")))
		call YDLocal1Set(real, "JCJG", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "技能"), ("Cool" + I2S( YDLocal1Get(integer, "等级")))))
		call YDLocal1Set(real, "冷却缩减", YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"冷却缩减", real))
		call YDLocal1Set(real, "冷却缩减加成", YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"冷却缩减加成", real))
		if ((YDLocal1Get(real, "冷却缩减") >= OperatorRealAdd( 0.33, YDLocal1Get(real, "冷却缩减加成")))) then
			call YDLocal1Set(real, "冷却缩减", OperatorRealAdd( 0.33, YDLocal1Get(real, "冷却缩减加成")))
		else
		endif
		if ((GetSpellAbilityId() == 'A0IM')) then
			if ((YDLocal1Get(real, "冷却缩减") >= 0.25)) then
				call YDLocal1Set(real, "冷却缩减", 0.25)
			else
			endif
		else
		endif
		if ((GetSpellAbilityId() == 'A0IP')) then
			if ((YDLocal1Get(real, "冷却缩减") >= 0.20)) then
				call YDLocal1Set(real, "冷却缩减", 0.20)
			else
			endif
		else
		endif
		//↓↓↓下列if条件中的技能因技能设计原因在各自的技能触发中独自设置冷却时间↓↓↓
		if ((GetSpellAbilityId() != 'A0EA') and (GetSpellAbilityId() != 'A0DB') and (GetSpellAbilityId() != 'A0DG')) then
		else
			if ((YDLocal1Get(real, "冷却缩减") >= 0.33) and (GetSpellAbilityId() == 'A0DG')) then
				call YDLocal1Set(real, "冷却缩减", 0.33)
			else
			endif
		endif
		if ((YDLocal1Get(real, "冷却缩减") >= 0.01)) then
			call YDLocal1Set(real, "CD", OperatorRealMultiply( YDLocal1Get(real, "JCJG"), OperatorRealSubtract( 1.00, YDLocal1Get(real, "冷却缩减"))))
			call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "YX"), YDLocal1Get(abilcode, "技能"), YDLocal1Get(integer, "等级"), 105, YDLocal1Get(real, "CD"))
		else
		endif
		if (((YDLocal1Get(abilcode, "技能") == 'A0JJ') or (YDLocal1Get(abilcode, "技能") == 'A0JI') or (YDLocal1Get(abilcode, "技能") == 'A0JK') or (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQW") or (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQE") or (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQR"))) then
			if (((YDLocal1Get(abilcode, "技能") == 'A0JJ') or (YDLocal1Get(abilcode, "技能") == 'A0JI') or (YDLocal1Get(abilcode, "技能") == 'A0JK'))) then
				call YDLocal1Set(real, "CD", OperatorRealSubtract( 12.00, OperatorRealMultiply( 12.00, YDLocal1Get(real, "冷却缩减"))))
				call YDWESetUnitAbilityState( GetTriggerUnit(), 'A0JH', 1, YDLocal1Get(real, "CD"))
			else
			endif
			if (((YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQW") or (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQE") or (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 216) == "SLSQR"))) then
				call YDLocal1Set(real, "CD", OperatorRealSubtract( 9.00, OperatorRealMultiply( 9.00, YDLocal1Get(real, "冷却缩减"))))
				call YDWESetUnitAbilityState( GetTriggerUnit(), 'A0JT', 1, YDLocal1Get(real, "CD"))
			else
			endif
		else
		endif
	else
	endif
	if ((YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, GetSpellAbilityId(), "race") == "nightelf")) then
		call YDLocal1Set(real, "技能消耗", OperatorRealAdd( I2R( YDWEGetUnitAbilityDataInteger( GetTriggerUnit(), GetSpellAbilityId(), GetUnitAbilityLevel( GetTriggerUnit(), GetSpellAbilityId()), 104)), 0.00))
		call YDLocal1Set(real, "百分比消耗", YDWEGetUnitAbilityDataReal( GetTriggerUnit(), GetSpellAbilityId(), GetUnitAbilityLevel( GetTriggerUnit(), GetSpellAbilityId()), 102))
		//说明这些技能不是通魔面板技能
		if ((YDLocal1Get(real, "百分比消耗") >= 0.90)) then
			call YDLocal1Release()
			return
		else
		endif
		call YDLocal1Set(real, "技能消耗", OperatorRealAdd( YDLocal1Get(real, "技能消耗"), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_MANA), YDLocal1Get(real, "百分比消耗"))))
		call SetUnitManaPercentBJ( GetTriggerUnit(), OperatorRealSubtract( GetUnitManaPercent( GetTriggerUnit()), OperatorRealMultiply( YDLocal1Get(real, "百分比消耗"), 100.00)))
		call YDLocal1Set(real, "减少量", YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"魔法消耗减少", real))
		//回蓝
		if ((YDLocal1Get(real, "减少量") >= 0.01)) then
			call SetUnitState( GetTriggerUnit(), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( GetTriggerUnit(), UNIT_STATE_MANA), OperatorRealMultiply( YDLocal1Get(real, "减少量"), YDLocal1Get(real, "技能消耗"))))
		else
		endif
		//被动
		if ((GetTriggerUnit() == YDUserDataGet(string, "爱德华","单位", unit))) then
			call SetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( GetTriggerUnit(), UNIT_STATE_LIFE), YDLocal1Get(real, "技能消耗")))
		else
		endif
	else
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig______________________u takes nothing returns nothing
	set gg_trg______________________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg______________________u,"冷却缩减与蓝耗")
#endif
	call TriggerAddAction(gg_trg______________________u, function Trig______________________uActions)
endfunction

