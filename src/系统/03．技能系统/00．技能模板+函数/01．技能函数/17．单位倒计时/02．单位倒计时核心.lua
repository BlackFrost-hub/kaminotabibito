local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_6709_6548, _____5355_4F4D_5DF2_6B7B_4EA1, _____5220_9664_5B9E_4F8BID, _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668, ____on_5EF6_8FDF_9500_6BC1_7279_6548, _____9500_6BC1_5012_8BA1_65F6_7279_6548, _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B, _____6267_884C_5F3A_53162_5230_671F_6548_679C, _____5206_53D1_5355_4F4D_5012_8BA1_65F6_5230_671F_6548_679C, _____63A8_8FDB_5355_4E2A_5355_4F4D_5012_8BA1_65F6, _____9A71_52A8_5355_4F4D_5012_8BA1_65F6, ____on_5355_4F4D_5012_8BA1_65F6_5EF6_8FDF_51FB_6740_539F_5355_4F4D, offTick10ms, addDelayedCallback, YDUserDataSet, _____521B_5EFA_53EC_5524_7269, debugLogForce, GetUnitX, GetUnitY, IsUnitPaused, IsUnitType, KillUnit, DestroyEffect, DzUnbindEffect, DzSetEffectVisible, DzSetEffectScale, UNIT_TYPE_DEAD, _____6A21_5757_540D, _____5012_8BA1_65F6_5468_671F_79D2, _____5F3A_53162_6548_679CID, _____5F3A_5316_53EC_5524_7F29_653E, _____539F_5355_4F4D_5EF6_8FDF_51FB_6740_6BEB_79D2, _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668, _____5012_8BA1_65F6_5B9E_4F8B_8868, _____5012_8BA1_65F6_5B9E_4F8BID_8868, _____5355_4F4D_5230_5012_8BA1_65F6ID_8868, _____5EF6_8FDF_51FB_6740_5355_4F4D_961F_5217, _____5F85_5EF6_8FDF_9500_6BC1_7279_6548_961F_5217
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____5355_4F4D_5DF2_6B7B_4EA1(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return true
    end
    return IsUnitType(unit, UNIT_TYPE_DEAD)
end
function _____5220_9664_5B9E_4F8BID(_____5B9E_4F8BID)
    local index = __TS__ArrayIndexOf(_____5012_8BA1_65F6_5B9E_4F8BID_8868, _____5B9E_4F8BID)
    if index >= 0 then
        __TS__ArraySplice(_____5012_8BA1_65F6_5B9E_4F8BID_8868, index, 1)
    end
end
function _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    if #_____5012_8BA1_65F6_5B9E_4F8BID_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(_____9A71_52A8_5355_4F4D_5012_8BA1_65F6)
end
function ____on_5EF6_8FDF_9500_6BC1_7279_6548()
    local effect = table.remove(_____5F85_5EF6_8FDF_9500_6BC1_7279_6548_961F_5217, 1)
    if effect == nil or effect == 0 then
        return
    end
    DestroyEffect(effect)
end
function _____9500_6BC1_5012_8BA1_65F6_7279_6548(effect)
    if effect == nil or effect == 0 then
        return
    end
    DzUnbindEffect(effect)
    DzSetEffectVisible(effect, false)
    DzSetEffectScale(effect, 0)
    _____5F85_5EF6_8FDF_9500_6BC1_7279_6548_961F_5217[#_____5F85_5EF6_8FDF_9500_6BC1_7279_6548_961F_5217 + 1] = effect
    addDelayedCallback(10, ____on_5EF6_8FDF_9500_6BC1_7279_6548)
end
function _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B(_____5B9E_4F8BID, _____662F_5426_5230_671F)
    local _____5B9E_4F8B = _____5012_8BA1_65F6_5B9E_4F8B_8868[_____5B9E_4F8BID]
    if _____5B9E_4F8B == nil then
        return
    end
    _____5012_8BA1_65F6_5B9E_4F8B_8868[_____5B9E_4F8BID] = nil
    _____5355_4F4D_5230_5012_8BA1_65F6ID_8868[_____5B9E_4F8B["单位句柄ID"]] = nil
    _____5220_9664_5B9E_4F8BID(_____5B9E_4F8BID)
    _____9500_6BC1_5012_8BA1_65F6_7279_6548(_____5B9E_4F8B["倒计时特效"])
    if _____662F_5426_5230_671F and _____5355_4F4D_6709_6548(_____5B9E_4F8B["单位"]) then
        YDUserDataSet(
            "unit",
            _____5B9E_4F8B["单位"],
            "Expire",
            "boolean",
            true
        )
        _____5206_53D1_5355_4F4D_5012_8BA1_65F6_5230_671F_6548_679C(_____5B9E_4F8B)
    end
    _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
end
function _____6267_884C_5F3A_53162_5230_671F_6548_679C(_____5B9E_4F8B)
    if not _____5355_4F4D_6709_6548(_____5B9E_4F8B["单位"]) then
        return
    end
    if _____5B9E_4F8B["强化单位类型"] == nil or _____5B9E_4F8B["强化单位类型"] == 0 or _____5B9E_4F8B["强化单位类型"] == "" then
        debugLogForce(_____6A21_5757_540D, "强化2跳过：PowerUPunitType 无效")
        return
    end
    local _____53EC_5524_7269 = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = _____5B9E_4F8B["单位"],
        ["单位类型"] = _____5B9E_4F8B["强化单位类型"],
        X = GetUnitX(_____5B9E_4F8B["单位"]),
        Y = GetUnitY(_____5B9E_4F8B["单位"]),
        ["缩放"] = _____5F3A_5316_53EC_5524_7F29_653E,
        ["持续时间"] = _____5B9E_4F8B["强化持续时间"],
        ["模型文件"] = _____5B9E_4F8B["强化模型"],
        ["生命值"] = _____5B9E_4F8B["强化生命值"]
    })
    if _____53EC_5524_7269 ~= nil and _____53EC_5524_7269 ~= 0 then
        YDUserDataSet(
            "unit",
            _____5B9E_4F8B["单位"],
            "PowerUPUnit",
            "unit",
            _____53EC_5524_7269
        )
    end
    _____5EF6_8FDF_51FB_6740_5355_4F4D_961F_5217[#_____5EF6_8FDF_51FB_6740_5355_4F4D_961F_5217 + 1] = _____5B9E_4F8B["单位"]
    addDelayedCallback(_____539F_5355_4F4D_5EF6_8FDF_51FB_6740_6BEB_79D2, ____on_5355_4F4D_5012_8BA1_65F6_5EF6_8FDF_51FB_6740_539F_5355_4F4D)
end
function _____5206_53D1_5355_4F4D_5012_8BA1_65F6_5230_671F_6548_679C(_____5B9E_4F8B)
    if _____5B9E_4F8B["到期效果ID"] == _____5F3A_53162_6548_679CID then
        _____6267_884C_5F3A_53162_5230_671F_6548_679C(_____5B9E_4F8B)
    end
end
function _____63A8_8FDB_5355_4E2A_5355_4F4D_5012_8BA1_65F6(_____5B9E_4F8B)
    if _____5355_4F4D_5DF2_6B7B_4EA1(_____5B9E_4F8B["单位"]) then
        _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B(_____5B9E_4F8B.ID, false)
        return
    end
    if IsUnitPaused(_____5B9E_4F8B["单位"]) then
        return
    end
    _____5B9E_4F8B["已经过时间"] = _____5B9E_4F8B["已经过时间"] + _____5012_8BA1_65F6_5468_671F_79D2
    if _____5B9E_4F8B["已经过时间"] >= _____5B9E_4F8B["持续时间"] then
        _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B(_____5B9E_4F8B.ID, true)
    end
end
function _____9A71_52A8_5355_4F4D_5012_8BA1_65F6()
    local index = 0
    while index < #_____5012_8BA1_65F6_5B9E_4F8BID_8868 do
        local _____5B9E_4F8BID = _____5012_8BA1_65F6_5B9E_4F8BID_8868[index + 1]
        local _____5B9E_4F8B = _____5012_8BA1_65F6_5B9E_4F8B_8868[_____5B9E_4F8BID]
        if _____5B9E_4F8B ~= nil then
            _____63A8_8FDB_5355_4E2A_5355_4F4D_5012_8BA1_65F6(_____5B9E_4F8B)
        end
        if _____5012_8BA1_65F6_5B9E_4F8BID_8868[index + 1] == _____5B9E_4F8BID then
            index = index + 1
        end
    end
end
function ____on_5355_4F4D_5012_8BA1_65F6_5EF6_8FDF_51FB_6740_539F_5355_4F4D()
    local unit = table.remove(_____5EF6_8FDF_51FB_6740_5355_4F4D_961F_5217, 1)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    KillUnit(unit)
end
--- 单位倒计时系统 - 核心逻辑
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_1.EC_CreateEffect
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
YDUserDataSet = ____require_result_2.YDUserDataSet
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
_____521B_5EFA_53EC_5524_7269 = ____require_result_3["创建召唤物"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_4.debugLogForce
local GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitPaused = jass.IsUnitPaused
IsUnitType = jass.IsUnitType
KillUnit = jass.KillUnit
DestroyEffect = jass.DestroyEffect
local R2I = jass.R2I
local DzBindEffect = japi.DzBindEffect
DzUnbindEffect = japi.DzUnbindEffect
local DzGetColor = japi.DzGetColor
local DzSetEffectVertexColor = japi.DzSetEffectVertexColor
DzSetEffectVisible = japi.DzSetEffectVisible
DzSetEffectScale = japi.DzSetEffectScale
local EXSetEffectSize = japi.EXSetEffectSize
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
_____6A21_5757_540D = "单位倒计时"
local _____5012_8BA1_65F6_7279_6548_6A21_578B = "resource\\models\\Common\\Progressbar.mdx"
local _____5012_8BA1_65F6_7279_6548_7ED1_5B9A_70B9 = "overhead"
_____5012_8BA1_65F6_5468_671F_79D2 = 0.01
local _____9ED8_8BA4_7279_6548Z = 250
local _____9ED8_8BA4_7279_6548_671D_5411 = 270
local _____9ED8_8BA4_7279_6548_7F29_653E = 1
local _____9ED8_8BA4_7279_6548_901F_5EA6 = 1
_____5F3A_53162_6548_679CID = 2
_____5F3A_5316_53EC_5524_7F29_653E = 2
_____539F_5355_4F4D_5EF6_8FDF_51FB_6740_6BEB_79D2 = 100
local _____5012_8BA1_65F6_7279_6548_5EF6_8FDF_9500_6BC1_6BEB_79D2 = 10
local _____4E0B_4E00_4E2A_5355_4F4D_5012_8BA1_65F6ID = 0
_____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 = false
_____5012_8BA1_65F6_5B9E_4F8B_8868 = {}
_____5012_8BA1_65F6_5B9E_4F8BID_8868 = {}
_____5355_4F4D_5230_5012_8BA1_65F6ID_8868 = {}
_____5EF6_8FDF_51FB_6740_5355_4F4D_961F_5217 = {}
local function _____786E_4FDD_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(_____9A71_52A8_5355_4F4D_5012_8BA1_65F6)
end
_____5F85_5EF6_8FDF_9500_6BC1_7279_6548_961F_5217 = {}
local function _____9650_5236_5230_989C_8272_5B57_8282(value)
    if value <= 0 then
        return 0
    end
    if value >= 255 then
        return 255
    end
    return R2I(value)
end
local function _____8BBE_7F6E_5012_8BA1_65F6_7279_6548_989C_8272(effect, _____53C2_6570)
    if effect == nil or effect == 0 then
        return
    end
    local color = DzGetColor(
        _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["红"]),
        _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["绿"]),
        _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["蓝"]),
        _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["透明度"])
    )
    DzSetEffectVertexColor(effect, color)
end
____exports["启动单位倒计时核心"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548(_____53C2_6570["单位"]) then
        return 0
    end
    if not (_____53C2_6570["持续时间"] > 0) then
        return 0
    end
    local unitHid = GetHandleId(_____53C2_6570["单位"])
    local oldId = _____5355_4F4D_5230_5012_8BA1_65F6ID_8868[unitHid]
    if oldId ~= nil and oldId ~= 0 then
        _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B(oldId, false)
    end
    local effect = EC_CreateEffect(
        _____5012_8BA1_65F6_7279_6548_6A21_578B,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____9ED8_8BA4_7279_6548Z,
        _____9ED8_8BA4_7279_6548_671D_5411,
        _____9ED8_8BA4_7279_6548_7F29_653E,
        _____9ED8_8BA4_7279_6548_901F_5EA6,
        -1
    )
    if effect ~= nil and effect ~= 0 then
        _____8BBE_7F6E_5012_8BA1_65F6_7279_6548_989C_8272(effect, _____53C2_6570)
        DzBindEffect(_____53C2_6570["单位"], _____5012_8BA1_65F6_7279_6548_7ED1_5B9A_70B9, effect)
    end
    _____4E0B_4E00_4E2A_5355_4F4D_5012_8BA1_65F6ID = _____4E0B_4E00_4E2A_5355_4F4D_5012_8BA1_65F6ID + 1
    local id = _____4E0B_4E00_4E2A_5355_4F4D_5012_8BA1_65F6ID
    _____5012_8BA1_65F6_5B9E_4F8B_8868[id] = {
        ID = id,
        ["单位"] = _____53C2_6570["单位"],
        ["单位句柄ID"] = unitHid,
        ["持续时间"] = _____53C2_6570["持续时间"],
        ["已经过时间"] = 0,
        ["到期效果ID"] = _____53C2_6570["到期效果ID"],
        ["倒计时特效"] = effect,
        ["红"] = _____53C2_6570["红"],
        ["绿"] = _____53C2_6570["绿"],
        ["蓝"] = _____53C2_6570["蓝"],
        ["透明度"] = _____53C2_6570["透明度"],
        ["强化持续时间"] = _____53C2_6570["强化持续时间"],
        ["强化生命值"] = _____53C2_6570["强化生命值"],
        ["强化模型"] = _____53C2_6570["强化模型"],
        ["强化单位类型"] = _____53C2_6570["强化单位类型"]
    }
    _____5355_4F4D_5230_5012_8BA1_65F6ID_8868[unitHid] = id
    _____5012_8BA1_65F6_5B9E_4F8BID_8868[#_____5012_8BA1_65F6_5B9E_4F8BID_8868 + 1] = id
    _____786E_4FDD_4E2D_5FC3_8BA1_65F6_5668()
    return id
end
____exports["取消单位倒计时"] = function(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local id = _____5355_4F4D_5230_5012_8BA1_65F6ID_8868[GetHandleId(unit)]
    if id ~= nil and id ~= 0 then
        _____7ED3_675F_5355_4F4D_5012_8BA1_65F6_5B9E_4F8B(id, false)
    end
end
return ____exports
