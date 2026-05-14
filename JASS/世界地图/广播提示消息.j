//===========================================================================
// Trigger: 未命名触发器 002
//===========================================================================
function Trig____________________002Actions takes nothing returns nothing
	local integer ydul_xh
	YDLocalInitialize()
	call YDLocal1Set(real, "wh", YDWEOperatorReal3( (16.00 / 9.00), /, (I2R( DzGetClientWidth()) / I2R( DzGetClientHeight())), *, 0.75))
	set udg_I_noticenumber/*消息编号*/[1] = 0
	set udg_I_noticenumber/*消息编号*/[2] = 0
	set udg_I_noticenumber/*消息编号*/[3] = 0
	set udg_I_noticenumber/*消息编号*/[4] = 0
	set ydul_xh = 0
	loop
		exitwhen ydul_xh > 20
		call YDLocal1Set(integer, "n1", YDWEOperatorInt3( ydul_xh, *, 3, +, 1))
		call YDLocal1Set(integer, "n2", YDWEOperatorInt3( ydul_xh, *, 3, +, 2))
		call YDLocal1Set(integer, "n3", YDWEOperatorInt3( ydul_xh, *, 3, +, 3))
		set udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")] = DzCreateFrameByTagName( "BACKDROP", "back", DzGetGameUI(), "template", 0)
		set udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n2")] = DzCreateFrameByTagName( "BACKDROP", "tb", udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], "template", 0)
		set udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")] = DzCreateFrameByTagName( "TEXT", "name", udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], "template", 0)
		call DzFrameSetTexture( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], "UInoticebackdrop.tga", 0)
		call DzFrameSetTexture( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n2")], "UInotice.tga", 0)
		call DzFrameSetText( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], "啊啊啊啊啊")
		call DzFrameSetSize( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n2")], (0.02 * YDLocal1Get(real, "wh")), 0.02)
		call DzFrameSetPoint( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n2")], 5, udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], 3, -0.002, 0.00)
		call DzFrameSetPoint( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], 8, udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], 8, 0.01, -0.002)
		call DzFrameSetPoint( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], 3, udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n2")], 3, -0.002, 0.00)
		call DzFrameSetFont( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], "zt.ttf", 0.012, 0)
		call DzFrameSetTextAlignment( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], 14)
		call DzFrameShow( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], false)
		set ydul_xh = ydul_xh + 1
	endloop
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig____________________002 takes nothing returns nothing
	set gg_trg____________________002 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________002,"未命名触发器 002")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg____________________002, 1.00)
	call TriggerAddAction(gg_trg____________________002, function Trig____________________002Actions)
endfunction
//===========================================================================
// Trigger: 未命名触发器 001
//===========================================================================
function Trig____________________001Func011Func012Func001Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), integer, "alpha", (YDLocalGet(GetExpiredTimer(), integer, "alpha") - 30))
	if ((YDLocalGet(GetExpiredTimer(), player, "player") == GetLocalPlayer())) then
		call DzFrameSetAlpha( udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "n1")], YDLocalGet(GetExpiredTimer(), integer, "alpha"))
	else
	endif
	if ((YDLocalGet(GetExpiredTimer(), integer, "alpha") <= 31)) then
		if ((YDLocalGet(GetExpiredTimer(), player, "player") == GetLocalPlayer())) then
			call DzFrameShow( udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "n1")], false)
		else
		endif
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________001Func011Func012Func001T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, player, "player", YDLocalGet(GetExpiredTimer(), player, "player"))
	call YDLocalSet(ydl_timer, integer, "index", YDLocalGet(GetExpiredTimer(), integer, "index"))
	call YDLocalSet(ydl_timer, integer, "n1", YDLocalGet(GetExpiredTimer(), integer, "n1"))
	call YDLocalSet(ydl_timer, integer, "alpha", 255)
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.03, true, function Trig____________________001Func011Func012Func001Func004T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.03, true," function Trig____________________001Func011Func012Func001Func004T","未命名触发器 001")
#endif 
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________001Func011T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), player, "w") == GetLocalPlayer())) then
		call DzFrameSetAbsolutePoint( udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "n3")], 3, YDLocalGet(GetExpiredTimer(), real, "x"), 0.28)
		if ((YDLocalGet(GetExpiredTimer(), integer, "index") != 1)) then
			call YDLocalSet(GetExpiredTimer(), integer, "indexup", (YDLocalGet(GetExpiredTimer(), integer, "index") - 1))
			call YDLocalSet(GetExpiredTimer(), integer, "nup", YDWEOperatorInt3( (YDLocalGet(GetExpiredTimer(), integer, "index") - 2), *, 3, +, 3))
		else
			call YDLocalSet(GetExpiredTimer(), integer, "indexup", (YDLocalGet(GetExpiredTimer(), integer, "index") + 20))
			call YDLocalSet(GetExpiredTimer(), integer, "nup", YDWEOperatorInt3( (YDLocalGet(GetExpiredTimer(), integer, "index") + 19), *, 3, +, 3))
		endif
		call DzFrameSetPoint( udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "nup")], 3, udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "n3")], 3, (udg_R_uiweiyi/*消息位移*/[(YDLocalGet(GetExpiredTimer(), integer, "index") - 1)] + YDLocalGet(GetExpiredTimer(), real, "x1")), 0.018)
		call DzFrameSetAlpha( udg_UI_notice/*系统提示UI*/[YDLocalGet(GetExpiredTimer(), integer, "n1")], YDLocalGet(GetExpiredTimer(), integer, "alpha"))
		set udg_R_uiweiyi/*消息位移*/[YDLocalGet(GetExpiredTimer(), integer, "index")] = (udg_R_uiweiyi/*消息位移*/[YDLocalGet(GetExpiredTimer(), integer, "index")] - 0.004)
	else
	endif
	call YDLocalSet(GetExpiredTimer(), real, "x", (YDLocalGet(GetExpiredTimer(), real, "x") - 0.004))
	call YDLocalSet(GetExpiredTimer(), real, "x1", (YDLocalGet(GetExpiredTimer(), real, "x1") + 0.004))
	call YDLocalSet(GetExpiredTimer(), integer, "alpha", (YDLocalGet(GetExpiredTimer(), integer, "alpha") + 10))
	if ((YDLocalGet(GetExpiredTimer(), real, "x") <= 0.10)) then
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, player, "player", YDLocalGet(GetExpiredTimer(), player, "player"))
		call YDLocalSet(ydl_timer, integer, "index", YDLocalGet(GetExpiredTimer(), integer, "index"))
		call YDLocalSet(ydl_timer, integer, "n1", YDLocalGet(GetExpiredTimer(), integer, "n1"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 3.00, false, function Trig____________________001Func011Func012Func001T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig____________________001Func011Func012Func001T","未命名触发器 001")
#endif 
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________001Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(player, "w", YDLocal1Get(player, "w"))
	call YDLocal1Set(integer, "id", GetConvertedPlayerId( YDLocal1Get(player, "w")))
	set udg_I_noticenumber/*消息编号*/[YDLocal1Get(integer, "id")] = (udg_I_noticenumber/*消息编号*/[YDLocal1Get(integer, "id")] + 1)
	call YDLocal1Set(integer, "index", udg_I_noticenumber/*消息编号*/[YDLocal1Get(integer, "id")])
	call YDLocal1Set(string, "str", YDUserDataGet(player, GetTriggerPlayer(),"消息", string))
	call YDLocal1Set(integer, "n1", YDWEOperatorInt3( (YDLocal1Get(integer, "index") - 1), *, 3, +, 1))
	call YDLocal1Set(integer, "n3", YDWEOperatorInt3( (YDLocal1Get(integer, "index") - 1), *, 3, +, 3))
	call YDLocal1Set(real, "x", 0.20)
	call YDLocal1Set(integer, "alpha", 5)
	if ((YDLocal1Get(player, "w") == GetLocalPlayer())) then
		call DzFrameShow( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], true)
		call DzFrameSetAbsolutePoint( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], 3, YDLocal1Get(real, "x"), 0.28)
		call DzFrameSetText( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n3")], YDLocal1Get(string, "str"))
		call DzFrameSetAlpha( udg_UI_notice/*系统提示UI*/[YDLocal1Get(integer, "n1")], YDLocal1Get(integer, "alpha"))
		set udg_R_uiweiyi/*消息位移*/[YDLocal1Get(integer, "index")] = 0.10
	else
	endif
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, real, "x", YDLocal1Get(real, "x"))
	call YDLocalSet(ydl_timer, real, "x1", -0.096)
	call YDLocalSet(ydl_timer, integer, "alpha", YDLocal1Get(integer, "alpha"))
	call YDLocalSet(ydl_timer, player, "player", YDLocal1Get(player, "player"))
	call YDLocalSet(ydl_timer, integer, "index", YDLocal1Get(integer, "index"))
	call YDLocalSet(ydl_timer, integer, "n1", YDLocal1Get(integer, "n1"))
	call YDLocalSet(ydl_timer, integer, "n3", YDLocal1Get(integer, "n3"))
	call YDLocalSet(ydl_timer, integer, "nup", YDLocal1Get(integer, "nup"))
	call YDLocalSet(ydl_timer, player, "w", YDLocal1Get(player, "w"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.01, true, function Trig____________________001Func011T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.01, true," function Trig____________________001Func011T","未命名触发器 001")
#endif 
	if ((udg_I_noticenumber/*消息编号*/[YDLocal1Get(integer, "id")] >= 21)) then
		set udg_I_noticenumber/*消息编号*/[YDLocal1Get(integer, "id")] = 0
	else
	endif
	call YDUserDataClear(player, YDLocal1Get(player, "w"),"消息", string)
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________001 takes nothing returns nothing
	set gg_trg____________________001 = CreateTrigger()
	call DisableTrigger(gg_trg____________________001)
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________001,"未命名触发器 001")
#endif
	call TriggerAddAction(gg_trg____________________001, function Trig____________________001Actions)
endfunction

//===========================================================================
// Trigger: 未命名触发器 003
//===========================================================================
function Trig____________________003Actions takes nothing returns nothing
	local integer ydl_triggerstep
	local trigger ydl_trigger
	YDLocalInitialize()
	call YDUserDataSet(player, GetTriggerPlayer(),"消息", string, "我是你的爸爸")
	set ydl_trigger = gg_trg____________________001
	YDLocalExecuteTrigger(ydl_trigger)
	call YDLocal5Set(player, "w", GetTriggerPlayer())
	call YDTriggerExecuteTrigger(ydl_trigger, true)
	call YDLocal1Release()
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig____________________003 takes nothing returns nothing
	set gg_trg____________________003 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________003,"未命名触发器 003")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________003, Player(0), "1", true)
	call TriggerAddAction(gg_trg____________________003, function Trig____________________003Actions)
endfunction


//===========================================================================
// Trigger: 未命名触发器 003 复制
//===========================================================================
function Trig____________________003_______uActions takes nothing returns nothing
	local integer ydl_triggerstep
	local trigger ydl_trigger
	YDLocalInitialize()
	call YDUserDataSet(player, GetTriggerPlayer(),"消息", string, "我是你的妈妈")
	set ydl_trigger = gg_trg____________________001
	YDLocalExecuteTrigger(ydl_trigger)
	call YDLocal5Set(player, "w", GetTriggerPlayer())
	call YDTriggerExecuteTrigger(ydl_trigger, true)
	call YDLocal1Release()
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig____________________003_______u takes nothing returns nothing
	set gg_trg____________________003_______u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________003_______u,"未命名触发器 003 复制")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________003_______u, Player(0), "2", true)
	call TriggerAddAction(gg_trg____________________003_______u, function Trig____________________003_______uActions)
endfunction

