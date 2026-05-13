local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_GAFC = ____require_result_0.X_GAFC
local X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
local X_GetAbleX = ____require_result_0.X_GetAbleX
local X_GetAbleY = ____require_result_0.X_GetAbleY
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["申请单位暂停占用"]
local _____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["释放单位暂停占用"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_1["单位是否存在其他暂停占用"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____96F6_79D2_540E_64AD_653E_5355_4F4D_52A8_4F5C = ____require_result_2["零秒后播放单位动作"]
local _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____require_result_2["零秒后重置单位动画"]
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitTimeScale = jass.SetUnitTimeScale
____exports.jass = jass
____exports.jglobals = jglobals
____exports.X_GAFC = X_GAFC
____exports.X_IsTerrainWalkable = X_IsTerrainWalkable
____exports.X_GetAbleX = X_GetAbleX
____exports.X_GetAbleY = X_GetAbleY
____exports["申请单位暂停占用"] = _____7533_8BF7_5355_4F4D_6682_505C_5360_7528
____exports["释放单位暂停占用"] = _____91CA_653E_5355_4F4D_6682_505C_5360_7528
____exports["单位是否存在其他暂停占用"] = _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528
____exports["零秒后播放单位动作"] = _____96F6_79D2_540E_64AD_653E_5355_4F4D_52A8_4F5C
____exports["零秒后重置单位动画"] = _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B
____exports.SetUnitAnimation = SetUnitAnimation
____exports.SetUnitTimeScale = SetUnitTimeScale
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
____exports.DEFAULT_MOVE_EFFECT_MODEL = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"
____exports.DEFAULT_ATTACK_TYPE = jass.ATTACK_TYPE_NORMAL
____exports.DEFAULT_DAMAGE_TYPE = jass.DAMAGE_TYPE_NORMAL
____exports.DEFAULT_WEAPON_TYPE = jass.WEAPON_TYPE_WHOKNOWS
____exports["活动位移列表"] = {}
____exports["位移映射"] = {}
____exports["单位当前位移"] = {}
____exports["命中记录"] = {}
local _____679A_4E3E_7EC4 = nil
local _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
local _____4E0B_4E00_4E2A_4F4D_79FBID = 0
____exports["分配新位移ID"] = function()
    _____4E0B_4E00_4E2A_4F4D_79FBID = _____4E0B_4E00_4E2A_4F4D_79FBID + 1
    return _____4E0B_4E00_4E2A_4F4D_79FBID
end
____exports["取句柄ID"] = function(h)
    return h ~= nil and h ~= 0 and jass.GetHandleId(h) or 0 or 0
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
    return u ~= nil and u ~= 0 and jass.GetUnitState(u, jass.UNIT_STATE_LIFE) > ____exports.UNIT_ALIVE_LIFE
end
____exports["在可玩区域内"] = function(x, y)
    return x >= jass.GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= jass.GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= jass.GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= jass.GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
____exports["计算坐标距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
____exports["清理命中记录"] = function(_____4F4D_79FBID)
    local _____524D_7F00 = tostring(_____4F4D_79FBID) .. ":"
    for key in pairs(____exports["命中记录"]) do
        if (string.find(key, _____524D_7F00, nil, true) or 0) - 1 == 0 then
            __TS__Delete(____exports["命中记录"], key)
        end
    end
end
____exports["生成命中键"] = function(_____4F4D_79FBID, _____76EE_6807_5355_4F4D)
    return (tostring(_____4F4D_79FBID) .. ":") .. tostring(____exports["取句柄ID"](_____76EE_6807_5355_4F4D))
end
____exports["计算每Tick位移"] = function(_____8DDD_79BB, _____6301_7EED_65F6_95F4, _____6BCF_79D2_901F_5EA6)
    if _____6BCF_79D2_901F_5EA6 ~= nil and _____6BCF_79D2_901F_5EA6 > 0 then
        return _____6BCF_79D2_901F_5EA6 * ____exports.TICK_INTERVAL
    end
    if _____6301_7EED_65F6_95F4 ~= nil and _____6301_7EED_65F6_95F4 > 0 then
        return _____8DDD_79BB / (_____6301_7EED_65F6_95F4 / ____exports.TICK_INTERVAL)
    end
    return _____8DDD_79BB
end
____exports["单位已被暂停"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return jass.IsUnitPaused(_____5355_4F4D) == true
end
____exports["播放位移特效"] = function(_____5B9E_4F8B)
    local _____6A21_578B = _____5B9E_4F8B["位移特效"]
    if _____6A21_578B == nil or _____6A21_578B == "" then
        return
    end
    local _____7279_6548 = jass.AddSpecialEffect(
        _____6A21_578B,
        jass.GetUnitX(_____5B9E_4F8B["单位"]),
        jass.GetUnitY(_____5B9E_4F8B["单位"])
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        jass.DestroyEffect(_____7279_6548)
    end
end
____exports["获取枚举组"] = function()
    if _____679A_4E3E_7EC4 == nil or _____679A_4E3E_7EC4 == 0 then
        _____679A_4E3E_7EC4 = jass.CreateGroup()
    end
    return _____679A_4E3E_7EC4
end
____exports["清空枚举组"] = function()
    local g = ____exports["获取枚举组"]()
    while true do
        local u = jass.FirstOfGroup(g)
        if u == nil or u == 0 then
            break
        end
        jass.GroupRemoveUnit(g, u)
    end
end
____exports["销毁枚举组"] = function()
    if _____679A_4E3E_7EC4 ~= nil and _____679A_4E3E_7EC4 ~= 0 then
        jass.DestroyGroup(_____679A_4E3E_7EC4)
        _____679A_4E3E_7EC4 = nil
    end
end
return ____exports
