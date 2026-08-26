//===========================================================================
// Trigger: 未命名触发器 005
//===========================================================================
function Trig____________________005Func001Func001Func001Func001Func001Func001Func005Func001Func001Func018T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call TriggerExecute( gg_trg____Boss_____________________u)
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

function Trig____________________005Func001Func001Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 3.00)) then
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetUnitName( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), null, "TRIGSTR_946", bj_TIMETYPE_ADD, 0, false)
		call YDLocalSet(GetExpiredTimer(), unit, "水触手", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n049', -29009.70, -8991.00, 0.00))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", -29009.70, -8991.00))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________005Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetSpellAbilityId() == 'A08E')) then
		if ((GetHeroLevel( GetTriggerUnit()) >= 3) and (GetHeroLevel( GetTriggerUnit()) <= 6) and (IsUnitInRangeXY( GetTriggerUnit(), -29009.70, -8991.00, 350.00) == true) and (RectContainsUnit( gg_rct______________014, GetTriggerUnit()) == true)) then
			call RemoveRect( gg_rct______________014)
			call YDLocal1Set(real, "循环实数", 0.00)
			call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", -29009.70, -8991.00))
			call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_945", bj_TIMETYPE_SET, 1.50, true)
			call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", -29009.70, -8991.00))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
			call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 1.00, true, function Trig____________________005Func001Func001Func008T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 1.00, true," function Trig____________________005Func001Func001Func008T","未命名触发器 005")
#endif 
		else
			if ((IsUnitInRangeXY( GetTriggerUnit(), 27711.20, -27961.50, 350.00) == true) and (RectContainsUnit( gg_rct______________009, GetTriggerUnit()) == true)) then
				call RemoveRect( gg_rct______________009)
				call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_944", bj_TIMETYPE_ADD, 0, false)
				call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "在书架处阅读了《远古精灵奥术》，受益匪浅，|cff99ccff魔法伤害永久+1%，|r|cffccffff魔法恢复永久+1/秒|r"))
				call YDUserDataSet(unit, GetTriggerUnit(),"魔法恢复", real, OperatorRealAdd( YDUserDataGet(unit, GetTriggerUnit(),"魔法恢复", real), 1.00))
				call YDUserDataSet(player, GetTriggerPlayer(),"魔法伤害", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"魔法伤害", real), 0.01))
			else
				if ((IsUnitInRangeXY( GetTriggerUnit(), -20745.70, -15044.70, 250.00) == true)) then
					call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_DISCOVERED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "意外发现了某处能进入的精灵小屋..（|cff99ccff命中率+1%|r）"))
					call YDUserDataSet(player, GetTriggerPlayer(),"命中率", real, OperatorRealAdd( YDUserDataGet(player, GetTriggerPlayer(),"命中率", real), 0.01))
				else
					if ((IsUnitInRangeXY( GetTriggerUnit(), -19518.70, -14847.50, 250.00) == true) and (RectContainsUnit( gg_rct______________040, GetTriggerUnit()) == true)) then
						call RemoveRect( gg_rct______________040)
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_943", bj_TIMETYPE_SET, 3.00, true)
						call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "意外发现了藏在空木桩里的果子.."))
						call UnitAddItem( GetTriggerUnit(), CreateItem( 'I03W', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
					else
						if ((IsUnitInRangeXY( GetTriggerUnit(), -17829.60, -14820.50, 250.00) == true) and (RectContainsUnit( gg_rct______________042, GetTriggerUnit()) == true)) then
							call RemoveRect( gg_rct______________042)
							call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_935", bj_TIMETYPE_SET, 3.00, true)
							call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "意外发现了藏在树上的果子.."))
							call UnitAddItem( GetTriggerUnit(), CreateItem( 'I03W', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
						else
							if ((RectContainsUnit( gg_rct______________075, GetTriggerUnit()) == true) and (IsUnitInRangeXY( GetTriggerUnit(), -27891.20, -7869.10, 300.00) == true)) then
								call RemoveRect( gg_rct______________075)
								call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_942", bj_TIMETYPE_SET, 3.00, true)
								call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "意外发现了藏在空木桩里的物品.."))
								call YDLocal1Set(integer, "随机整数", GetRandomInt( 1, 3))
								if ((YDLocal1Get(integer, "随机整数") == 1)) then
									call UnitAddItem( GetTriggerUnit(), CreateItem( 'I03W', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
								else
								endif
								if ((YDLocal1Get(integer, "随机整数") == 2)) then
									call UnitAddItem( GetTriggerUnit(), CreateItem( 'ram1', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
								else
								endif
								if ((YDLocal1Get(integer, "随机整数") == 3)) then
									call UnitAddItem( GetTriggerUnit(), CreateItem( 'rde1', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
								else
								endif
							else
								if ((IsUnitInRangeXY( GetTriggerUnit(), -25991.20, -11029.40, 800.00) == true)) then
									call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_941", bj_TIMETYPE_SET, 3.00, true)
								else
									if ((GetHeroLevel( GetTriggerUnit()) >= 9) and (RectContainsUnit( gg_rct______________115, GetTriggerUnit()) == true)) then
										call RemoveRect( gg_rct______________115)
										call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", -27037.10, -17633.30))
										call SFB_setBuff( GetTriggerUnit(), 0, 6.00)
										call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_940", bj_TIMETYPE_SET, 1.50, true)
										call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", -27037.10, -17633.30))
										call YDLocal1Set(unit, "Boss", CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'n001', -27037.10, -17633.30, 270.00))
										call YDUserDataSet(trigger, gg_trg____Boss_____________________u,"Boss", unit, YDLocal1Get(unit, "Boss"))
										call YDUserDataSet(trigger, gg_trg____Boss_____________________u,"玩家英雄", unit, GetTriggerUnit())
										call YDUserDataSet(unit, YDLocal1Get(unit, "Boss"),"闪避率", real, 0.20)
										call TriggerRegisterUnitEvent(gg_trg_______Boss003, YDLocal1Get(unit, "Boss"), EVENT_UNIT_SPELL_EFFECT)
										call SetUnitOwner( gg_unit_n05Q_0003, Player(5), true)
										set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
										call TimerStart(ydl_timer, 3.00, false, function Trig____________________005Func001Func001Func001Func001Func001Func001Func005Func001Func001Func018T)
#ifdef StarDebuggerIncluded 
										call  SDR_DebugTimer(ydl_timer, 3.00, false," function Trig____________________005Func001Func001Func001Func001Func001Func001Func005Func001Func001Func018T","未命名触发器 005")
#endif 
									else
										call GS_news( GetOwningPlayer( GetTriggerUnit()), "TRIGSTR_936")
										if ((RectContainsUnit( gg_rct______________117, GetTriggerUnit()) == true)) then
											call RemoveRect( gg_rct______________117)
											call CreateItem( 'I0D9', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()))
											call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_937", bj_TIMETYPE_ADD, 0, false)
											call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "发现了一本魔法书！"))
										else
										endif
										if ((RectContainsUnit( gg_rct______________116, GetTriggerUnit()) == true)) then
											call RemoveRect( gg_rct______________116)
											call CreateItem( 'I0D8', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()))
											call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_938", bj_TIMETYPE_ADD, 0, false)
											call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "发现了古时候精灵族的打造图纸...."))
										else
										endif
										if ((RectContainsUnit( gg_rct______________118, GetTriggerUnit()) == true)) then
											call RemoveRect( gg_rct______________118)
											call CreateItem( 'I0DB', GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()))
											call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_939", bj_TIMETYPE_ADD, 0, false)
											call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, YDWEOperatorString3( "|cffffff00『系统提示』：|r", GetUnitName( GetTriggerUnit()), "发现了一个小道具！"))
										else
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	else
	endif
	if ((GetSpellAbilityId() == 'A016')) then
		call YDLocal1Set(item, "物品", GetSpellTargetItem())
		call YDLocal1Set(unit, "YX", GetTriggerUnit())
		if ((GetItemTypeId( GetSpellTargetItem()) != 'shwd') and (GetItemTypeId( GetSpellTargetItem()) != 'I036') and (GetItemTypeId( GetSpellTargetItem()) != 'I0CN') and (GetItemTypeId( GetSpellTargetItem()) != 'I0D4') and (GetItemTypeId( GetSpellTargetItem()) != 'I0D5') and (GetItemTypeId( GetSpellTargetItem()) != 'I0D6') and (GetItemTypeId( GetSpellTargetItem()) != 'I09R') and (GetItemTypeId( GetSpellTargetItem()) != 'I0DJ') and (GetItemTypeId( GetSpellTargetItem()) != 'I0DK') and (GetItemTypeId( GetSpellTargetItem()) != 'I0D7')) then
			call YDLocal1Set(boolean, "0.1", false)
			if (((GetItemTypeId( GetSpellTargetItem()) == 'I05D') or (GetItemTypeId( GetSpellTargetItem()) == 'I04W') or (GetItemTypeId( GetSpellTargetItem()) == 'I053') or (GetItemTypeId( GetSpellTargetItem()) == 'I055') or (GetItemTypeId( GetSpellTargetItem()) == 'I054') or (GetItemTypeId( GetSpellTargetItem()) == 'I056') or (GetItemTypeId( GetSpellTargetItem()) == 'I06K') or (GetItemTypeId( GetSpellTargetItem()) == 'I06T') or (GetItemTypeId( GetSpellTargetItem()) == 'I07S') or (GetItemTypeId( GetSpellTargetItem()) == 'I08N') or (GetItemTypeId( GetSpellTargetItem()) == 'I07O') or (GetItemTypeId( GetSpellTargetItem()) == 'I08V') or (GetItemTypeId( GetSpellTargetItem()) == 'I079') or (GetItemTypeId( GetSpellTargetItem()) == 'I072'))) then
				call YDLocal1Set(boolean, "0.1", true)
			else
			endif
			if (((GetItemType( GetSpellTargetItem()) == ITEM_TYPE_PURCHASABLE) or (GetItemType( GetSpellTargetItem()) == ITEM_TYPE_CHARGED))) then
				call YDLocal1Set(integer, "次数", YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( YDLocal1Get(item, "物品")), "uses"))
				call YDLocal1Set(integer, "单次价格", OperatorIntegerDivide( YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( YDLocal1Get(item, "物品")), "goldcost"), YDLocal1Get(integer, "次数")))
				call YDLocal1Set(integer, "初始价格", OperatorIntegerMultiply( YDLocal1Get(integer, "单次价格"), GetItemCharges( YDLocal1Get(item, "物品"))))
			else
				call YDLocal1Set(integer, "初始价格", YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( GetSpellTargetItem()), "goldcost"))
			endif
			if ((YDLocal1Get(boolean, "0.1") == true)) then
				call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 15.00, ("|cFFFFFF00『系统提示』：|r此物品" + (YDWEOperatorString3( "『", GetItemName( GetSpellTargetItem()), "』") + "只能获得原价10%价格")))
				call YDLocal1Set(integer, "C", 10)
			else
				call YDLocal1Set(integer, "C", 3)
			endif
			call AdjustPlayerStateBJ( OperatorIntegerDivide( YDLocal1Get(integer, "初始价格"), YDLocal1Get(integer, "C")), GetOwningPlayer( YDLocal1Get(unit, "YX")), PLAYER_STATE_RESOURCE_GOLD)
			call CreateTextTagUnitBJ( ("+" + I2S( OperatorIntegerDivide( YDLocal1Get(integer, "初始价格"), YDLocal1Get(integer, "C")))), YDLocal1Get(unit, "YX"), 0, 12.00, 100, 100, 0.00, 0)
			call SetTextTagVelocity( GetLastCreatedTextTag(), 0.00, 0.07)
			call YDWETimerDestroyTextTag( 1.00, GetLastCreatedTextTag())
			call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl", GetItemX( YDLocal1Get(item, "物品")), GetItemY( YDLocal1Get(item, "物品"))))
			call RemoveItem( GetSpellTargetItem())
		else
			call DisplayTimedTextToPlayer( GetTriggerPlayer(), 0, 0, 15.00, ("|cFFFFFF00『系统提示』：|r此物品" + (YDWEOperatorString3( "『", GetItemName( GetSpellTargetItem()), "』") + "无法点金")))
		endif
	else
	endif
	if ((GetSpellAbilityId() == 'A017')) then
		call YDLocal1Set(location, "点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(location, "目标点", GetSpellTargetLoc())
		if ((IsTerrainPathableBJ( YDLocal1Get(location, "目标点"), PATHING_TYPE_WALKABILITY) == true) and (IsTerrainPathableBJ( YDLocal1Get(location, "目标点"), PATHING_TYPE_FLOATABILITY) == false)) then
			call YDLocal1Set(integer, "随机整数", GetRandomInt( 1, 100))
			if ((YDLocal1Get(integer, "随机整数") <= 5)) then
				call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_947")
			else
				call YDWETimerDestroyEffect( 2, AddSpecialEffectLoc( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", YDLocal1Get(location, "目标点")))
			endif
			if ((YDLocal1Get(integer, "随机整数") > 5) and (YDLocal1Get(integer, "随机整数") <= 10)) then
				call UnitAddItemByIdSwapped( 'I031', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 10) and (YDLocal1Get(integer, "随机整数") <= 20)) then
				call UnitAddItemByIdSwapped( 'I030', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 20) and (YDLocal1Get(integer, "随机整数") <= 30)) then
				call UnitAddItemByIdSwapped( 'I02Z', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 30) and (YDLocal1Get(integer, "随机整数") <= 40)) then
				call UnitAddItemByIdSwapped( 'I02Y', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 40) and (YDLocal1Get(integer, "随机整数") <= 50)) then
				call UnitAddItemByIdSwapped( 'I02W', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 50) and (YDLocal1Get(integer, "随机整数") <= 75)) then
				call UnitAddItemByIdSwapped( 'I02X', GetTriggerUnit())
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 73) and (YDLocal1Get(integer, "随机整数") <= 83)) then
				if ((GetHeroLevel( GetTriggerUnit()) <= 15)) then
					call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_948", bj_TIMETYPE_ADD, 0, true)
					call CreateNUnitsAtLocFacingLocBJ( 1, 'n02R', Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocal1Get(location, "目标点"), YDLocal1Get(location, "点"))
				else
					if ((udg_WYDW/*避免Boss重复刷新*/[0] <= 0.00) and (GetHeroLevel( GetTriggerUnit()) > 19)) then
						set udg_WYDW/*避免Boss重复刷新*/[0] = 1.00
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_949", bj_TIMETYPE_ADD, 0, true)
						call CreateNUnitsAtLocFacingLocBJ( 1, 'n02S', Player(PLAYER_NEUTRAL_PASSIVE), YDLocal1Get(location, "目标点"), YDLocal1Get(location, "点"))
						call YDUserDataSet(unit, GetLastCreatedUnit(),"魔抗", real, 0.25)
						call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ALWAYSHINT, "TRIGSTR_950")
					else
					endif
				endif
			else
			endif
			if ((YDLocal1Get(integer, "随机整数") > 83) and (YDLocal1Get(integer, "随机整数") <= 93)) then
				if ((GetHeroLevel( GetTriggerUnit()) <= 15)) then
					call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_953", bj_TIMETYPE_ADD, 0, true)
					call CreateNUnitsAtLocFacingLocBJ( 1, 'n02T', Player(PLAYER_NEUTRAL_AGGRESSIVE), YDLocal1Get(location, "目标点"), YDLocal1Get(location, "点"))
				else
					if ((udg_WYDW/*避免Boss重复刷新*/[1] <= 0.00) and (GetHeroLevel( GetTriggerUnit()) > 19)) then
						set udg_WYDW/*避免Boss重复刷新*/[1] = 1.00
						call CreateNUnitsAtLocFacingLocBJ( 1, 'n02U', Player(PLAYER_NEUTRAL_PASSIVE), YDLocal1Get(location, "目标点"), YDLocal1Get(location, "点"))
						call YDUserDataSet(unit, GetLastCreatedUnit(),"魔抗", real, 0.25)
						call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_951", bj_TIMETYPE_ADD, 0, true)
						call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ALWAYSHINT, "TRIGSTR_952")
					else
					endif
				endif
			else
			endif
			if ((udg_WYDW/*避免Boss重复刷新*/[8] <= 0.00) and (YDLocal1Get(integer, "随机整数") > 93) and (YDLocal1Get(integer, "随机整数") <= 100)) then
				call YDLocal1Set(unit, "渔夫", CreateUnit( Player(6), 'n01K', 23347.10, -29831.30, 90.00))
				set udg_WYDW/*避免Boss重复刷新*/[8] = 1.00
				call SetUnitPosition( GetTriggerUnit(), 21615.20, -29218.30)
				call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_954", bj_TIMETYPE_ADD, 0, true)
				call TransmissionFromUnitWithNameBJ( GetPlayersAll(), GetTriggerUnit(), GetUnitName( GetTriggerUnit()), null, "TRIGSTR_955", bj_TIMETYPE_ADD, 0, true)
				call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ALWAYSHINT, "TRIGSTR_956")
			else
			endif
		else
		endif
		call RemoveLocation( YDLocal1Get(location, "目标点"))
		call RemoveLocation( YDLocal1Get(location, "点"))
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________005 takes nothing returns nothing
	set gg_trg____________________005 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________005,"未命名触发器 005")
#endif
	call TriggerAddAction(gg_trg____________________005, function Trig____________________005Actions)
endfunction

