--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位属性函数
-- 
-- 来源于 StarUnit.j，提供单位属性相关功能。
-- 
-- 公开接口：
--   SU_GetUnitModel(u)              - 获取单位模型文件路径
--   SU_GetHeroParmary(u)            - 获取英雄主属性类型（0=力量,1=敏捷,2=智力）
--   SU_AddHeroState(u, id, typ, v)  - 增加/设置英雄属性
--   SU_GetHeroParmaryValue(u)       - 获取英雄主属性数值
--   SU_AddHeroAllState(u, a, b, c)  - 添加英雄三项属性
--   SU_SetHeroParmaryValue(u, typ, v) - 增加/设置/减少英雄主属性值
--   SU_HeroISParmary(u, i)          - 判断英雄主属性类型
local jass = require("jass.common")
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
--- 获取单位模型文件路径
-- 
-- @param u 目标单位
-- @returns 模型文件路径（自动补全.mdl后缀）
function ____exports.SU_GetUnitModel(self, u)
    if u == nil or u == 0 then
        return ""
    end
    local ____temp_0
    if type(jass.GetUnitTypeId) == "function" then
        ____temp_0 = jass.GetUnitTypeId(u)
    else
        ____temp_0 = 0
    end
    local unitId = ____temp_0
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
--- 获取英雄主属性类型
-- 
-- @param u 目标英雄
-- @returns 主属性类型（0=力量, 1=敏捷, 2=智力, -1=无效）
function ____exports.SU_GetHeroParmary(self, u)
    if u == nil or u == 0 then
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
    if japi ~= nil and type(japi.EXExecuteScript) == "function" then
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
    end
    return -1
end
--- 增加/设置英雄属性
-- 
-- @param u 目标英雄
-- @param id 属性类型（0=力量, 1=敏捷, 2=智力）
-- @param typ 操作类型（0=增加, 1=设置）
-- @param value 数值
function ____exports.SU_AddHeroState(self, u, id, typ, value)
    if u == nil or u == 0 then
        return
    end
    local isAdd = typ == 0
    if id == ____exports.PRIMARY_STR then
        local ____temp_2
        if type(jass.GetHeroStr) == "function" then
            ____temp_2 = jass.GetHeroStr(u, false)
        else
            ____temp_2 = 0
        end
        local current = ____temp_2
        if type(jass.SetHeroStr) == "function" then
            local ____jass_SetHeroStr_5 = jass.SetHeroStr
            local ____u_4 = u
            local ____isAdd_3
            if isAdd then
                ____isAdd_3 = current + value
            else
                ____isAdd_3 = value
            end
            ____jass_SetHeroStr_5(jass, ____u_4, ____isAdd_3, false)
        end
    elseif id == ____exports.PRIMARY_AGI then
        local ____temp_6
        if type(jass.GetHeroAgi) == "function" then
            ____temp_6 = jass.GetHeroAgi(u, false)
        else
            ____temp_6 = 0
        end
        local current = ____temp_6
        if type(jass.SetHeroAgi) == "function" then
            local ____jass_SetHeroAgi_9 = jass.SetHeroAgi
            local ____u_8 = u
            local ____isAdd_7
            if isAdd then
                ____isAdd_7 = current + value
            else
                ____isAdd_7 = value
            end
            ____jass_SetHeroAgi_9(jass, ____u_8, ____isAdd_7, false)
        end
    elseif id == ____exports.PRIMARY_INT then
        local ____temp_10
        if type(jass.GetHeroInt) == "function" then
            ____temp_10 = jass.GetHeroInt(u, false)
        else
            ____temp_10 = 0
        end
        local current = ____temp_10
        if type(jass.SetHeroInt) == "function" then
            local ____jass_SetHeroInt_13 = jass.SetHeroInt
            local ____u_12 = u
            local ____isAdd_11
            if isAdd then
                ____isAdd_11 = current + value
            else
                ____isAdd_11 = value
            end
            ____jass_SetHeroInt_13(jass, ____u_12, ____isAdd_11, false)
        end
    end
end
--- 获取英雄主属性数值（含绿字）
-- 
-- @param u 目标英雄
-- @returns 主属性数值（-1表示无效）
function ____exports.SU_GetHeroParmaryValue(self, u)
    if u == nil or u == 0 then
        return -1
    end
    local typ = ____exports.SU_GetHeroParmary(nil, u)
    if typ == ____exports.PRIMARY_STR then
        local ____temp_14
        if type(jass.GetHeroStr) == "function" then
            ____temp_14 = jass.GetHeroStr(u, true)
        else
            ____temp_14 = 0
        end
        return ____temp_14
    elseif typ == ____exports.PRIMARY_AGI then
        local ____temp_15
        if type(jass.GetHeroAgi) == "function" then
            ____temp_15 = jass.GetHeroAgi(u, true)
        else
            ____temp_15 = 0
        end
        return ____temp_15
    elseif typ == ____exports.PRIMARY_INT then
        local ____temp_16
        if type(jass.GetHeroInt) == "function" then
            ____temp_16 = jass.GetHeroInt(u, true)
        else
            ____temp_16 = 0
        end
        return ____temp_16
    end
    return -1
end
--- 添加英雄三项属性
-- 
-- @param u 目标英雄
-- @param a 力量增加值
-- @param b 智力增加值（注意：原JASS参数顺序是 a=力量, b=智力, c=敏捷）
-- @param c 敏捷增加值
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
--- 增加/设置/减少英雄主属性值
-- 
-- @param u 目标英雄
-- @param typ 操作类型（0=增加, 1=设置, 2=减少）
-- @param value 数值
function ____exports.SU_SetHeroParmaryValue(self, u, typ, value)
    if u == nil or u == 0 then
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
--- 判断英雄主属性类型
-- 
-- @param u 目标英雄
-- @param i 要判断的属性类型
-- @returns 是否匹配
function ____exports.SU_HeroISParmary(self, u, i)
    return ____exports.SU_GetHeroParmary(nil, u) == i
end
return ____exports
