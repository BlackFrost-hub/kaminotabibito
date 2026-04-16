function Trig_OnMultiKillFunc003Func002Func001Func001Func001Func003Func004Func001Func001A takes nothing returns nothing
    // 设置是有凶手的
    call YDUserDataSet(unit, GetEnumUnit(), "killer", boolean, true)
    call KillUnit( GetEnumUnit() )
endfunction

function Trig_OnMultiKillFunc003Func002Conditions takes nothing returns nothing
    local group ydl_group
    local unit ydl_unit
    local integer ydl_triggerstep
    local trigger ydl_trigger
    if ((YDWEIsTriggerEventId(EVENT_UNIT_DAMAGED) == true)) then
        if ((GetEventDamage() >= GetUnitState(YDLocalGet(GetTriggeringTrigger(), unit, "unit"), UNIT_STATE_LIFE))) then
            // 判断是否同一单位
            call YDWESetEventDamage( 0. )
            if ((YDLocalGet(GetTriggeringTrigger(), unit, "unit") == YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "lastKilledUnit", unit))) then
                call DoNothing(  )
            else
                // If击杀间隔超过＞窗口时间，那么Reset
                if ((OperatorRealSubtract(udg_Elapsed/*游戏运行时间/*, YDLocalGet(GetTriggeringTrigger(), real, "lastKillTime")) > YDLocalGet(GetTriggeringTrigger(), real, "killWindow"))) then
                    call YDUserDataSet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killCount", integer, 1)
                else
                    call YDUserDataSet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killCount", integer, OperatorIntegerAdd(YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killCount", integer), 1))
                endif
                call YDUserDataSet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "lastKillTime", real, udg_Elapsed/*游戏运行时间/*)
                call YDUserDataSet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "lastKilledUnit", unit, YDLocalGet(GetTriggeringTrigger(), unit, "unit"))
                if ((YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killCount", integer) >= 3)) then
                    call ForGroupBJ( YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killGroup", group), function Trig_OnMultiKillFunc003Func002Func001Func001Func001Func003Func004Func001Func001A )
                    call DestroyGroup( YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killGroup", group) )
                else
                endif
            endif
        else
        endif
    else
    endif
    if ((YDWEIsTriggerEventId(EVENT_UNIT_DEATH) == true)) then
        call YDLocalSet(GetTriggeringTrigger(), unit, "killerUnit", GetKillingUnitBJ())
        call GroupRemoveUnit( YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killGroup", group), YDLocalGet(GetTriggeringTrigger(), unit, "unit") )
        if ((CountUnitsInGroup(YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killGroup", group)) <= 0)) then
            // 判断是否被玩家击杀（因为使用的是杀死单位这个动作，也会没有击杀凶手，因此要绑定变量）
            if ((YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "unit"), "killer", boolean) == true)) then
                call DoNothing(  )
            else
                // 判断是否自然死亡
                if ((YDLocalGet(GetTriggeringTrigger(), unit, "killerUnit") == null)) then
                    set STES_Hash = StringHash("OnMultiKillEffectID")
                    set STES_Index = LoadInteger(STES_GetTable(),STES_Hash,skey_index)
                    set STES_LoopA = 0
                    loop
                    exitwhen STES_LoopA>=STES_Index
                    set ydl_trigger = LoadTriggerHandle(STES_GetTable(),STES_Hash,STES_LoopA) 
                    YDLocalExecuteTrigger(ydl_trigger)
                    if (HaveSavedInteger(YDLOC, GetHandleId(ydl_trigger), SKey_Trigger)) then
                        set ydl_triggerstep = GetHandleId(ydl_trigger)
                    endif
                    call SaveInteger(YDHT,GetHandleId(ydl_trigger),SKey_PIndex,StarIndex3)
                    call YDLocal5Set(integer, "EffectID", YDLocalGet(GetTriggeringTrigger(), integer, "EffectID"))
                    call YDLocal5Set(real, "HealAmount", YDLocalGet(GetTriggeringTrigger(), real, "HealAmount"))
                    call YDLocal5Set(unit, "HealTarget", YDLocalGet(GetTriggeringTrigger(), unit, "HealTarget"))
                    call YDLocal5Set(unit, "HealSource", YDLocalGet(GetTriggeringTrigger(), unit, "HealSource"))
                    call YDTriggerExecuteTrigger(ydl_trigger,false)
                    set STES_LoopA = STES_LoopA + 1
                    endloop
                    if ((YDLocalGet(GetTriggeringTrigger(), boolean, "DiyEvent") == true)) then
                        set STES_Hash = StringHash(YDLocalGet(GetTriggeringTrigger(), string, "DiyEventString"))
                        set STES_Index = LoadInteger(STES_GetTable(),STES_Hash,skey_index)
                        set STES_LoopA = 0
                        loop
                        exitwhen STES_LoopA>=STES_Index
                        set ydl_trigger = LoadTriggerHandle(STES_GetTable(),STES_Hash,STES_LoopA) 
                        YDLocalExecuteTrigger(ydl_trigger)
                        if (HaveSavedInteger(YDLOC, GetHandleId(ydl_trigger), SKey_Trigger)) then
                            set ydl_triggerstep = GetHandleId(ydl_trigger)
                        endif
                        call SaveInteger(YDHT,GetHandleId(ydl_trigger),SKey_PIndex,StarIndex3)
                        call YDLocal5Set(unit, "triggerUnit", YDLocalGet(GetTriggeringTrigger(), unit, "triggerUnit"))
                        call YDTriggerExecuteTrigger(ydl_trigger,false)
                        set STES_LoopA = STES_LoopA + 1
                        endloop
                    else
                    endif
                else
                endif
            endif
            if ((YDLocalGet(GetTriggeringTrigger(), boolean, "Finish") == true)) then
                call ShowUnit( YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), true )
                call DestroyGroup( YDUserDataGet(unit, YDLocalGet(GetTriggeringTrigger(), unit, "effectSource"), "killGroup", group) )
            else
            endif
        else
        endif
        call YDLocal4Release()
        call DestroyTrigger(GetTriggeringTrigger())
    else
    endif
    set ydl_group = null
    set ydl_unit = null
    set ydl_trigger = null
endfunction
function Trig_OnMultiKillActions takes nothing returns nothing
    local trigger ydl_trigger
    YDLocalInitialize()
    call YDUserDataSet(unit, YDLocal1Get(unit, "effectSource"), "killCount", integer, 0)
    call YDUserDataSet(unit, YDLocal1Get(unit, "effectSource"), "lastKillTime", real, 0.00)
    call YDUserDataSet(unit, YDLocal1Get(unit, "effectSource"), "lastKilledUnit", unit, null)
    set ydl_trigger = CreateTrigger()
    call SaveInteger(YDLOC,GetHandleId(ydl_trigger),SKey_Trigger,1)
    call YDLocalSet(ydl_trigger, boolean, "DiyEvent", YDLocal1Get(boolean, "DiyEvent"))
    call YDLocalSet(ydl_trigger, string, "DiyEventString", YDLocal1Get(string, "DiyEventString"))
    call YDLocalSet(ydl_trigger, boolean, "Finish", YDLocal1Get(boolean, "Finish"))
    call YDLocalSet(ydl_trigger, unit, "effectSource", YDLocal1Get(unit, "effectSource"))
    call YDLocalSet(ydl_trigger, real, "killWindow", YDLocal1Get(real, "killWindow"))
    call YDLocalSet(ydl_trigger, unit, "killerUnit", YDLocal1Get(unit, "killerUnit"))
    call YDLocalSet(ydl_trigger, real, "lastKillTime", YDLocal1Get(real, "lastKillTime"))
    call YDLocalSet(ydl_trigger, unit, "unit", YDLocal1Get(unit, "unit"))
    call TriggerRegisterUnitEvent( ydl_trigger, YDLocal1Get(unit, "unit"), EVENT_UNIT_DAMAGED )
    call TriggerRegisterUnitEvent( ydl_trigger, YDLocal1Get(unit, "unit"), EVENT_UNIT_DEATH )
    call TriggerAddCondition(ydl_trigger, Condition(function Trig_OnMultiKillFunc003Func002Conditions))
    call YDLocal1Release()
    set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig_OnMultiKill takes nothing returns nothing
    set gg_trg_OnMultiKill = CreateTrigger()
#ifdef DEBUG
    call YDWESaveTriggerName(gg_trg_OnMultiKill, "OnMultiKill")
#endif
    call STES_Register( gg_trg_OnMultiKill, "OnMultiKill" )
    call TriggerAddAction(gg_trg_OnMultiKill, function Trig_OnMultiKillActions)
endfunction

