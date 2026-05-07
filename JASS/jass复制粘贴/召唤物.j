
//===========================================================================
// Trigger: Summon_System
//===========================================================================
function Trig_Summon_SystemActions takes nothing returns nothing
	local integer ydl_triggerstep
	local trigger ydl_trigger
	YDLocalInitialize()
	if ((YDLocal1Get(real, "facing") == 0.00)) then
		call YDLocal1Set(degree, "facing", bj_UNIT_FACING)
	else
	endif
	if ((YDLocal1Get(unit, "Summon") == null)) then
		call YDLocal1Set(unit, "Summon", SUO_CreateUnit_Loc( GetOwningPlayer( YDLocal1Get(unit, "Master")), YDLocal1Get(unitcode, "unitType"), Location( YDLocal1Get(real, "x"), YDLocal1Get(real, "y")), 50.00, YDLocal1Get(degree, "facing"), 255, 255, 255, 255, YDLocal1Get(real, "time"), true))
		set ydl_trigger = GetTriggeringTrigger()
		set Star_PIndex = LoadInteger(YDHT,GetHandleId(GetTriggeringTrigger()),SKey_PIndex)
		call YDLocal7Set(unit, "Summon", YDLocal1Get(unit, "Summon"))
		call RemoveSavedInteger(YDHT,GetHandleId(GetTriggeringTrigger()),SKey_PIndex)
	else
	endif
	call DzSetUnitModel( YDLocal1Get(unit, "Summon"), YDLocal1Get(string, "ModelFileID"))
	if ((YDLocal1Get(unit, "Master") != null)) then
		call YDUserDataSet(unit, YDLocal1Get(unit, "Summon"),"Master", unit, YDLocal1Get(unit, "Master"))
	else
	endif
	if ((YDLocal1Get(real, "moveHeight") >= 50.00)) then
		call SetUnitFlyHeight( YDLocal1Get(unit, "Sunmmon"), YDLocal1Get(real, "moveHeight"), 0.00)
	else
	endif
	if ((YDLocal1Get(real, "HP") > 0.00)) then
		call YDLocal1Set(real, "HP", OperatorRealMultiply( YDLocal1Get(real, "HP"), udg_HP2/*小怪血量百分比/*))
		call SetUnitState( YDLocal1Get(unit, "Summon"), UNIT_STATE_MAX_LIFE, YDLocal1Get(real, "HP"))
		call SetUnitLifePercentBJ( YDLocal1Get(unit, "Summon"), 100)
	else
	endif
	if ((YDLocal1Get(real, "regenHP") > 0.00)) then
		call SetUnitState( YDLocal1Get(unit, "Summon"), UNIT_STATE_MAX_LIFE, YDLocal1Get(real, "HP"))
	else
	endif
	if ((YDLocal1Get(real, "AttackPower") > 0.00)) then
		call SetUnitState( YDLocal1Get(unit, "Summon"), ConvertUnitState(0x12), YDLocal1Get(real, "AttackPower"))
	else
	endif
	if ((YDLocal1Get(real, "MoveHeight") > 0.00)) then
		call SetUnitState( YDLocal1Get(unit, "Summon"), ConvertUnitState(0x25), YDLocal1Get(real, "atkCd"))
	else
	endif
	if ((YDLocal1Get(real, "def") > 0.00)) then
		call SetUnitState( YDLocal1Get(unit, "Summon"), ConvertUnitState(0x20), YDLocal1Get(real, "def"))
	else
	endif
	if ((YDLocal1Get(real, "size") > 0.00)) then
		call SetUnitScale( YDLocal1Get(unit, "Summon"), YDLocal1Get(real, "size"), YDLocal1Get(real, "size"), YDLocal1Get(real, "size"))
	else
	endif
	call YDLocal1Release()
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig_Summon_System takes nothing returns nothing
	set gg_trg_Summon_System = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Summon_System,"Summon_System")
#endif
	call STES_Register(gg_trg_Summon_System, "OnSummonEvent")
	call TriggerAddAction(gg_trg_Summon_System, function Trig_Summon_SystemActions)
endfunction

