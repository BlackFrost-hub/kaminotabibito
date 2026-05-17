//===========================================================================
// Trigger: 玩家开启宝箱时BX2
//===========================================================================
function Trig______________________BX2Func002Func001Func001Func001Func001Func002Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "bs"),"hh", boolean, true)
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig______________________BX2Actions takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(unit, "预开启者", YDLocal1Get(unit, "预开启者"))
	call YDLocal1Set(destructable, "被预开启的宝箱", YDLocal1Get(destructable, "被预开启的宝箱"))
	call YDLocal1Set(real, "X", GetUnitX( YDLocal1Get(unit, "预开启者")))
	call YDLocal1Set(real, "Y", GetUnitY( YDLocal1Get(unit, "预开启者")))
	if ((GetDestructableTypeId( YDLocal1Get(destructable, "被预开启的宝箱")) == 'B00Z')) then
		set ydl_group = CreateGroup()
		call GroupEnumUnitsInRange(ydl_group, YDLocal1Get(real, "X"), YDLocal1Get(real, "Y"), 3000.00, null)
		loop
			set ydl_unit = FirstOfGroup(ydl_group)
			exitwhen ydl_unit == null
			call GroupRemoveUnit(ydl_group, ydl_unit)
			if ((GetUnitTypeId( ydl_unit) == 'N01Y')) then
				call YDLocal1Set(unit, "bs", ydl_unit)
				if ((YDUserDataGet(unit, YDLocal1Get(unit, "bs"),"hh", boolean) == false)) then
					call YDUserDataSet(unit, YDLocal1Get(unit, "bs"),"hh", boolean, true)
					if ((GetRandomInt( 1, 2) == 1)) then
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( YDLocal1Get(unit, "bs")), null, ("小老鼠" + (YDWEOperatorString3( "（", GetUnitName( YDLocal1Get(unit, "预开启者")), "）") + "，也太目中无人了吧？")), bj_TIMETYPE_SET, 4.00, false)
					else
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( YDLocal1Get(unit, "bs")), null, ("嘿嘿..有个贪婪的家伙" + (YDWEOperatorString3( "（", GetUnitName( YDLocal1Get(unit, "预开启者")), "）") + "仆从们，吞噬他！")), bj_TIMETYPE_SET, 4.00, false)
					endif
					//YDTrigger Error:不要嵌套使用<逆天--选取单位>
					set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
					call YDLocalSet(ydl_timer, unit, "bs", YDLocal1Get(unit, "bs"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
					call TimerStart(ydl_timer, 5.00, false, function Trig______________________BX2Func002Func001Func001Func001Func001Func002Func004T)
#ifdef StarDebuggerIncluded 
					call  SDR_DebugTimer(ydl_timer, 5.00, false," function Trig______________________BX2Func002Func001Func001Func001Func001Func002Func004T","玩家开启宝箱时BX2")
#endif 
				else
				endif
			else
			endif
		endloop
		call DestroyGroup(ydl_group)
	else
	endif
	call YDLocal1Release()
	set ydl_group = null
	set ydl_unit = null
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig______________________BX2 takes nothing returns nothing
	set gg_trg______________________BX2 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg______________________BX2,"玩家开启宝箱时BX2")
#endif
	call STES_Register(gg_trg______________________BX2, "玩家准备开启宝箱")
	call TriggerAddAction(gg_trg______________________BX2, function Trig______________________BX2Actions)
endfunction

//===========================================================================
// Trigger: 宝箱被打开BX
//===========================================================================
function Trig________________BXFunc002Func001Func001Func001Func001Func002Func003T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "bs"),"hh2", boolean, true)
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig________________BXActions takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(unit, "开启者", YDLocal1Get(unit, "开启者"))
	call YDLocal1Set(destructable, "被开启的宝箱", YDLocal1Get(destructable, "被开启的宝箱"))
	call YDLocal1Set(real, "X", GetUnitX( YDLocal1Get(unit, "开启者")))
	call YDLocal1Set(real, "Y", GetUnitY( YDLocal1Get(unit, "开启者")))
	call YDLocal1Set(real, "X2", GetDestructableX( YDLocal1Get(destructable, "被开启的宝箱")))
	call YDLocal1Set(real, "Y2", GetDestructableY( YDLocal1Get(destructable, "被开启的宝箱")))
	call RemoveDestructable( YDLocal1Get(destructable, "被开启的宝箱"))
	if ((GetDestructableTypeId( YDLocal1Get(destructable, "被开启的宝箱")) == 'B00Z')) then
		set ydl_group = CreateGroup()
		call GroupEnumUnitsInRange(ydl_group, YDLocal1Get(real, "X"), YDLocal1Get(real, "Y"), 2500.00, null)
		loop
			set ydl_unit = FirstOfGroup(ydl_group)
			exitwhen ydl_unit == null
			call GroupRemoveUnit(ydl_group, ydl_unit)
			if ((GetUnitTypeId( ydl_unit) == 'N01Y')) then
				call YDLocal1Set(unit, "bs", ydl_unit)
				if ((YDUserDataGet(unit, YDLocal1Get(unit, "bs"),"hh2", boolean) == false)) then
					call YDUserDataSet(unit, YDLocal1Get(unit, "bs"),"hh2", boolean, true)
					if ((GetRandomInt( 1, 2) == 1)) then
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( YDLocal1Get(unit, "bs")), null, ("小家伙" + (udg_String/*常量字符串*/[OperatorIntegerAdd( GetPlayerId( YDLocal1Get(player, "预开启者")), 1)] + "还真被你得手了，可恶！（莫斯特永久提高3%基础攻击力）")), bj_TIMETYPE_SET, 4.00, false)
					else
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( YDLocal1Get(unit, "bs")), null, ("老子的珍藏！你" + (YDWEOperatorString3( "（", udg_String/*常量字符串*/[OperatorIntegerAdd( GetPlayerId( YDLocal1Get(player, "预开启者")), 1)], "）") + "成功惹怒了我！（莫斯特永久提高3%基础攻击力）")), bj_TIMETYPE_SET, 4.00, false)
					endif
					set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
					call YDLocalSet(ydl_timer, unit, "bs", YDLocal1Get(unit, "bs"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
					call TimerStart(ydl_timer, 5.00, false, function Trig________________BXFunc002Func001Func001Func001Func001Func002Func003T)
#ifdef StarDebuggerIncluded 
					call  SDR_DebugTimer(ydl_timer, 5.00, false," function Trig________________BXFunc002Func001Func001Func001Func001Func002Func003T","宝箱被打开BX")
#endif 
				else
				endif
			else
			endif
		endloop
		call DestroyGroup(ydl_group)
	else
	endif
	if ((GetDestructableTypeId( YDLocal1Get(destructable, "被开启的宝箱")) == 'B00Z')) then
		call YDLocal1Set(integer, "sjzs", 0)
		if ((YDLocal1Get(integer, "sjzs") <= 30)) then
			call CreateItem( 'azhr', YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"))
			if ((GetRandomInt( 1, 2) == 1)) then
				call CreateItem( 'rdis', YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"))
			else
				call CreateItem( 'I01B', YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"))
			endif
		else
		endif
		if ((YDLocal1Get(integer, "sjzs") > 30) and (YDLocal1Get(integer, "sjzs") <= 55)) then
			call CreateItem( 'gold', YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"))
		else
		endif
		if ((YDLocal1Get(integer, "sjzs") > 55) and (YDLocal1Get(integer, "sjzs") <= 80)) then
			call YDLocal1Set(real, "sjss", GetRandomReal( 0.01, 1))
			//D
			call StringBufferAdd( udg_String/*常量字符串*/[0])
			call StringBufferAdd( udg_String/*常量字符串*/[GetConvertedPlayerId( GetTriggerPlayer())])
			call StringBufferAdd( "通过盗贼宝箱开到了")
			if ((YDLocal1Get(real, "sjss") >= 0.55)) then
				call StringBufferAdd( udg_String/*常量字符串*/[13])
				call YDLocal1Set(real, "sjss2", GetRandomReal( 0.01, 1))
				if ((YDLocal1Get(integer, "sjzs2") <= 60)) then
					call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "D+级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
					call StringBufferAdd( udg_String/*常量字符串*/[58])
				else
					if ((YDLocal1Get(integer, "sjzs2") > 60)) then
						call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "D++级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
						call StringBufferAdd( udg_String/*常量字符串*/[59])
					else
					endif
				endif
			else
				//C
				if ((YDLocal1Get(real, "sjss") > 0.55) and (YDLocal1Get(real, "sjss") <= 0.90)) then
					call YDLocal1Set(real, "sjss2", GetRandomReal( 0.01, 1))
					if ((YDLocal1Get(integer, "sjzs2") <= 30)) then
						call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "C-级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
						call StringBufferAdd( udg_String/*常量字符串*/[14])
						call StringBufferAdd( udg_String/*常量字符串*/[60])
					else
						if ((YDLocal1Get(integer, "sjzs2") > 30) and (YDLocal1Get(integer, "sjzs2") <= 55)) then
							call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "C级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
							call StringBufferAdd( udg_String/*常量字符串*/[14])
							call StringBufferAdd( udg_String/*常量字符串*/[61])
						else
							if ((YDLocal1Get(integer, "sjzs2") > 55) and (YDLocal1Get(integer, "sjzs2") <= 80)) then
								call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "C+级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
								call StringBufferAdd( udg_String/*常量字符串*/[15])
								call StringBufferAdd( udg_String/*常量字符串*/[62])
							else
								if ((YDLocal1Get(integer, "sjzs2") > 80)) then
									call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "C++级物品池","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
									call StringBufferAdd( udg_String/*常量字符串*/[15])
									call StringBufferAdd( udg_String/*常量字符串*/[63])
								else
								endif
							endif
						endif
					endif
				else
					//B-
					if ((YDLocal1Get(real, "sjss") > 0.90) and (YDLocal1Get(real, "sjss") <= 1.00)) then
						call YDLocal1Set(item, "装备", PlaceRandomItem( YDUserDataGet(string, "B-级物品","物品池", itempool), YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2")))
						call StringBufferAdd( udg_String/*常量字符串*/[16])
						call StringBufferAdd( udg_String/*常量字符串*/[64])
					else
					endif
				endif
			endif
			call StringBufferAdd( udg_String/*常量字符串*/[10])
			call StringBufferAdd( udg_String/*常量字符串*/[50])
			call StringBufferAdd( udg_String/*常量字符串*/[41])
			call StringBufferAdd( GetItemName( YDLocal1Get(item, "装备")))
			call StringBufferAdd( udg_String/*常量字符串*/[42])
			call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, StringBufferLoad())
		else
		endif
		if ((YDLocal1Get(integer, "sjzs") > 80) and (YDLocal1Get(integer, "sjzs") <= 90)) then
			call CreateItem( 'gmfr', YDLocal1Get(real, "X2"), YDLocal1Get(real, "Y2"))
		else
		endif
		if ((YDLocal1Get(integer, "sjzs") > 90) and (YDLocal1Get(integer, "sjzs") <= 100)) then
			call SetUnitLifePercentBJ( YDLocal1Get(unit, "开启者"), OperatorRealSubtract( GetUnitLifePercent( YDLocal1Get(unit, "开启者")), OperatorRealMultiply( GetUnitLifePercent( YDLocal1Get(unit, "开启者")), 0.70)))
			call SFB_setBuff( YDLocal1Get(unit, "开启者"), 0, 1.50)
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_group = null
	set ydl_unit = null
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig________________BX takes nothing returns nothing
	set gg_trg________________BX = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg________________BX,"宝箱被打开BX")
#endif
	call STES_Register(gg_trg________________BX, "宝箱被开启")
	call TriggerAddAction(gg_trg________________BX, function Trig________________BXActions)
endfunction

