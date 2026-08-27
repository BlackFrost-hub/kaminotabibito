--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Blizzard.j / YDTrigger `BJOptimization/Unit.h` 等单位相关 BJ 封装（迁入 BJ 库）。
-- 
-- 分文件约定：
-- - `GetAttackedUnitBJ` → `01．触发与事件`
-- - `GetUnitLifePercent`、`GetUnitManaPercent`、`SetUnitLifeBJ`、`SetUnitManaBJ` 及 `IsUnitDeadBJ` / `IsUnitAliveBJ`、英雄与百分比 API → `02．单位与英雄`
-- - 商店库存 → `03．物品与库存`
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local forEachUnitInGroup = ____require_result_0.forEachUnitInGroup
local CreateCorpse = jass.CreateCorpse
local GetLocationX = jass.GetLocationX
local GetLocationY = jass.GetLocationY
local SetUnitBlendTime = jass.SetUnitBlendTime
local SetUnitAnimation = jass.SetUnitAnimation
local GroupAddUnit = jass.GroupAddUnit
local TimerStart = jass.TimerStart
function ____exports.String2UnitIdBJ(unitIdString)
    return jass:UnitId(unitIdString)
end
function ____exports.GetIssuedOrderIdBJ()
    return jass:GetIssuedOrderId()
end
function ____exports.GetKillingUnitBJ()
    return jass:GetKillingUnit()
end
function ____exports.UnitSuspendDecayBJ(suspend, unit)
    jass:UnitSuspendDecay(unit, suspend)
end
function ____exports.GetUnitStateSwap(state, unit)
    return jass:GetUnitState(unit, state)
end
function ____exports.SelectUnitSingle(unit)
    jass:ClearSelection()
    jass:SelectUnit(unit, true)
end
function ____exports.SelectGroupBJ(group)
    jass:ClearSelection()
    forEachUnitInGroup(
        nil,
        group,
        function(u)
            if u ~= nil then
                jass:SelectUnit(u, true)
            end
        end
    )
end
function ____exports.SelectUnitAdd(unit)
    jass:SelectUnit(unit, true)
end
function ____exports.SelectUnitRemove(unit)
    jass:SelectUnit(unit, false)
end
--- 对齐 Blizzard.j 的 ForceUICancelBJ：取消指定玩家当前打开的技能/目标选择界面。
function ____exports.ForceUICancelBJ(player)
    if player == nil or player == 0 then
        return
    end
    jass:ForceUICancel(player)
end
function ____exports.IsUnitHiddenBJ(unit)
    return jass:IsUnitHidden(unit)
end
function ____exports.ShowUnitHide(unit)
    jass:ShowUnit(unit, false)
end
function ____exports.IssueTrainOrderByIdBJ(unit, id)
    return jass:IssueImmediateOrderById(unit, id)
end
function ____exports.GroupTrainOrderByIdBJ(group, id)
    return jass:GroupImmediateOrderById(group, id)
end
function ____exports.IssueUpgradeOrderByIdBJ(unit, id)
    return jass:IssueUpgradeOrderById(unit, id)
end
function ____exports.SetUnitFlyHeightBJ(unit, height, rate)
    jass:SetUnitFlyHeight(unit, height, rate)
end
function ____exports.SetUnitTurnSpeedBJ(unit, speed)
    jass:SetUnitTurnSpeed(unit, speed)
end
function ____exports.GetUnitDefaultPropWindowBJ(unit)
    return jass:GetUnitDefaultPropWindow(unit)
end
function ____exports.SetUnitBlendTimeBJ(unit, time)
    jass:SetUnitBlendTime(unit, time)
end
function ____exports.SetUnitAcquireRangeBJ(unit, range)
    jass:SetUnitAcquireRange(unit, range)
end
function ____exports.UnitSetCanSleepBJ(unit, canSleep)
    jass:UnitAddSleep(unit, canSleep)
end
function ____exports.UnitCanSleepBJ(unit)
    return jass:UnitCanSleep(unit)
end
function ____exports.UnitWakeUpBJ(unit)
    jass:UnitWakeUp(unit)
end
function ____exports.UnitIsSleepingBJ(unit)
    return jass:UnitIsSleeping(unit)
end
function ____exports.UnitGenerateAlarms(unit, generate)
    jass:UnitIgnoreAlarm(unit, not generate)
end
function ____exports.PauseUnitBJ(pause, unit)
    jass:PauseUnit(unit, pause)
end
function ____exports.IsUnitPausedBJ(unit)
    return jass:IsUnitPaused(unit)
end
function ____exports.ResetUnitAnimation(whichUnit)
    if whichUnit == nil or whichUnit == 0 then
        return
    end
    jass:SetUnitAnimation(whichUnit, "stand")
end
function ____exports.UnitPauseTimedLifeBJ(flag, unit)
    jass:UnitPauseTimedLife(unit, flag)
end
function ____exports.UnitApplyTimedLifeBJ(duration, buffId, unit)
    jass:UnitApplyTimedLife(unit, buffId, duration)
end
function ____exports.UnitShareVisionBJ(share, unit, player)
    jass:UnitShareVision(unit, player, share)
end
function ____exports.UnitRemoveAbilityBJ(abilityId, unit)
    return jass:UnitRemoveAbility(unit, abilityId)
end
function ____exports.UnitAddAbilityBJ(abilityId, unit)
    return jass:UnitAddAbility(unit, abilityId)
end
function ____exports.UnitRemoveTypeBJ(____type, unit)
    return jass:UnitRemoveType(unit, ____type)
end
function ____exports.UnitAddTypeBJ(____type, unit)
    return jass:UnitAddType(unit, ____type)
end
function ____exports.UnitMakeAbilityPermanentBJ(permanent, abilityId, unit)
    jass:UnitMakeAbilityPermanent(unit, permanent, abilityId)
end
function ____exports.SetUnitExplodedBJ(unit, exploded)
    jass:SetUnitExploded(unit, exploded)
end
function ____exports.GetTransportUnitBJ()
    return jass:GetTransportUnit()
end
function ____exports.GetLoadedUnitBJ()
    return jass:GetLoadedUnit()
end
function ____exports.IsUnitInTransportBJ(unit, transport)
    return jass:IsUnitInTransport(unit, transport)
end
function ____exports.IsUnitLoadedBJ(unit)
    return jass:IsUnitLoaded(unit)
end
function ____exports.IsUnitIllusionBJ(unit)
    return jass:IsUnitIllusion(unit)
end
function ____exports.SetUnitUseFoodBJ(enable, unit)
    jass:SetUnitUseFood(unit, enable)
end
function ____exports.UnitDamageTargetBJ(unit, target, amount, attacktype, damagetype)
    local ____temp_1
    if jass.WEAPON_TYPE_WHOKNOWS ~= nil then
        ____temp_1 = jass.WEAPON_TYPE_WHOKNOWS
    else
        ____temp_1 = nil
    end
    local weapon = ____temp_1
    return jass:UnitDamageTarget(
        unit,
        target,
        amount,
        true,
        false,
        attacktype,
        damagetype,
        weapon
    )
end
function ____exports.UnitId2OrderIdBJ(unitId)
    return unitId
end
function ____exports.GetLastCreatedUnit()
    return jglobals.bj_lastCreatedUnit
end
function ____exports.GetLastReplacedUnitBJ()
    return jglobals.bj_lastReplacedUnit
end
--- 对齐 Blizzard.j：
-- function DoesUnitGenerateAlarms takes unit whichUnit returns boolean
--     return not UnitIgnoreAlarmToggled(whichUnit)
-- endfunction
function ____exports.DoesUnitGenerateAlarms(unit)
    return not jass:UnitIgnoreAlarmToggled(unit)
end
function ____exports.GetUnitPropWindowBJ(unit)
    return jass:GetUnitPropWindow(unit) * jglobals.bj_RADTODEG
end
--- 对应 Blizzard.j 的 CreatePermanentCorpseLocBJ。
function ____exports.CreatePermanentCorpseLocBJ(style, unitid, whichPlayer, loc, facing)
    if loc == nil or loc == 0 then
        return nil
    end
    local corpse = CreateCorpse(
        whichPlayer,
        unitid,
        GetLocationX(loc),
        GetLocationY(loc),
        facing
    )
    jglobals.bj_lastCreatedUnit = corpse
    if corpse == nil or corpse == 0 then
        return corpse
    end
    SetUnitBlendTime(corpse, 0)
    local fleshStyle = jglobals.bj_CORPSETYPE_FLESH
    local ____temp_2
    if style == fleshStyle then
        ____temp_2 = jglobals.bj_suspendDecayFleshGroup
    else
        ____temp_2 = jglobals.bj_suspendDecayBoneGroup
    end
    local decayGroup = ____temp_2
    SetUnitAnimation(corpse, style == fleshStyle and "decay flesh" or "decay bone")
    if decayGroup ~= nil and decayGroup ~= 0 then
        GroupAddUnit(decayGroup, corpse)
    end
    local decayTimer = jglobals.bj_delayedSuspendDecayTimer
    if decayTimer ~= nil and decayTimer ~= 0 then
        TimerStart(decayTimer, 0.05, false, nil)
    end
    return corpse
end
return ____exports
