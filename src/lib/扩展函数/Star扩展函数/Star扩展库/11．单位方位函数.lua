--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位方位函数
-- 
-- 来源于 StarUnit.j，提供单位间方位判断功能。
-- 
-- 公开接口：
--   SU_DotBehindUnit(fac, x, y, a, b)  - 判断点是否在单位背面
--   SU_GetUnitOfUnit(u, tu)            - 获取单位间方位关系
--   SU_IsUnitInfrontUnit2(u, tu)       - 判断单位是否在正前方（宽松）
--   SU_IsUnitInfrontUnit(u, tu)        - 判断单位是否在正前方（严格）
--   SU_IsUnitBehindUnit(u, tu)         - 判断单位是否在正后方
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.00．BJ全局兜底")
local CosBJ = ____require_result_0.CosBJ
local BJ_DEGTORAD = ____require_result_0.BJ_DEGTORAD
--- 计算两点间角度（度数）
-- 对应 JASS: Math.GAFC / X_GAFC
local function GAFC(self, x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD
end
--- 判断点是否在单位背面
-- 
-- @param fac 单位朝向（度数）
-- @param x 单位X坐标
-- @param y 单位Y坐标
-- @param a 目标点X坐标
-- @param b 目标点Y坐标
-- @returns 是否在背面
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
--- 获取单位间方位关系
-- 
-- @param u 参考单位
-- @param tu 目标单位
-- @returns 方位关系：1=正面(±30°), 2=背面(±30°), 3=侧面, 4=正面(±45°), 5=背面(±45°)
function ____exports.SU_GetUnitOfUnit(self, u, tu)
    if u == nil or u == 0 or tu == nil or tu == 0 then
        return 3
    end
    local ____temp_1
    if type(jass.GetUnitX) == "function" then
        ____temp_1 = jass.GetUnitX(u)
    else
        ____temp_1 = 0
    end
    local x = ____temp_1
    local ____temp_2
    if type(jass.GetUnitY) == "function" then
        ____temp_2 = jass.GetUnitY(u)
    else
        ____temp_2 = 0
    end
    local y = ____temp_2
    local ____temp_3
    if type(jass.GetUnitX) == "function" then
        ____temp_3 = jass.GetUnitX(tu)
    else
        ____temp_3 = 0
    end
    local a = ____temp_3
    local ____temp_4
    if type(jass.GetUnitY) == "function" then
        ____temp_4 = jass.GetUnitY(tu)
    else
        ____temp_4 = 0
    end
    local b = ____temp_4
    local ____temp_5
    if type(jass.GetUnitFacing) == "function" then
        ____temp_5 = jass.GetUnitFacing(u)
    else
        ____temp_5 = 0
    end
    local facing = ____temp_5
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
--- 判断单位是否在另一单位正前方（宽松判断，cos>0即前方）
-- 
-- @param u 参考单位
-- @param tu 目标单位
-- @returns 是否在前方
function ____exports.SU_IsUnitInfrontUnit2(self, u, tu)
    if u == nil or u == 0 or tu == nil or tu == 0 then
        return false
    end
    local ____temp_6
    if type(jass.GetUnitX) == "function" then
        ____temp_6 = jass.GetUnitX(u)
    else
        ____temp_6 = 0
    end
    local x = ____temp_6
    local ____temp_7
    if type(jass.GetUnitY) == "function" then
        ____temp_7 = jass.GetUnitY(u)
    else
        ____temp_7 = 0
    end
    local y = ____temp_7
    local ____temp_8
    if type(jass.GetUnitX) == "function" then
        ____temp_8 = jass.GetUnitX(tu)
    else
        ____temp_8 = 0
    end
    local a = ____temp_8
    local ____temp_9
    if type(jass.GetUnitY) == "function" then
        ____temp_9 = jass.GetUnitY(tu)
    else
        ____temp_9 = 0
    end
    local b = ____temp_9
    local ____temp_10
    if type(jass.GetUnitFacing) == "function" then
        ____temp_10 = jass.GetUnitFacing(u)
    else
        ____temp_10 = 0
    end
    local facing = ____temp_10
    local angle = GAFC(
        nil,
        x,
        y,
        a,
        b
    ) - facing
    local c = CosBJ(nil, angle)
    return c > 0
end
--- 判断单位是否在另一单位正前方（严格判断，±30°）
-- 
-- @param u 参考单位
-- @param tu 目标单位
-- @returns 是否在正前方
function ____exports.SU_IsUnitInfrontUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 1
end
--- 判断单位是否在另一单位正后方（严格判断，±30°）
-- 
-- @param u 参考单位
-- @param tu 目标单位
-- @returns 是否在正后方
function ____exports.SU_IsUnitBehindUnit(self, u, tu)
    return ____exports.SU_GetUnitOfUnit(nil, u, tu) == 2
end
return ____exports
