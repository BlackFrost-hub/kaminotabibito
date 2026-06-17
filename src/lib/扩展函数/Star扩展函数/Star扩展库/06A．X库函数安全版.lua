--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local xLib = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local jass = require("jass.common")
local GetUnitDefaultPropWindow = jass.GetUnitDefaultPropWindow
local SetUnitPropWindow = jass.SetUnitPropWindow
local X_IsTerrainWalkableRaw = xLib.X_IsTerrainWalkable
local X_IsUnitTerrainWalkableRaw = xLib.X_IsUnitTerrainWalkable
local X_GetAbleXRaw = xLib.X_GetAbleX
local X_GetAbleYRaw = xLib.X_GetAbleY
local X_IsTerrainDeepWaterRaw = xLib.X_IsTerrainDeepWater
local X_IsTerrainShallowWaterRaw = xLib.X_IsTerrainShallowWater
local X_IsTerrainLandRaw = xLib.X_IsTerrainLand
local X_IsTerrainPlatformRaw = xLib.X_IsTerrainPlatform
local X_GDBCRaw = xLib.X_GDBC
local X_GAFCRaw = xLib.X_GAFC
local X_R2I2Raw = xLib.X_R2I2
local function _____53D6_6570_5B57(value, fallback)
    if fallback == nil then
        fallback = 0
    end
    if value == nil or value == false or value == "" then
        return fallback
    end
    return value
end
local function _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisArg, xOrY, yMaybe)
    local x = xOrY
    local y = yMaybe
    if y == nil and type(thisArg) == "number" and type(xOrY) == "number" then
        x = thisArg
        y = xOrY
    end
    return {
        x = _____53D6_6570_5B57(x),
        y = _____53D6_6570_5B57(y)
    }
end
local function _____5F52_4F4D_5355_4F4D_4E09_53C2_6570(thisArg, unitOrX, xOrY, yMaybe)
    local unit = unitOrX
    local x = xOrY
    local y = yMaybe
    if y == nil and unitOrX ~= nil and type(xOrY) == "number" then
        unit = thisArg
        x = unitOrX
        y = xOrY
    end
    return {
        unit = unit,
        x = _____53D6_6570_5B57(x),
        y = _____53D6_6570_5B57(y)
    }
end
local function _____5F52_4F4D_56DB_5750_6807_53C2_6570(thisArg, x1OrY1, y1OrX2, x2OrY2, y2Maybe)
    local x1 = x1OrY1
    local y1 = y1OrX2
    local x2 = x2OrY2
    local y2 = y2Maybe
    if y2 == nil and type(thisArg) == "number" and type(x1OrY1) == "number" and type(y1OrX2) == "number" and type(x2OrY2) == "number" then
        x1 = thisArg
        y1 = x1OrY1
        x2 = y1OrX2
        y2 = x2OrY2
    end
    return {
        x1 = _____53D6_6570_5B57(x1),
        y1 = _____53D6_6570_5B57(y1),
        x2 = _____53D6_6570_5B57(x2),
        y2 = _____53D6_6570_5B57(y2)
    }
end
function ____exports.X_IsTerrainWalkableSafe(thisOrX, xOrY, yMaybe)
    local ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_0 = _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisOrX, xOrY, yMaybe)
    local x = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_0.x
    local y = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_0.y
    return X_IsTerrainWalkableRaw(x, y)
end
function ____exports.X_IsUnitTerrainWalkableSafe(thisOrUnit, unitOrX, xOrY, yMaybe)
    local ____5F52_4F4D_5355_4F4D_4E09_53C2_6570_result_1 = _____5F52_4F4D_5355_4F4D_4E09_53C2_6570(thisOrUnit, unitOrX, xOrY, yMaybe)
    local unit = ____5F52_4F4D_5355_4F4D_4E09_53C2_6570_result_1.unit
    local x = ____5F52_4F4D_5355_4F4D_4E09_53C2_6570_result_1.x
    local y = ____5F52_4F4D_5355_4F4D_4E09_53C2_6570_result_1.y
    return X_IsUnitTerrainWalkableRaw(unit, x, y)
end
function ____exports.X_GetAbleXSafe()
    return X_GetAbleXRaw()
end
function ____exports.X_GetAbleYSafe()
    return X_GetAbleYRaw()
end
function ____exports.X_IsTerrainDeepWaterSafe(thisOrX, xOrY, yMaybe)
    local ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_2 = _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisOrX, xOrY, yMaybe)
    local x = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_2.x
    local y = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_2.y
    return X_IsTerrainDeepWaterRaw(x, y)
end
function ____exports.X_IsTerrainShallowWaterSafe(thisOrX, xOrY, yMaybe)
    local ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_3 = _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisOrX, xOrY, yMaybe)
    local x = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_3.x
    local y = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_3.y
    return X_IsTerrainShallowWaterRaw(x, y)
end
function ____exports.X_IsTerrainLandSafe(thisOrX, xOrY, yMaybe)
    local ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_4 = _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisOrX, xOrY, yMaybe)
    local x = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_4.x
    local y = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_4.y
    return X_IsTerrainLandRaw(x, y)
end
function ____exports.X_IsTerrainPlatformSafe(thisOrX, xOrY, yMaybe)
    local ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_5 = _____5F52_4F4D_53CC_5750_6807_53C2_6570(thisOrX, xOrY, yMaybe)
    local x = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_5.x
    local y = ____5F52_4F4D_53CC_5750_6807_53C2_6570_result_5.y
    return X_IsTerrainPlatformRaw(x, y)
end
--- 设置单位是否可以移动。
-- 站桩语义使用 PropWindow 锁定，不要用 SetUnitMoveSpeed(0)，避免污染移速系统和属性判断。
function ____exports.X_SetUnitMovableSafe(unit, movable)
    if unit == nil or unit == 0 then
        return
    end
    if movable then
        SetUnitPropWindow(
            unit,
            GetUnitDefaultPropWindow(unit)
        )
    else
        SetUnitPropWindow(unit, 0)
    end
end
function ____exports.X_FixUnitStandingSafe(unit)
    ____exports.X_SetUnitMovableSafe(unit, false)
end
function ____exports.X_RestoreUnitStandingSafe(unit)
    ____exports.X_SetUnitMovableSafe(unit, true)
end
function ____exports.X_GDBCSafe(thisOrX1, x1OrY1, y1OrX2, x2OrY2, y2Maybe)
    local ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_6 = _____5F52_4F4D_56DB_5750_6807_53C2_6570(
        thisOrX1,
        x1OrY1,
        y1OrX2,
        x2OrY2,
        y2Maybe
    )
    local x1 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_6.x1
    local y1 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_6.y1
    local x2 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_6.x2
    local y2 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_6.y2
    return X_GDBCRaw(x1, y1, x2, y2)
end
function ____exports.X_GAFCSafe(thisOrX1, x1OrY1, y1OrX2, x2OrY2, y2Maybe)
    local ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_7 = _____5F52_4F4D_56DB_5750_6807_53C2_6570(
        thisOrX1,
        x1OrY1,
        y1OrX2,
        x2OrY2,
        y2Maybe
    )
    local x1 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_7.x1
    local y1 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_7.y1
    local x2 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_7.x2
    local y2 = ____5F52_4F4D_56DB_5750_6807_53C2_6570_result_7.y2
    return X_GAFCRaw(x1, y1, x2, y2)
end
function ____exports.X_R2I2Safe(thisOrR, rMaybe)
    local ____temp_8
    if rMaybe ~= nil then
        ____temp_8 = rMaybe
    else
        ____temp_8 = thisOrR
    end
    local value = ____temp_8
    return X_R2I2Raw(_____53D6_6570_5B57(value))
end
return ____exports
