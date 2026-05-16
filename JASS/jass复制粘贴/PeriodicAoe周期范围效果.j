//===========================================================================
// Trigger: PeriodicAoe_CoreSystem
//===========================================================================
function Trig_PeriodicAoe_CoreSystemFunc003Func002T takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
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
	if (((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "EffectSourceUnit")) == true) or (YDLocalGet(GetExpiredTimer(), real, "Elapsed") >= YDLocalGet(GetExpiredTimer(), real, "EffectTime")))) then
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "Elapsed", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "Elapsed"), YDLocalGet(GetExpiredTimer(), real, "EffectInterval")))
		call YDLocalSet(GetExpiredTimer(), real, "x", GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "EffectSourceUnit")))
		call YDLocalSet(GetExpiredTimer(), real, "y", GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "EffectSourceUnit")))
		call YDLocalSet(GetExpiredTimer(), effect, "AoeEffect", EC_CreateEffect( YDLocalGet(GetExpiredTimer(), string, "AoeEffectFileID"), YDLocalGet(GetExpiredTimer(), real, "x"), YDLocalGet(GetExpiredTimer(), real, "y"), 0.0, 270.0, 1.50, 1.0, YDLocalGet(GetExpiredTimer(), real, "EffectInterval")))
		if ((YDLocalGet(GetExpiredTimer(), integer, "EffectID") == 3)) then
			set ydl_group = CreateGroup()
			call GroupEnumUnitsInRange(ydl_group, YDLocalGet(GetExpiredTimer(), real, "x"), YDLocalGet(GetExpiredTimer(), real, "y"), YDLocalGet(GetExpiredTimer(), real, "r"), null)
			loop
				set ydl_unit = FirstOfGroup(ydl_group)
				exitwhen ydl_unit == null
				call GroupRemoveUnit(ydl_group, ydl_unit)
				if ((IsUnitType( ydl_unit, UNIT_TYPE_ANCIENT) == false) and (IsUnitAliveBJ( ydl_unit) == true) and (SU_IsUnitInvincible( ydl_unit) == false) and (IsUnitInGroup( ydl_unit, YDUserDataGet(string, "玩家英雄","单位组", group)) == true)) then
					call YDLocalSet(GetExpiredTimer(), unit, "TargetUnit", ydl_unit)
					set star_hash = StringHash( "DebuffStacks")
					set star_loopIndex = LoadInteger(STES_GetTable(),star_hash,skey_index)
					set star_loopA = 0
					loop
						exitwhen star_loopA>=star_loopIndex
						set ydl_trigger = LoadTriggerHandle(STES_GetTable(),star_hash,star_loopA) 
						YDLocalExecuteTrigger(ydl_trigger)
						call YDLocal5Set(unit, "TargetUnit", YDLocalGet(GetExpiredTimer(), unit, "TargetUnit"))
						call YDLocal5Set(real, "Stacks", 7.00)
						call YDLocal5Set(boolean, "腐败值", true)
						call YDTriggerExecuteTrigger(ydl_trigger, false)
						set star_loopA = star_loopA + 1
					endloop
				else
				endif
			endloop
			call DestroyGroup(ydl_group)
		else
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_group = null
	set ydl_unit = null
	set ydl_trigger = null
endfunction

function Trig_PeriodicAoe_CoreSystemActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((YDLocal1Get(real, "EffectTime") <= 0.00)) then
		call YDLocal1Set(real, "EffectTime", 999.00)
	else
	endif
	call YDLocal1Set(real, "Elapsed", 0.00)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, string, "AoeEffectFileID", YDLocal1Get(string, "AoeEffectFileID"))
	call YDLocalSet(ydl_timer, integer, "EffectID", YDLocal1Get(integer, "EffectID"))
	call YDLocalSet(ydl_timer, real, "EffectInterval", YDLocal1Get(real, "EffectInterval"))
	call YDLocalSet(ydl_timer, unit, "EffectSourceUnit", YDLocal1Get(unit, "EffectSourceUnit"))
	call YDLocalSet(ydl_timer, real, "EffectTime", YDLocal1Get(real, "EffectTime"))
	call YDLocalSet(ydl_timer, real, "Elapsed", YDLocal1Get(real, "Elapsed"))
	call YDLocalSet(ydl_timer, unit, "TargetUnit", YDLocal1Get(unit, "TargetUnit"))
	call YDLocalSet(ydl_timer, real, "r", YDLocal1Get(real, "r"))
	call YDLocalSet(ydl_timer, real, "x", YDLocal1Get(real, "x"))
	call YDLocalSet(ydl_timer, real, "y", YDLocal1Get(real, "y"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, YDLocal1Get(real, "EffectInterval"), true, function Trig_PeriodicAoe_CoreSystemFunc003Func002T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, YDLocal1Get(real, "EffectInterval"), true," function Trig_PeriodicAoe_CoreSystemFunc003Func002T","PeriodicAoe_CoreSystem")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_PeriodicAoe_CoreSystem takes nothing returns nothing
	set gg_trg_PeriodicAoe_CoreSystem = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_PeriodicAoe_CoreSystem,"PeriodicAoe_CoreSystem")
#endif
	call STES_Register(gg_trg_PeriodicAoe_CoreSystem, "PeriodicAoe_Event")
	call TriggerAddAction(gg_trg_PeriodicAoe_CoreSystem, function Trig_PeriodicAoe_CoreSystemActions)
endfunction
//===========================================================================
// Trigger: Root（禁锢）
//===========================================================================
function Trig_Root____________uFunc009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitPausedBJ( YDLocalGet(GetExpiredTimer(), unit, "BuffTarget")) == true)) then
	else
		if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "BuffTarget"), 'BEer') == true)) then
			call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "BuffSource"), YDLocalGet(GetExpiredTimer(), unit, "BuffTarget"), YDLocalGet(GetExpiredTimer(), real, "HitDamage"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
		else
			#ifdef StarDebuggerIncluded 
			call SDR_DebugTimer_Remove(GetExpiredTimer())
			#endif 
			call YDLocal3Release()
			call DestroyTimer(GetExpiredTimer())
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_Root____________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((YDLocal1Get(real, "DamageInterval") <= 0.00)) then
		call YDLocal1Set(real, "DamageInterval", 1.00)
	else
	endif
	call YDLocal1Set(real, "time", OperatorRealAdd( YDLocal1Get(real, "time"), 0.05))
	call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocal1Get(unit, "BuffSource")), YDUserDataGet(string, "魔法效果马甲","单位类型", unitcode), GetUnitX( YDLocal1Get(unit, "BuffTarget")), GetUnitY( YDLocal1Get(unit, "BuffTarget")), 0))
	call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'A00D')
	call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A00D', 1, 102, YDLocal1Get(real, "time"))
	call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'A00D', 1, 103, YDLocal1Get(real, "time"))
	call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "entanglingroots", YDLocal1Get(unit, "BuffTarget"))
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "BuffSource", YDLocal1Get(unit, "BuffSource"))
	call YDLocalSet(ydl_timer, unit, "BuffTarget", YDLocal1Get(unit, "BuffTarget"))
	call YDLocalSet(ydl_timer, real, "HitDamage", YDLocal1Get(real, "HitDamage"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, YDLocal1Get(real, "DamageInterval"), true, function Trig_Root____________uFunc009T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, YDLocal1Get(real, "DamageInterval"), true," function Trig_Root____________uFunc009T","Root（禁锢）")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_Root____________u takes nothing returns nothing
	set gg_trg_Root____________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Root____________u,"Root（禁锢）")
#endif
	call STES_Register(gg_trg_Root____________u, "禁锢")
	call TriggerAddAction(gg_trg_Root____________u, function Trig_Root____________uActions)
endfunction
//===========================================================================
// Trigger: Parasite（寄生）
//===========================================================================
function Trig_Parasite____________uFunc009T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitPausedBJ( YDLocalGet(GetExpiredTimer(), unit, "BuffTarget")) == true)) then
	else
		if (((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "BuffTarget"), 'BNpa') == true))) then
			call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "BuffSource"), YDLocalGet(GetExpiredTimer(), unit, "BuffTarget"), YDLocalGet(GetExpiredTimer(), real, "HitDamage"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
		else
			#ifdef StarDebuggerIncluded 
			call SDR_DebugTimer_Remove(GetExpiredTimer())
			#endif 
			call YDLocal3Release()
			call DestroyTimer(GetExpiredTimer())
		endif
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_Parasite____________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((YDLocal1Get(real, "DamageInterval") <= 0.00)) then
		call YDLocal1Set(real, "DamageInterval", 1.00)
	else
	endif
	call YDLocal1Set(real, "time", OperatorRealAdd( YDLocal1Get(real, "time"), 0.05))
	call YDLocal1Set(unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocal1Get(unit, "BuffSource")), YDUserDataGet(string, "魔法效果马甲","单位类型", unitcode), GetUnitX( YDLocal1Get(unit, "BuffTarget")), GetUnitY( YDLocal1Get(unit, "BuffTarget")), 0))
	call UnitAddAbility( YDLocal1Get(unit, "辅助马甲"), 'ACpa')
	call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'ACpa', 1, 102, YDLocal1Get(real, "time"))
	call YDWESetUnitAbilityDataReal( YDLocal1Get(unit, "辅助马甲"), 'ACpa', 1, 103, YDLocal1Get(real, "time"))
	call IssueTargetOrder( YDLocal1Get(unit, "辅助马甲"), "parasite", YDLocal1Get(unit, "BuffTarget"))
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "BuffSource", YDLocal1Get(unit, "BuffSource"))
	call YDLocalSet(ydl_timer, unit, "BuffTarget", YDLocal1Get(unit, "BuffTarget"))
	call YDLocalSet(ydl_timer, real, "HitDamage", YDLocal1Get(real, "HitDamage"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, YDLocal1Get(real, "DamageInterval"), true, function Trig_Parasite____________uFunc009T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, YDLocal1Get(real, "DamageInterval"), true," function Trig_Parasite____________uFunc009T","Parasite（寄生）")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_Parasite____________u takes nothing returns nothing
	set gg_trg_Parasite____________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_Parasite____________u,"Parasite（寄生）")
#endif
	call STES_Register(gg_trg_Parasite____________u, "寄生")
	call TriggerAddAction(gg_trg_Parasite____________u, function Trig_Parasite____________uActions)
endfunction
//===========================================================================
// Trigger: DebuffStacks（腐败/惩罚）
//===========================================================================
function Trig_DebuffStacks___________________uActions takes nothing returns nothing
	local integer star_loopA
	local integer star_loopIndex
	local integer star_hash
	local integer ydl_triggerstep
	local trigger ydl_trigger
	YDLocalInitialize()
	if ((YDLocal1Get(boolean, "腐败值") == true)) then
		call YDUserDataSet(player, GetOwningPlayer( YDLocal1Get(unit, "TargetUnit")),"腐败值", real, OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( YDLocal1Get(unit, "TargetUnit")),"腐败值", real), YDLocal1Get(real, "Stacks")))
		call YDLocal1Set(effect, "Effect", EC_CreateEffect( "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl", GetUnitX( YDLocal1Get(unit, "TargetUnit")), GetUnitY( YDLocal1Get(unit, "TargetUnit")), 0.0, 270.0, 1.50, 1.0, 1.00))
		if ((YDUserDataGet(player, GetOwningPlayer( YDLocal1Get(unit, "TargetUnit")),"腐败值", real) >= 100.00)) then
		else
		endif
		call YDLocal1Set(string, "string", udg_String/*常量字符串*/[46])
		call YDLocal1Set(real, "red", 100.00)
		call YDLocal1Set(real, "green", 20.00)
		call YDLocal1Set(real, "blue", 20.00)
	else
	endif
	set star_hash = StringHash( "数值显示")
	set star_loopIndex = LoadInteger(STES_GetTable(),star_hash,skey_index)
	set star_loopA = 0
	loop
		exitwhen star_loopA>=star_loopIndex
		set ydl_trigger = LoadTriggerHandle(STES_GetTable(),star_hash,star_loopA) 
		YDLocalExecuteTrigger(ydl_trigger)
		call YDLocal5Set(real, "Real", YDLocal1Get(real, "Stacks"))
		call YDLocal5Set(unit, "Unit", YDLocal1Get(unit, "TargetUnit"))
		call YDLocal5Set(string, "string", YDLocal1Get(string, "string"))
		call YDLocal5Set(real, "red", YDLocal1Get(real, "red"))
		call YDLocal5Set(real, "green", YDLocal1Get(real, "green"))
		call YDLocal5Set(real, "blue", YDLocal1Get(real, "blue"))
		call YDTriggerExecuteTrigger(ydl_trigger, false)
		set star_loopA = star_loopA + 1
	endloop
	call YDLocal1Release()
	set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig_DebuffStacks___________________u takes nothing returns nothing
	set gg_trg_DebuffStacks___________________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_DebuffStacks___________________u,"DebuffStacks（腐败/惩罚）")
#endif
	call STES_Register(gg_trg_DebuffStacks___________________u, "DebuffStacks")
	call TriggerAddAction(gg_trg_DebuffStacks___________________u, function Trig_DebuffStacks___________________uActions)
endfunction




