//===========================================================================
// Trigger: 死亡类触发CF
//===========================================================================
function Trig________________CFConditions takes nothing returns boolean
	return ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_ANCIENT) == false)) and ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_MECHANICAL) == false)) and ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_SUMMONED) == false))
endfunction

function Trig________________CFFunc005Func002003003 takes nothing returns boolean
	return ((GetUnitFlyHeight( GetFilterUnit()) <= 99999.00) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and ((IsUnitEnemy( GetFilterUnit(), GetTriggerPlayer()) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (10 >= 10))))))
endfunction

function Trig________________CFFunc005Func003A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	if ((IsUnitAliveBJ( YDLocal2Get(unit, "选取单位")) == true) and (UnitHasItemOfTypeBJ( YDLocal2Get(unit, "选取单位"), 'I03D') == true)) then
		call CreateNUnitsAtLocFacingLocBJ( 1, 'u000', GetOwningPlayer( YDLocal2Get(unit, "选取单位")), YDLocal2Get(location, "点"), YDLocal2Get(location, "点"))
		call UnitApplyTimedLife( GetLastCreatedUnit(), 'BHwe', 5.00)
		call SetUnitState( GetLastCreatedUnit(), UNIT_STATE_MAX_LIFE, OperatorRealAdd( 300.00, OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_MAX_LIFE), 0.25)))
		call SetUnitState( GetLastCreatedUnit(), ConvertUnitState(0x12), OperatorRealAdd( 25.00, OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "选取单位"), ConvertUnitState(0x15)), 0.40)))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffectLoc( "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl", YDLocal2Get(location, "点")))
		call SetUnitLifePercentBJ( GetLastCreatedUnit(), 100)
	else
	endif
endfunction

function Trig________________CFActions takes nothing returns nothing
	YDLocalInitialize()
	call YDLocal1Set(location, "点", GetUnitLoc( GetDyingUnit()))
	if ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_ANCIENT) == false)) then
		call YDLocal1Set(group, "单位组", GetUnitsInRangeOfLocMatching( 500.00, YDLocal1Get(location, "点"), Condition(function Trig________________CFFunc005Func002003003)))
		call ForGroupBJ( YDLocal1Get(group, "单位组"),function Trig________________CFFunc005Func003A)
		call DestroyGroup( YDLocal1Get(group, "单位组"))
	else
	endif
	if ((UnitHasItemOfTypeBJ( GetKillingUnitBJ(), 'I06H') == true)) then
		call YDLocal1Set(integer, "层数", GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I06H')))
		if ((YDLocal1Get(integer, "层数") >= 100)) then
		else
			call SetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I06H'), OperatorIntegerAdd( GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I06H')), 2))
		endif
	else
	endif
	if (((UnitHasItemOfTypeBJ( GetKillingUnitBJ(), 'I0BE') == true) or (UnitHasItemOfTypeBJ( GetKillingUnitBJ(), 'I0BF') == true))) then
		if ((UnitHasItemOfTypeBJ( GetKillingUnitBJ(), 'I0BE') == true)) then
			call SetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BE'), OperatorIntegerAdd( GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BE')), 1))
			if ((GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BE')) >= 20)) then
				call RemoveItem( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BE'))
				call UnitAddItemByIdSwapped( 'I0BI', GetKillingUnitBJ())
			else
			endif
		else
		endif
		if ((UnitHasItemOfTypeBJ( GetKillingUnitBJ(), 'I0BF') == true)) then
			call SetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BF'), OperatorIntegerAdd( GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BF')), 1))
			if ((GetItemCharges( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BF')) >= 20)) then
				call RemoveItem( GetItemOfTypeFromUnitBJ( GetKillingUnitBJ(), 'I0BF'))
				call UnitAddItemByIdSwapped( 'I0BJ', GetKillingUnitBJ())
			else
			endif
		else
		endif
	else
	endif
	call RemoveLocation( YDLocal1Get(location, "点"))
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig________________CF takes nothing returns nothing
	set gg_trg________________CF = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg________________CF,"死亡类触发CF")
#endif
	call TriggerRegisterPlayerUnitEventSimple(gg_trg________________CF, Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_DEATH)
	call TriggerRegisterPlayerUnitEventSimple(gg_trg________________CF, Player(7), EVENT_PLAYER_UNIT_DEATH)
	call TriggerAddCondition(gg_trg________________CF, Condition(function Trig________________CFConditions))
	call TriggerAddAction(gg_trg________________CF, function Trig________________CFActions)
endfunction

