function Trig_HealAnyUnitFunc001Func001Func005Func002Func008T takes nothing returns nothing
    call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "HealUnit"), "因果之力冷却", boolean, false)
    #ifdef StarDebuggerIncluded
    call SDR_DebugTimer_Remove( GetExpiredTimer() ) 
    #endif
    call YDLocal3Release()
    call DestroyTimer(GetExpiredTimer())
endfunction

function Trig_HealAnyUnitFunc001Func001Func005Func004T takes nothing returns nothing
    call Cya_Attribute_SetState( YDLocalGet(GetExpiredTimer(), unit, "HealUnit"), 5, 2, 0.05 )
    call YDUserDataSet(unit, YDLocalGet(GetExpiredTimer(), unit, "HealUnit"), "圆环之力", integer, OperatorIntegerAdd(YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "HealUnit"), "圆环之力", integer), -1))
    #ifdef StarDebuggerIncluded
    call SDR_DebugTimer_Remove( GetExpiredTimer() ) 
    #endif
    call YDLocal3Release()
    call DestroyTimer(GetExpiredTimer())
endfunction

function Trig_HealAnyUnitActions takes nothing returns nothing
    local timer ydl_timer
    local trigger ydl_trigger
    local integer ydl_triggerstep
    YDLocalInitialize()
    if ((YDLocal1Get(real, "HealAmount") >= 0.20) and (IsUnitOwnedByPlayer(YDLocal1Get(unit, "HealSource"), GetOwningPlayer(YDUserDataGet(string, "鹿目圆香", "单位", unit))) == true) and (IsUnitType(YDLocal1Get(unit, "HealUnit"), UNIT_TYPE_HERO) == true) and (IsUnitType(YDLocal1Get(unit, "HealUnit"), UNIT_TYPE_SUMMONED) == false)) then
        if ((YDUserDataGet(unit, YDLocal1Get(unit, "HealUnit"), "圆环之力", integer) >= 10)) then
            if ((YDUserDataGet(unit, YDLocal1Get(unit, "HealUnit"), "因果之力冷却", boolean) == false)) then
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[1] )
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[2] )
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[3] )
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[4] )
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[5] )
                call UnitRemoveAbility( YDLocal1Get(unit, "HealUnit"), udg_MFXG[6] )
                call YDUserDataSet(unit, YDLocal1Get(unit, "HealUnit"), "因果之力冷却", boolean, true)
                set ydl_timer = CreateTimer()
                call YDLocalSet(ydl_timer, unit, "HealUnit", YDLocal1Get(unit, "HealUnit"))
                call TimerStart(ydl_timer, 12.00, false, function Trig_HealAnyUnitFunc001Func001Func005Func002Func008T)
                #ifdef StarDebuggerIncluded
                call SDR_DebugTimer(ydl_timer, 12.00, false, "function Trig_HealAnyUnitFunc001Func001Func005Func002Func008T")
                #endif
                set STES_Hash = StringHash("治疗事件")
                set STES_Index = LoadInteger(STES_GetTable(),STES_Hash,skey_index)
                set STES_LoopA = 0
                loop
                exitwhen STES_LoopA>=STES_Index
                set ydl_trigger = LoadTriggerHandle(STES_GetTable(),STES_Hash,STES_LoopA) 
                YDLocalExecuteTrigger(ydl_trigger)
                if (HaveSavedInteger(YDLOC, GetHandleId(ydl_trigger), SKey_Trigger)) then
                    set ydl_triggerstep = GetHandleId(ydl_trigger)
                endif
                call YDLocal5Set(real, "HealAmount", OperatorRealMultiply(GetUnitState(YDLocal1Get(unit, "HealUnit"), UNIT_STATE_MAX_LIFE), 0.20))
                call YDLocal5Set(unit, "HealTarget", YDLocal1Get(unit, "HealUnit"))
                call YDLocal5Set(unit, "HealSource", YDUserDataGet(string, "鹿目圆香", "单位", unit))
                call YDLocal5Set(boolean, "HealEffect", true)
                call YDTriggerExecuteTrigger(ydl_trigger,false)
                set STES_LoopA = STES_LoopA + 1
                endloop
            else
            endif
        else
            call Cya_Attribute_SetState( YDLocal1Get(unit, "HealUnit"), 5, 1, 0.05 )
            call YDUserDataSet(unit, YDLocal1Get(unit, "HealUnit"), "圆环之力", integer, OperatorIntegerAdd(YDUserDataGet(unit, YDLocal1Get(unit, "HealUnit"), "圆环之力", integer), 1))
            set ydl_timer = CreateTimer()
            call YDLocalSet(ydl_timer, unit, "HealUnit", YDLocal1Get(unit, "HealUnit"))
            call TimerStart(ydl_timer, 13.00, false, function Trig_HealAnyUnitFunc001Func001Func005Func004T)
            #ifdef StarDebuggerIncluded
            call SDR_DebugTimer(ydl_timer, 13.00, false, "function Trig_HealAnyUnitFunc001Func001Func005Func004T")
            #endif
        endif
    else
    endif
    if ((UnitHasBuffBJ(YDLocal1Get(unit, "HealUnit"), 'B01Z') == true)) then
        call YDLocal1Set(real, "SH", OperatorRealMultiply(YDLocal1Get(real, "HealAmount"), OperatorRealAdd(1.00, OperatorRealMultiply(0.07, udg_N))))
        call UnitDamageTarget( YDUserDataGet(string, "Boss", "沙漠食人魔", unit), YDLocal1Get(unit, "HealUnit"), YDLocal1Get(real, "SH"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS )
        call EC_CreateEffect( "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl", GetUnitX(YDLocal1Get(unit, "HealUnit")), GetUnitY(YDLocal1Get(unit, "HealUnit")), 0.0, 270.0, 1.50, 1.0, 1.00 )
    else
    endif
    call YDLocal1Release()
    set ydl_timer = null
    set ydl_trigger = null
endfunction

//===========================================================================
function InitTrig_HealAnyUnit takes nothing returns nothing
    set gg_trg_HealAnyUnit = CreateTrigger()
#ifdef DEBUG
    call YDWESaveTriggerName(gg_trg_HealAnyUnit, "HealAnyUnit")
#endif
    call STES_Register( gg_trg_HealAnyUnit, "任意单位被治疗" )
    call TriggerAddAction(gg_trg_HealAnyUnit, function Trig_HealAnyUnitActions)
endfunction

