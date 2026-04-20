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
local stringToFourCC = ____require_result_0.stringToFourCC
function ____exports.String2UnitIdBJ(self, unitIdString)
    return jass.UnitId(unitIdString)
end
function ____exports.GetIssuedOrderIdBJ(self)
    return jass.GetIssuedOrderId()
end
function ____exports.GetKillingUnitBJ(self)
    return jass.GetKillingUnit()
end
function ____exports.UnitSuspendDecayBJ(self, suspend, unit)
    jass.UnitSuspendDecay(unit, suspend)
end
function ____exports.GetUnitStateSwap(self, state, unit)
    return jass.GetUnitState(unit, state)
end
function ____exports.SelectUnitSingle(self, unit)
    jass.ClearSelection()
    jass.SelectUnit(unit, true)
end
function ____exports.SelectGroupBJ(self, group)
    jass.ClearSelection()
    jass.ForGroup(
        group,
        function()
            local u = jass.GetEnumUnit()
            if u ~= nil then
                jass.SelectUnit(u, true)
            end
        end
    )
end
function ____exports.SelectUnitAdd(self, unit)
    jass.SelectUnit(unit, true)
end
function ____exports.SelectUnitRemove(self, unit)
    jass.SelectUnit(unit, false)
end
function ____exports.IsUnitHiddenBJ(self, unit)
    return jass.IsUnitHidden(unit)
end
function ____exports.ShowUnitHide(self, unit)
    jass.ShowUnit(unit, false)
end
function ____exports.IssueTrainOrderByIdBJ(self, unit, id)
    return jass.IssueImmediateOrderById(unit, id)
end
function ____exports.GroupTrainOrderByIdBJ(self, group, id)
    return jass.GroupImmediateOrderById(group, id)
end
function ____exports.IssueUpgradeOrderByIdBJ(self, unit, id)
    return jass.IssueUpgradeOrderById(unit, id)
end
function ____exports.SetUnitFlyHeightBJ(self, unit, height, rate)
    jass.SetUnitFlyHeight(unit, height, rate)
end
function ____exports.SetUnitTurnSpeedBJ(self, unit, speed)
    jass.SetUnitTurnSpeed(unit, speed)
end
function ____exports.GetUnitDefaultPropWindowBJ(self, unit)
    return jass.GetUnitDefaultPropWindow(unit)
end
function ____exports.SetUnitBlendTimeBJ(self, unit, time)
    jass.SetUnitBlendTime(unit, time)
end
function ____exports.SetUnitAcquireRangeBJ(self, unit, range)
    jass.SetUnitAcquireRange(unit, range)
end
function ____exports.UnitSetCanSleepBJ(self, unit, canSleep)
    jass.UnitAddSleep(unit, canSleep)
end
function ____exports.UnitCanSleepBJ(self, unit)
    return jass.UnitCanSleep(unit)
end
function ____exports.UnitWakeUpBJ(self, unit)
    jass.UnitWakeUp(unit)
end
function ____exports.UnitIsSleepingBJ(self, unit)
    return jass.UnitIsSleeping(unit)
end
function ____exports.UnitGenerateAlarms(self, unit, generate)
    jass.UnitIgnoreAlarm(unit, not generate)
end
function ____exports.PauseUnitBJ(self, pause, unit)
    jass.PauseUnit(unit, pause)
end
function ____exports.IsUnitPausedBJ(self, unit)
    return jass.IsUnitPaused(unit)
end
function ____exports.UnitPauseTimedLifeBJ(self, flag, unit)
    jass.UnitPauseTimedLife(unit, flag)
end
function ____exports.UnitApplyTimedLifeBJ(self, duration, buffId, unit)
    jass.UnitApplyTimedLife(unit, buffId, duration)
end
function ____exports.UnitShareVisionBJ(self, share, unit, player)
    jass.UnitShareVision(unit, player, share)
end
function ____exports.UnitRemoveAbilityBJ(self, abilityId, unit)
    return jass.UnitRemoveAbility(unit, abilityId)
end
function ____exports.UnitAddAbilityBJ(self, abilityId, unit)
    return jass.UnitAddAbility(unit, abilityId)
end
function ____exports.UnitRemoveTypeBJ(self, ____type, unit)
    return jass.UnitRemoveType(unit, ____type)
end
function ____exports.UnitAddTypeBJ(self, ____type, unit)
    return jass.UnitAddType(unit, ____type)
end
function ____exports.UnitMakeAbilityPermanentBJ(self, permanent, abilityId, unit)
    jass.UnitMakeAbilityPermanent(unit, permanent, abilityId)
end
function ____exports.SetUnitExplodedBJ(self, unit, exploded)
    jass.SetUnitExploded(unit, exploded)
end
function ____exports.GetTransportUnitBJ(self)
    return jass.GetTransportUnit()
end
function ____exports.GetLoadedUnitBJ(self)
    return jass.GetLoadedUnit()
end
function ____exports.IsUnitInTransportBJ(self, unit, transport)
    return jass.IsUnitInTransport(unit, transport)
end
function ____exports.IsUnitLoadedBJ(self, unit)
    return jass.IsUnitLoaded(unit)
end
function ____exports.IsUnitIllusionBJ(self, unit)
    return jass.IsUnitIllusion(unit)
end
function ____exports.SetUnitUseFoodBJ(self, enable, unit)
    jass.SetUnitUseFood(unit, enable)
end
function ____exports.UnitDamageTargetBJ(self, unit, target, amount, attacktype, damagetype)
    local ____temp_1
    if jass.WEAPON_TYPE_WHOKNOWS ~= nil then
        ____temp_1 = jass.WEAPON_TYPE_WHOKNOWS
    else
        ____temp_1 = nil
    end
    local weapon = ____temp_1
    return jass.UnitDamageTarget(
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
function ____exports.UnitId2OrderIdBJ(self, unitId)
    return unitId
end
function ____exports.GetLastCreatedUnit(self)
    return jglobals.bj_lastCreatedUnit
end
function ____exports.GetLastReplacedUnitBJ(self)
    return jglobals.bj_lastReplacedUnit
end
--- 对齐 Blizzard.j：
-- function DoesUnitGenerateAlarms takes unit whichUnit returns boolean
--     return not UnitIgnoreAlarmToggled(whichUnit)
-- endfunction
function ____exports.DoesUnitGenerateAlarms(self, unit)
    return not jass.UnitIgnoreAlarmToggled(unit)
end
function ____exports.GetUnitPropWindowBJ(self, unit)
    return jass.GetUnitPropWindow(unit) * jglobals.bj_RADTODEG
end
return ____exports
