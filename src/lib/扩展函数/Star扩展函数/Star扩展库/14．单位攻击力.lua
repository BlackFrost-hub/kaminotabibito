--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位攻击力函数
-- 
-- 来源于 StarUnit.j，提供单位攻击力相关功能。
-- 
-- 公开接口：
--   SU_GetUnitWhiteAtk(u, a)  - 获取英雄/单位白字攻击力
local jass = require("jass.common")
local UNIT_STATE_ATTACK1_BASE = 18
local UNIT_STATE_ATTACK1_BONUS = 16
local UNIT_STATE_ATTACK1_COUNT = 17
--- 获取英雄主属性数值（白字）
-- 
-- @param u 目标英雄
-- @returns 主属性白字数值
local function getHeroPrimaryGreenValue(self, u)
    local primaryType = -1
    local japi = nil
    do
        local function ____catch(_e)
            japi = nil
        end
        local ____try, ____hasReturned = pcall(function()
            japi = require("jass.japi")
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
    local ____temp_0
    if type(jass.GetUnitTypeId) == "function" then
        ____temp_0 = jass.GetUnitTypeId(u)
    else
        ____temp_0 = 0
    end
    local unitId = ____temp_0
    if japi ~= nil and type(japi.EXExecuteScript) == "function" then
        local script = ("(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" .. tostring(unitId)) .. "']; if _u then return _u.Primary or '' else return '' end end)()"
        local primary = japi.EXExecuteScript(script) or ""
        if primary == "STR" then
            primaryType = 0
        elseif primary == "AGI" then
            primaryType = 1
        elseif primary == "INT" then
            primaryType = 2
        end
    end
    if primaryType == 0 then
        local ____temp_1
        if type(jass.GetHeroStr) == "function" then
            ____temp_1 = jass.GetHeroStr(u, true)
        else
            ____temp_1 = 0
        end
        local total = ____temp_1
        local ____temp_2
        if type(jass.GetHeroStr) == "function" then
            ____temp_2 = jass.GetHeroStr(u, false)
        else
            ____temp_2 = 0
        end
        local green = ____temp_2
        return total - green
    elseif primaryType == 1 then
        local ____temp_3
        if type(jass.GetHeroAgi) == "function" then
            ____temp_3 = jass.GetHeroAgi(u, true)
        else
            ____temp_3 = 0
        end
        local total = ____temp_3
        local ____temp_4
        if type(jass.GetHeroAgi) == "function" then
            ____temp_4 = jass.GetHeroAgi(u, false)
        else
            ____temp_4 = 0
        end
        local green = ____temp_4
        return total - green
    elseif primaryType == 2 then
        local ____temp_5
        if type(jass.GetHeroInt) == "function" then
            ____temp_5 = jass.GetHeroInt(u, true)
        else
            ____temp_5 = 0
        end
        local total = ____temp_5
        local ____temp_6
        if type(jass.GetHeroInt) == "function" then
            ____temp_6 = jass.GetHeroInt(u, false)
        else
            ____temp_6 = 0
        end
        local green = ____temp_6
        return total - green
    end
    return 0
end
--- 获取英雄/单位白字攻击力
-- 
-- 计算公式：
-- 白字攻击 = 攻击基础伤害 + 攻击加成 * (骰子数 + 1) / 2 - 主属性绿字 * a
-- 
-- @param u 目标单位
-- @param a 主属性系数（通常为1，用于扣除主属性加成的攻击力）
-- @returns 白字攻击力
function ____exports.SU_GetUnitWhiteAtk(self, u, a)
    if u == nil or u == 0 then
        return 0
    end
    local primaryGreen = getHeroPrimaryGreenValue(nil, u)
    local ____temp_7
    if type(jass.GetUnitState) == "function" then
        ____temp_7 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE)
        )
    else
        ____temp_7 = 0
    end
    local baseDmg = ____temp_7
    local ____temp_8
    if type(jass.GetUnitState) == "function" then
        ____temp_8 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS)
        )
    else
        ____temp_8 = 0
    end
    local bonusDmg = ____temp_8
    local ____temp_9
    if type(jass.GetUnitState) == "function" then
        ____temp_9 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_COUNT)
        )
    else
        ____temp_9 = 0
    end
    local diceCount = ____temp_9
    local whiteAtk = baseDmg + bonusDmg * (diceCount + 1) / 2 - a * primaryGreen
    return whiteAtk
end
return ____exports
