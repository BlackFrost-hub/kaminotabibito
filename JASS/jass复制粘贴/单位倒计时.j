//===========================================================================
// Trigger: UnitTimer_CoreSystem
//===========================================================================
function Trig_UnitTimer_CoreSystemFunc002Func004T takes nothing returns nothing
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
	if ((IsUnitDeadBJ( YDLocalGet(GetExpiredTimer(), unit, "Unit")) == true)) then
		call YDLocalSet(GetExpiredTimer(), boolean, "TimerFinish", true)
	else
	endif
	if ((IsUnitPausedBJ( YDLocalGet(GetExpiredTimer(), unit, "Unit")) == true)) then
		call DoNothing()
	else
		if ((YDLocalGet(GetExpiredTimer(), real, "Elapsed") >= YDLocalGet(GetExpiredTimer(), real, "time"))) then
			call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "Unit"),"Expire", boolean, true)
			call YDLocalSet(GetExpiredTimer(), boolean, "TimerFinish", true)
			if ((YDLocalGet(GetExpiredTimer(), integer, "EffectID") <= 0)) then
				call DoNothing()
			else
				if ((YDLocalGet(GetExpiredTimer(), integer, "EffectID") == 2)) then
					set star_hash = StringHash( "UnitTimer_Effect_2")
					set star_loopIndex = LoadInteger(STES_GetTable(),star_hash,skey_index)
					set star_loopA = 0
					loop
						exitwhen star_loopA>=star_loopIndex
						set ydl_trigger = LoadTriggerHandle(STES_GetTable(),star_hash,star_loopA) 
						YDLocalExecuteTrigger(ydl_trigger)
						call YDLocal5Set(unit, "Unit", YDLocalGet(GetExpiredTimer(), unit, "Unit"))
						call YDLocal5Set(integer, "SummonID", 1)
						call YDLocal5Set(real, "PowerUPtime", YDLocalGet(GetExpiredTimer(), real, "PowerUPtime"))
						call YDLocal5Set(real, "PowerUPHP", YDLocalGet(GetExpiredTimer(), real, "PowerUPHP"))
						call YDLocal5Set(string, "PowerUPModel", YDLocalGet(GetExpiredTimer(), string, "PowerUPModel"))
						call YDLocal5Set(unitcode, "PowerUPunitType", YDLocalGet(GetExpiredTimer(), unitcode, "PowerUPunitType"))
						call YDTriggerExecuteTrigger(ydl_trigger, false)
						set star_loopA = star_loopA + 1
					endloop
				else
				endif
			endif
		else
			call YDLocalSet(GetExpiredTimer(), real, "Elapsed", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "Elapsed"), 0.04))
			call EXSetEffectXY( YDLocalGet(GetExpiredTimer(), effect, "CountdownEffect"), GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "Unit")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "Unit")))
		endif
	endif
	if ((YDLocalGet(GetExpiredTimer(), boolean, "TimerFinish") == true)) then
		call EXSetEffectSize( YDLocalGet(GetExpiredTimer(), effect, "CountdownEffect"), 0.00)
		call DestroyEffect( YDLocalGet(GetExpiredTimer(), effect, "CountdownEffect"))
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

function Trig_UnitTimer_CoreSystemActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(effect, "CountdownEffect", EC_CreateEffect( "war3mapImported\\progressbarcountdown.mdl", YDLocal1Get(real, "x"), YDLocal1Get(real, "y"), 233.00, 270.0, 1.0, 1.0, -1))
	call YDLocal1Set(real, "Elapsed", 0.00)
	call YDLocal1Set(boolean, "TimerFinish", false)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, effect, "CountdownEffect", YDLocal1Get(effect, "CountdownEffect"))
	call YDLocalSet(ydl_timer, integer, "EffectID", YDLocal1Get(integer, "EffectID"))
	call YDLocalSet(ydl_timer, real, "Elapsed", YDLocal1Get(real, "Elapsed"))
	call YDLocalSet(ydl_timer, real, "PowerUPHP", YDLocal1Get(real, "PowerUPHP"))
	call YDLocalSet(ydl_timer, string, "PowerUPModel", YDLocal1Get(string, "PowerUPModel"))
	call YDLocalSet(ydl_timer, real, "PowerUPtime", YDLocal1Get(real, "PowerUPtime"))
	call YDLocalSet(ydl_timer, unitcode, "PowerUPunitType", YDLocal1Get(unitcode, "PowerUPunitType"))
	call YDLocalSet(ydl_timer, boolean, "TimerFinish", YDLocal1Get(boolean, "TimerFinish"))
	call YDLocalSet(ydl_timer, unit, "Unit", YDLocal1Get(unit, "Unit"))
	call YDLocalSet(ydl_timer, real, "time", YDLocal1Get(real, "time"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.04, true, function Trig_UnitTimer_CoreSystemFunc002Func004T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.04, true," function Trig_UnitTimer_CoreSystemFunc002Func004T","UnitTimer_CoreSystem")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_UnitTimer_CoreSystem takes nothing returns nothing
	set gg_trg_UnitTimer_CoreSystem = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_UnitTimer_CoreSystem,"UnitTimer_CoreSystem")
#endif
	call STES_Register(gg_trg_UnitTimer_CoreSystem, "UnitTimer")
	call TriggerAddAction(gg_trg_UnitTimer_CoreSystem, function Trig_UnitTimer_CoreSystemActions)
endfunction
//===========================================================================
// Trigger: UnitTimer_OnExpireEffect_2(强化2)
//===========================================================================
function Trig_UnitTimer_OnExpireEffect_2_______2_uFunc004Func001T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call KillUnit( YDLocalGet(GetExpiredTimer(), unit, "Unit"))
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

function Trig_UnitTimer_OnExpireEffect_2_______2_uActions takes nothing returns nothing
	local integer star_loopA
	local integer star_loopIndex
	local integer star_hash
	local integer ydl_triggerstep
	local trigger ydl_trigger
	local timer ydl_timer
	YDLocalInitialize()
	set star_hash = StringHash( "OnSummonEvent")
	set star_loopIndex = LoadInteger(STES_GetTable(),star_hash,skey_index)
	set star_loopA = 0
	loop
		exitwhen star_loopA>=star_loopIndex
		set ydl_trigger = LoadTriggerHandle(STES_GetTable(),star_hash,star_loopA) 
		YDLocalExecuteTrigger(ydl_trigger)
		call SaveInteger(YDHT,GetHandleId(ydl_trigger),SKey_PIndex,GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step)
		call YDLocal5Set(unit, "Master", YDLocal1Get(unit, "Unit"))
		call YDLocal5Set(unitcode, "unitType", YDLocal1Get(unitcode, "PowerUPunitType"))
		call YDLocal5Set(real, "x", GetUnitX( YDLocal1Get(unit, "Unit")))
		call YDLocal5Set(real, "y", GetUnitY( YDLocal1Get(unit, "Unit")))
		call YDLocal5Set(real, "size", 2.00)
		call YDLocal5Set(real, "time", YDLocal1Get(real, "PowerUPtime"))
		call YDLocal5Set(string, "ModelFileID", YDLocal1Get(string, "PowerUPModel"))
		call YDLocal5Set(real, "HP", YDLocal1Get(real, "PowerUPHP"))
		call YDTriggerExecuteTrigger(ydl_trigger, false)
		set star_loopA = star_loopA + 1
	endloop
	call YDUserDataSet(unit, YDLocal1Get(unit, "Unit"),"PowerUPUnit", unit, YDLocal1Get(unit, "Summon"))
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "Unit", YDLocal1Get(unit, "Unit"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.10, false, function Trig_UnitTimer_OnExpireEffect_2_______2_uFunc004Func001T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.10, false," function Trig_UnitTimer_OnExpireEffect_2_______2_uFunc004Func001T","UnitTimer_OnExpireEffect_2(强化2)")
#endif 
	call YDLocal1Release()
	set ydl_trigger = null
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_UnitTimer_OnExpireEffect_2_______2_u takes nothing returns nothing
	set gg_trg_UnitTimer_OnExpireEffect_2_______2_u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_UnitTimer_OnExpireEffect_2_______2_u,"UnitTimer_OnExpireEffect_2(强化2)")
#endif
	call STES_Register(gg_trg_UnitTimer_OnExpireEffect_2_______2_u, "UnitTimer_Effect_2")
	call TriggerAddAction(gg_trg_UnitTimer_OnExpireEffect_2_______2_u, function Trig_UnitTimer_OnExpireEffect_2_______2_uActions)
endfunction


