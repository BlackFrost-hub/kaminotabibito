//===========================================================================
// Trigger: 未命名触发器 005
//===========================================================================
function Trig____________________005Conditions takes nothing returns boolean
	return ((IsUnitType( GetTriggerUnit(), UNIT_TYPE_HERO) == true)) and ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true))
endfunction

function Trig____________________005Func003Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((UnitHasItemOfTypeBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品"))) == true)) then
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I061') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07V') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I02C') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07D') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I056') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I060') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I00V') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I0CA') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I0C9') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07W') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I057') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07U') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I045') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07F') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07Y') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07E') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I043') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I00F') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I06D') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I044'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 1)
		else
		endif
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I039') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I022') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I059') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I025') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I02O'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 2)
		else
		endif
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I095') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I08Q') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I08X') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I0B0') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07M') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07L') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I080') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I03C') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I01H') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I02R') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I01E') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04I') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I051') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I081') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I00H') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07B') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I00T'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 4)
		else
		endif
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I0D3') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I08P') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04K') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I00W') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I040') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I042') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07H') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I041') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I0C3') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I01C') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I03F'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 3)
		else
		endif
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04K') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04L') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I026') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I06C') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04A') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I04B'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 6)
		else
		endif
		if (((GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I05A') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I08E') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I09Y') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I08I') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07J') or (GetItemTypeId( YDLocalGet(GetExpiredTimer(), item, "物品")) == 'I07I'))) then
			call Ir_SetUnitAttackType( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 5)
		else
		endif
	else
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________005Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(item, "物品", GetManipulatedItem())
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
	call YDLocalSet(ydl_timer, item, "物品", YDLocal1Get(item, "物品"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.05, false, function Trig____________________005Func003Func002T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.05, false," function Trig____________________005Func003Func002T","未命名触发器 005")
#endif 
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________005 takes nothing returns nothing
	set gg_trg____________________005 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________005,"未命名触发器 005")
#endif
	call TriggerAddCondition(gg_trg____________________005, Condition(function Trig____________________005Conditions))
	call TriggerAddAction(gg_trg____________________005, function Trig____________________005Actions)
endfunction

