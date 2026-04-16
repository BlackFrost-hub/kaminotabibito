//===========================================================================
// Trigger: CastBar（吟唱条）
//===========================================================================
function Trig_CastBar_______________uFunc003Func036T takes nothing returns nothing
	local integer star_loopA
	local integer star_loopIndex
	local integer star_hash
	local integer ydl_triggerstep
	local trigger ydl_trigger
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), real, "ss", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "ss"), OperatorRealDivide( 0.02, YDLocalGet(GetExpiredTimer(), real, "sj"))))
	call YDLocalSet(GetExpiredTimer(), real, "s", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "s"), 0.02))
	call DzFrameSetAnimateOffset( YDLocalGet(GetExpiredTimer(), frame, "前景"), OperatorRealSubtract( 1.00, YDLocalGet(GetExpiredTimer(), real, "ss")))
	set star_hash = StringHash( "NumberToString")
	set star_loopIndex = LoadInteger(STES_GetTable(),star_hash,skey_index)
	set star_loopA = 0
	loop
		exitwhen star_loopA>=star_loopIndex
		set ydl_trigger = LoadTriggerHandle(STES_GetTable(),star_hash,star_loopA) 
		YDLocalExecuteTrigger(ydl_trigger)
		call SaveInteger(YDHT,GetHandleId(ydl_trigger),SKey_PIndex,GetHandleId(GetExpiredTimer()))
		call YDLocal5Set(real, "amount", OperatorRealSubtract( YDLocalGet(GetExpiredTimer(), real, "sj"), YDLocalGet(GetExpiredTimer(), real, "s")))
		call YDTriggerExecuteTrigger(ydl_trigger, false)
		set star_loopA = star_loopA + 1
	endloop
	call DzFrameSetText( YDLocalGet(GetExpiredTimer(), frame, "倒计时"), StringBufferLoad())
	if ((YDLocalGet(GetExpiredTimer(), real, "s") >= YDLocalGet(GetExpiredTimer(), real, "sj"))) then
		call DzFrameShow( YDLocalGet(GetExpiredTimer(), frame, "前景"), false)
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "背景"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "显示文本"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "进度"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "中间符号"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "倒计时"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "文本提示"))
		call DzDestroyFrame( YDLocalGet(GetExpiredTimer(), frame, "前景"))
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
	set ydl_trigger = null
endfunction

function Trig_CastBar_______________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call DzFrameShow( YDUserDataGet(string, "上一个场地ui","ui", frame), false)
	call YDLocal1Set(frame, "前景", DzCreateFrameByTagName( "SPRITE", "吟唱条前景", DzGetGameUI(), "template", 0))
	call YDUserDataSet(string, "上一个场地ui","ui", frame, YDLocal1Get(frame, "前景"))
	if ((YDLocal1Get(integer, "颜色ID") == 1)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_gb2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 2)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_t1.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 3)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_o2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 4)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_r2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 5)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_p2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 6)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_g2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 7)) then
		call DzFrameSetModel( YDLocal1Get(frame, "前景"), "war3mapImported\\UI_shengmingzhi_b2.mdx", 0, 0)
	else
	endif
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "前景"), 4, 0.549, 0.2)
	call DzFrameSetAnimate( YDLocal1Get(frame, "前景"), 0, false)
	call DzFrameSetAnimateOffset( YDLocal1Get(frame, "前景"), 1.00)
	call DzFrameShow( YDLocal1Get(frame, "前景"), true)
	call YDLocal1Set(frame, "背景", DzCreateFrameByTagName( "SPRITE", "吟唱条背景", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetAbsolutePoint( YDLocal1Get(frame, "背景"), 4, 0.549, 0.2)
	if ((YDLocal1Get(integer, "颜色ID") == 1)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_gb2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 2)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_t1.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 3)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_o2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 4)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_r2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 5)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_p2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 6)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_g2.mdx", 0, 0)
	else
	endif
	if ((YDLocal1Get(integer, "颜色ID") == 7)) then
		call DzFrameSetModel( YDLocal1Get(frame, "背景"), "war3mapImported\\UI_shengmingzhi-beijing_b2.mdx", 0, 0)
	else
	endif
	call DzFrameSetPriority( YDLocal1Get(frame, "背景"), 0)
	call YDLocal1Set(frame, "显示文本", DzCreateFrameByTagName( "TEXT", "吟唱条文本", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetPoint( YDLocal1Get(frame, "显示文本"), 4, YDLocal1Get(frame, "前景"), 4, -0.148, 0.02)
	call DzFrameSetText( YDLocal1Get(frame, "显示文本"), "吟唱中")
	call DzFrameSetPriority( YDLocal1Get(frame, "显示文本"), 2)
	call YDLocal1Set(frame, "进度", DzCreateFrameByTagName( "TEXT", "吟唱条进度", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetPoint( YDLocal1Get(frame, "进度"), 4, YDLocal1Get(frame, "前景"), 4, -0.162, 0.005)
	call DzFrameSetText( YDLocal1Get(frame, "进度"), R2S( YDLocal1Get(real, "s")))
	call DzFrameSetPriority( YDLocal1Get(frame, "进度"), 2)
	call YDLocal1Set(frame, "中间符号", DzCreateFrameByTagName( "TEXT", "吟唱条符号", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetPoint( YDLocal1Get(frame, "中间符号"), 4, YDLocal1Get(frame, "前景"), 4, -0.15, 0.005)
	call DzFrameSetText( YDLocal1Get(frame, "中间符号"), "/")
	call DzFrameSetPriority( YDLocal1Get(frame, "中间符号"), 2)
	call YDLocal1Set(frame, "倒计时", DzCreateFrameByTagName( "TEXT", "吟唱条时间", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetPoint( YDLocal1Get(frame, "倒计时"), 4, YDLocal1Get(frame, "前景"), 4, -0.138, 0.005)
	call DzFrameSetText( YDLocal1Get(frame, "倒计时"), R2S( YDLocal1Get(real, "s")))
	call DzFrameSetPriority( YDLocal1Get(frame, "倒计时"), 2)
	call YDLocal1Set(frame, "文本提示", DzCreateFrameByTagName( "TEXT", "吟唱条文本提示", YDLocal1Get(frame, "前景"), "template", 0))
	call DzFrameSetPoint( YDLocal1Get(frame, "文本提示"), 4, YDLocal1Get(frame, "前景"), 0, -0.12, 0.005)
	call DzFrameSetText( YDLocal1Get(frame, "文本提示"), "场地技能：")
	if ((YDLocal1Get(string, "string") == "")) then
		call DzFrameSetText( YDLocal1Get(frame, "文本提示"), "场地技能：")
	else
		call DzFrameSetText( YDLocal1Get(frame, "文本提示"), YDLocal1Get(string, "string"))
	endif
	call DzFrameSetPriority( YDLocal1Get(frame, "文本提示"), 2)
	call YDLocal1Set(real, "s", 0.00)
	call YDLocal1Set(real, "ss", 0.00)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, real, "s", YDLocal1Get(real, "s"))
	call YDLocalSet(ydl_timer, real, "sj", YDLocal1Get(real, "sj"))
	call YDLocalSet(ydl_timer, real, "ss", YDLocal1Get(real, "ss"))
	call YDLocalSet(ydl_timer, frame, "中间符号", YDLocal1Get(frame, "中间符号"))
	call YDLocalSet(ydl_timer, frame, "倒计时", YDLocal1Get(frame, "倒计时"))
	call YDLocalSet(ydl_timer, frame, "前景", YDLocal1Get(frame, "前景"))
	call YDLocalSet(ydl_timer, frame, "文本提示", YDLocal1Get(frame, "文本提示"))
	call YDLocalSet(ydl_timer, frame, "显示文本", YDLocal1Get(frame, "显示文本"))
	call YDLocalSet(ydl_timer, frame, "背景", YDLocal1Get(frame, "背景"))
	call YDLocalSet(ydl_timer, frame, "进度", YDLocal1Get(frame, "进度"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.02, true, function Trig_CastBar_______________uFunc003Func036T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig_CastBar_______________uFunc003Func036T","CastBar（吟唱条）")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_CastBar_______________u takes nothing returns nothing
	set gg_trg_CastBar_______________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_CastBar_______________u,"CastBar（吟唱条）")
#endif
	call STES_Register(gg_trg_CastBar_______________u, "注册吟唱条")
	call TriggerAddAction(gg_trg_CastBar_______________u, function Trig_CastBar_______________uActions)
endfunction

