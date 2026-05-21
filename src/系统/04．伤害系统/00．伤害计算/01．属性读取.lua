local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 属性读取模块
-- 
-- 功能：从单位/玩家读取属性值，应用玩家上限
-- 
-- 重要：YDUserData 的属性名必须使用中文（STAT_CONFIG.name），不能使用英文key
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.00．伤害常量")
local STAT_LIMITS = ____require_result_2.STAT_LIMITS
local ENEMY_STAT_LIMITS = ____require_result_2.ENEMY_STAT_LIMITS
local BREAKABLE_LIMITS = ____require_result_2.BREAKABLE_LIMITS
local ____require_result_3 = require("lib.扩展函数.YDWE函数.06．护甲获取")
local YDWEGetUnitArmor = ____require_result_3.YDWEGetUnitArmor
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
--- 判断单位是否为玩家英雄
-- 以玩家英雄单位组为准；组未就绪时由独立 helper 回退到注册英雄桥接。
function ____exports.isPlayerUnit(self, unit)
    return _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(nil, unit)
end
--- 获取单位所属玩家ID
function ____exports.getPlayerId(self, unit)
    if unit == nil then
        return -1
    end
    local owner = GetOwningPlayer(nil, unit)
    if owner == nil then
        return -1
    end
    return GetPlayerId(nil, owner)
end
--- 读取单位属性（优先单位属性，其次玩家属性）
-- 
-- @param unit 目标单位
-- @param attrName 属性名（中文，如 "魔抗"、"物理伤害"）
-- @param valueType 值类型 "real" | "integer" | "boolean"
-- @param defaultValue 默认值
function ____exports.getUnitAttr(self, unit, attrName, valueType, defaultValue)
    if defaultValue == nil then
        defaultValue = 0
    end
    if unit == nil then
        return defaultValue
    end
    local unitValue = YDUserDataGet(
        nil,
        "unit",
        unit,
        attrName,
        valueType
    )
    if valueType == "real" or valueType == "integer" then
        local numValue = __TS__Number(unitValue)
        if numValue ~= 0 then
            return numValue
        end
    elseif valueType == "boolean" then
        if unitValue == true or unitValue == 1 then
            return true
        end
        if unitValue == false or unitValue == 0 then
            return false
        end
    end
    local player = GetOwningPlayer(nil, unit)
    if player ~= nil then
        local playerValue = YDUserDataGet(
            nil,
            "player",
            player,
            attrName,
            valueType
        )
        if valueType == "real" or valueType == "integer" then
            local numValue = __TS__Number(playerValue)
            if numValue ~= 0 then
                return numValue
            end
        elseif valueType == "boolean" then
            if playerValue == true or playerValue == 1 then
                return true
            end
        end
    end
    return defaultValue
end
--- 读取实数属性
function ____exports.getRealAttr(self, unit, attrName, defaultValue)
    if defaultValue == nil then
        defaultValue = 0
    end
    return __TS__Number(____exports.getUnitAttr(
        nil,
        unit,
        attrName,
        "real",
        defaultValue
    ))
end
--- 读取布尔属性
function ____exports.getBoolAttr(self, unit, attrName, defaultValue)
    if defaultValue == nil then
        defaultValue = false
    end
    local value = ____exports.getUnitAttr(
        nil,
        unit,
        attrName,
        "boolean",
        defaultValue
    )
    return value == true or value == 1
end
--- 读取属性并应用玩家上下限
-- 
-- @param unit 目标单位
-- @param attrName 属性名（中文）
-- @param isPlayer 是否为玩家单位
function ____exports.getRealAttrWithLimit(self, unit, attrName, isPlayer)
    local value = ____exports.getRealAttr(nil, unit, attrName, 0)
    local limit = isPlayer and STAT_LIMITS[attrName] or ENEMY_STAT_LIMITS[attrName]
    if limit == nil then
        return value
    end
    if isPlayer then
        local breakAttr = BREAKABLE_LIMITS[attrName]
        if breakAttr ~= nil then
            local breakValue = ____exports.getRealAttr(nil, unit, breakAttr, 0)
            if breakValue > 0 then
                if value > breakValue then
                    value = breakValue
                end
                if value < limit.min then
                    value = limit.min
                end
                return value
            end
        end
    end
    if value > limit.max then
        value = limit.max
    end
    if value < limit.min then
        value = limit.min
    end
    return value
end
--- 读取攻击者的伤害加成属性
function ____exports.getAttackerDamageBonus(self, attacker)
    return ____exports.getRealAttr(nil, attacker, "伤害%", 0)
end
--- 读取受击者的伤害减少%
function ____exports.getTargetDamageReduction(self, target, isPlayer)
    return ____exports.getRealAttrWithLimit(nil, target, "伤害减少%", isPlayer)
end
--- 读取受击者的魔抗（应用上限）
function ____exports.getTargetMagicResist(self, target, isPlayer)
    return ____exports.getRealAttrWithLimit(nil, target, "魔抗", isPlayer)
end
--- 读取受击者的物理抗性（应用上限）
function ____exports.getTargetPhysResist(self, target, isPlayer)
    return ____exports.getRealAttrWithLimit(nil, target, "物理抗性", isPlayer)
end
--- 读取攻击者的护甲穿透
function ____exports.getAttackerArmorPierce(self, attacker)
    return ____exports.getRealAttr(nil, attacker, "护甲穿透", 0)
end
--- 读取攻击者的魔法穿透
function ____exports.getAttackerMagicPierce(self, attacker)
    return ____exports.getRealAttr(nil, attacker, "魔法穿透", 0)
end
--- 读取受击者护甲
function ____exports.getTargetArmor(self, target)
    return YDWEGetUnitArmor(nil, target)
end
--- 是否免疫伤害
function ____exports.isImmuneDamage(self, unit)
    return ____exports.getBoolAttr(nil, unit, "免疫伤害", false)
end
--- 是否免疫普攻
function ____exports.isImmuneNormalAttack(self, unit)
    return ____exports.getBoolAttr(nil, unit, "免疫普攻", false)
end
--- 是否减伤关闭
function ____exports.isDamageReduceDisabled(self, unit)
    return ____exports.getBoolAttr(nil, unit, "减伤关闭", false)
end
--- 是否无视护甲
function ____exports.isIgnoreArmor(self, attacker)
    return ____exports.getBoolAttr(nil, attacker, "无视护甲", false)
end
--- 是否无视魔抗
function ____exports.isIgnoreMagicResist(self, attacker)
    return ____exports.getBoolAttr(nil, attacker, "无视魔抗", false)
end
--- 是否伤害吸魔突破
function ____exports.canBreakManaStealLimit(self, unit)
    return ____exports.getBoolAttr(nil, unit, "伤害吸魔突破", false)
end
return ____exports
