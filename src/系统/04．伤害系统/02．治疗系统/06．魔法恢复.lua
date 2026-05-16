--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local fireManaShowEvent, _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57, MANA_REGEN_COLOR
function fireManaShowEvent(target, amount)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(target, amount, {["红"] = MANA_REGEN_COLOR.red, ["绿"] = MANA_REGEN_COLOR.green, ["蓝"] = MANA_REGEN_COLOR.blue})
end
--- 魔法恢复系统
-- 
-- 功能：执行魔法恢复、显示数值
-- 
-- 后续接手者注意：
-- 1. 直接调用 doManaRegen 执行魔法恢复
-- 2. 内部会直接显示数值漂浮文字
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_0.STES_FireWithParams
local ____require_result_1 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
_____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_1["显示单位数值漂浮文字"]
MANA_REGEN_COLOR = {red = 53, green = 80, blue = 92}
--- 系统开关
local MANA_REGEN_SYSTEM_ENABLED = true
--- 执行魔法恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param showEffect 是否显示数值
-- @returns 实际恢复量
function ____exports.doManaRegen(target, amount, showEffect)
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
    local manaGap = maxMana - currentMana
    local safeGap = manaGap > 0 and manaGap or 0
    local actualRegen = amount < safeGap and amount or safeGap
    if actualRegen <= 0 then
        return 0
    end
    jass.SetUnitState(target, jass.UNIT_STATE_MANA, currentMana + actualRegen)
    if showEffect then
        fireManaShowEvent(target, actualRegen)
    end
    return actualRegen
end
--- 触发 STES "恢复魔法事件"
-- 供Lua/JASS端调用，JASS端监听器会执行实际恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param source 来源单位（可为null）
function ____exports.fireManaRegenEvent(target, amount, source)
    STES_FireWithParams("恢复魔法事件", {{type = "real", name = "HealAmount", value = amount}, {type = "unit", name = "HealTarget", value = target}, {type = "unit", name = "HealSource", value = source}})
end
return ____exports
