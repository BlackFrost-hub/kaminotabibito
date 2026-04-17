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
    local ____temp_1
    if type(jass.GetUnitTypeId) == "function" then
        ____temp_1 = jass.GetUnitTypeId(u)
    else
        ____temp_1 = 0
    end
    local unitId = ____temp_1
    if unitId == 0 then
        return -1
    end
    if japi == nil or type(japi.EXExecuteScript) ~= "function" then
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
        local ____temp_2
        if type(jass.GetHeroStr) == "function" then
            ____temp_2 = jass.GetHeroStr(u, true)
        else
            ____temp_2 = 0
        end
        local total = ____temp_2
        local ____temp_3
        if type(jass.GetHeroStr) == "function" then
            ____temp_3 = jass.GetHeroStr(u, false)
        else
            ____temp_3 = 0
        end
        local green = ____temp_3
        return total - green
    end
    if primaryType == ____exports.PRIMARY_AGI then
        local ____temp_4
        if type(jass.GetHeroAgi) == "function" then
            ____temp_4 = jass.GetHeroAgi(u, true)
        else
            ____temp_4 = 0
        end
        local total = ____temp_4
        local ____temp_5
        if type(jass.GetHeroAgi) == "function" then
            ____temp_5 = jass.GetHeroAgi(u, false)
        else
            ____temp_5 = 0
        end
        local green = ____temp_5
        return total - green
    end
    if primaryType == ____exports.PRIMARY_INT then
        local ____temp_6
        if type(jass.GetHeroInt) == "function" then
            ____temp_6 = jass.GetHeroInt(u, true)
        else
            ____temp_6 = 0
        end
        local total = ____temp_6
        local ____temp_7
        if type(jass.GetHeroInt) == "function" then
            ____temp_7 = jass.GetHeroInt(u, false)
        else
            ____temp_7 = 0
        end
        local green = ____temp_7
        return total - green
    end
    return 0
end
function ____exports.SU_GetUnitModel(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return ""
    end
    local ____temp_8
    if type(jass.GetUnitTypeId) == "function" then
        ____temp_8 = jass.GetUnitTypeId(u)
    else
        ____temp_8 = 0
    end
    local unitId = ____temp_8
    local file = ""
    if japi ~= nil and type(japi.EXExecuteScript) == "function" then
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
        local ____temp_9
        if type(jass.GetHeroStr) == "function" then
            ____temp_9 = jass.GetHeroStr(u, false)
        else
            ____temp_9 = 0
        end
        local current = ____temp_9
        if type(jass.SetHeroStr) == "function" then
            local ____jass_SetHeroStr_12 = jass.SetHeroStr
            local ____u_11 = u
            local ____isAdd_10
            if isAdd then
                ____isAdd_10 = current + value
            else
                ____isAdd_10 = value
            end
            ____jass_SetHeroStr_12(jass, ____u_11, ____isAdd_10, false)
        end
    elseif id == ____exports.PRIMARY_AGI then
        local ____temp_13
        if type(jass.GetHeroAgi) == "function" then
            ____temp_13 = jass.GetHeroAgi(u, false)
        else
            ____temp_13 = 0
        end
        local current = ____temp_13
        if type(jass.SetHeroAgi) == "function" then
            local ____jass_SetHeroAgi_16 = jass.SetHeroAgi
            local ____u_15 = u
            local ____isAdd_14
            if isAdd then
                ____isAdd_14 = current + value
            else
                ____isAdd_14 = value
            end
            ____jass_SetHeroAgi_16(jass, ____u_15, ____isAdd_14, false)
        end
    elseif id == ____exports.PRIMARY_INT then
        local ____temp_17
        if type(jass.GetHeroInt) == "function" then
            ____temp_17 = jass.GetHeroInt(u, false)
        else
            ____temp_17 = 0
        end
        local current = ____temp_17
        if type(jass.SetHeroInt) == "function" then
            local ____jass_SetHeroInt_20 = jass.SetHeroInt
            local ____u_19 = u
            local ____isAdd_18
            if isAdd then
                ____isAdd_18 = current + value
            else
                ____isAdd_18 = value
            end
            ____jass_SetHeroInt_20(jass, ____u_19, ____isAdd_18, false)
        end
    end
end
function ____exports.SU_GetHeroParmaryValue(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return -1
    end
    local typ = ____exports.SU_GetHeroParmary(nil, u)
    if typ == ____exports.PRIMARY_STR then
        local ____temp_21
        if type(jass.GetHeroStr) == "function" then
            ____temp_21 = jass.GetHeroStr(u, true)
        else
            ____temp_21 = 0
        end
        return ____temp_21
    end
    if typ == ____exports.PRIMARY_AGI then
        local ____temp_22
        if type(jass.GetHeroAgi) == "function" then
            ____temp_22 = jass.GetHeroAgi(u, true)
        else
            ____temp_22 = 0
        end
        return ____temp_22
    end
    if typ == ____exports.PRIMARY_INT then
        local ____temp_23
        if type(jass.GetHeroInt) == "function" then
            ____temp_23 = jass.GetHeroInt(u, true)
        else
            ____temp_23 = 0
        end
        return ____temp_23
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
    return CosBJ(nil, angle) <= -0.707106
end
function ____exports.SU_GetUnitOfUnit(self, u, tu)
    if not SUC_IsValidUnit(nil, u) or not SUC_IsValidUnit(nil, tu) then
        return 3
    end
    local ____temp_24
    if type(jass.GetUnitX) == "function" then
        ____temp_24 = jass.GetUnitX(u)
    else
        ____temp_24 = 0
    end
    local x = ____temp_24
    local ____temp_25
    if type(jass.GetUnitY) == "function" then
        ____temp_25 = jass.GetUnitY(u)
    else
        ____temp_25 = 0
    end
    local y = ____temp_25
    local ____temp_26
    if type(jass.GetUnitX) == "function" then
        ____temp_26 = jass.GetUnitX(tu)
    else
        ____temp_26 = 0
    end
    local a = ____temp_26
    local ____temp_27
    if type(jass.GetUnitY) == "function" then
        ____temp_27 = jass.GetUnitY(tu)
    else
        ____temp_27 = 0
    end
    local b = ____temp_27
    local ____temp_28
    if type(jass.GetUnitFacing) == "function" then
        ____temp_28 = jass.GetUnitFacing(u)
    else
        ____temp_28 = 0
    end
    local facing = ____temp_28
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - facing
    local c = CosBJ(nil, angle)
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
    local ____temp_29
    if type(jass.GetUnitX) == "function" then
        ____temp_29 = jass.GetUnitX(u)
    else
        ____temp_29 = 0
    end
    local x = ____temp_29
    local ____temp_30
    if type(jass.GetUnitY) == "function" then
        ____temp_30 = jass.GetUnitY(u)
    else
        ____temp_30 = 0
    end
    local y = ____temp_30
    local ____temp_31
    if type(jass.GetUnitX) == "function" then
        ____temp_31 = jass.GetUnitX(tu)
    else
        ____temp_31 = 0
    end
    local a = ____temp_31
    local ____temp_32
    if type(jass.GetUnitY) == "function" then
        ____temp_32 = jass.GetUnitY(tu)
    else
        ____temp_32 = 0
    end
    local b = ____temp_32
    local ____temp_33
    if type(jass.GetUnitFacing) == "function" then
        ____temp_33 = jass.GetUnitFacing(u)
    else
        ____temp_33 = 0
    end
    local facing = ____temp_33
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - facing
    return CosBJ(nil, angle) > 0
end
function ____exports.SU_IsUnitInfrontUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 1
end
function ____exports.SU_IsUnitBehindUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 2
end
function ____exports.SU_GetUnitWhiteAtk(self, u, a)
    if not SUC_IsValidUnit(nil, u) then
        return 0
    end
    local primaryGreen = getHeroPrimaryGreenValue(nil, u)
    local ____temp_34
    if type(jass.GetUnitState) == "function" then
        ____temp_34 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE)
        )
    else
        ____temp_34 = 0
    end
    local baseDmg = ____temp_34
    local ____temp_35
    if type(jass.GetUnitState) == "function" then
        ____temp_35 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS)
        )
    else
        ____temp_35 = 0
    end
    local bonusDmg = ____temp_35
    local ____temp_36
    if type(jass.GetUnitState) == "function" then
        ____temp_36 = jass.GetUnitState(
            u,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_COUNT)
        )
    else
        ____temp_36 = 0
    end
    local diceCount = ____temp_36
    return baseDmg + bonusDmg * (diceCount + 1) / 2 - a * primaryGreen
end
return ____exports
