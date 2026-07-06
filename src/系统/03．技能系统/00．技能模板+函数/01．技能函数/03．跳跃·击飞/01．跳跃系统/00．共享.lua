--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_GAFC = ____require_result_0.X_GAFC
local X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
local X_IsUnitTerrainWalkable = ____require_result_0.X_IsUnitTerrainWalkable
local X_GetAbleX = ____require_result_0.X_GetAbleX
local X_GetAbleY = ____require_result_0.X_GetAbleY
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["申请单位暂停占用"]
local _____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["释放单位暂停占用"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_1["单位是否存在其他暂停占用"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____require_result_2["零秒后重置单位动画"]
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetRectMinX = jass.GetRectMinX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxX = jass.GetRectMaxX
local GetRectMaxY = jass.GetRectMaxY
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetRandomReal = jass.GetRandomReal
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitFacing = jass.SetUnitFacing
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local Cos = jass.Cos
local Sin = jass.Sin
local IsUnitPaused = jass.IsUnitPaused
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
____exports.jass = jass
____exports.jglobals = jglobals
____exports.X_GAFC = X_GAFC
____exports.X_IsTerrainWalkable = X_IsTerrainWalkable
____exports.X_IsUnitTerrainWalkable = X_IsUnitTerrainWalkable
____exports.X_GetAbleX = X_GetAbleX
____exports.X_GetAbleY = X_GetAbleY
____exports["申请单位暂停占用"] = _____7533_8BF7_5355_4F4D_6682_505C_5360_7528
____exports["释放单位暂停占用"] = _____91CA_653E_5355_4F4D_6682_505C_5360_7528
____exports["单位是否存在其他暂停占用"] = _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528
____exports["零秒后重置单位动画"] = _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B
____exports.GetHandleId = GetHandleId
____exports.GetUnitState = GetUnitState
____exports.GetRectMinX = GetRectMinX
____exports.GetRectMinY = GetRectMinY
____exports.GetRectMaxX = GetRectMaxX
____exports.GetRectMaxY = GetRectMaxY
____exports.UnitAddAbility = UnitAddAbility
____exports.UnitRemoveAbility = UnitRemoveAbility
____exports.AddSpecialEffect = AddSpecialEffect
____exports.DestroyEffect = DestroyEffect
____exports.GetRandomReal = GetRandomReal
____exports.GetUnitX = GetUnitX
____exports.GetUnitY = GetUnitY
____exports.GetUnitFlyHeight = GetUnitFlyHeight
____exports.SetUnitFlyHeight = SetUnitFlyHeight
____exports.SetUnitFacing = SetUnitFacing
____exports.SetUnitX = SetUnitX
____exports.SetUnitY = SetUnitY
____exports.Cos = Cos
____exports.Sin = Sin
____exports.IsUnitPaused = IsUnitPaused
____exports.ForGroup = ForGroup
____exports.GetEnumUnit = GetEnumUnit
local ____jglobals_bj_DEGTORAD_3 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_3 == nil then
    ____jglobals_bj_DEGTORAD_3 = 0.017453292519943295
end
____exports.BJ_DEGTORAD = ____jglobals_bj_DEGTORAD_3
____exports.TICK_INTERVAL = 0.02
____exports.CENTER_TIMER_TICKS = 2
____exports.MAX_SUB_STEP = 31
____exports.WALKABLE_TOLERANCE = 8
____exports.UNIT_ALIVE_LIFE = 0.405
____exports.DEFAULT_JUMP_EFFECT_MODEL = ""
____exports.CROW_FORM_ABILITY_ID = 1097691750
____exports["活动跳跃列表"] = {}
____exports["跳跃映射"] = {}
____exports["单位当前跳跃"] = {}
local _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
local _____4E0B_4E00_4E2A_8DF3_8DC3ID = 0
____exports["分配新跳跃ID"] = function()
    _____4E0B_4E00_4E2A_8DF3_8DC3ID = _____4E0B_4E00_4E2A_8DF3_8DC3ID + 1
    return _____4E0B_4E00_4E2A_8DF3_8DC3ID
end
____exports["取句柄ID"] = function(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0 or 0
end
local function _____6536_96C6_5355_4F4D_7EC4_6210_5458()
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58[#_____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 + 1] = _____5355_4F4D
    end
end
____exports["快照单位组"] = function(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    ForGroup(_____5355_4F4D_7EC4, _____6536_96C6_5355_4F4D_7EC4_6210_5458)
    local _____7ED3_679C = _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    return _____7ED3_679C
end
____exports["单位存活"] = function(u)
    return u ~= nil and u ~= 0 and GetUnitState(u, jass.UNIT_STATE_LIFE) > ____exports.UNIT_ALIVE_LIFE
end
____exports["在可玩区域内"] = function(x, y)
    return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
____exports["计算坐标距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
____exports["计算每tick位移"] = function(_____8DDD_79BB, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 <= 0 then
        return _____8DDD_79BB
    end
    return _____8DDD_79BB / (_____6301_7EED_65F6_95F4 / ____exports.TICK_INTERVAL)
end
____exports["确保单位可设置飞行高度"] = function(_____5355_4F4D)
    UnitAddAbility(_____5355_4F4D, ____exports.CROW_FORM_ABILITY_ID)
    UnitRemoveAbility(_____5355_4F4D, ____exports.CROW_FORM_ABILITY_ID)
end
____exports["限制进度"] = function(v)
    if v <= 0 then
        return 0
    end
    if v >= 1 then
        return 1
    end
    return v
end
____exports["计算抛物线高度"] = function(_____8FDB_5EA6, _____6700_5927_9AD8_5EA6)
    local t = ____exports["限制进度"](_____8FDB_5EA6)
    return 4 * _____6700_5927_9AD8_5EA6 * t * (1 - t)
end
____exports["播放跳跃特效"] = function(_____5B9E_4F8B)
    local _____6A21_578B = _____5B9E_4F8B["跳跃特效"]
    if _____6A21_578B == nil or _____6A21_578B == "" then
        return
    end
    local _____7279_6548 = AddSpecialEffect(
        _____6A21_578B,
        GetUnitX(_____5B9E_4F8B["单位"]),
        GetUnitY(_____5B9E_4F8B["单位"])
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        DestroyEffect(_____7279_6548)
    end
end
____exports["单位已被暂停"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return IsUnitPaused(_____5355_4F4D) == true
end
return ____exports
