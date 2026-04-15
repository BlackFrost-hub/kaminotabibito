//===========================================================================
// Trigger: 属性多面板SXDMB8.0
//===========================================================================
function Trig________________SXDMB8_0Func005Func001Func002Func027A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	if ((GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "选取单位")) == ConvertedPlayer( YDLocalGet(GetExpiredTimer(), integer, "整数")))) then
		call YDLocalSet(GetExpiredTimer(), real, "攻击间隔", OperatorRealDivide( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), ConvertUnitState(0x25)), GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), ConvertUnitState(0x51))))
		call YDLocalSet(GetExpiredTimer(), real, "每秒攻速", OperatorRealDivide( 1.00, YDLocalGet(GetExpiredTimer(), real, "攻击间隔")))
		call YDLocalSet(GetExpiredTimer(), real, "移动速度", GetUnitMoveSpeed( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
		call YDUserDataSet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "选取单位")),"移动速度", real, YDLocalGet(GetExpiredTimer(), real, "移动速度"))
		call YDUserDataSet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "选取单位")),"每秒攻速", real, YDLocalGet(GetExpiredTimer(), real, "每秒攻速"))
	else
	endif
endfunction

function Trig________________SXDMB8_0Func005T takes nothing returns nothing
	local integer ydul_DbfFGsylZyZAD
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	set ydul_DbfFGsylZyZAD = 1
	loop
		exitwhen ydul_DbfFGsylZyZAD > 5
		//未显示则表示该玩家位置没有玩家在线，不作任何动作
		if ((IsMultiboardDisplayed( udg_SXduomianban[ydul_DbfFGsylZyZAD]) == true)) then
			call MultiboardSetTitleText( udg_SXduomianban[ydul_DbfFGsylZyZAD], YDWEOperatorString3( "属性面板（", "难度：", YDWEOperatorString3( I2S( R2I( udg_N)), "）", ("游戏时间：" + YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[2]), "小时", YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[1]), "分", YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[0]), "秒", "")))))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 1, ("物理伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"物理伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"物理伤害减免", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 1, ("护甲穿透：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"护穿", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 1, ("魔法伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔法伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔抗", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 1, ("魔法穿透：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔法穿透", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 2, ("技能伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"技能伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"技能伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 2, ("强化伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"强化伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"强化伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 2, ("召唤物伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"召唤物伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"召唤物伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 3, ("金属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"金属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"金属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 3, ("风属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"木属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"木属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 3, ("冰属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"水属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"水属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 3, ("火属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"火焰伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"火属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 4, ("土属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"土属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"土属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 4, ("雷属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"雷属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"雷属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 4, ("光属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"光属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"光属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 4, ("暗属性伤害：" + YDWEOperatorString3( (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"暗属性伤害加成", real), 100.00)))) + "%"), "/", (I2S( R2I( OperatorRealSubtract( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"暗属性伤害减少", real), 100.00)))) + "%"))))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 5, ("暴击率：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"暴击率", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 5, ("暴击伤害：" + (I2S( R2I( OperatorRealAdd( 150.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"暴击伤害", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 5, ("被暴击率：-" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"被暴击率减少", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 5, ("被暴击伤害：-" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"暴击伤害减免", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 6, ("命中率：" + (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"命中率", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 6, ("闪避率：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"闪避率", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 6, ("冷却缩减：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"冷却缩减", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 6, ("伤害固定减少：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"伤害减少", real), 1.00)))) + "")))
			call YDLocalSet(GetExpiredTimer(), integer, "整数", ydul_DbfFGsylZyZAD)
			call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig________________SXDMB8_0Func005Func001Func002Func027A)
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 7, ("攻击速度：" + (R2S( YDLocalGet(GetExpiredTimer(), real, "每秒攻速")) + "次/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 7, ("移动速度：" + (R2S( YDLocalGet(GetExpiredTimer(), real, "移动速度")) + "")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 7, ("眩晕抗性：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"减少控制时间", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 8, ("普攻伤害吸血：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"普攻伤害吸血", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 8, ("魔法伤害吸血：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔法伤害吸血", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 8, ("伤害吸血：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"伤害吸血", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 9, ("当前生命恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"总生命恢复", real), 1.00)))) + "/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 9, ("基础生命恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"生命恢复", real), 1.00)))) + "/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 9, ("百分比生命恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"百分比生命回复", real), 100.00)))) + "%/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 9, ("生命恢复效率：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"生命恢复属性增幅", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 10, ("技能治疗效率：" + (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"技能治疗加成", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 10, ("受到治疗效率：" + (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"受到的治疗加成", real), 100.00)))) + "%")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 1, 11, ("当前魔法恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"总魔法恢复", real), 1.00)))) + "/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 2, 11, ("基础魔法恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔法恢复", real), 1.00)))) + "/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 3, 11, ("百分比魔法恢复：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"百分比魔法回复", real), 100.00)))) + "%/秒")))
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZAD], 4, 11, ("技能消耗减少：" + (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, ConvertedPlayer( ydul_DbfFGsylZyZAD),"魔法消耗减少", real), 100.00)))) + "%")))
		else
			call DoNothing()
		endif
		set ydul_DbfFGsylZyZAD = ydul_DbfFGsylZyZAD + 1
	endloop
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig________________SXDMB8_0Actions takes nothing returns nothing
	local integer ydul_DbfFGsylZyZD
	local timer ydl_timer
	YDLocalInitialize()
	//创建多面板与多面板项目命名
	set ydul_DbfFGsylZyZD = 1
	loop
		exitwhen ydul_DbfFGsylZyZD > 5
		if ((GetPlayerController( ConvertedPlayer( ydul_DbfFGsylZyZD)) == MAP_CONTROL_USER) and (GetPlayerSlotState( ConvertedPlayer( ydul_DbfFGsylZyZD)) == PLAYER_SLOT_STATE_PLAYING) and (GetPlayerSlotState( ConvertedPlayer( ydul_DbfFGsylZyZD)) != PLAYER_SLOT_STATE_LEFT) and (GetPlayerSlotState( ConvertedPlayer( ydul_DbfFGsylZyZD)) != PLAYER_SLOT_STATE_EMPTY)) then
			set udg_SXduomianban[ydul_DbfFGsylZyZD] = CreateMultiboard()
			call MultiboardSetTitleText( udg_SXduomianban[ydul_DbfFGsylZyZD], YDWEOperatorString3( "属性面板（", "难度：", YDWEOperatorString3( I2S( R2I( udg_N)), "）", ("游戏时间：" + YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[2]), "小时", YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[1]), "分", YDWEOperatorString3( I2S( udg_Time/*游戏时间*/[0]), "秒", "")))))))
			call MultiboardSetTitleTextColor( udg_SXduomianban[ydul_DbfFGsylZyZD], 255, 215, 0, 255)
			call MultiboardSetItemsWidth( udg_SXduomianban[ydul_DbfFGsylZyZD], 0.08)
			call MultiboardSetRowCount( udg_SXduomianban[ydul_DbfFGsylZyZD], 11)
			call MultiboardSetColumnCount( udg_SXduomianban[ydul_DbfFGsylZyZD], 4)
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 1, "TRIGSTR_10103")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 1, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 1, "TRIGSTR_10104")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 1, "ReplaceableTextures\\CommandButtons\\BTNSteelRanged.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 1, "TRIGSTR_10105")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 1, "ReplaceableTextures\\CommandButtons\\BTNNecromancerMaster.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 1, "TRIGSTR_10106")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 1, "ReplaceableTextures\\CommandButtons\\BTNTheBlackArrow.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 2, "TRIGSTR_10107")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 2, "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 2, "TRIGSTR_10108")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 2, "ReplaceableTextures\\CommandButtons\\BTNWitchDoctorMaster.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 2, "TRIGSTR_10109")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 2, "ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 2, "TRIGSTR_10110")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 2, "ReplaceableTextures\\CommandButtons\\BTNGrizzlyBear.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 3, "TRIGSTR_10111")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 3, "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 3, "TRIGSTR_10112")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 3, "ReplaceableTextures\\CommandButtons\\BTNHumanLumberUpgrade1.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 3, "TRIGSTR_10113")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 3, "ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 3, "TRIGSTR_10114")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 3, "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 4, "TRIGSTR_10115")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 4, "ReplaceableTextures\\CommandButtons\\BTNGatherGold.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 4, "TRIGSTR_10116")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 4, "ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 4, "TRIGSTR_10117")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 4, "ReplaceableTextures\\CommandButtons\\BTNResurrection.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 4, "TRIGSTR_10118")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 4, "ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 5, "TRIGSTR_10119")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 5, "ReplaceableTextures\\CommandButtons\\BTNCriticalStrike.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 5, "TRIGSTR_10120")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 5, "ReplaceableTextures\\CommandButtons\\BTNSmash.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 5, "TRIGSTR_10121")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 5, "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 5, "TRIGSTR_10122")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 5, "ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 6, "TRIGSTR_10123")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 6, "ReplaceableTextures\\CommandButtons\\BTNMarksmanship.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 6, "TRIGSTR_10124")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 6, "ReplaceableTextures\\PassiveButtons\\PASBTNEvasion.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 6, "TRIGSTR_10125")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 6, "ReplaceableTextures\\CommandButtons\\BTNStarWand.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 6, "TRIGSTR_10126")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 6, "ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 7, "TRIGSTR_10127")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 7, "ReplaceableTextures\\CommandButtons\\BTNGlove.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 7, "TRIGSTR_10128")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 7, "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 7, "TRIGSTR_10129")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 7, "ReplaceableTextures\\CommandButtons\\BTNStun.blp")
			call MultiboardSetItemStyleBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 7, true, false)
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 8, "TRIGSTR_10130")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 8, "ReplaceableTextures\\CommandButtons\\BTNMaskOfDeath.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 8, "TRIGSTR_10131")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 8, "ReplaceableTextures\\CommandButtons\\BTNManaDrain.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 8, "TRIGSTR_10132")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 8, "ReplaceableTextures\\CommandButtons\\BTNDevourMagic.blp")
			call MultiboardSetItemStyleBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 8, true, false)
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 9, "TRIGSTR_10133")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 9, "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 9, "TRIGSTR_10134")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 9, "ReplaceableTextures\\CommandButtons\\BTNRingSkull.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 9, "TRIGSTR_10135")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 9, "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 9, "TRIGSTR_10136")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 9, "ReplaceableTextures\\CommandButtons\\BTNReplenishHealthOff.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 10, "TRIGSTR_10137")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 10, "ReplaceableTextures\\CommandButtons\\BTNHealingWave.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 10, "TRIGSTR_10138")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 10, "ReplaceableTextures\\CommandButtons\\BTNHealingSpray.blp")
			call MultiboardSetItemStyleBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 10, true, false)
			call MultiboardSetItemStyleBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 10, true, false)
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 11, "TRIGSTR_10139")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 1, 11, "ReplaceableTextures\\CommandButtons\\BTNVialFull.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 11, "TRIGSTR_10140")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 2, 11, "ReplaceableTextures\\CommandButtons\\BTNSobiMask.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 11, "TRIGSTR_10141")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 3, 11, "ReplaceableTextures\\CommandButtons\\BTNBrilliance.blp")
			call MultiboardSetItemValueBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 11, "TRIGSTR_10142")
			call MultiboardSetItemIconBJ( udg_SXduomianban[ydul_DbfFGsylZyZD], 4, 11, "ReplaceableTextures\\CommandButtons\\BTNPriestAdept.blp")
		else
		endif
		if ((ConvertedPlayer( ydul_DbfFGsylZyZD) == GetLocalPlayer())) then
			call MultiboardDisplay( udg_SXduomianban[ydul_DbfFGsylZyZD], true)
		else
		endif
		set ydul_DbfFGsylZyZD = ydul_DbfFGsylZyZD + 1
	endloop
	//显示属性
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, real, "攻击间隔", YDLocal1Get(real, "攻击间隔"))
	call YDLocalSet(ydl_timer, integer, "整数", YDLocal1Get(integer, "整数"))
	call YDLocalSet(ydl_timer, real, "每秒攻速", YDLocal1Get(real, "每秒攻速"))
	call YDLocalSet(ydl_timer, real, "移动速度", YDLocal1Get(real, "移动速度"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 4.00, true, function Trig________________SXDMB8_0Func005T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 4.00, true," function Trig________________SXDMB8_0Func005T","属性多面板SXDMB8.0")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig________________SXDMB8_0 takes nothing returns nothing
	set gg_trg________________SXDMB8_0 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg________________SXDMB8_0,"属性多面板SXDMB8.0")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg________________SXDMB8_0, 1.00)
	call TriggerAddAction(gg_trg________________SXDMB8_0, function Trig________________SXDMB8_0Actions)
endfunction

