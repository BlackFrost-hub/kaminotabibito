--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsValidUnit = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsValidUnit
--- Star扩展库 - 单位属性方位与攻击函数
-- 
-- 提供单位模型、英雄主属性、方位判断与白字攻击力计算。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.00．BJ全局兜底")
local CosBJ = ____require_result_0.CosBJ
local BJ_DEGTORAD = ____require_result_0.BJ_DEGTORAD
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
____exports.PRIMARY_STR = 0
____exports.PRIMARY_AGI = 1
____exports.PRIMARY_INT = 2
local UNIT_STATE_ATTACK1_BASE = 18
local UNIT_STATE_ATTACK1_BONUS = 16
local UNIT_STATE_ATTACK1_COUNT = 17
local function getUnitPrimaryTypeFromSlk(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return -1
    end
    local unitId = jass.GetUnitTypeId(u)
    if unitId == 0 then
        return -1
    end
    if japi == nil then
        return -1
    end
    local script = ("(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" .. tostring(unitId)) .. "']; if _u then return _u.Primary or '' else return '' end end)()"
    local primary = japi.EXExecuteScript(script) or ""
    if primary == "STR" then
        return ____exports.PRIMARY_STR
    end
    if primary == "AGI" then
        return ____exports.PRIMARY_AGI
    end
    if primary == "INT" then
        return ____exports.PRIMARY_INT
    end
    return -1
end
local function GAFC(self, x1, y1, x2, y2)
    return jass.Atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD
end
local function getHeroPrimaryGreenValue(self, u)
    local primaryType = getUnitPrimaryTypeFromSlk(nil, u)
    if primaryType == ____exports.PRIMARY_STR then
        local total = jass.GetHeroStr(u, true)
        local green = jass.GetHeroStr(u, false)
        return total - green
    end
    if primaryType == ____exports.PRIMARY_AGI then
        local total = jass.GetHeroAgi(u, true)
        local green = jass.GetHeroAgi(u, false)
        return total - green
    end
    if primaryType == ____exports.PRIMARY_INT then
        local total = jass.GetHeroInt(u, true)
        local green = jass.GetHeroInt(u, false)
        return total - green
    end
    return 0
end
function ____exports.SU_GetUnitModel(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return ""
    end
    local unitId = jass.GetUnitTypeId(u)
    local file = ""
    if japi ~= nil then
        local script = ("(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" .. tostring(unitId)) .. "']; if _u then return _u.file or '' else return '' end end)()"
        file = japi.EXExecuteScript(script) or ""
    end
    if #file > 0 then
        local suffix = string.lower(string.sub(file, -4))
        if suffix ~= ".mdl" and suffix ~= ".mdx" then
            file = file .. ".mdl"
        end
    end
    return file
end
function ____exports.SU_GetHeroParmary(self, u)
    return getUnitPrimaryTypeFromSlk(nil, u)
end
function ____exports.SU_AddHeroState(self, u, id, typ, value)
    if not SUC_IsValidUnit(nil, u) then
        return
    end
    local isAdd = typ == 0
    if id == ____exports.PRIMARY_STR then
        local current = jass.GetHeroStr(u, false)
        local ____jass_SetHeroStr_3 = jass.SetHeroStr
        local ____u_2 = u
        local ____isAdd_1
        if isAdd then
            ____isAdd_1 = current + value
        else
            ____isAdd_1 = value
        end
        ____jass_SetHeroStr_3(jass, ____u_2, ____isAdd_1, false)
    elseif id == ____exports.PRIMARY_AGI then
        local current = jass.GetHeroAgi(u, false)
        local ____jass_SetHeroAgi_6 = jass.SetHeroAgi
        local ____u_5 = u
        local ____isAdd_4
        if isAdd then
            ____isAdd_4 = current + value
        else
            ____isAdd_4 = value
        end
        ____jass_SetHeroAgi_6(jass, ____u_5, ____isAdd_4, false)
    elseif id == ____exports.PRIMARY_INT then
        local current = jass.GetHeroInt(u, false)
        local ____jass_SetHeroInt_9 = jass.SetHeroInt
        local ____u_8 = u
        local ____isAdd_7
        if isAdd then
            ____isAdd_7 = current + value
        else
            ____isAdd_7 = value
        end
        ____jass_SetHeroInt_9(jass, ____u_8, ____isAdd_7, false)
    end
end
function ____exports.SU_GetHeroParmaryValue(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return -1
    end
    local typ = ____exports.SU_GetHeroParmary(nil, u)
    if typ == ____exports.PRIMARY_STR then
        return jass.GetHeroStr(u, true)
    end
    if typ == ____exports.PRIMARY_AGI then
        return jass.GetHeroAgi(u, true)
    end
    if typ == ____exports.PRIMARY_INT then
        return jass.GetHeroInt(u, true)
    end
    return -1
end
function ____exports.SU_AddHeroAllState(self, u, a, b, c)
    ____exports.SU_AddHeroState(
        nil,
        u,
        ____exports.PRIMARY_STR,
        0,
        a
    )
    ____exports.SU_AddHeroState(
        nil,
        u,
        ____exports.PRIMARY_INT,
        0,
        b
    )
    ____exports.SU_AddHeroState(
        nil,
        u,
        ____exports.PRIMARY_AGI,
        0,
        c
    )
end
function ____exports.SU_SetHeroParmaryValue(self, u, typ, value)
    if not SUC_IsValidUnit(nil, u) then
        return
    end
    local primaryType = ____exports.SU_GetHeroParmary(nil, u)
    if primaryType < 0 then
        return
    end
    if typ == 0 then
        ____exports.SU_AddHeroState(
            nil,
            u,
            primaryType,
            0,
            value
        )
    elseif typ == 1 then
        ____exports.SU_AddHeroState(
            nil,
            u,
            primaryType,
            1,
            value
        )
    elseif typ == 2 then
        ____exports.SU_AddHeroState(
            nil,
            u,
            primaryType,
            1,
            -value
        )
    end
end
function ____exports.SU_HeroISParmary(self, u, i)
    return ____exports.SU_GetHeroParmary(nil, u) == i
end
function ____exports.SU_DotBehindUnit(self, fac, x, y, a, b)
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - fac
    return CosBJ(angle) <= -0.707106
end
function ____exports.SU_GetUnitOfUnit(self, u, tu)
    if not SUC_IsValidUnit(nil, u) or not SUC_IsValidUnit(nil, tu) then
        return 3
    end
    local x = jass.GetUnitX(u)
    local y = jass.GetUnitY(u)
    local a = jass.GetUnitX(tu)
    local b = jass.GetUnitY(tu)
    local facing = jass.GetUnitFacing(u)
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - facing
    local c = CosBJ(angle)
    if c >= 0.866025 then
        return 1
    end
    if c >= 0.707106 then
        return 4
    end
    if c <= -0.866025 then
        return 2
    end
    if c <= -0.707106 then
        return 5
    end
    return 3
end
function ____exports.SU_IsUnitInfrontUnit2(self, u, tu)
    if not SUC_IsValidUnit(nil, u) or not SUC_IsValidUnit(nil, tu) then
        return false
    end
    local x = jass.GetUnitX(u)
    local y = jass.GetUnitY(u)
    local a = jass.GetUnitX(tu)
    local b = jass.GetUnitY(tu)
    local facing = jass.GetUnitFacing(u)
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - facing
    return CosBJ(angle) > 0
end
function ____exports.SU_IsUnitInfrontUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 1
end
function ____exports.SU_IsUnitBehindUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 2
end
function ____exports.SU_GetUnitWhiteAtk(self, uOrA, aMaybe)
    local u = uOrA
    local a = aMaybe
    if a == nil and (type(uOrA) == "number" or uOrA == nil) then
        u = self
        a = uOrA
    end
    if a == nil or a == false or a == "" then
        a = 0
    end
    if not SUC_IsValidUnit(nil, u) then
        return 0
    end
    local primaryGreen = getHeroPrimaryGreenValue(nil, u)
    local baseDmg = jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE)
    )
    local bonusDmg = jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS)
    )
    local diceCount = jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ATTACK1_COUNT)
    )
    return baseDmg + bonusDmg * (diceCount + 1) / 2 - a * primaryGreen
end
return ____exports
