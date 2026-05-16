//===========================================================================
// Trigger: CombatNumbers
//===========================================================================
function Trig_CombatNumbersActions takes nothing returns nothing
	local integer ydul_A
	YDLocalInitialize()
	call YDLocal1Set(integer, "integer", R2I2( YDLocal1Get(real, "Real")))
	if ((YDLocal1Get(integer, "integer") == 0)) then
		call YDLocal1Release()
		return
	else
	endif
	if ((YDLocal1Get(integer, "integer") < 0)) then
		call YDLocal1Set(integer, "integer", IAbsBJ( YDLocal1Get(integer, "integer")))
		//添加-到缓冲池
		call StringBufferAdd( udg_String/*常量字符串*/[45])
	else
		//添加+到缓冲池
		call StringBufferAdd( udg_String/*常量字符串*/[44])
	endif
	call YDLocal1Set(integer, "digit", 0)
	call YDLocal1Set(integer, "divisor", 1000000)
	call YDLocal1Set(boolean, "hasStarted", false)
	set ydul_A = 1
	loop
		exitwhen ydul_A > 7
		call YDLocal1Set(integer, "digit", OperatorIntegerDivide( YDLocal1Get(integer, "integer"), YDLocal1Get(integer, "divisor")))
		if ((YDLocal1Get(integer, "digit") == 0)) then
			if ((YDLocal1Get(boolean, "hasStarted") == true)) then
				call StringBufferAdd( udg_integer/*整数字符串/*[0])
			else
			endif
		else
			call YDLocal1Set(boolean, "hasStarted", true)
			call YDLocal1Set(integer, "integer", OperatorIntegerSubtract( YDLocal1Get(integer, "integer"), OperatorIntegerMultiply( YDLocal1Get(integer, "digit"), YDLocal1Get(integer, "divisor"))))
			call StringBufferAdd( udg_integer/*整数字符串/*[YDLocal1Get(integer, "digit")])
		endif
		call YDLocal1Set(integer, "divisor", OperatorIntegerDivide( YDLocal1Get(integer, "divisor"), 10))
		set ydul_A = ydul_A + 1
	endloop
	if ((YDLocal1Get(boolean, "ComputeOnly") == true)) then
		call YDLocal1Release()
		return
	else
	endif
	call StringBufferAdd( YDLocal1Get(string, "string"))
	if ((YDLocal1Get(real, "size") <= 0.00)) then
		call YDLocal1Set(real, "size", 10.00)
	else
	endif
	if ((YDLocal1Get(real, "red") <= 0.00)) then
		call YDLocal1Set(real, "red", 100.00)
	else
	endif
	if ((YDLocal1Get(real, "green") <= 0.00)) then
		call YDLocal1Set(real, "green", 100.00)
	else
	endif
	if ((YDLocal1Get(real, "blue") <= 0.00)) then
		call YDLocal1Set(real, "blue", 100.00)
	else
	endif
	call YDLocal1Set(location, "point", GetUnitLoc( YDLocal1Get(unit, "Unit")))
	call CreateTextTagLocBJ( StringBufferLoad(), YDLocal1Get(location, "point"), 15.00, YDLocal1Get(real, "size"), YDLocal1Get(real, "red"), YDLocal1Get(real, "green"), YDLocal1Get(real, "blue"), 0.00)
	call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
	call YDWETimerDestroyTextTag( 1.00, GetLastCreatedTextTag())
	call RemoveLocation( YDLocal1Get(location, "point"))
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_CombatNumbers takes nothing returns nothing
	set gg_trg_CombatNumbers = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_CombatNumbers,"CombatNumbers")
#endif
	call STES_Register(gg_trg_CombatNumbers, "数值显示")
	call TriggerAddAction(gg_trg_CombatNumbers, function Trig_CombatNumbersActions)
endfunction

//===========================================================================
// Trigger: ConvertNumberToString0.00-60.99
//===========================================================================
function Trig_ConvertNumberToString0_00_60_99Actions takes nothing returns nothing
	local integer ydul_a
	local integer ydul_i
	YDLocalInitialize()
	call YDLocal1Set(integer, "Int", R2I( YDLocal1Get(real, "amount")))
	if ((YDLocal1Get(integer, "Int") >= 0) and (YDLocal1Get(integer, "Int") <= 60)) then
		call StringBufferAdd( udg_integer/*整数字符串/*[YDLocal1Get(integer, "Int")])
	else
		call DoNothing()
	endif
	//小数点读取
	call StringBufferAdd( udg_string2/*小数点字符串/*[10])
	set ydul_a = 1
	loop
		exitwhen ydul_a > 3
		call YDLocal1Set(real, "amount", OperatorRealMultiply( YDLocal1Get(real, "decimal"), 10.00))
		call YDLocal1Set(integer, "Int", R2I( YDLocal1Get(real, "amount")))
		call YDLocal1Set(real, "decimal", OperatorRealSubtract( YDLocal1Get(real, "amount"), I2R( YDLocal1Get(integer, "Int"))))
		set ydul_i = 0
		loop
			exitwhen ydul_i > 9
			if ((YDLocal1Get(integer, "Int") == ydul_i)) then
				call StringBufferAdd( udg_integer/*整数字符串/*[ydul_i])
			else
			endif
			set ydul_i = ydul_i + 1
		endloop
		set ydul_a = ydul_a + 1
	endloop
	call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, StringBufferLoad())
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_ConvertNumberToString0_00_60_99 takes nothing returns nothing
	set gg_trg_ConvertNumberToString0_00_60_99 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_ConvertNumberToString0_00_60_99,"ConvertNumberToString0.00-60.99")
#endif
	call STES_Register(gg_trg_ConvertNumberToString0_00_60_99, "NnumberToString")
	call TriggerAddAction(gg_trg_ConvertNumberToString0_00_60_99, function Trig_ConvertNumberToString0_00_60_99Actions)
endfunction

