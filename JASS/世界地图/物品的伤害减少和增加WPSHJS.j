//===========================================================================
// Trigger: 物品的伤害减少和增加WPSHJS
//===========================================================================
function Trig_______________________________WPSHJSConditions takes nothing returns boolean
	return ((YDWEIsEventDamageType( DAMAGE_TYPE_MIND) == false)) and ((GetEventDamage() >= 1.00)) and ((YDUserDataGet(unit, GetTriggerUnit(),"减伤关闭", boolean) == false))
endfunction

function Trig_______________________________WPSHJSFunc012Func002003003 takes nothing returns boolean
	return ((GetFilterUnit() != GetTriggerUnit()) and (IsUnitType( GetFilterUnit(), UNIT_TYPE_HERO) == true))
endfunction

function Trig_______________________________WPSHJSActions takes nothing returns nothing
	YDLocalInitialize()
	//告知ai，你要注意这个jass文件的全局前置的3个条件
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I03Q') == true)) then
		//固定减少自身最大生命值1%的魔法伤害|
		call YDWESetEventDamage( OperatorRealSubtract( GetEventDamage(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01)))
	else
		if ((YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true) and (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I03P') == true)) then
			//固定减少自身最大生命值1%的物理伤害
			call YDWESetEventDamage( OperatorRealSubtract( GetEventDamage(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.01)))
		else
		endif
	endif
	//收到的伤害减少2%最大生命值
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I09V') == true)) then
	else
		call YDWESetEventDamage( OperatorRealSubtract( GetEventDamage(), OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.02)))
	endif
	//来自300外的伤害减少20%
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I08C') == true)) then
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((YDLocal1Get(real, "距离") > 300.00)) then
			call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.80))
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	//伙伴之力（被动）：周围800范围每有一名友方英雄，则受到的伤害降低3%
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I042') == true)) then
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 800.00, YDLocal1Get(location, "点"), Condition(function Trig_______________________________WPSHJSFunc012Func002003003)))
		call YDLocal1Set(integer, "数量", CountUnitsInGroup( YDLocal1Get(group, "单位组")))
		call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), OperatorRealSubtract( 1.00, OperatorRealMultiply( 0.03, I2R( YDLocal1Get(integer, "数量"))))))
		call RemoveLocation( YDLocal1Get(location, "点"))
		call DestroyGroup( YDLocal1Get(group, "单位组"))
	else
	endif
	if (((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I08D') == true) or (UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I02B') == true))) then
		//熔岩恶魔王翼来自300范围外的伤害减少10%|n
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "点2", GetUnitLoc( GetEventDamageSource()))
		call YDLocal1Set(real, "距离", DistanceBetweenPoints( YDLocal1Get(location, "点"), YDLocal1Get(location, "点2")))
		if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I08D') == true) and (YDLocal1Get(real, "距离") >= 300.00)) then
			call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.90))
		else
		endif
		//精致木盾：受到400范围外的敌人造成的伤害减少35%
		if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I02B') == true) and (YDLocal1Get(real, "距离") >= 400.00)) then
			call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.65))
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "点"))
		call RemoveLocation( YDLocal1Get(location, "点2"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I06K') == true)) then
		//护肩防护（被动）：受到伤害有30%的几率减少40%，并且反击力量×4的强化伤害，对于低于自身最大生命值2%+自身等级×1的伤害则完全抵挡
		//告知ai:这里的概率要走我们的幸运值系统/反击或许可以走反击系统
		if ((GetEventDamage() < OperatorRealAdd( OperatorRealMultiply( GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE), 0.02), I2R( GetHeroStr( GetTriggerUnit(), true))))) then
			call YDWESetEventDamage( 0.00)
		else
			call YDLocal1Set(integer, "随机整数", GetRandomInt( 1, 100))
			if ((YDLocal1Get(integer, "随机整数") <= 30)) then
				call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.40))
				call YDLocal1Set(unit, "反击单位", GetEventDamageSource())
				call UnitDamageTarget( GetTriggerUnit(), GetEventDamageSource(), OperatorRealMultiply( I2R( GetHeroStr( GetTriggerUnit(), true)), 4.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_METAL_HEAVY_CHOP)
			else
			endif
		endif
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetTriggerUnit(), 'I06V') == true)) then
		//暴击防护：受到伤害时有概率减少25%伤害，每有1%暴击率就增加1%几率
		//告知ai:这里的概率要走我们的幸运值系统
		call YDLocal1Set(real, "概率", YDUserDataGet(player, GetTriggerPlayer(),"暴击率", real))
		call YDLocal1Set(real, "随机实数", GetRandomReal( 0, 1))
		if ((OperatorRealAdd( YDLocal1Get(real, "概率"), 0.25) >= YDLocal1Get(real, "随机实数"))) then
			call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.75))
		else
		endif
	else
	endif
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == true) and (YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == false) and (YDWEIsEventDamageType( DAMAGE_TYPE_ENHANCED) == false)) then
		//附魔·狱魔短匕：魔法加成大于1%时，魔法伤害对恶魔种族的魔法伤害+45%
		if (((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true) or (IsUnitRace( GetTriggerUnit(), RACE_DEMON) == true))) then
			if ((UnitHasItemOfTypeBJ( GetEventDamageSource(), 'I07J') == true)) then
				call DisableTrigger( GetTriggeringTrigger())
				call UnitDamageTarget( GetEventDamageSource(), GetTriggerUnit(), OperatorRealMultiply( GetEventDamage(), 0.45), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
				call EnableTrigger( GetTriggeringTrigger())
			else
			endif
		else
		endif
	else
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_______________________________WPSHJS takes nothing returns nothing
	set gg_trg_______________________________WPSHJS = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_______________________________WPSHJS,"物品的伤害减少和增加WPSHJS")
#endif
	call MNAnyUnitDamaged(gg_trg_______________________________WPSHJS, 5.00)
	call TriggerAddCondition(gg_trg_______________________________WPSHJS, Condition(function Trig_______________________________WPSHJSConditions))
	call TriggerAddAction(gg_trg_______________________________WPSHJS, function Trig_______________________________WPSHJSActions)
endfunction

