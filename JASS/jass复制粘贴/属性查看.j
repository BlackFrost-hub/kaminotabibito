//===========================================================================
// Trigger: 伤害统计and属性UI
//===========================================================================
function Trig_____________and______UIFunc002Func022Func001A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), player, "选取玩家", GetEnumPlayer())
	call YDLocalSet(GetExpiredTimer(), string, "1", I2S( R2I( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"造成伤害", real))))
	call YDLocalSet(GetExpiredTimer(), string, "2", I2S( R2I( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"承受伤害", real))))
	call YDLocalSet(GetExpiredTimer(), string, "3", I2S( R2I( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"治疗量", real))))
	call DzFrameSetText( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"伤害文本", frame), YDWEOperatorString3( "|cffff6600", YDLocalGet(GetExpiredTimer(), string, "1"), "|r"))
	call DzFrameSetText( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"承伤", frame), YDWEOperatorString3( "|cffffcc99", YDLocalGet(GetExpiredTimer(), string, "2"), "|r"))
	call DzFrameSetText( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "选取玩家"),"治疗", frame), YDWEOperatorString3( "|cffffffcc", YDLocalGet(GetExpiredTimer(), string, "3"), "|r"))
endfunction

function Trig_____________and______UIFunc002Func022T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_____________and______UIFunc002Func022Func001A)
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________and______UIFunc002Func023Conditions takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetTriggeringTrigger())
	set G_LIndex = G_SIndex
	#endif
	if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
		call DzFrameShow( YDUserDataGet(string, "伤害统计","frame", frame), true)
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________and______UIFunc002Func024Conditions takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetTriggeringTrigger())
	set G_LIndex = G_SIndex
	#endif
	if ((DzGetTriggerKeyPlayer() == GetLocalPlayer())) then
		call DzFrameShow( YDUserDataGet(string, "伤害统计","frame", frame), false)
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________and______UIFunc002Func025Conditions takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetTriggeringTrigger())
	set G_LIndex = G_SIndex
	#endif
	if ((DzIsKeyDown( 113) == true)) then
		call YDLocalSet(GetTriggeringTrigger(), unit, "DW", YDUserDataGet(string, "F2","YX", unit))
	else
		if ((DzIsKeyDown( 114) == true)) then
			call YDLocalSet(GetTriggeringTrigger(), unit, "DW", YDUserDataGet(string, "F3","YX", unit))
		else
			if ((DzIsKeyDown( 115) == true)) then
				call YDLocalSet(GetTriggeringTrigger(), unit, "DW", YDUserDataGet(string, "F4","YX", unit))
			else
				if ((DzIsKeyDown( 116) == true)) then
					call YDLocalSet(GetTriggeringTrigger(), unit, "DW", YDUserDataGet(string, "F5","YX", unit))
				else
					if ((DzIsKeyDown( 117) == true)) then
						call YDLocalSet(GetTriggeringTrigger(), unit, "DW", YDUserDataGet(string, "F6","YX", unit))
					else
					endif
				endif
			endif
		endif
	endif
	if ((YDLocalGet(GetTriggeringTrigger(), unit, "DW") != null)) then
		call StarOther_PanCameraToTimedForPlayer( DzGetTriggerKeyPlayer(), GetUnitX( YDLocalGet(GetTriggeringTrigger(), unit, "DW")), GetUnitY( YDLocalGet(GetTriggeringTrigger(), unit, "DW")), 0.05)
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________and______UIFunc003Func002Func002Func018Func061T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "物理"), YDWEOperatorString3( YDWEOperatorString3( "|cff993300物理伤害：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"物理伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"物理伤害减免", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cff993300护甲穿透：|r", I2S( R2I( OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"护穿", real), 100.00))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "魔法"), YDWEOperatorString3( YDWEOperatorString3( "|cff00ccff魔法伤害：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔法伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( (100.00 - (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔抗", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cff00ccff魔法穿透：|r", I2S( R2I( OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔法穿透", real), 100.00))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "技能"), YDWEOperatorString3( YDWEOperatorString3( "|cffff6800技能伤害：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"技能伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( (100.00 - (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"技能伤害减少", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cffff6600强化伤害：|r", I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"强化伤害加成", real), 100.00)))), ("%" + (I2S( R2I( (100.00 - 0.00))) + "%")))))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "召唤"), YDWEOperatorString3( YDWEOperatorString3( "|cff333333召唤物伤害：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"召唤物伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"召唤物伤害减少", real) * 100.00)))) + "%"))), " ", ""))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "属性"), YDWEOperatorString3( YDWEOperatorString3( "|cffff0000火属性：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"火焰伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"火属性伤害减少", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cff00ffff冰属性：|r", I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"水属性伤害加成", real), 100.00)))), ("%/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"水属性伤害减少", real) * 100.00)))) + "%")))))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "属性2"), YDWEOperatorString3( YDWEOperatorString3( "|cffccffff雷属性：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"雷属性伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"雷属性伤害减少", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cff99cc00风属性：|r", I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"木属性伤害加成", real), 100.00)))), ("%/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"风属性伤害减少", real) * 100.00)))) + "%")))))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "属性3"), YDWEOperatorString3( YDWEOperatorString3( "|cffffff00光属性：|r", (I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"光属性伤害加成", real), 100.00)))) + "%"), ("/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"光属性伤害减少", real) * 100.00)))) + "%"))), " ", YDWEOperatorString3( "|cff993366暗属性：|r", I2S( R2I( OperatorRealAdd( 100.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"暗属性伤害加成", real), 100.00)))), ("%/" + (I2S( R2I( OperatorRealSubtract( 100.00, (YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"暗属性伤害减少", real) * 100.00)))) + "%")))))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "暴击"), YDWEOperatorString3( YDWEOperatorString3( "|cffff0000暴击率：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"暴击率", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cffff0000暴击伤害：|r", I2S( R2I( OperatorRealAdd( 150.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"暴击伤害加成", real), 100.00)))), ("%" + ""))))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "被暴击"), YDWEOperatorString3( YDWEOperatorString3( "|cffff0000被暴击率：-|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"被暴击率减少", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cffff0000被暴击伤害：-|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"暴击伤害减免", real), 100.00)))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "闪避命中"), YDWEOperatorString3( YDWEOperatorString3( "|cffff8080命中率：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"命中率", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cffff8080闪避率：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"闪避率", real), 100.00)))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "冷却缩减"), YDWEOperatorString3( YDWEOperatorString3( "|cffff8080冷却缩减：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"冷却缩减", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cff99ccff固定伤害减少：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"伤害减少", real), 1.00)))), "")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "速度"), YDWEOperatorString3( YDWEOperatorString3( "|cff99ccff攻击速度：|r", (R2S( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"每秒攻速", real)) + "次/秒"), " "), " ", YDWEOperatorString3( "|cff99ccff移动速度：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"移动速度", real), 1.00)))), "")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "眩晕抗性"), YDWEOperatorString3( YDWEOperatorString3( "|cff99ccff眩晕抗性：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"减少控制时间", real), 100.00)))) + "%"), ("" + "")), " ", ""))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "吸血"), YDWEOperatorString3( YDWEOperatorString3( "|cffff0000普攻吸血：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"普通攻击吸血", real), 100.00)))) + "%"), " "), " ", YDWEOperatorString3( "|cffff0000魔法吸血：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔法伤害吸血", real), 100.00)))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "伤害吸血"), YDWEOperatorString3( YDWEOperatorString3( "|cffff0000伤害吸血：|r", (I2S( R2I( OperatorRealAdd( 0.01, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"伤害吸血", real), 100.00)))) + "%"), ""), " ", ""))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "回血"), YDWEOperatorString3( YDWEOperatorString3( "|cffccffcc当前回血：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"总生命恢复", real), 1.00)))) + "/秒"), ""), " ", YDWEOperatorString3( "|cffccffcc基础生命恢复：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"生命恢复", real), 1.00)))), "/秒")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "回血B"), YDWEOperatorString3( YDWEOperatorString3( "|cffccffcc百分比回血：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"百分比生命回复", real), 100.00)))) + "%/秒"), ""), " ", YDWEOperatorString3( "|cffccffcc生命恢复效率：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"生命恢复属性增幅", real), 100.00)))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "治疗"), YDWEOperatorString3( YDWEOperatorString3( "|cffffcc99技能治疗效率：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"技能治疗加成", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cffffcc99受到治疗效率：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"受到的治疗加成", real), 100.00)))), "%")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "回魔"), YDWEOperatorString3( YDWEOperatorString3( "|cffccffcc总魔法恢复|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"总魔法恢复", real), 1.00)))) + "/秒"), ""), " ", YDWEOperatorString3( "|cffccffff基础魔法恢复|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔法恢复", real), 1.00)))), "/秒")))
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "回魔B"), YDWEOperatorString3( YDWEOperatorString3( "|cffccffff百分比回魔：|r", (I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"百分比魔法回复", real), 100.00)))) + "%"), ""), " ", YDWEOperatorString3( "|cffccffff技能消耗减少：|r", I2S( R2I( OperatorRealAdd( 0.00, OperatorRealMultiply( YDUserDataGet(player, YDLocalGet(GetExpiredTimer(), player, "WJ"),"魔法消耗减少", real), 100.00)))), "%")))
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func001Func002003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(4),"文本", frame), true)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func001Func003003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(4),"文本", frame), false)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func003003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(3),"文本", frame), true)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func004003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(3),"文本", frame), false)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func003003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(2),"文本", frame), true)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func004003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(2),"文本", frame), false)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func003003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(1),"文本", frame), true)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func001Func004003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(1),"文本", frame), false)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func003003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(0),"文本", frame), true)
endfunction

function Trig_____________and______UIFunc003Func002Func002Func023Func004003 takes nothing returns nothing
	call DzFrameShow( YDUserDataGet(player, Player(0),"文本", frame), false)
endfunction

function Trig_____________and______UIActions takes nothing returns nothing
	local integer ydul_C
	local timer ydl_timer
	local trigger ydl_trigger
	local integer ydul_A
	YDLocalInitialize()
	call YDLocal1Set(integer, "T", R2I( udg_T))
	call YDLocal1Set(frame, "伤害统计", DzCreateFrameByTagName( "BACKDROP", "主线任务", DzGetGameUI(), "template", 0))
	call DzFrameSetTexture( YDLocal1Get(frame, "伤害统计"), "war3mapImported\\wenbenkuang.blp", 0)
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "伤害统计"), 4, 0.6775, 0.3311028)
	call DzFrameSetSize( YDLocal1Get(frame, "伤害统计"), 0.2308336, 0.19)
	call DzFrameShow( YDLocal1Get(frame, "伤害统计"), false)
	call DzFrameSetAlpha( YDLocal1Get(frame, "伤害统计"), 210)
	call YDLocal1Set(frame, "文本A", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "文本A"), 4, 0.62, (0.4091424 - 0.00))
	call DzFrameSetText( YDLocal1Get(frame, "文本A"), "对Boss伤害")
	call DzFrameSetFont( YDLocal1Get(frame, "文本A"), "war3mapImported\\uizt.ttf", 0.012, 0)
	call YDLocal1Set(frame, "文本B", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "文本B"), 4, 0.68, (0.4091424 - 0.00))
	call DzFrameSetText( YDLocal1Get(frame, "文本B"), "承受Boss伤害")
	call DzFrameSetFont( YDLocal1Get(frame, "文本B"), "war3mapImported\\uizt.ttf", 0.012, 0)
	call YDLocal1Set(frame, "文本C", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "文本C"), 4, 0.74, (0.4091424 - 0.00))
	call DzFrameSetText( YDLocal1Get(frame, "文本C"), "治疗队友")
	call DzFrameSetFont( YDLocal1Get(frame, "文本C"), "war3mapImported\\uizt.ttf", 0.012, 0)
	call YDUserDataSet(string, "伤害统计","Frame", frame, YDLocal1Get(frame, "伤害统计"))
	call YDLocal1Set(integer, "ZS", 0)
	set ydul_C = 1
	loop
		exitwhen ydul_C > 5
		call YDLocal1Set(player, "WJ2", ConvertedPlayer( ydul_C))
		if ((GetPlayerSlotState( ConvertedPlayer( ydul_C)) == PLAYER_SLOT_STATE_PLAYING)) then
			call YDLocal1Set(integer, "ZS", OperatorIntegerAdd( YDLocal1Get(integer, "ZS"), 1))
			call YDLocal1Set(unit, "YX", YDUserDataGet(player, YDLocal1Get(player, "WJ2"),"英雄", unit))
			call YDUserDataSet(string, ("F" + I2S( OperatorIntegerAdd( YDLocal1Get(integer, "ZS"), 1))),"YX", unit, YDLocal1Get(unit, "YX"))
			call YDLocal1Set(frame, "英雄头像", DzCreateFrameByTagName( "BACKDROP", "主线任务", YDLocal1Get(frame, "伤害统计"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "英雄头像"), 4, 0.574792, (0.382 - (0.028275 * I2R( OperatorIntegerSubtract( YDLocal1Get(integer, "ZS"), 1)))))
			call DzFrameSetTexture( YDLocal1Get(frame, "英雄头像"), YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocal1Get(unit, "YX")), "Art"), 0)
			call DzFrameSetSize( YDLocal1Get(frame, "英雄头像"), 0.0187504, 0.026013)
			call DzFrameShow( YDLocal1Get(frame, "英雄头像"), true)
			call YDLocal1Set(frame, "伤害文本", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "伤害文本"), 4, 0.62, (0.4091424 - (0.028275 * I2R( YDLocal1Get(integer, "ZS")))))
			call DzFrameSetText( YDLocal1Get(frame, "伤害文本"), "0")
			call YDLocal1Set(frame, "承伤", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "承伤"), 4, 0.68, (0.4091424 - (0.028275 * I2R( YDLocal1Get(integer, "ZS")))))
			call DzFrameSetText( YDLocal1Get(frame, "承伤"), "0")
			call YDLocal1Set(frame, "治疗", DzCreateFrameByTagName( "TEXT", "主线任务提示文本", YDLocal1Get(frame, "伤害统计"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "治疗"), 4, 0.74, (0.4091424 - (0.028275 * I2R( YDLocal1Get(integer, "ZS")))))
			call DzFrameSetText( YDLocal1Get(frame, "治疗"), "0")
			call YDUserDataSet(player, YDLocal1Get(player, "WJ2"),"伤害文本", frame, YDLocal1Get(frame, "伤害文本"))
			call YDUserDataSet(player, YDLocal1Get(player, "WJ2"),"承伤", frame, YDLocal1Get(frame, "承伤"))
			call YDUserDataSet(player, YDLocal1Get(player, "WJ2"),"治疗", frame, YDLocal1Get(frame, "治疗"))
		else
		endif
		set ydul_C = ydul_C + 1
	endloop
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, string, "1", YDLocal1Get(string, "1"))
	call YDLocalSet(ydl_timer, string, "2", YDLocal1Get(string, "2"))
	call YDLocalSet(ydl_timer, string, "3", YDLocal1Get(string, "3"))
	call YDLocalSet(ydl_timer, player, "选取玩家", YDLocal1Get(player, "选取玩家"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 3.00, true, function Trig_____________and______UIFunc002Func022T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 3.00, true," function Trig_____________and______UIFunc002Func022T","伤害统计and属性UI")
#endif 
	set ydl_trigger = CreateTrigger()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_trigger)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 1, 9)
	call TriggerAddCondition( ydl_trigger, Condition(function Trig_____________and______UIFunc002Func023Conditions))
	set ydl_trigger = CreateTrigger()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_trigger)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 9)
	call TriggerAddCondition( ydl_trigger, Condition(function Trig_____________and______UIFunc002Func024Conditions))
	set ydl_trigger = CreateTrigger()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_trigger)
#endif
	call YDLocalSet(ydl_trigger, unit, "DW", YDLocal1Get(unit, "DW"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 113)
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 114)
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 115)
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 116)
	call DzTriggerRegisterKeyEventTrg(ydl_trigger, 0, 117)
	call TriggerAddCondition( ydl_trigger, Condition(function Trig_____________and______UIFunc002Func025Conditions))
	call YDLocal1Set(integer, "ZS2", 0)
	set ydul_A = 2
	loop
		exitwhen ydul_A > 6
		call YDLocal1Set(player, "WJ", ConvertedPlayer( (ydul_A - 1)))
		if ((GetPlayerSlotState( YDLocal1Get(player, "WJ")) == PLAYER_SLOT_STATE_PLAYING)) then
			call YDLocal1Set(integer, "ZS2", OperatorIntegerAdd( YDLocal1Get(integer, "ZS2"), 1))
			call YDLocal1Set(unit, "YX2", YDUserDataGet(player, YDLocal1Get(player, "WJ"),"英雄", unit))
			call YDLocal1Set(frame, "英雄头像", DzCreateFrameByTagName( "BACKDROP", "主线任务", DzGetGameUI(), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "英雄头像"), 4, OperatorRealAdd( 0.01, (I2R( OperatorIntegerAdd( YDLocal1Get(integer, "ZS2"), 1)) * 0.027)), 0.560415)
			call DzFrameSetSize( YDLocal1Get(frame, "英雄头像"), 0.023, 0.023)
			call DzFrameSetTexture( YDLocal1Get(frame, "英雄头像"), YDWEGetObjectPropertyString( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocal1Get(unit, "YX2")), "Art"), 0)
			call DzFrameShow( YDLocal1Get(frame, "英雄头像"), true)
			call YDLocal1Set(frame, "按键", DzCreateFrameByTagName( "TEXT", "任务提示", YDLocal1Get(frame, "英雄头像"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "按键"), 4, OperatorRealAdd( 0.01, (I2R( OperatorIntegerAdd( YDLocal1Get(integer, "ZS2"), 1)) * 0.027)), 0.540415)
			call DzFrameSetText( YDLocal1Get(frame, "按键"), ("|cffffff00" + ("F" + (I2S( OperatorIntegerAdd( YDLocal1Get(integer, "ZS2"), 1)) + "|r"))))
			call YDLocal1Set(frame, "文本框", DzCreateFrameByTagName( "BACKDROP", "主线任务文本框", YDLocal1Get(frame, "英雄头像"), "template", 0))
			call DzFrameSetTexture( YDLocal1Get(frame, "文本框"), "war3mapImported\\wenbenkuang.blp", 0)
			call DzFrameSetSize( YDLocal1Get(frame, "文本框"), 0.18, 0.30)
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "文本框"), 4, 0.118, 0.4077288)
			call DzFrameShow( YDLocal1Get(frame, "文本框"), true)
			call DzFrameShow( YDLocal1Get(frame, "文本框"), false)
			call DzFrameSetFont( YDLocal1Get(frame, "文本框"), "war3mapImported\\uizt.ttf", 0.009, 0)
			call YDLocal1Set(frame, "物理", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "物理"), 4, 0.0758336, 0.5363808)
			call DzFrameSetSize( YDLocal1Get(frame, "物理"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "魔法", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "魔法"), 4, 0.1545832, 0.5363808)
			call DzFrameSetSize( YDLocal1Get(frame, "魔法"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "技能", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "技能"), 4, 0.0754168, 0.5160228)
			call DzFrameSetSize( YDLocal1Get(frame, "技能"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "召唤", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "召唤"), 4, 0.1541664, 0.5160228)
			call DzFrameSetSize( YDLocal1Get(frame, "召唤"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "属性", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "属性"), 4, 0.0754168, 0.4956642)
			call DzFrameSetSize( YDLocal1Get(frame, "属性"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "属性2", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "属性2"), 4, 0.1537504, 0.4956642)
			call DzFrameSetSize( YDLocal1Get(frame, "属性2"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "属性3", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "属性3"), 4, 0.0758336, 0.4753062)
			call DzFrameSetSize( YDLocal1Get(frame, "属性3"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "暴击", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "暴击"), 4, 0.0758336, 0.4549482)
			call DzFrameSetSize( YDLocal1Get(frame, "暴击"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "被暴击", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "被暴击"), 4, 0.1545832, 0.4549482)
			call DzFrameSetSize( YDLocal1Get(frame, "被暴击"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "闪避命中", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "闪避命中"), 4, 0.0758336, 0.4345902)
			call DzFrameSetSize( YDLocal1Get(frame, "闪避命中"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "冷却缩减", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "冷却缩减"), 4, 0.1545832, 0.4345902)
			call DzFrameSetSize( YDLocal1Get(frame, "冷却缩减"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "速度", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "速度"), 4, 0.0758336, 0.4142316)
			call DzFrameSetSize( YDLocal1Get(frame, "速度"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "眩晕抗性", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "眩晕抗性"), 4, 0.1545832, 0.4142316)
			call DzFrameSetSize( YDLocal1Get(frame, "眩晕抗性"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "吸血", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "吸血"), 4, 0.0758336, 0.3938736)
			call DzFrameSetSize( YDLocal1Get(frame, "吸血"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "伤害吸血", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "伤害吸血"), 4, 0.1545832, 0.3944394)
			call DzFrameSetSize( YDLocal1Get(frame, "伤害吸血"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "回血", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "回血"), 4, 0.0758336, 0.3735156)
			call DzFrameSetSize( YDLocal1Get(frame, "回血"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "回血B", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "回血B"), 4, 0.1545832, 0.3735156)
			call DzFrameSetSize( YDLocal1Get(frame, "回血B"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "治疗", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "治疗"), 4, 0.0758336, 0.3531576)
			call DzFrameSetSize( YDLocal1Get(frame, "治疗"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "回魔", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "回魔"), 4, 0.0758336, 0.332799)
			call DzFrameSetSize( YDLocal1Get(frame, "回魔"), 0.0766664, 0.0186618)
			call YDLocal1Set(frame, "回魔B", DzCreateFrameByTagName( "TEXT", "1", YDLocal1Get(frame, "文本框"), "template", 0))
			call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "回魔B"), 4, 0.1545832, 0.332799)
			call DzFrameSetSize( YDLocal1Get(frame, "回魔B"), 0.0766664, 0.0186618)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, player, "WJ", YDLocal1Get(player, "WJ"))
			call YDLocalSet(ydl_timer, frame, "伤害吸血", YDLocal1Get(frame, "伤害吸血"))
			call YDLocalSet(ydl_timer, frame, "冷却缩减", YDLocal1Get(frame, "冷却缩减"))
			call YDLocalSet(ydl_timer, frame, "召唤", YDLocal1Get(frame, "召唤"))
			call YDLocalSet(ydl_timer, frame, "吸血", YDLocal1Get(frame, "吸血"))
			call YDLocalSet(ydl_timer, frame, "回血", YDLocal1Get(frame, "回血"))
			call YDLocalSet(ydl_timer, frame, "回血B", YDLocal1Get(frame, "回血B"))
			call YDLocalSet(ydl_timer, frame, "回魔", YDLocal1Get(frame, "回魔"))
			call YDLocalSet(ydl_timer, frame, "回魔B", YDLocal1Get(frame, "回魔B"))
			call YDLocalSet(ydl_timer, frame, "属性", YDLocal1Get(frame, "属性"))
			call YDLocalSet(ydl_timer, frame, "属性2", YDLocal1Get(frame, "属性2"))
			call YDLocalSet(ydl_timer, frame, "属性3", YDLocal1Get(frame, "属性3"))
			call YDLocalSet(ydl_timer, frame, "技能", YDLocal1Get(frame, "技能"))
			call YDLocalSet(ydl_timer, frame, "暴击", YDLocal1Get(frame, "暴击"))
			call YDLocalSet(ydl_timer, frame, "治疗", YDLocal1Get(frame, "治疗"))
			call YDLocalSet(ydl_timer, frame, "物理", YDLocal1Get(frame, "物理"))
			call YDLocalSet(ydl_timer, frame, "眩晕抗性", YDLocal1Get(frame, "眩晕抗性"))
			call YDLocalSet(ydl_timer, frame, "被暴击", YDLocal1Get(frame, "被暴击"))
			call YDLocalSet(ydl_timer, frame, "速度", YDLocal1Get(frame, "速度"))
			call YDLocalSet(ydl_timer, frame, "闪避命中", YDLocal1Get(frame, "闪避命中"))
			call YDLocalSet(ydl_timer, frame, "魔法", YDLocal1Get(frame, "魔法"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 3.00, true, function Trig_____________and______UIFunc003Func002Func002Func018Func061T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 3.00, true," function Trig_____________and______UIFunc003Func002Func002Func018Func061T","伤害统计and属性UI")
#endif 
			call YDLocal1Set(frame, "按钮", DzCreateFrameByTagName( "GLUETEXTBUTTON", "主线按钮", YDLocal1Get(frame, "英雄头像"), "template", 0))
			call DzFrameSetPoint( YDLocal1Get(frame, "按钮"), 4, YDLocal1Get(frame, "英雄头像"), 4, 0, 0)
			call DzFrameSetSize( YDLocal1Get(frame, "按钮"), 0.035, 0.035)
			call YDUserDataSet(player, YDLocal1Get(player, "WJ"),"文本", frame, YDLocal1Get(frame, "文本框"))
			if ((Player(0) == YDLocal1Get(player, "WJ"))) then
				call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 2, function Trig_____________and______UIFunc003Func002Func002Func023Func003003, false)
				call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 3, function Trig_____________and______UIFunc003Func002Func002Func023Func004003, false)
			else
				if ((Player(1) == YDLocal1Get(player, "WJ"))) then
					call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 2, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func003003, false)
					call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 3, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func004003, false)
				else
					if ((Player(2) == YDLocal1Get(player, "WJ"))) then
						call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 2, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func003003, false)
						call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 3, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func004003, false)
					else
						if ((Player(3) == YDLocal1Get(player, "WJ"))) then
							call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 2, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func003003, false)
							call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 3, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func004003, false)
						else
							if ((Player(4) == YDLocal1Get(player, "WJ"))) then
								call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 2, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func001Func002003, false)
								call DzFrameSetScriptByCode( YDLocal1Get(frame, "按钮"), 3, function Trig_____________and______UIFunc003Func002Func002Func023Func001Func001Func001Func001Func003003, false)
							else
							endif
						endif
					endif
				endif
			endif
		else
		endif
		set ydul_A = ydul_A + 1
	endloop
	call YDLocal1Release()
	set ydl_timer = null
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig_____________and______UI takes nothing returns nothing
	set gg_trg_____________and______UI = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_____________and______UI,"伤害统计and属性UI")
#endif
	call TriggerAddAction(gg_trg_____________and______UI, function Trig_____________and______UIActions)
endfunction

