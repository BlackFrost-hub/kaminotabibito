//===========================================================================
// Trigger: 未命名触发器 002
//===========================================================================
function Trig____________________002Conditions takes nothing returns boolean
	return (((UnitHasBuffBJ( GetEventDamageSource(), 'B00U') == true) or ((GetUnitTypeId( GetEventDamageSource()) == 'O005') and ((UnitHasBuffBJ( GetTriggerUnit(), udg_MFXG[1]) == true) or (UnitHasBuffBJ( GetTriggerUnit(), udg_MFXG[2]) == true)))))
endfunction

function Trig____________________002Func004Func004T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 1.00)
	call PauseUnit( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), false)
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

function Trig____________________002Func005Func006003003 takes nothing returns boolean
	return (((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and (IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false)) and (((IsUnitAliveBJ( GetFilterUnit()) == true) and (GetFilterUnit() != GetTriggerUnit())) and (IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( GetEventDamageSource())) == true)))
endfunction

function Trig____________________002Func005Func011A takes nothing returns nothing
	call UnitDamageTarget( GetEventDamageSource(), GetEnumUnit(), OperatorRealMultiply( YDLocal2Get(real, "伤害值"), 1.00), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig____________________002Func005Func014T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"), 1.00)
	call YDWEUnitRemoveStun( YDLocalGet(GetExpiredTimer(), unit, "GetEventDamageSource"))
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

function Trig____________________002Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetUnitTypeId( GetEventDamageSource()) == 'N05J')) then
		call YDLocal1Set(real, "暴击率", OperatorRealAdd( YDLocal1Get(real, "暴击率"), OperatorRealMultiply( YDUserDataGet(unit, GetTriggerUnit(),"沙漠食人魔", real), 0.20)))
	else
	endif
	if ((GetUnitTypeId( GetEventDamageSource()) == 'n03M')) then
		call YDLocal1Set(real, "初始伤害", OperatorRealDivide( GetEventDamage(), OperatorRealSubtract( 1.00, OperatorRealDivide( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x20)), OperatorRealAdd( GetUnitState( GetTriggerUnit(), ConvertUnitState(0x20)), 50.00)))))
		call YDLocal1Set(real, "伤害值", OperatorRealMultiply( YDLocal1Get(real, "初始伤害"), YDLocal1Get(real, "输出暴击伤害")))
	else
		call YDLocal1Set(real, "伤害值", OperatorRealMultiply( GetEventDamage(), YDLocal1Get(real, "输出暴击伤害")))
	endif
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) == false) and (GetUnitTypeId( GetEventDamageSource()) == 'N05J')) then
		call YDUserDataSet(unit, GetTriggerUnit(),"沙漠食人魔蓄力", real, 0.00)
	else
	endif
	if ((GetUnitTypeId( GetEventDamageSource()) == 'n03M')) then
		call PauseUnit( GetEventDamageSource(), true)
		call SetUnitTimeScale( GetEventDamageSource(), 1.50)
		call SetUnitAnimationByIndex( GetEventDamageSource(), 3)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.66, false, function Trig____________________002Func004Func004T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.66, false," function Trig____________________002Func004Func004T","未命名触发器 002")
#endif 
	else
	endif
	if ((YDWEIsEventAttackType( ATTACK_TYPE_NORMAL) != true) and (GetUnitTypeId( GetEventDamageSource()) == 'E05V')) then
		call YDWEUnitAddStun( GetEventDamageSource())
		call SetUnitTimeScale( GetEventDamageSource(), 3.00)
		call SetUnitAnimationByIndex( GetEventDamageSource(), 11)
		call YDLocal1Set(location, "触发单位点", GetUnitLoc( GetTriggerUnit()))
		call YDLocal1Set(group, "判断碰撞单位组", GetUnitsInRangeOfLocMatching( 300.00, YDLocal1Get(location, "触发单位点"), Condition(function Trig____________________002Func005Func006003003)))
		call YDLocal1Set(effect, "雷霆一击", AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit())))
		call EXSetEffectZ( YDLocal1Get(effect, "雷霆一击"), GetUnitFlyHeight( GetTriggerUnit()))
		call EXSetEffectSize( YDLocal1Get(effect, "雷霆一击"), YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( GetTriggerUnit()), "modelScale"))
		call YDWETimerDestroyEffect( 1.00, YDLocal1Get(effect, "雷霆一击"))
		call ForGroupBJ( YDLocal1Get(group, "判断碰撞单位组"),function Trig____________________002Func005Func011A)
		call RemoveLocation( YDLocal1Get(location, "触发单位点"))
		call DestroyGroup( YDLocal1Get(group, "判断碰撞单位组"))
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, unit, "GetEventDamageSource", GetEventDamageSource())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.20, false, function Trig____________________002Func005Func014T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.20, false," function Trig____________________002Func005Func014T","未命名触发器 002")
#endif 
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________002 takes nothing returns nothing
	set gg_trg____________________002 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________002,"未命名触发器 002")
#endif
	call TriggerAddCondition(gg_trg____________________002, Condition(function Trig____________________002Conditions))
	call TriggerAddAction(gg_trg____________________002, function Trig____________________002Actions)
endfunction

