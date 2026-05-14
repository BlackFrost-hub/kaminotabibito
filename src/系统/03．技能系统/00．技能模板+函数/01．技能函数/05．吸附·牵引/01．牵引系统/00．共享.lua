--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 牵引系统 - 共享类型、常量与工具函数
local jass = require("jass.common")
local jglobals = require("jass.globals")
____exports.GetHandleId = jass.GetHandleId
____exports.GetUnitX = jass.GetUnitX
____exports.GetUnitY = jass.GetUnitY
____exports.GetUnitTypeId = jass.GetUnitTypeId
____exports.GetUnitState = jass.GetUnitState
____exports.IsUnitType = jass.IsUnitType
____exports.GetRectMinX = jass.GetRectMinX
____exports.GetRectMinY = jass.GetRectMinY
____exports.GetRectMaxX = jass.GetRectMaxX
____exports.GetRectMaxY = jass.GetRectMaxY
____exports.SetUnitX = jass.SetUnitX
____exports.SetUnitY = jass.SetUnitY
____exports.SetUnitFacing = jass.SetUnitFacing
____exports.PauseUnit = jass.PauseUnit
____exports.IsUnitPaused = jass.IsUnitPaused
____exports.SetUnitPathing = jass.SetUnitPathing
____exports.SquareRoot = jass.SquareRoot
____exports.Atan2 = jass.Atan2
____exports.Cos = jass.Cos
____exports.Sin = jass.Sin
____exports.R2I = jass.R2I
local ____jglobals_bj_RADTODEG_0 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_0 == nil then
    ____jglobals_bj_RADTODEG_0 = 57.29577951308232
end
____exports.bj_RADTODEG = ____jglobals_bj_RADTODEG_0
local ____jglobals_bj_DEGTORAD_1 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_1 == nil then
    ____jglobals_bj_DEGTORAD_1 = 0.017453292519943295
end
____exports.bj_DEGTORAD = ____jglobals_bj_DEGTORAD_1
____exports.ForGroup = jass.ForGroup
____exports.GetEnumUnit = jass.GetEnumUnit
____exports.AddLightning = jass.AddLightning
____exports.MoveLightning = jass.MoveLightning
____exports.MoveLightningEx = jass.MoveLightningEx
____exports.DestroyLightning = jass.DestroyLightning
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
____exports.X_IsTerrainWalkable = ____require_result_2.X_IsTerrainWalkable
____exports.X_IsUnitTerrainWalkable = ____require_result_2.X_IsUnitTerrainWalkable
____exports.X_GetAbleX = ____require_result_2.X_GetAbleX
____exports.X_GetAbleY = ____require_result_2.X_GetAbleY
____exports.TICK_INTERVAL = 0.02
____exports.CENTER_TIMER_TICKS = 2
____exports.MAX_SUB_STEP = 31
____exports.WALKABLE_TOLERANCE = 8
____exports.UNIT_ALIVE_LIFE = 0.405
____exports["闪电效果代码_闪电链主闪电"] = "CLPB"
____exports["闪电效果代码_闪电链次闪电"] = "CLSB"
____exports["闪电效果代码_生命汲取"] = "DRAB"
____exports["闪电效果代码_生命汲取生命"] = "DRAL"
____exports["闪电效果代码_魔力汲取"] = "DRAM"
____exports["闪电效果代码_叉状闪电"] = "FORK"
____exports["闪电效果代码_治疗波主闪电"] = "HWPB"
____exports["闪电效果代码_治疗波次闪电"] = "HWSB"
____exports["闪电效果代码_闪电攻击"] = "CHIM"
____exports["闪电效果代码_魔法束缚"] = "LEAS"
____exports["闪电效果代码_灵魂锁链"] = "SPLK"
____exports["闪电效果代码_牵引绳子"] = "ROP"
____exports["闪电效果代码_魔力之焰"] = "MFPB"
____exports["闪电效果代码_死亡之指"] = "AFOD"
____exports.DEFAULT_LIGHTNING_CODE = ____exports["闪电效果代码_闪电链主闪电"]
____exports["单位组快照缓存"] = {}
____exports["活动牵引列表"] = {}
____exports["牵引映射"] = {}
____exports["单位当前牵引"] = {}
____exports["下一个牵引ID"] = 0
____exports["推进下一个牵引ID"] = function()
    ____exports["下一个牵引ID"] = ____exports["下一个牵引ID"] + 1
    return ____exports["下一个牵引ID"]
end
____exports["取句柄ID"] = function(h)
    return h ~= nil and h ~= 0 and ____exports.GetHandleId(h) or 0 or 0
end
____exports["单位存活"] = function(u)
    if u == nil or u == 0 then
        return false
    end
    if ____exports.GetUnitTypeId(u) == 0 then
        return false
    end
    if ____exports.IsUnitType(u, jass.UNIT_TYPE_DEAD) == true then
        return false
    end
    return ____exports.GetUnitState(u, jass.UNIT_STATE_LIFE) > ____exports.UNIT_ALIVE_LIFE
end
____exports["在可玩区域内"] = function(x, y)
    return x >= ____exports.GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= ____exports.GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= ____exports.GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= ____exports.GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
____exports["计算坐标距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return ____exports.SquareRoot(dx * dx + dy * dy)
end
____exports["计算朝向角度"] = function(x1, y1, x2, y2)
    return ____exports.Atan2(y2 - y1, x2 - x1) * ____exports.bj_RADTODEG
end
____exports["收集单位组成员"] = function()
    local _____5355_4F4D = ____exports.GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        local ____exports__5355_4F4D_7EC4_5FEB_7167_7F13_5B58_3 = ____exports["单位组快照缓存"]
        ____exports__5355_4F4D_7EC4_5FEB_7167_7F13_5B58_3[#____exports__5355_4F4D_7EC4_5FEB_7167_7F13_5B58_3 + 1] = _____5355_4F4D
    end
end
____exports["快照单位组"] = function(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    ____exports["单位组快照缓存"] = {}
    ____exports.ForGroup(_____5355_4F4D_7EC4, ____exports["收集单位组成员"])
    local _____7ED3_679C = ____exports["单位组快照缓存"]
    ____exports["单位组快照缓存"] = {}
    return _____7ED3_679C
end
____exports["计算每Tick位移"] = function(_____53C2_6570)
    if _____53C2_6570["每Tick位移"] ~= nil and _____53C2_6570["每Tick位移"] > 0 then
        return _____53C2_6570["每Tick位移"]
    end
    if _____53C2_6570["每秒速度"] ~= nil and _____53C2_6570["每秒速度"] > 0 then
        return _____53C2_6570["每秒速度"] * ____exports.TICK_INTERVAL
    end
    return 10
end
____exports["计算持续Tick数"] = function(_____53C2_6570)
    if _____53C2_6570["持续时间"] ~= nil and _____53C2_6570["持续时间"] > 0 then
        local ticks = ____exports.R2I(_____53C2_6570["持续时间"] / ____exports.TICK_INTERVAL + 0.0001)
        return ticks > 0 and ticks or 1
    end
    return 50
end
____exports["解析中心坐标"] = function(_____53C2_6570)
    if _____53C2_6570["中心单位"] ~= nil and _____53C2_6570["中心单位"] ~= 0 then
        return {
            x = ____exports.GetUnitX(_____53C2_6570["中心单位"]),
            y = ____exports.GetUnitY(_____53C2_6570["中心单位"])
        }
    end
    if _____53C2_6570["中心X"] ~= nil and _____53C2_6570["中心Y"] ~= nil then
        return {x = _____53C2_6570["中心X"], y = _____53C2_6570["中心Y"]}
    end
    return nil
end
return ____exports
