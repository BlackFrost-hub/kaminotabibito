//===========================================================================
// Trigger: 英雄使用技能与记录QWERskill
//===========================================================================
function Trig____________________________QWERskillActions takes nothing returns nothing
	YDLocalInitialize()
	if ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true)) then
		call YDLocal1Set(abilcode, "skill", GetSpellAbilityId())
		if ((YDUserDataHas(unit, GetTriggerUnit(),"Qskill", abilcode) == false) and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "skill"), "hotkey") == "Q")) then
			call YDUserDataSet(unit, GetTriggerUnit(),"Qskill", abilcode, YDLocal1Get(abilcode, "skill"))
		else
		endif
		if ((YDUserDataHas(unit, GetTriggerUnit(),"Wskill", abilcode) == false) and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "skill"), "hotkey") == "W")) then
			call YDUserDataSet(unit, GetTriggerUnit(),"Wskill", abilcode, YDLocal1Get(abilcode, "skill"))
		else
		endif
		if ((YDUserDataHas(unit, GetTriggerUnit(),"Eskill", abilcode) == false) and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "skill"), "hotkey") == "E")) then
			call YDUserDataSet(unit, GetTriggerUnit(),"Eskill", abilcode, YDLocal1Get(abilcode, "skill"))
		else
		endif
		if ((YDUserDataHas(unit, GetTriggerUnit(),"Rskill", abilcode) == false) and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "skill"), "hotkey") == "R")) then
			call YDUserDataSet(unit, GetTriggerUnit(),"Rskill", abilcode, YDLocal1Get(abilcode, "skill"))
		else
		endif
		if ((YDUserDataHas(unit, GetTriggerUnit(),"Dskill", abilcode) == false) and (YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_ABILITY, YDLocal1Get(abilcode, "skill"), "hotkey") == "D")) then
			call YDUserDataSet(unit, GetTriggerUnit(),"Dskill", abilcode, YDLocal1Get(abilcode, "skill"))
		else
		endif
	else
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig____________________________QWERskill takes nothing returns nothing
	set gg_trg____________________________QWERskill = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________________QWERskill,"英雄使用技能与记录QWERskill")
#endif
	call TriggerAddAction(gg_trg____________________________QWERskill, function Trig____________________________QWERskillActions)
endfunction

