//===========================================================================
// Trigger: 未命名触发器 005
//===========================================================================
function Trig____________________005Func002Func004T takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call EXSetEffectSize( YDLocalGet(GetExpiredTimer(), effect, "ts"), 0.00)
	call EC_CreateEffect( "war3mapImported\\superdarkflash.mdl", YDLocalGet(GetExpiredTimer(), real, "X"), YDLocalGet(GetExpiredTimer(), real, "Y"), 35.00, 270.0, 1.10, 1.0, 1.10)
	call EC_CreateEffect( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", YDLocalGet(GetExpiredTimer(), real, "X"), YDLocalGet(GetExpiredTimer(), real, "Y"), 35.00, 270.0, 1.10, 1.0, 0.10)
	set ydl_group = CreateGroup()
	call GroupEnumUnitsInRange(ydl_group, YDLocalGet(GetExpiredTimer(), real, "X"), YDLocalGet(GetExpiredTimer(), real, "Y"), 240.00, null)
	loop
		set ydl_unit = FirstOfGroup(ydl_group)
		exitwhen ydl_unit == null
		call GroupRemoveUnit(ydl_group, ydl_unit)
		if ((IsUnitEnemy( ydl_unit, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))) == true) and (IsUnitType( ydl_unit, UNIT_TYPE_ANCIENT) == false) and (IsUnitAliveBJ( ydl_unit) == true)) then
			call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ydl_unit, OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), ConvertUnitState(0x15)), 4.50), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
		else
		endif
	endloop
	call DestroyGroup(ydl_group)
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_group = null
	set ydl_unit = null
endfunction

function Trig____________________005Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetUnitTypeId( GetTriggerUnit()) == 'N05D')) then
		call YDLocal1Set(effect, "ts", EC_CreateEffect( "war3mapImported\\mr.war3_ring.mdl", GetUnitX( GetEventDamageSource()), GetUnitY( GetEventDamageSource()), 50.00, 270.00, 0.80, 1.0, 0.70))
		call YDLocal1Set(real, "X", GetUnitX( GetEventDamageSource()))
		call YDLocal1Set(real, "Y", GetUnitY( GetEventDamageSource()))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
		call YDLocalSet(ydl_timer, real, "X", YDLocal1Get(real, "X"))
		call YDLocalSet(ydl_timer, real, "Y", YDLocal1Get(real, "Y"))
		call YDLocalSet(ydl_timer, effect, "ts", YDLocal1Get(effect, "ts"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 1.00, false, function Trig____________________005Func002Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 1.00, false," function Trig____________________005Func002Func004T","未命名触发器 005")
#endif 
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

