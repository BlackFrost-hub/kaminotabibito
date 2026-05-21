//===========================================================================
// Trigger: 未命名触发器 004
//===========================================================================
function Trig____________________004Actions takes nothing returns nothing
	call UnitAddItemByIdSwapped( 'ratf', gg_unit_Hamg_0002)
endfunction

//===========================================================================
function InitTrig____________________004 takes nothing returns nothing
	set gg_trg____________________004 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________004,"未命名触发器 004")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________004, Player(0), "252", true)
	call TriggerAddAction(gg_trg____________________004, function Trig____________________004Actions)
endfunction
 //===========================================================================
// Trigger: 未命名触发器 006
//===========================================================================
function Trig____________________006Conditions takes nothing returns boolean
	return ((GetItemTypeId( GetManipulatedItem()) == 'ratf'))
endfunction

function Trig____________________006Actions takes nothing returns nothing
	call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "111")
endfunction

//===========================================================================
function InitTrig____________________006 takes nothing returns nothing
	set gg_trg____________________006 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________006,"未命名触发器 006")
#endif
	call TriggerRegisterAnyUnitEventBJ(gg_trg____________________006, EVENT_PLAYER_UNIT_PICKUP_ITEM)
	call TriggerAddCondition(gg_trg____________________006, Condition(function Trig____________________006Conditions))
	call TriggerAddAction(gg_trg____________________006, function Trig____________________006Actions)
endfunction