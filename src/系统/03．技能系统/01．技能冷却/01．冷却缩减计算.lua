local ____lualib = require("lualib_bundle")
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
--- 冷却缩减计算模块
-- 
-- 功能：计算技能冷却缩减，应用上限
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDWESetUnitAbilityDataReal = ____require_result_0.YDWESetUnitAbilityDataReal
local getObjectPropertyReal = ____require_result_0.getObjectPropertyReal
local ObjectType = ____require_result_0.ObjectType
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____require_result_2 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local COOLDOWN_REDUCTION_CAP = ____require_result_2.COOLDOWN_REDUCTION_CAP
local SKILL_COOLDOWN_CAPS = ____require_result_2.SKILL_COOLDOWN_CAPS
local COOLDOWN_BLACKLIST = ____require_result_2.COOLDOWN_BLACKLIST
--- 检查技能是否在黑名单中
function ____exports.isBlacklistedSkill(self, abilityId)
    return __TS__ArraySome(
        COOLDOWN_BLACKLIST,
        function(____, id) return stringToFourCC(nil, id) == abilityId end
    )
end
--- 检查单位是否为特殊单位（E001不参与冷却缩减）
function ____exports.isExcludedUnit(self, unit)
    local unitTypeId = jass:GetUnitTypeId(unit)
    return unitTypeId == stringToFourCC(nil, "E001")
end
--- 获取冷却缩减属性
function ____exports.getCooldownReduction(self, unit)
    local player = jass:GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        "冷却缩减",
        "real"
    )
end
--- 获取冷却缩减加成属性（突破上限）
function ____exports.getCooldownReductionBonus(self, unit)
    local player = jass:GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        "冷却缩减加成",
        "real"
    )
end
--- 获取技能冷却上限
-- 
-- @param abilityId 技能ID
-- @param hasBonus 是否有突破上限属性
-- @returns 冷却上限
function ____exports.getCooldownCap(self, abilityId, hasBonus)
    for ____, ____value in ipairs(__TS__ObjectEntries(SKILL_COOLDOWN_CAPS)) do
        local idStr = ____value[1]
        local cap = ____value[2]
        if stringToFourCC(nil, idStr) == abilityId then
            return cap
        end
    end
    if hasBonus then
        local bonus = 0
        return COOLDOWN_REDUCTION_CAP + bonus
    end
    return COOLDOWN_REDUCTION_CAP
end
--- 应用冷却缩减上限
function ____exports.applyCooldownCap(self, reduction, abilityId, bonus)
    for ____, ____value in ipairs(__TS__ObjectEntries(SKILL_COOLDOWN_CAPS)) do
        local idStr = ____value[1]
        local cap = ____value[2]
        if stringToFourCC(nil, idStr) == abilityId then
            return math.min(reduction, cap)
        end
    end
    local cap = COOLDOWN_REDUCTION_CAP + bonus
    return math.min(reduction, cap)
end
--- 获取技能原始冷却时间
function ____exports.getBaseCooldown(self, abilityId, level)
    local coolKey = "Cool" .. tostring(level)
    return getObjectPropertyReal(nil, ObjectType.ABILITY, abilityId, coolKey)
end
--- 计算实际冷却时间
-- 
-- @param baseCooldown 原始冷却
-- @param reduction 冷却缩减比例
-- @returns 实际冷却时间
function ____exports.calcActualCooldown(self, baseCooldown, reduction)
    if reduction <= 0 then
        return baseCooldown
    end
    return baseCooldown * (1 - reduction)
end
--- 设置技能冷却时间
function ____exports.setAbilityCooldown(self, unit, abilityId, level, cooldown)
    YDWESetUnitAbilityDataReal(
        nil,
        unit,
        abilityId,
        level,
        105,
        cooldown
    )
end
return ____exports
