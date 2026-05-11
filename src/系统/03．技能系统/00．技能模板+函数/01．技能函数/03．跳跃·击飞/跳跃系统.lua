local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_53E5_67C4ID, _____5355_4F4D_5B58_6D3B, _____5728_53EF_73A9_533A_57DF_5185, _____8BA1_7B97_5750_6807_8DDD_79BB, _____9650_5236_8FDB_5EA6, _____8BA1_7B97_629B_7269_7EBF_9AD8_5EA6, _____64AD_653E_8DF3_8DC3_7279_6548, _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____5185_90E8_79FB_9664_8DF3_8DC3, _____7ED3_675F_8DF3_8DC3_5B9E_4F8B, _____7ED3_675F_8DF3_8DC3ID, _____5C1D_8BD5_79FB_52A8_4E00_6B65, _____63A8_8FDB_4E00_6B65, ____on_8DF3_8DC3_7CFB_7EDFTick, jass, jglobals, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY, _____91CA_653E_5355_4F4D_6682_505C_5360_7528, _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528, _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B, offTick10ms, GetHandleId, GetUnitState, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY, AddSpecialEffect, DestroyEffect, GetUnitX, GetUnitY, GetUnitFlyHeight, SetUnitFlyHeight, SetUnitFacing, SetUnitX, SetUnitY, Cos, Sin, IsUnitPaused, BJ_DEGTORAD, CENTER_TIMER_TICKS, MAX_SUB_STEP, WALKABLE_TOLERANCE, UNIT_ALIVE_LIFE, _____6D3B_52A8_8DF3_8DC3_5217_8868, _____8DF3_8DC3_6620_5C04, _____5355_4F4D_5F53_524D_8DF3_8DC3, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0 or 0
end
function _____5355_4F4D_5B58_6D3B(u)
    return u ~= nil and u ~= 0 and GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____5728_53EF_73A9_533A_57DF_5185(x, y)
    return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
function _____9650_5236_8FDB_5EA6(v)
    if v <= 0 then
        return 0
    end
    if v >= 1 then
        return 1
    end
    return v
end
function _____8BA1_7B97_629B_7269_7EBF_9AD8_5EA6(_____8FDB_5EA6, _____6700_5927_9AD8_5EA6)
    local t = _____9650_5236_8FDB_5EA6(_____8FDB_5EA6)
    return 4 * _____6700_5927_9AD8_5EA6 * t * (1 - t)
end
function _____64AD_653E_8DF3_8DC3_7279_6548(_____5B9E_4F8B)
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
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_8DF3_8DC3_7CFB_7EDFTick)
end
function _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_8DF3_8DC3_5217_8868 ~= 0 then
        return
    end
    ____tick_8BA1_6570 = 0
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
function _____5185_90E8_79FB_9664_8DF3_8DC3(_____5B9E_4F8B)
    local _____8DF3_8DC3ID = _____5B9E_4F8B.id
    local _____5355_4F4DID = _____5B9E_4F8B["单位ID"]
    __TS__Delete(_____8DF3_8DC3_6620_5C04, _____8DF3_8DC3ID)
    if _____5355_4F4D_5F53_524D_8DF3_8DC3[_____5355_4F4DID] == _____8DF3_8DC3ID then
        __TS__Delete(_____5355_4F4D_5F53_524D_8DF3_8DC3, _____5355_4F4DID)
    end
    local idx = _____5B9E_4F8B.listIndex
    local lastIdx = #_____6D3B_52A8_8DF3_8DC3_5217_8868 - 1
    if idx ~= lastIdx then
        local last = _____6D3B_52A8_8DF3_8DC3_5217_8868[lastIdx + 1]
        _____6D3B_52A8_8DF3_8DC3_5217_8868[idx + 1] = last
        last.listIndex = idx
    end
    table.remove(_____6D3B_52A8_8DF3_8DC3_5217_8868)
    _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____7ED3_675F_8DF3_8DC3_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____8DF3_8DC3_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____8DF3_8DC3ID = _____5B9E_4F8B.id
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["结束回调"]
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and _____5B9E_4F8B["上次附加高度"] ~= 0 then
        local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____5355_4F4D)
        SetUnitFlyHeight(_____5355_4F4D, _____5F53_524D_9AD8_5EA6 - _____5B9E_4F8B["上次附加高度"], 0)
        _____5B9E_4F8B["上次附加高度"] = 0
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____91CA_653E_5355_4F4D_6682_505C_5360_7528(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    if _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and _____539F_56E0 ~= "死亡" and _____539F_56E0 ~= "主单位死亡" then
        _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B(_____5355_4F4D)
    end
    _____5185_90E8_79FB_9664_8DF3_8DC3(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
    end
end
function _____7ED3_675F_8DF3_8DC3ID(_____8DF3_8DC3ID, _____539F_56E0)
    local _____5B9E_4F8B = _____8DF3_8DC3_6620_5C04[_____8DF3_8DC3ID]
    if not _____5B9E_4F8B then
        return false
    end
    _____7ED3_675F_8DF3_8DC3_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5F53_524DX = GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = GetUnitY(_____5355_4F4D)
    local _____5F27_5EA6 = _____5B9E_4F8B["角度"] * BJ_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____4F4D_79FB_8DDD_79BB * Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____4F4D_79FB_8DDD_79BB * Sin(_____5F27_5EA6)
    if not _____5728_53EF_73A9_533A_57DF_5185(_____65B0X, _____65B0Y) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if not X_IsTerrainWalkable(nil, _____65B0X, _____65B0Y) then
        local _____53EF_901A_884CX = X_GetAbleX(nil)
        local _____53EF_901A_884CY = X_GetAbleY(nil)
        local ableDist = _____8BA1_7B97_5750_6807_8DDD_79BB(_____65B0X, _____65B0Y, _____53EF_901A_884CX, _____53EF_901A_884CY)
        if ableDist > WALKABLE_TOLERANCE then
            return {["停止"] = true, ["原因"] = "阻挡"}
        end
    end
    local _____843D_70B9_8FC7_6EE4 = _____5B9E_4F8B["落点过滤"]
    if type(_____843D_70B9_8FC7_6EE4) == "function" and not _____843D_70B9_8FC7_6EE4(_____65B0X, _____65B0Y, _____5355_4F4D, _____5B9E_4F8B.id) then
        return {["停止"] = true, ["原因"] = "阻挡"}
    end
    if _____5B9E_4F8B["朝向跟随跳跃"] then
        SetUnitFacing(_____5355_4F4D, _____5B9E_4F8B["角度"])
    end
    SetUnitX(_____5355_4F4D, _____65B0X)
    SetUnitY(_____5355_4F4D, _____65B0Y)
    _____5B9E_4F8B["已移动"] = _____5B9E_4F8B["已移动"] + _____4F4D_79FB_8DDD_79BB
    local _____8FDB_5EA6 = _____5B9E_4F8B["总距离"] > 0 and _____5B9E_4F8B["已移动"] / _____5B9E_4F8B["总距离"] or 1
    local _____65B0_9644_52A0_9AD8_5EA6 = _____8BA1_7B97_629B_7269_7EBF_9AD8_5EA6(_____8FDB_5EA6, _____5B9E_4F8B["跳跃高度"])
    local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____5355_4F4D)
    SetUnitFlyHeight(_____5355_4F4D, _____5F53_524D_9AD8_5EA6 - _____5B9E_4F8B["上次附加高度"] + _____65B0_9644_52A0_9AD8_5EA6, 0)
    _____5B9E_4F8B["上次附加高度"] = _____65B0_9644_52A0_9AD8_5EA6
    if _____5B9E_4F8B["已移动"] >= _____5B9E_4F8B["总距离"] then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    return {["停止"] = false}
end
function _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
    local _____8D77_59CB_5DF2_79FB_52A8 = _____5B9E_4F8B["已移动"]
    local _____5269_4F59_8DDD_79BB = _____5B9E_4F8B["总距离"] - _____5B9E_4F8B["已移动"]
    if _____5269_4F59_8DDD_79BB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____672Ctick_4F4D_79FB = _____5B9E_4F8B["每tick位移"]
    if _____672Ctick_4F4D_79FB > _____5269_4F59_8DDD_79BB then
        _____672Ctick_4F4D_79FB = _____5269_4F59_8DDD_79BB
    end
    if _____672Ctick_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____5269_4F59_6B65_957F = _____672Ctick_4F4D_79FB
    while _____5269_4F59_6B65_957F > 0 do
        local _____5B50_6B65_957F = _____5269_4F59_6B65_957F > MAX_SUB_STEP and MAX_SUB_STEP or _____5269_4F59_6B65_957F
        local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____5B50_6B65_957F)
        if _____7ED3_679C["停止"] then
            if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
                _____64AD_653E_8DF3_8DC3_7279_6548(_____5B9E_4F8B)
            end
            return _____7ED3_679C
        end
        if _____8DF3_8DC3_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
            return {["停止"] = true, ["原因"] = "中断"}
        end
        _____5269_4F59_6B65_957F = _____5269_4F59_6B65_957F - _____5B50_6B65_957F
    end
    if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
        _____64AD_653E_8DF3_8DC3_7279_6548(_____5B9E_4F8B)
    end
    return {["停止"] = false}
end
function ____on_8DF3_8DC3_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_8DF3_8DC3_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_8DF3_8DC3_5217_8868[i + 1]
            if _____8DF3_8DC3_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                i = i + 1
                goto __continue55
            end
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_8DF3_8DC3_5B9E_4F8B(_____5B9E_4F8B, "死亡")
                goto __continue55
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                _____7ED3_675F_8DF3_8DC3_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
                goto __continue55
            end
            if IsUnitPaused(_____5B9E_4F8B["单位"]) == true then
                if not _____5B9E_4F8B["暂停单位"] or _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(_____5B9E_4F8B["单位"], _____5B9E_4F8B["暂停来源"]) then
                    i = i + 1
                    goto __continue55
                end
            end
            local _____7ED3_679C = _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
            if _____7ED3_679C["停止"] then
                _____7ED3_675F_8DF3_8DC3_5B9E_4F8B(_____5B9E_4F8B, _____7ED3_679C["原因"] or "完成")
                goto __continue55
            end
            i = i + 1
        end
        ::__continue55::
    end
end
____exports["停止单位跳跃"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____8DF3_8DC3ID = _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    if not _____8DF3_8DC3ID then
        return false
    end
    return _____7ED3_675F_8DF3_8DC3ID(_____8DF3_8DC3ID, _____539F_56E0)
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_GAFC = ____require_result_0.X_GAFC
X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
X_GetAbleX = ____require_result_0.X_GetAbleX
X_GetAbleY = ____require_result_0.X_GetAbleY
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["申请单位暂停占用"]
_____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____require_result_1["释放单位暂停占用"]
_____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_1["单位是否存在其他暂停占用"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
_____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____require_result_2["零秒后重置单位动画"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_3.onTick10ms
offTick10ms = ____require_result_3.offTick10ms
GetHandleId = jass.GetHandleId
GetUnitState = jass.GetUnitState
GetRectMinX = jass.GetRectMinX
GetRectMinY = jass.GetRectMinY
GetRectMaxX = jass.GetRectMaxX
GetRectMaxY = jass.GetRectMaxY
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
SetUnitFlyHeight = jass.SetUnitFlyHeight
SetUnitFacing = jass.SetUnitFacing
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
Cos = jass.Cos
Sin = jass.Sin
IsUnitPaused = jass.IsUnitPaused
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local ____jglobals_bj_DEGTORAD_4 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_4 == nil then
    ____jglobals_bj_DEGTORAD_4 = 0.017453292519943295
end
BJ_DEGTORAD = ____jglobals_bj_DEGTORAD_4
local TICK_INTERVAL = 0.02
CENTER_TIMER_TICKS = 2
MAX_SUB_STEP = 31
WALKABLE_TOLERANCE = 8
UNIT_ALIVE_LIFE = 0.405
local DEFAULT_JUMP_EFFECT_MODEL = ""
local CROW_FORM_ABILITY_ID = 1097691750
_____6D3B_52A8_8DF3_8DC3_5217_8868 = {}
_____8DF3_8DC3_6620_5C04 = {}
_____5355_4F4D_5F53_524D_8DF3_8DC3 = {}
local _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
local _____4E0B_4E00_4E2A_8DF3_8DC3ID = 0
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____6536_96C6_5355_4F4D_7EC4_6210_5458()
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58[#_____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 + 1] = _____5355_4F4D
    end
end
local function _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    ForGroup(_____5355_4F4D_7EC4, _____6536_96C6_5355_4F4D_7EC4_6210_5458)
    local _____7ED3_679C = _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    return _____7ED3_679C
end
local function _____8BA1_7B97_6BCFtick_4F4D_79FB(_____8DDD_79BB, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 <= 0 then
        return _____8DDD_79BB
    end
    return _____8DDD_79BB / (_____6301_7EED_65F6_95F4 / TICK_INTERVAL)
end
local function _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
    UnitAddAbility(_____5355_4F4D, CROW_FORM_ABILITY_ID)
    UnitRemoveAbility(_____5355_4F4D, CROW_FORM_ABILITY_ID)
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_8DF3_8DC3_7CFB_7EDFTick)
end
local function _____89E3_6790_8DF3_8DC3_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] ~= nil then
        return _____53C2_6570["角度"]
    end
    if _____53C2_6570["目标X"] ~= nil and _____53C2_6570["目标Y"] ~= nil then
        return X_GAFC(
            nil,
            GetUnitX(_____5355_4F4D),
            GetUnitY(_____5355_4F4D),
            _____53C2_6570["目标X"],
            _____53C2_6570["目标Y"]
        )
    end
    return nil
end
local function _____521B_5EFA_8DF3_8DC3_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return 0
    end
    if _____53C2_6570["距离"] == nil or _____53C2_6570["距离"] <= 0 then
        return 0
    end
    if _____53C2_6570["持续时间"] == nil or _____53C2_6570["持续时间"] <= 0 then
        return 0
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return 0
    end
    ____exports["停止单位跳跃"](_____5355_4F4D, "中断")
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
    local _____6BCFtick_4F4D_79FB = _____8BA1_7B97_6BCFtick_4F4D_79FB(_____53C2_6570["距离"], _____53C2_6570["持续时间"])
    if _____6BCFtick_4F4D_79FB <= 0 then
        return 0
    end
    _____4E0B_4E00_4E2A_8DF3_8DC3ID = _____4E0B_4E00_4E2A_8DF3_8DC3ID + 1
    local _____8DF3_8DC3ID = _____4E0B_4E00_4E2A_8DF3_8DC3ID
    local _____5B9E_4F8B = {
        id = _____8DF3_8DC3ID,
        listIndex = #_____6D3B_52A8_8DF3_8DC3_5217_8868,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["主单位"] = _____53C2_6570["主单位"],
        ["主单位死亡时中断"] = _____53C2_6570["主单位死亡时中断"] ~= false,
        ["角度"] = _____89D2_5EA6,
        ["总距离"] = _____53C2_6570["距离"],
        ["已移动"] = 0,
        ["每tick位移"] = _____6BCFtick_4F4D_79FB,
        ["跳跃高度"] = _____53C2_6570["跳跃高度"] or 0,
        ["上次附加高度"] = 0,
        ["暂停单位"] = _____53C2_6570["暂停单位"] ~= false,
        ["暂停来源"] = "跳跃系统:" .. tostring(_____8DF3_8DC3ID),
        ["朝向跟随跳跃"] = _____53C2_6570["朝向跟随跳跃"] == true,
        ["跳跃特效"] = _____53C2_6570["跳跃特效"] or DEFAULT_JUMP_EFFECT_MODEL,
        ["落点过滤"] = _____53C2_6570["落点过滤"],
        ["结束回调"] = _____53C2_6570["结束回调"],
        ["开始回调"] = _____53C2_6570["开始回调"]
    }
    _____8DF3_8DC3_6620_5C04[_____8DF3_8DC3ID] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_8DF3_8DC3[_____5355_4F4DID] = _____8DF3_8DC3ID
    _____6D3B_52A8_8DF3_8DC3_5217_8868[#_____6D3B_52A8_8DF3_8DC3_5217_8868 + 1] = _____5B9E_4F8B
    if _____5B9E_4F8B["暂停单位"] then
        _____7533_8BF7_5355_4F4D_6682_505C_5360_7528(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if type(_____53C2_6570["开始回调"]) == "function" then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____8DF3_8DC3ID)
    end
    return _____8DF3_8DC3ID
end
____exports["开始跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    local _____89D2_5EA6 = _____89E3_6790_8DF3_8DC3_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    return _____521B_5EFA_8DF3_8DC3_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
end
____exports["开始定向跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    return ____exports["开始跳跃"](_____5355_4F4D, _____53C2_6570)
end
____exports["开始单位组跳跃"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DF3_8DC3ID = ____exports["开始跳跃"](_____5355_4F4D, _____53C2_6570)
        if _____8DF3_8DC3ID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____8DF3_8DC3ID
        end
    end
    return _____7ED3_679C
end
____exports["开始单位组定向跳跃"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DF3_8DC3ID = ____exports["开始定向跳跃"](_____5355_4F4D, _____53C2_6570)
        if _____8DF3_8DC3ID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____8DF3_8DC3ID
        end
    end
    return _____7ED3_679C
end
____exports["停止跳跃"] = function(_____8DF3_8DC3ID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return _____7ED3_675F_8DF3_8DC3ID(_____8DF3_8DC3ID, _____539F_56E0)
end
____exports["单位是否正在跳跃"] = function(_____5355_4F4D)
    local _____8DF3_8DC3ID = _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    return _____8DF3_8DC3ID ~= nil and _____8DF3_8DC3_6620_5C04[_____8DF3_8DC3ID] ~= nil
end
____exports["获取单位当前跳跃ID"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)] or 0
end
____exports["获取活跃跳跃数量"] = function()
    return #_____6D3B_52A8_8DF3_8DC3_5217_8868
end
return ____exports
