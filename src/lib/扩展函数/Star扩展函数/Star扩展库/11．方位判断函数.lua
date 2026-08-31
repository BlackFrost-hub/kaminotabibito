--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsValidUnit = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsValidUnit
--- Star扩展库 - 方位判断函数
-- 
-- 提供全方位的单位方位判断功能，支持自定义角度阈值。
-- 所有函数均基于单位面朝方向与目标位置的夹角计算。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.00．BJ全局兜底")
local BJ_DEGTORAD = ____require_result_0.BJ_DEGTORAD
local ____require_result_1 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_1.CosBJ
--- 内部工具：计算两点间角度（度）
local function _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return jass.Atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD
end
--- 方位：正前方（0° ± 30°）
____exports["方位_正前方"] = 1
--- 方位：正后方（180° ± 30°）
____exports["方位_正后方"] = 2
--- 方位：侧面（非前后方）
____exports["方位_侧面"] = 3
--- 方位：左前方（45° ± 45°）
____exports["方位_左前方"] = 4
--- 方位：左后方（135° ± 45°）
____exports["方位_左后方"] = 5
--- 判断目标是否在单位的指定角度范围内
-- 
-- @param unit 单位A
-- @param target 目标单位B
-- @param angleRange 角度范围（0-180），如45表示前后各45°范围内
-- @returns 是否在指定角度范围内
____exports["是否在指定角度范围内"] = function(unit, target, angleRange)
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return false
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    return CosBJ(angle) >= CosBJ(angleRange)
end
--- 判断目标是否在单位的前方指定角度范围内
-- 
-- @param unit 单位A
-- @param target 目标单位B
-- @param angleRange 前方角度范围（0-90），如45表示前方左右各45°
-- @returns 是否在前方指定角度范围内
____exports["是否在前方角度内"] = function(unit, target, angleRange)
    if angleRange == nil then
        angleRange = 45
    end
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return false
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    local cosVal = CosBJ(angle)
    return cosVal >= CosBJ(angleRange)
end
--- 判断目标是否在单位的后方指定角度范围内
-- 
-- @param unit 单位A
-- @param target 目标单位B
-- @param angleRange 后方角度范围（0-90），如45表示后方左右各45°
-- @returns 是否在后方指定角度范围内
____exports["是否在后方角度内"] = function(unit, target, angleRange)
    if angleRange == nil then
        angleRange = 45
    end
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return false
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    local cosVal = CosBJ(angle)
    return cosVal <= -CosBJ(angleRange)
end
--- 判断目标是否在单位正前方（0° ± 30°）
____exports["是否在正前方"] = function(unit, target)
    return ____exports["是否在前方角度内"](unit, target, 30)
end
--- 判断目标是否在单位正后方（180° ± 30°）
____exports["是否在正后方"] = function(unit, target)
    return ____exports["是否在后方角度内"](unit, target, 30)
end
--- 判断目标是否在单位左侧（0° - 90°）
____exports["是否在左侧"] = function(unit, target)
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return false
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    return angle > 0 and angle < 180
end
--- 判断目标是否在单位右侧（0° - -180°）
____exports["是否在右侧"] = function(unit, target)
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return false
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    return angle < 0 or angle > 180
end
--- 判断目标是否在单位前方（余弦 > 0，即 ±90° 范围内）
____exports["是否在前方"] = function(unit, target)
    return ____exports["是否在前方角度内"](unit, target, 90)
end
--- 判断目标是否在单位后方（余弦 < 0，即 >90° 范围内）
____exports["是否在后方"] = function(unit, target)
    return ____exports["是否在后方角度内"](unit, target, 90)
end
--- 获取目标相对单位的方位区间
-- 
-- @returns 1=正前方, 2=正后方, 3=侧面, 4=左前方, 5=左后方
____exports["获取方位区间"] = function(unit, target)
    if not SUC_IsValidUnit(unit) or not SUC_IsValidUnit(target) then
        return 3
    end
    local x1 = jass.GetUnitX(unit)
    local y1 = jass.GetUnitY(unit)
    local x2 = jass.GetUnitX(target)
    local y2 = jass.GetUnitY(target)
    local facing = jass.GetUnitFacing(unit)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2) - facing
    local c = CosBJ(angle)
    if c >= 0.866025 then
        return ____exports["方位_正前方"]
    end
    if c >= 0.707106 then
        return ____exports["方位_左前方"]
    end
    if c <= -0.866025 then
        return ____exports["方位_正后方"]
    end
    if c <= -0.707106 then
        return ____exports["方位_左后方"]
    end
    return ____exports["方位_侧面"]
end
---
-- @deprecated 使用 是否在正后方() 代替
____exports.SU_DotBehindUnit = function(fac, x, y, a, b)
    local angle = _____8BA1_7B97_4E24_70B9_89D2_5EA6(x, y, a, b) - fac
    return CosBJ(angle) <= -0.707106
end
---
-- @deprecated 使用 获取方位区间() 代替
____exports.SU_GetUnitOfUnit = function(u, tu) return ____exports["获取方位区间"](u, tu) end
---
-- @deprecated 使用 是否在前方() 代替
____exports.SU_IsUnitInfrontUnit2 = function(u, tu) return ____exports["是否在前方"](u, tu) end
---
-- @deprecated 使用 是否在正前方() 代替
____exports.SU_IsUnitInfrontUnit = function(u, tu) return ____exports["是否在正前方"](u, tu) end
---
-- @deprecated 使用 是否在正后方() 代替
____exports.SU_IsUnitBehindUnit = function(u, tu) return ____exports["是否在正后方"](u, tu) end
return ____exports
