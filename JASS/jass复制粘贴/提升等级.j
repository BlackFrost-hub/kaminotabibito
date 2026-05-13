//===========================================================================
// Trigger: 等级提升效果+技能领悟YXLW
//===========================================================================
function Trig________________________________YXLWActions takes nothing returns nothing
	YDLocalInitialize()
	call YDLocal1Set(integer, "LV", GetHeroLevel( GetTriggerUnit()))
	if ((GetUnitTypeId( GetTriggerUnit()) == 'H00Q')) then
		call YDLocal1Set(unit, "爱德华", YDUserDataGet(string, "爱德华","单位", unit))
		call SetUnitState( YDLocal1Get(unit, "爱德华"), ConvertUnitState(0x20), OperatorRealAdd( GetUnitState( YDLocal1Get(unit, "爱德华"), ConvertUnitState(0x20)), 0.30))
	else
	endif
	if ((GetHeroLevel( GetTriggerUnit()) == 3)) then
		if ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_MELEE_ATTACKER) == true)) then
			call SetUnitState( GetTriggerUnit(), ConvertUnitState(0x12), OperatorRealAdd( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x12)), 12.00))
		else
			call SetUnitState( GetTriggerUnit(), ConvertUnitState(0x12), OperatorRealAdd( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x12)), 7.00))
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "克劳德","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0CJ')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0CG')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0CF')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0CK')
					else
						if ((GetHeroLevel( GetTriggerUnit()) == 30)) then
							call YDLocal1Set(abilcode, "技能", 'A0DL')
						else
						endif
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "逆回十六夜","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0E3')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0E4')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0E5')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0E1')
					else
						if ((GetHeroLevel( GetTriggerUnit()) == 30)) then
						else
						endif
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "黑崎一护","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A01G')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A01K')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A01L')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A01H')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "坂井悠二","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0E8')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0E9')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0EA')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0ED')
					else
						if ((GetHeroLevel( GetTriggerUnit()) == 30)) then
							call YDLocal1Set(abilcode, "技能", 'A0EB')
						else
						endif
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "一方通行","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0DU')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0DV')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0DW')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0DX')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "佐佐木小次郎","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0GS')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0GQ')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0GV')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0GP')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "十六夜咲夜","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A00Q')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A00U')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A00Z')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A00Y')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "八云紫","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0FV')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0FU')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0FW')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0FT')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "saber","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0DB')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0DE')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0DG')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0DF')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "藤原妹红","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0GB')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0G6')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0GG')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0G7')
					else
						if ((GetHeroLevel( GetTriggerUnit()) == 25)) then
							call YDLocal1Set(abilcode, "技能", 'A0G9')
						else
						endif
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "鹿目圆香","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A01U')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0LU')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A01T')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0FR')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetTriggerUnit() == YDUserDataGet(string, "铃仙","单位", unit))) then
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
			call YDLocal1Set(abilcode, "技能", 'A0GK')
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call YDLocal1Set(abilcode, "技能", 'A0GI')
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call YDLocal1Set(abilcode, "技能", 'A0GH')
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call YDLocal1Set(abilcode, "技能", 'A0GL')
					else
					endif
				endif
			endif
		endif
	else
	endif
	if ((YDLocal1Get(abilcode, "技能") == 0)) then
	else
		if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
				call UnitAddAbility( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"))
				call DisplayTimedTextToPlayer( GetOwningPlayer( GetTriggerUnit()), 0, 0, 20.00, YDWEOperatorString3( "|cffffff00『系统提示』：|r|cffffffcc『", GetUnitName( GetTriggerUnit()), ("』|r回忆起了技能|cffff99cc『" + (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 215) + "』|r"))))
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
					call UnitAddAbility( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"))
					call DisplayTimedTextToPlayer( GetOwningPlayer( GetTriggerUnit()), 0, 0, 20.00, YDWEOperatorString3( "|cffffff00『系统提示』：|r|cffffffcc『", GetUnitName( GetTriggerUnit()), ("』|r回忆起了技能|cffff99cc『" + (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 215) + "』|r"))))
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
						call UnitAddAbility( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"))
						call DisplayTimedTextToPlayer( GetOwningPlayer( GetTriggerUnit()), 0, 0, 20.00, YDWEOperatorString3( "|cffffff00『系统提示』：|r|cffffffcc『", GetUnitName( GetTriggerUnit()), ("』|r回忆起了技能|cffff99cc『" + (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 215) + "』|r"))))
					else
						if ((GetHeroLevel( GetTriggerUnit()) == 30)) then
							call UnitAddAbility( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"))
							call DisplayTimedTextToPlayer( GetOwningPlayer( GetTriggerUnit()), 0, 0, 20.00, YDWEOperatorString3( "|cffffff00『系统提示』：|r|cffffffcc『", GetUnitName( GetTriggerUnit()), ("』|r回忆起了技能|cffff99cc『" + (YDWEGetUnitAbilityDataString( GetTriggerUnit(), YDLocal1Get(abilcode, "技能"), 1, 215) + "』|r"))))
						else
						endif
					endif
				endif
			endif
		endif
	endif
	if ((GetHeroLevel( GetTriggerUnit()) == 2)) then
		call YDUserDataSet(unit, YDLocal1Get(unit, "英雄"),"Q技能", abilcode, YDLocal1Get(abilcode, "技能"))
	else
		if ((GetHeroLevel( GetTriggerUnit()) == 5)) then
			call YDUserDataSet(unit, YDLocal1Get(unit, "英雄"),"W技能", abilcode, YDLocal1Get(abilcode, "技能"))
		else
			if ((GetHeroLevel( GetTriggerUnit()) == 10)) then
				call YDUserDataSet(unit, YDLocal1Get(unit, "英雄"),"E技能", abilcode, YDLocal1Get(abilcode, "技能"))
			else
				if ((GetHeroLevel( GetTriggerUnit()) == 15)) then
					call YDUserDataSet(unit, YDLocal1Get(unit, "英雄"),"R技能", abilcode, YDLocal1Get(abilcode, "技能"))
				else
					if ((GetHeroLevel( GetTriggerUnit()) == 30)) then
						call YDUserDataSet(unit, YDLocal1Get(unit, "英雄"),"D技能", abilcode, YDLocal1Get(abilcode, "技能"))
					else
					endif
				endif
			endif
		endif
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig________________________________YXLW takes nothing returns nothing
	set gg_trg________________________________YXLW = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg________________________________YXLW,"等级提升效果+技能领悟YXLW")
#endif
	call TriggerAddAction(gg_trg________________________________YXLW, function Trig________________________________YXLWActions)
endfunction

