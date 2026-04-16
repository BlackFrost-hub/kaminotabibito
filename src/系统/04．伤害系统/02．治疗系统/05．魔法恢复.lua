--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local fireManaShowEvent, STES_Fire, YDLocal5Set, SHOW_DAMAGE_EVENT, MANA_REGEN_COLOR
function fireManaShowEvent(self, target, amount)
    YDLocal5Set(nil, "real", "Real", amount)
    YDLocal5Set(nil, "unit", "Unit", target)
    YDLocal5Set(nil, "real", "red", MANA_REGEN_COLOR.red)
    YDLocal5Set(nil, "real", "green", MANA_REGEN_COLOR.green)
    YDLocal5Set(nil, "real", "blue", MANA_REGEN_COLOR.blue)
    STES_Fire(nil, nil, SHOW_DAMAGE_EVENT)
end
--- 魔法恢复系统
-- 
-- 功能：执行魔法恢复、显示数值
-- 
-- 后续接手者注意：
-- 1. 直接调用 doManaRegen 执行魔法恢复
-- 2. 内部会触发 STES "数值显示" 事件
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_Fire = ____require_result_0.STES_Fire
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_1.YDLocal5Set
SHOW_DAMAGE_EVENT = "数值显示"
MANA_REGEN_COLOR = {red = 53, green = 80, blue = 92}
--- 系统开关
local MANA_REGEN_SYSTEM_ENABLED = true
--- 执行魔法恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param showEffect 是否显示数值
-- @returns 实际恢复量
function ____exports.doManaRegen(self, target, amount, showEffect)
    if showEffect == nil then
        showEffect = true
    end
    if not MANA_REGEN_SYSTEM_ENABLED then
        return 0
    end
    if target == nil or amount <= 0 then
        return 0
    end
    if jass.IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return 0
    end
    local currentMana = jass.GetUnitState(target, jass.UNIT_STATE_MANA)
    local maxMana = jass.GetUnitState(target, jass.UNIT_STATE_MAX_MANA)
    local actualRegen = math.min(
        amount,
        math.max(0, maxMana - currentMana)
    )
    if actualRegen <= 0 then
        return 0
    end
    jass.SetUnitState(target, jass.UNIT_STATE_MANA, currentMana + actualRegen)
    if showEffect then
        fireManaShowEvent(nil, target, actualRegen)
    end
    return actualRegen
end
--- 触发 STES "恢复魔法事件"
-- 供Lua/JASS端调用，JASS端监听器会执行实际恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param source 来源单位（可为null）
function ____exports.fireManaRegenEvent(self, target, amount, source)
    YDLocal5Set(nil, "real", "HealAmount", amount)
    YDLocal5Set(nil, "unit", "HealTarget", target)
    YDLocal5Set(nil, "unit", "HealSource", source)
    STES_Fire(nil, "恢复魔法事件")
end
return ____exports
