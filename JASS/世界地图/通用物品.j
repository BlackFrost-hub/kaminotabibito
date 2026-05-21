//===========================================================================
// Trigger: 获得物品触发事件
//===========================================================================
function Trig_________________________uConditions takes nothing returns boolean
	return ((IsUnitInGroup( GetTriggerUnit(), YDUserDataGet(string, "玩家英雄","单位组", group)) == true))
endfunction

function Trig_________________________uFunc009Func001T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call RemoveItem( YDLocalGet(GetExpiredTimer(), item, "GetManipulatedItem"))
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

function Trig_________________________uActions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	//告知ai：注意jass的全局条件
	//吃书残留清除
	if (((GetItemType( GetManipulatedItem()) == ITEM_TYPE_CHARGED) or (GetItemType( GetManipulatedItem()) == ITEM_TYPE_PURCHASABLE))) then
		if ((GetItemCharges( GetManipulatedItem()) <= 1) and (YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_ITEM, GetItemTypeId( GetManipulatedItem()), "perishable") == 1) and (IsItemPowerup( GetManipulatedItem()) == true)) then
			call RemoveItem( GetManipulatedItem())
		else
		endif
	else
	endif
	//获取附带特效
	if ((GetItemTypeId( GetManipulatedItem()) == 'I0CX')) then
		call RemoveItem( GetManipulatedItem())
		call YDLocal1Set(effect, "t", EC_CreateEffect( "Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl", GetUnitX( GetTriggerUnit()), GetUnitY( GetTriggerUnit()), 0.0, 270.0, 1.50, 1.0, 1.50))
	else
	endif
	//合成打造
	if (((GetItemTypeId( GetManipulatedItem()) == 'I01A') or (GetItemTypeId( GetManipulatedItem()) == 'I04U'))) then
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, item, "GetManipulatedItem", GetManipulatedItem())
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.50, false, function Trig_________________________uFunc009Func001T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.50, false," function Trig_________________________uFunc009Func001T","获得物品触发事件")
#endif 
	else
	endif
	//传送
	//告知ai：传送在TS\系统\02．物品系统\15．装备技能\00．物品\00．通用物品\01 .传送集合 下一个物品一个文件，以后会扩展
	if ((GetItemTypeId( GetManipulatedItem()) == 'I06Z')) then
		call YDLocal1Set(location, "镜头点", GetRectCenter( gg_rct______________091))
		call PanCameraToTimedLocForPlayer( GetOwningPlayer( GetTriggerUnit()), YDLocal1Get(location, "镜头点"), 0)
		call SetUnitPosition( GetTriggerUnit(), 14853.40, -14964.30)
		call RemoveItem( GetManipulatedItem())
	else
	endif
	//领取技能
	if ((GetItemTypeId( GetManipulatedItem()) == 'I0CW')) then
		call RemoveItem( GetItemOfTypeFromUnitBJ( GetTriggerUnit(), GetItemTypeId( GetManipulatedItem())))
		if ((YDUserDataHas(player, GetOwningPlayer( GetTriggerUnit()),"FF", abilcode) == true) and (YDUserDataGet(player, GetOwningPlayer( GetTriggerUnit()),"FF领取", boolean) == false)) then
			call BJDebugMsg( "TRIGSTR_9075")
			call YDUserDataSet(player, GetOwningPlayer( GetTriggerUnit()),"FF领取", boolean, true)
			call UnitAddAbility( GetManipulatingUnit(), YDUserDataGet2(player, GetOwningPlayer( GetTriggerUnit()),"FF", abilcode))
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_________________________u takes nothing returns nothing
	set gg_trg_________________________u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_________________________u,"获得物品触发事件")
#endif
	call TriggerRegisterAnyUnitEventBJ(gg_trg_________________________u, EVENT_PLAYER_UNIT_PICKUP_ITEM)
	call TriggerAddCondition(gg_trg_________________________u, Condition(function Trig_________________________uConditions))
	call TriggerAddAction(gg_trg_________________________u, function Trig_________________________uActions)
endfunction

