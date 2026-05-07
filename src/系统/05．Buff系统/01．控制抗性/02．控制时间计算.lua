local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
--- 控制时间计算模块
-- 
-- 功能：计算削减后的控制时间，应用上限
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.00．控制抗性常量")
local CONTROL_REDUCTION_CAP = ____require_result_2.CONTROL_REDUCTION_CAP
local BOSS_CONTROL_LIMITS = ____require_result_2.BOSS_CONTROL_LIMITS
local ____require_result_3 = require("系统.05．Buff系统.01．控制抗性.01．控制检测")
local getHeroDuration = ____require_result_3.getHeroDuration
--- 获取单位的减少控制时间属性
-- 
-- 优先级：单位属性 > 玩家属性
function ____exports.getControlReduction(self, unit)
    local unitValue = YDUserDataGet(
        nil,
        "unit",
        unit,
        "眩晕抗性",
        "real"
    )
    if unitValue > 0.01 then
        return unitValue
    end
    local player = jass.GetOwningPlayer(unit)
    if player ~= nil then
        local playerValue = YDUserDataGet(
            nil,
            "player",
            player,
            "眩晕抗性",
            "real"
        )
        if playerValue > 0.01 then
            return playerValue
        end
    end
    return 0
end
--- 应用控制时间削减上限
function ____exports.applyControlReductionCap(self, reduction)
    return reduction < CONTROL_REDUCTION_CAP and reduction or CONTROL_REDUCTION_CAP
end
--- 检查并应用Boss控制时间上限
function ____exports.applyBossControlLimit(self, unit, duration)
    local unitTypeId = jass.GetUnitTypeId(unit)
    for ____, ____value in ipairs(__TS__ObjectEntries(BOSS_CONTROL_LIMITS)) do
        local idStr = ____value[1]
        local limit = ____value[2]
        if stringToFourCC(nil, idStr) == unitTypeId and duration > limit then
            return limit
        end
    end
    return duration
end
--- 基于原始持续时间计算削减后的控制时长
-- 
-- 供快速Buff等直接传入持续时间的场景复用。
function ____exports.calcReducedControlDuration(self, target, originalDuration)
    local duration = originalDuration
    local reduction = ____exports.getControlReduction(nil, target)
    if reduction > 0.01 then
        reduction = ____exports.applyControlReductionCap(nil, reduction)
        duration = originalDuration * (1 - reduction)
    end
    return ____exports.applyBossControlLimit(nil, target, duration)
end
--- 计算削减后的控制时间
-- 
-- @param target 目标单位
-- @param abilityId 技能ID
-- @returns 实际控制时间
function ____exports.calcReducedControlTime(self, target, abilityId)
    local originalDuration = getHeroDuration(nil, abilityId)
    return ____exports.calcReducedControlDuration(nil, target, originalDuration)
end
return ____exports
