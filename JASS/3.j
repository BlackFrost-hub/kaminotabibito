//===========================================================================
// Trigger: JLC精灵城003
//===========================================================================
function Trig_JLC_________003Func003Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call ModifyGateBJ( bj_GATEOPERATION_OPEN, gg_dest_LTe1_11879)
	call ShowDestructable( gg_dest_B00K_5466, false)
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

function Trig_JLC_________003Func003Func008A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct__________u)
endfunction

function Trig_JLC_________003Func004Func005A takes nothing returns nothing
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________121)
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________122)
	call CreateFogModifierRectBJ( true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct______________123)
endfunction

function Trig_JLC_________003Func006Func025A takes nothing returns nothing
	call AdjustPlayerStateBJ( 15000, GetEnumPlayer(), PLAYER_STATE_RESOURCE_GOLD)
endfunction

function Trig_JLC_________003Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","阿尔文", unit), 400.00) == true)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 21)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call YDLocal1Set(unit, "aew", YDUserDataGet(string, "主线NPC","阿尔文", unit))
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_1565", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_1585", null, "TRIGSTR_1586", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_2114", null, "TRIGSTR_2671", bj_TIMETYPE_SET, 3.50, true)
		call EC_CreateEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( YDLocal1Get(unit, "aew")), GetUnitY( YDLocal1Get(unit, "aew")), 0.0, 270.0, 2.00, 1.0, 1.50)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_2881", null, "TRIGSTR_2887", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_2909", null, "TRIGSTR_2935", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_2936", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_2974", null, "TRIGSTR_2976", bj_TIMETYPE_SET, 4.50, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_3025")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_3026")
		call PingMinimap( -6997.40, -13110.90, 20.00)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), gg_unit_n04R_0048, 999.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 21)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 22)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3063", bj_TIMETYPE_SET, 2.26, true)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 2.50, false, function Trig_JLC_________003Func003Func006T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 2.50, false," function Trig_JLC_________003Func003Func006T","JLC精灵城003")
#endif 
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3142", null, "TRIGSTR_3145", bj_TIMETYPE_SET, 7.00, true)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________003Func003Func008A)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3471", bj_TIMETYPE_SET, 2.25, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_3477")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_3478")
		call PingMinimap( -10900.60, -10601.80, 20.00)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","jl禁军门卫", unit), 999.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 22)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 23)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________003Func004Func005A)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3618", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3624", null, "TRIGSTR_3633", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3643", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3645", null, "TRIGSTR_3686", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3687", bj_TIMETYPE_SET, 1.50, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_3703")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_3720")
		call PingMinimap( 18924.90, -24399.80, 20.00)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "主线NPC","jl禁军门卫2", unit), 600.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 23)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 24)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3738", bj_TIMETYPE_SET, 20.00, false)
		call QuestSetDiscovered( udg_RW[8], true)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_DISCOVERED, "TRIGSTR_3753")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZX","克林姆德王", unit), 999.00) == true) and ((YDUserDataGet(string, "剧情进度","整数", integer) == 23) or (YDUserDataGet(string, "剧情进度","整数", integer) == 24))) then
		call YDUserDataClear(string, "主线NPC","jl禁军门卫", unit)
		call YDUserDataClear(string, "主线NPC","jl禁军门卫", unit)
		call YDUserDataSet(string, "剧情进度","整数", integer, 25)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call SetUnitInvulnerable( YDUserDataGet(string, "jq","npc", unit), true)
		call PauseUnit( YDUserDataGet(string, "jq","npc", unit), true)
		call SetUnitOwner( YDUserDataGet(string, "主线NPC","jlw", unit), Player(6), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3807", bj_TIMETYPE_SET, 2.40, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3808", null, "TRIGSTR_3843", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3860", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3861", null, "TRIGSTR_3880", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_3882", bj_TIMETYPE_SET, 5.00, true)
		call SetStackedSoundBJ( true, gg_snd_JQBGM02, gg_rct______________121)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_3906", null, "TRIGSTR_3992", bj_TIMETYPE_SET, 8.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4066", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4206", null, "TRIGSTR_4209", bj_TIMETYPE_SET, 10.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4253", bj_TIMETYPE_SET, 8.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4510", null, "TRIGSTR_4511", bj_TIMETYPE_SET, 11.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4512", bj_TIMETYPE_SET, 7.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4513", null, "TRIGSTR_4544", bj_TIMETYPE_SET, 10.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4553", bj_TIMETYPE_SET, 3.25, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4554", null, "TRIGSTR_4555", bj_TIMETYPE_SET, 10.50, true)
		call ForForce( YDUserDataGet(string, "玩家","玩家组", force),function Trig_JLC_________003Func006Func025A)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_ITEMACQUIRED, "TRIGSTR_4556")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4738", bj_TIMETYPE_SET, 3.25, true)
		call SetStackedSoundBJ( false, gg_snd_JQBGM02, gg_rct______________121)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_4787")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_4841")
		call PingMinimap( -2906.20, -14099.80, 20.00)
		call YDUserDataSet(string, "jq","npc", unit, CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'ohun', -2823.10, -14119.80, 180.00))
		call RemoveDestructable( gg_dest_Dofw_5490)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "jq","npc", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 25)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 26)
		call YDLocal1Set(unit, "npc", YDUserDataGet(string, "jq","npc", unit))
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call PauseUnit( GetTriggerUnit(), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4973", null, "TRIGSTR_4974", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_4978", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_4979", null, "TRIGSTR_5136", bj_TIMETYPE_SET, 2.50, true)
		call PauseUnit( GetTriggerUnit(), false)
		call SetUnitInvulnerable( YDUserDataGet(string, "jq","npc", unit), false)
		call PauseUnit( YDUserDataGet(string, "jq","npc", unit), false)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5137", bj_TIMETYPE_SET, 2.00, false)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_5142")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_5143")
		call YDUserDataClear(string, "jq","npc", unit)
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "巨魔首领","Boss", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 26)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 27)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call PauseUnit( GetTriggerUnit(), true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5211", null, "TRIGSTR_5214", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5234", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5235", null, "TRIGSTR_5239", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5257", bj_TIMETYPE_SET, 4.00, true)
		call PauseUnit( GetTriggerUnit(), false)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5259", bj_TIMETYPE_SET, 2.00, false)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_5265")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_5267")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZX","克林姆德王", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 29)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 30)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5269", null, "TRIGSTR_5275", bj_TIMETYPE_SET, 2.10, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5276", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5277", null, "TRIGSTR_5279", bj_TIMETYPE_SET, 4.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5280", null, "TRIGSTR_5283", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5285", bj_TIMETYPE_SET, 2.00, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_5287")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_5289")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZX","赫克提尔", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 30)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 31)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5290", null, "TRIGSTR_5302", bj_TIMETYPE_SET, 2.10, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5305", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5309", null, "TRIGSTR_5310", bj_TIMETYPE_SET, 2.10, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5313", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5314", null, "TRIGSTR_5331", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5332", null, "TRIGSTR_5336", bj_TIMETYPE_SET, 5.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5337", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5339", null, "TRIGSTR_5361", bj_TIMETYPE_SET, 2.10, true)
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_WARNING, "TRIGSTR_5362")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5363", null, "TRIGSTR_5364", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5365", null, "TRIGSTR_5366", bj_TIMETYPE_SET, 2.10, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_5367", bj_TIMETYPE_SET, 1.20, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_5370")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_5400")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZX","克林姆德王", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 31)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 32)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5425", null, "TRIGSTR_5426", bj_TIMETYPE_SET, 6.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5439", null, "TRIGSTR_5460", bj_TIMETYPE_SET, 3.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5461", null, "TRIGSTR_5462", bj_TIMETYPE_SET, 1.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5463", null, "TRIGSTR_5464", bj_TIMETYPE_SET, 3.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5623", null, "TRIGSTR_5624", bj_TIMETYPE_SET, 6.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5627", null, "TRIGSTR_5689", bj_TIMETYPE_SET, 4.70, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5690", null, "TRIGSTR_5764", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5789", null, "TRIGSTR_5790", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5791", null, "TRIGSTR_5793", bj_TIMETYPE_SET, 4.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5794", null, "TRIGSTR_5795", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5796", null, "TRIGSTR_5797", bj_TIMETYPE_SET, 3.90, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5799", null, "TRIGSTR_5801", bj_TIMETYPE_SET, 1.50, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_5810")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_5831")
	else
	endif
	if ((IsUnitInRange( GetTriggerUnit(), YDUserDataGet(string, "ZX","克林姆德王", unit), 400.00) == true) and (YDUserDataGet(string, "剧情进度","整数", integer) == 33)) then
		call YDUserDataSet(string, "剧情进度","整数", integer, 34)
		call IssueImmediateOrder( GetTriggerUnit(), "stop")
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5832", null, "TRIGSTR_5833", bj_TIMETYPE_SET, 2.10, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5835", null, "TRIGSTR_5836", bj_TIMETYPE_SET, 5.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5837", null, "TRIGSTR_5838", bj_TIMETYPE_SET, 1.60, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5839", null, "TRIGSTR_5840", bj_TIMETYPE_SET, 8.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5843", null, "TRIGSTR_5891", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_5927", null, "TRIGSTR_6236", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6237", null, "TRIGSTR_6238", bj_TIMETYPE_SET, 3.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6245", null, "TRIGSTR_6264", bj_TIMETYPE_SET, 2.00, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6265", null, "TRIGSTR_6268", bj_TIMETYPE_SET, 2.20, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6280", null, "TRIGSTR_6283", bj_TIMETYPE_SET, 3.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6284", null, "TRIGSTR_6285", bj_TIMETYPE_SET, 5.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6286", null, "TRIGSTR_6287", bj_TIMETYPE_SET, 4.20, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, GetUnitName( GetTriggerUnit()), null, "TRIGSTR_6299", bj_TIMETYPE_SET, 2.50, true)
		call TransmissionFromUnitWithNameBJ( GetPlayersAll(), null, "TRIGSTR_6302", null, "TRIGSTR_6303", bj_TIMETYPE_SET, 4.50, true)
		call QuestSetDescription( udg_ZX[2], "TRIGSTR_6304")
		call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "TRIGSTR_6306")
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_JLC_________003 takes nothing returns nothing
	set gg_trg_JLC_________003 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_JLC_________003,"JLC精灵城003")
#endif
	call TriggerRegisterUnitInRangeSimple(gg_trg_JLC_________003, 850.00, gg_unit_n04R_0048)
	call TriggerAddAction(gg_trg_JLC_________003, function Trig_JLC_________003Actions)
endfunction

