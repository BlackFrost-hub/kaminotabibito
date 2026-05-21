//===========================================================================
// Trigger: 闪避命中BJXT
//===========================================================================
function Trig_____________BJXTConditions takes nothing returns boolean
	return ((GetEventDamage() >= 1.10))
endfunction

function Trig_____________BJXTActions takes nothing returns nothing
	YDLocalInitialize()
	//↓先判定命中率，若命中则判定闪避率，所有单位默认命中率100%，基础属性是0%，0=100
	if ((IsPlayerInForce( GetOwningPlayer( GetEventDamageSource()), YDUserDataGet(string, "玩家","玩家组", force)) == false) and (YDUserDataGet(unit, GetEventDamageSource(),"命中率", real) < 0.00)) then
		call YDLocal1Set(real, "随机实数", GetRandomReal( 0.00, -1.00))
		call YDLocal1Set(real, "命中率", YDUserDataGet(unit, GetEventDamageSource(),"命中率", real))
		if ((YDUserDataGet(unit, GetEventDamageSource(),"命中率", real) > YDLocal1Get(real, "随机实数"))) then
			call DoNothing()
		else
			call YDWESetEventDamage( 0.00)
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			call CreateTextTagLocBJ( "TRIGSTR_112", YDLocal1Get(location, "点"), 20.00, 12.00, 75.00, 1.00, 1.00, 20.00)
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
			call YDWETimerDestroyTextTag( 0.80, GetLastCreatedTextTag())
			call RemoveLocation( YDLocal1Get(location, "点"))
			call YDLocal1Release()
			return
			//↓↓↓未命中则不进行下面的闪避判定↓↓↓
		endif
	else
		if ((YDUserDataGet(player, GetTriggerPlayer(),"命中率", real) < 0.00)) then
			call YDLocal1Set(real, "随机实数", GetRandomReal( 0.00, -1.00))
			call YDLocal1Set(real, "命中率", YDUserDataGet(unit, GetEventDamageSource(),"命中率", real))
			if ((YDUserDataGet(player, GetTriggerPlayer(),"命中率", real) > YDLocal1Get(real, "随机实数"))) then
				call DoNothing()
			else
				call YDWESetEventDamage( 0.00)
				call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
				call CreateTextTagLocBJ( "TRIGSTR_111", YDLocal1Get(location, "点"), 20.00, 12.00, 75.00, 1.00, 1.00, 20.00)
				call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
				call YDWETimerDestroyTextTag( 0.80, GetLastCreatedTextTag())
				call RemoveLocation( YDLocal1Get(location, "点"))
				call YDLocal1Release()
				return
				//↓↓↓未命中则不进行下面的闪避判定↓↓↓
			endif
		else
		endif
	endif
	//只闪避低于70%最大生命值的伤害
	if ((GetEventDamage() < OperatorRealMultiply( 0.70, GetUnitState( GetTriggerUnit(), UNIT_STATE_MAX_LIFE))) and ((YDUserDataGet(unit, GetTriggerUnit(),"闪避率", real) > 0.01) or (YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"闪避率", real) > 0.00))) then
		//有这个属性时，普攻不会被闪避，必中
		if ((YDWEIsEventAttackDamage() == true) and (YDWEIsEventPhysicalDamage() == true) and (YDUserDataHas(unit, GetTriggerUnit(),"普攻必中", boolean) == true)) then
		else
		endif
		call YDLocal1Set(real, "随机实数", GetRandomReal( 0.01, 1.00))
		//玩家英雄是不会有单位的自定义值『闪避率』的，仅限敌人有，作者游戏设定
		if ((YDUserDataGet(unit, GetTriggerUnit(),"闪避率", real) > 0.01)) then
			call YDLocal1Set(real, "闪避率", YDUserDataGet(unit, GetTriggerUnit(),"闪避率", real))
			call YDLocal1Set(real, "闪避率", OperatorRealSubtract( YDLocal1Get(real, "闪避率"), YDUserDataGet(player, GetOwningPlayer( GetEventDamageSource()),"命中率", real)))
		else
			//玩家单位的闪避率命中率判定
			if ((YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"闪避率", real) > 0.01)) then
				call YDLocal1Set(real, "闪避率", YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"闪避率", real))
				if ((YDLocal1Get(real, "闪避率") >= 0.25)) then
					call YDLocal1Set(real, "闪避率", 0.25)
				else
				endif
				call YDLocal1Set(real, "闪避率", OperatorRealSubtract( YDLocal1Get(real, "闪避率"), YDUserDataGet(unit, GetEventDamageSource(),"命中率", real)))
			else
			endif
		endif
		//计算闪避率
		if ((YDLocal1Get(real, "闪避率") >= YDLocal1Get(real, "随机实数"))) then
			call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
			if ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true)) then
				call YDWESetEventDamage( 0.00)
				call CreateTextTagLocBJ( "TRIGSTR_113", YDLocal1Get(location, "点"), 20.00, 10.00, 50.00, 1.00, 1.00, 20.00)
			else
				//非玩家，敌人只能闪避70%伤害
				call YDWESetEventDamage( OperatorRealMultiply( GetEventDamage(), 0.30))
				call CreateTextTagLocBJ( "TRIGSTR_114", YDLocal1Get(location, "点"), 20.00, 10.00, 75.00, 1.00, 1.00, 20.00)
			endif
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
			call YDWETimerDestroyTextTag( 0.80, GetLastCreatedTextTag())
			call RemoveLocation( YDLocal1Get(location, "点"))
			//闪避优先走，被闪避则无视暴击判断，直接跳过
		else
		endif
	else
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_____________BJXT takes nothing returns nothing
	set gg_trg_____________BJXT = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_____________BJXT,"闪避命中BJXT")
#endif
	call MNAnyUnitDamaged(gg_trg_____________BJXT, 5.00)
	call TriggerAddCondition(gg_trg_____________BJXT, Condition(function Trig_____________BJXTConditions))
	call TriggerAddAction(gg_trg_____________BJXT, function Trig_____________BJXTActions)
endfunction

