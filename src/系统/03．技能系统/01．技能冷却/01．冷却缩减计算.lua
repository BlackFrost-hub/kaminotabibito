local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 冷却缩减计算模块
-- 
-- 功能：计算技能冷却缩减，应用上限
local jass = require("jass.common")
local ____YD_5B89_5168_6A21_5757 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local _____901A_7528_5DE5_5177_6A21_5757 = require("lib.扩展函数.封装函数.01．通用工具.index")
local ____YD_8BFB_53D6_7528_6237_6570_636E = ____YD_5B89_5168_6A21_5757.YDUserDataGetSafe
local ____YD_8BBE_7F6E_6280_80FD_51B7_5374_6570_636E = ____YD_5B89_5168_6A21_5757.YDWESetUnitAbilityDataRealSafe
local ____YD_8BFB_53D6_5BF9_8C61_5B9E_6570_5C5E_6027 = ____YD_5B89_5168_6A21_5757.getObjectPropertyRealSafe
local _____8F6C_56DB_5B57_8282 = _____901A_7528_5DE5_5177_6A21_5757.stringToFourCC
local _____6280_80FD_5BF9_8C61_7C7B_578B = 0
local ____require_result_0 = require("系统.03．技能系统.01．技能冷却.00．冷却常量")
local COOLDOWN_REDUCTION_CAP = ____require_result_0.COOLDOWN_REDUCTION_CAP
local SKILL_COOLDOWN_CAPS = ____require_result_0.SKILL_COOLDOWN_CAPS
local COOLDOWN_BLACKLIST = ____require_result_0.COOLDOWN_BLACKLIST
local EXCLUDED_COOLDOWN_UNIT = ____require_result_0.EXCLUDED_COOLDOWN_UNIT
local function _____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)
    if not _____914D_7F6E_952E_540D then
        return ""
    end
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or ""
end
--- 检查技能是否在黑名单中
function ____exports.isBlacklistedSkill(abilityId)
    return __TS__ArraySome(
        COOLDOWN_BLACKLIST,
        function(____, _____914D_7F6E_952E_540D) return _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)) == abilityId end
    )
end
--- 检查单位是否为特殊单位（E001不参与冷却缩减）
function ____exports.isExcludedUnit(unit)
    local unitTypeId = jass:GetUnitTypeId(unit)
    return unitTypeId == _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(EXCLUDED_COOLDOWN_UNIT))
end
--- 冷却属性读取规则：
-- 1. 先看单位属性。若单位值大于 0.01，优先使用，通常代表这是单独配置过属性的敌对单位。
-- 2. 否则回退到玩家属性。玩家侧默认只有一个英雄，因此玩家属性可视为该英雄的冷却属性来源。
local function getCooldownAttrValue(unit, attrName)
    if unit == nil then
        return 0
    end
    local unitValue = ____YD_8BFB_53D6_7528_6237_6570_636E("unit", unit, attrName, "real")
    if unitValue > 0.01 then
        return unitValue
    end
    local player = jass:GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return ____YD_8BFB_53D6_7528_6237_6570_636E("player", player, attrName, "real")
end
--- 获取冷却缩减属性
function ____exports.getCooldownReduction(unit)
    return getCooldownAttrValue(unit, "冷却缩减")
end
--- 获取额外冷却缩减上限属性
function ____exports.getCooldownReductionCapIncrease(unit)
    return getCooldownAttrValue(unit, "冷却缩减上限")
end
--- 获取技能冷却上限
-- 
-- @param abilityId 技能ID
-- @param capIncrease 额外冷却缩减上限
-- @returns 冷却上限
function ____exports.getCooldownCap(abilityId, capIncrease)
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(SKILL_COOLDOWN_CAPS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local _____914D_7F6E_952E_540D = ____value[1]
        local cap = ____value[2]
        if _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)) == abilityId then
            return cap
        end
    end
    return COOLDOWN_REDUCTION_CAP + capIncrease
end
--- 应用冷却缩减上限
function ____exports.applyCooldownCap(reduction, abilityId, capIncrease)
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(SKILL_COOLDOWN_CAPS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local _____914D_7F6E_952E_540D = ____value[1]
        local cap = ____value[2]
        if _____8F6C_56DB_5B57_8282(_____63D0_53D6_5185_90E8ID(_____914D_7F6E_952E_540D)) == abilityId then
            return reduction < cap and reduction or cap
        end
    end
    local cap = COOLDOWN_REDUCTION_CAP + capIncrease
    return reduction < cap and reduction or cap
end
--- 获取技能原始冷却时间
function ____exports.getBaseCooldown(abilityId, level)
    local coolKey = "Cool" .. tostring(level)
    return ____YD_8BFB_53D6_5BF9_8C61_5B9E_6570_5C5E_6027(_____6280_80FD_5BF9_8C61_7C7B_578B, abilityId, coolKey)
end
--- 计算实际冷却时间
-- 
-- @param baseCooldown 原始冷却
-- @param reduction 冷却缩减比例
-- @returns 实际冷却时间
function ____exports.calcActualCooldown(baseCooldown, reduction)
    if reduction <= 0 then
        return baseCooldown
    end
    return baseCooldown * (1 - reduction)
end
--- 设置技能冷却时间
function ____exports.setAbilityCooldown(unit, abilityId, level, cooldown)
    ____YD_8BBE_7F6E_6280_80FD_51B7_5374_6570_636E(
        unit,
        abilityId,
        level,
        105,
        cooldown
    )
end
return ____exports
