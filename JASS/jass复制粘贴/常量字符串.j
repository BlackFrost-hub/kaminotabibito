//===========================================================================
// Trigger: InitStringCache10.0S
//===========================================================================
function Trig_InitStringCache10_0SActions takes nothing returns nothing
	local integer ydul_I
	local integer ydul_N
	//这个是最常用字符串，直接设置为0
	set udg_String/*常量字符串*/[0] = "|cFFFFFF00『系统提示』：|r"
	set ydul_I = 0
	loop
		exitwhen ydul_I > 9
		set udg_integer/*整数字符串/*[ydul_I] = I2S( ydul_I)
		set ydul_I = ydul_I + 1
	endloop
	set udg_string2/*小数点字符串/*[10] = "."
	set ydul_N = 0
	loop
		exitwhen ydul_N > 9
		call StringBufferAdd( udg_string2/*小数点字符串/*[10])
		call StringBufferAdd( udg_integer/*整数字符串/*[ydul_N])
		set udg_string2/*小数点字符串/*[ydul_N] = StringBufferLoad()
		set ydul_N = ydul_N + 1
	endloop
	set udg_String/*常量字符串*/[1] = GetPlayerName( Player(0))
	set udg_String/*常量字符串*/[2] = GetPlayerName( Player(1))
	set udg_String/*常量字符串*/[3] = GetPlayerName( Player(2))
	set udg_String/*常量字符串*/[4] = GetPlayerName( Player(3))
	set udg_String/*常量字符串*/[10] = "|r"
	set udg_String/*常量字符串*/[11] = "|cffC0C0C0"
	set udg_String/*常量字符串*/[12] = "|cFF99CCFF"
	set udg_String/*常量字符串*/[13] = "|cff0070DD"
	set udg_String/*常量字符串*/[14] = "|cff800080"
	set udg_String/*常量字符串*/[15] = "|cffA335EE"
	set udg_String/*常量字符串*/[16] = "|cFFFFCC99"
	set udg_String/*常量字符串*/[17] = "|cffFF8000"
	set udg_String/*常量字符串*/[18] = "|cffFFD700"
	set udg_String/*常量字符串*/[19] = "|cFFFFFF00"
	set udg_String/*常量字符串*/[20] = "|cFFFF0000"
	set udg_String/*常量字符串*/[21] = "|cFFCCFFCC"
	set udg_String/*常量字符串*/[22] = "|cFF339966"
	set udg_String/*常量字符串*/[40] = "："
	set udg_String/*常量字符串*/[41] = "『"
	set udg_String/*常量字符串*/[42] = "』"
	set udg_String/*常量字符串*/[43] = "目标"
	set udg_String/*常量字符串*/[44] = "+"
	set udg_String/*常量字符串*/[45] = "-"
	set udg_String/*常量字符串*/[46] = "腐败值"
	set udg_String/*常量字符串*/[47] = "区域"
	set udg_String/*常量字符串*/[48] = "分钱：+"
	set udg_String/*常量字符串*/[50] = "装备"
	set udg_String/*常量字符串*/[51] = "物品"
	set udg_String/*常量字符串*/[52] = "E-级"
	set udg_String/*常量字符串*/[53] = "E级"
	set udg_String/*常量字符串*/[54] = "E+级"
	set udg_String/*常量字符串*/[55] = "E++级"
	set udg_String/*常量字符串*/[56] = "D-级"
	set udg_String/*常量字符串*/[57] = "D级"
	set udg_String/*常量字符串*/[58] = "D+级"
	set udg_String/*常量字符串*/[59] = "D++级"
	set udg_String/*常量字符串*/[60] = "C-级"
	set udg_String/*常量字符串*/[61] = "C级"
	set udg_String/*常量字符串*/[62] = "C+级"
	set udg_String/*常量字符串*/[63] = "C++级"
	set udg_String/*常量字符串*/[64] = "B-级"
endfunction

//===========================================================================
function InitTrig_InitStringCache10_0S takes nothing returns nothing
	set gg_trg_InitStringCache10_0S = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_InitStringCache10_0S,"InitStringCache10.0S")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg_InitStringCache10_0S, 1.00)
	call TriggerAddAction(gg_trg_InitStringCache10_0S, function Trig_InitStringCache10_0SActions)
endfunction

