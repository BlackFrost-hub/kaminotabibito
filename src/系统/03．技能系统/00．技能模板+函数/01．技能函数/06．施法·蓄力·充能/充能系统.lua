local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____83B7_53D6_5730_5F62_9AD8_5EA6, _____8BA1_7B97_5145_80FD_8FDB_5EA6, _____64AD_653E_5355_4F4D_5750_6807_7279_6548, _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668, _____89E6_53D1_5145_80FD_6253_65AD_56DE_8C03, _____7ED3_675F_5145_80FD_5B9E_4F8B, ____on_5145_80FD_7CFB_7EDFTick, jass, offTick10ms, YDWETimerDestroyEffect, _____79FB_9664_5355_4F4D_6682_505C, GetUnitTypeId, GetUnitState, IsUnitType, GetUnitX, GetUnitY, GetUnitFlyHeight, AddSpecialEffect, Location, MoveLocation, GetLocationZ, EXSetEffectZ, TICK_INTERVAL, CENTER_TIMER_TICKS, UNIT_ALIVE_LIFE, _____6D3B_52A8_5145_80FD_5217_8868, _____5145_80FD_6620_5C04, _____5355_4F4D_5F53_524D_5145_80FD, _____5145_80FD_6253_65AD_56DE_8C03_5217_8868, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570, _____5730_5F62_91C7_6837_70B9
local _____8FDB_5EA6_6761_7279_6548 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效")
local _____521B_5EFA_8FDB_5EA6_6761_7279_6548 = _____8FDB_5EA6_6761_7279_6548["创建进度条特效"]
local _____9500_6BC1_5355_4F4D_8FDB_5EA6_6761_7279_6548 = _____8FDB_5EA6_6761_7279_6548["销毁单位进度条特效"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["单位是否处于硬控制效果合集"]
function _____5355_4F4D_5B58_6D3B(u)
    if u == nil or u == 0 then
        return false
    end
    if GetUnitTypeId(u) == 0 then
        return false
    end
    if IsUnitType(u, jass.UNIT_TYPE_DEAD) then
        return false
    end
    return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____83B7_53D6_5730_5F62_9AD8_5EA6(x, y)
    if _____5730_5F62_91C7_6837_70B9 == nil then
        _____5730_5F62_91C7_6837_70B9 = Location(x, y)
    else
        MoveLocation(_____5730_5F62_91C7_6837_70B9, x, y)
    end
    return GetLocationZ(_____5730_5F62_91C7_6837_70B9) or 0
end
function _____8BA1_7B97_5145_80FD_8FDB_5EA6(_____5B9E_4F8B)
    if _____5B9E_4F8B["总持续时间"] <= 0 then
        return 0
    end
    local _____5DF2_8FDB_884C_65F6_95F4 = _____5B9E_4F8B["总持续时间"] - _____5B9E_4F8B["剩余时间"]
    local _____767E_5206_6BD4 = _____5DF2_8FDB_884C_65F6_95F4 / _____5B9E_4F8B["总持续时间"]
    if _____767E_5206_6BD4 <= 0 then
        return 0
    end
    if _____767E_5206_6BD4 >= 1 then
        return 1
    end
    return _____767E_5206_6BD4
end
function _____64AD_653E_5355_4F4D_5750_6807_7279_6548(_____5355_4F4D, _____6A21_578B, _____751F_547D_5468_671F)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or _____6A21_578B == nil or _____6A21_578B == "" then
        return
    end
    local x = GetUnitX(_____5355_4F4D)
    local y = GetUnitY(_____5355_4F4D)
    local effect = AddSpecialEffect(_____6A21_578B, x, y)
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(
            effect,
            _____83B7_53D6_5730_5F62_9AD8_5EA6(x, y) + GetUnitFlyHeight(_____5355_4F4D)
        )
    end
    YDWETimerDestroyEffect(nil, _____751F_547D_5468_671F, effect)
end
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_5145_80FD_7CFB_7EDFTick)
end
function _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_5145_80FD_5217_8868 > 0 then
        return
    end
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
function _____89E6_53D1_5145_80FD_6253_65AD_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____5145_80FDID)
    for ____, _____56DE_8C03 in ipairs(_____5145_80FD_6253_65AD_56DE_8C03_5217_8868) do
        _____56DE_8C03(_____5355_4F4D, _____539F_56E0, _____5145_80FDID)
    end
end
function _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    __TS__Delete(_____5145_80FD_6620_5C04, _____5B9E_4F8B.id)
    if _____5355_4F4D_5F53_524D_5145_80FD[_____5B9E_4F8B["单位ID"]] == _____5B9E_4F8B.id then
        __TS__Delete(_____5355_4F4D_5F53_524D_5145_80FD, _____5B9E_4F8B["单位ID"])
    end
    local index = __TS__ArrayIndexOf(_____6D3B_52A8_5145_80FD_5217_8868, _____5B9E_4F8B)
    if index >= 0 then
        __TS__ArraySplice(_____6D3B_52A8_5145_80FD_5217_8868, index, 1)
    end
    if _____5B9E_4F8B["显示进度条特效"] then
        _____9500_6BC1_5355_4F4D_8FDB_5EA6_6761_7279_6548(_____5B9E_4F8B["单位"])
    end
    if _____5B9E_4F8B["强制硬直"] and _____5B9E_4F8B["强制硬直来源"] ~= nil then
        _____79FB_9664_5355_4F4D_6682_505C(_____5B9E_4F8B["单位"], _____5B9E_4F8B["强制硬直来源"])
    end
    if _____539F_56E0 == "完成" and _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
        _____64AD_653E_5355_4F4D_5750_6807_7279_6548(_____5B9E_4F8B["单位"], _____5B9E_4F8B["完成特效"], _____5B9E_4F8B["完成特效生命周期"])
        if type(_____5B9E_4F8B["充能完成回调"]) == "function" then
            _____5B9E_4F8B["充能完成回调"](_____5B9E_4F8B["单位"], _____5B9E_4F8B.id)
        end
    end
    if type(_____5B9E_4F8B["结束回调"]) == "function" then
        _____5B9E_4F8B["结束回调"](_____5B9E_4F8B["单位"], _____539F_56E0, _____5B9E_4F8B.id)
    end
    if _____539F_56E0 ~= "完成" then
        _____89E6_53D1_5145_80FD_6253_65AD_56DE_8C03(_____5B9E_4F8B["单位"], _____539F_56E0, _____5B9E_4F8B.id)
    end
end
____exports["停止充能"] = function(_____5145_80FDID)
    local _____5B9E_4F8B = _____5145_80FD_6620_5C04[_____5145_80FDID]
    if _____5B9E_4F8B == nil then
        return false
    end
    _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, "中断")
    _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
    return true
end
function ____on_5145_80FD_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_5145_80FD_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_5145_80FD_5217_8868[i + 1]
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, "死亡")
                goto __continue79
            end
            if _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, "中断")
                goto __continue79
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
                goto __continue79
            end
            _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - TICK_INTERVAL
            _____5B9E_4F8B["下次过程特效倒计时"] = _____5B9E_4F8B["下次过程特效倒计时"] - TICK_INTERVAL
            _____5B9E_4F8B["下次周期回调倒计时"] = _____5B9E_4F8B["下次周期回调倒计时"] - TICK_INTERVAL
            if _____5B9E_4F8B["过程特效"] ~= nil and _____5B9E_4F8B["过程特效"] ~= "" and _____5B9E_4F8B["下次过程特效倒计时"] <= 0 then
                _____64AD_653E_5355_4F4D_5750_6807_7279_6548(_____5B9E_4F8B["单位"], _____5B9E_4F8B["过程特效"], _____5B9E_4F8B["过程特效生命周期"])
                _____5B9E_4F8B["下次过程特效倒计时"] = _____5B9E_4F8B["过程特效间隔"]
            end
            if type(_____5B9E_4F8B["周期回调"]) == "function" and _____5B9E_4F8B["下次周期回调倒计时"] <= 0 then
                local _____5DF2_8FDB_884C_65F6_95F4 = _____5B9E_4F8B["总持续时间"] - _____5B9E_4F8B["剩余时间"]
                _____5B9E_4F8B["周期回调"](
                    _____5B9E_4F8B["单位"],
                    _____5B9E_4F8B.id,
                    _____5DF2_8FDB_884C_65F6_95F4,
                    _____5B9E_4F8B["剩余时间"],
                    _____8BA1_7B97_5145_80FD_8FDB_5EA6(_____5B9E_4F8B)
                )
                _____5B9E_4F8B["下次周期回调倒计时"] = _____5B9E_4F8B["周期回调间隔"]
            end
            if _____5B9E_4F8B["剩余时间"] <= 0 then
                _____7ED3_675F_5145_80FD_5B9E_4F8B(_____5B9E_4F8B, "完成")
                goto __continue79
            end
            i = i + 1
        end
        ::__continue79::
    end
    _____5C1D_8BD5_5173_95ED_4E2D_5FC3_8BA1_65F6_5668()
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerImmediateOrderListener = ____require_result_1.registerImmediateOrderListener
local registerPointOrderListener = ____require_result_1.registerPointOrderListener
local registerTargetOrderListener = ____require_result_1.registerTargetOrderListener
local ____require_result_2 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
YDWETimerDestroyEffect = ____require_result_2.YDWETimerDestroyEffect
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local _____8C03_8BD5_6A21_5757_540D = "充能系统"
local GetHandleId = jass.GetHandleId
GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
AddSpecialEffect = jass.AddSpecialEffect
Location = jass.Location
MoveLocation = jass.MoveLocation
GetLocationZ = jass.GetLocationZ
local RemoveLocation = jass.RemoveLocation
EXSetEffectZ = japi.EXSetEffectZ
TICK_INTERVAL = 0.02
CENTER_TIMER_TICKS = 2
UNIT_ALIVE_LIFE = 0.405
local DEFAULT_EFFECT_INTERVAL = 0.1
local DEFAULT_EFFECT_DURATION = 1
_____6D3B_52A8_5145_80FD_5217_8868 = {}
_____5145_80FD_6620_5C04 = {}
_____5355_4F4D_5F53_524D_5145_80FD = {}
_____5145_80FD_6253_65AD_56DE_8C03_5217_8868 = {}
local _____4E0B_4E00_4E2A_5145_80FDID = 1
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
local _____5DF2_6CE8_518C_6307_4EE4_4E2D_65AD_76D1_542C = false
____tick_8BA1_6570 = 0
_____5730_5F62_91C7_6837_70B9 = nil
local function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and GetHandleId(h) or 0
end
local function _____5F52_4E00_5316_65F6_95F4(value, defaultValue)
    if value ~= nil and value > 0 then
        return value
    end
    return defaultValue
end
local function _____8BA1_7B97_8FC7_7A0B_7279_6548_95F4_9694(_____6301_7EED_65F6_95F4, _____53C2_6570)
    local _____64AD_653E_6B21_6570 = _____53C2_6570["过程特效播放次数"]
    if _____64AD_653E_6B21_6570 ~= nil and _____64AD_653E_6B21_6570 > 0 then
        return _____5F52_4E00_5316_65F6_95F4(_____6301_7EED_65F6_95F4 / _____64AD_653E_6B21_6570, DEFAULT_EFFECT_INTERVAL)
    end
    return _____5F52_4E00_5316_65F6_95F4(_____53C2_6570["过程特效间隔"], DEFAULT_EFFECT_INTERVAL)
end
local function _____8BA1_7B97_8FDB_5EA6_6761_52A8_753B_901F_5EA6(_____6301_7EED_65F6_95F4, _____53C2_6570)
    if _____53C2_6570["进度条特效动画速度"] ~= nil and _____53C2_6570["进度条特效动画速度"] > 0 then
        return _____53C2_6570["进度条特效动画速度"]
    end
    if _____6301_7EED_65F6_95F4 > 0 then
        return 1 / _____6301_7EED_65F6_95F4
    end
    return 1
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    ____tick_8BA1_6570 = 0
    onTick10ms(____on_5145_80FD_7CFB_7EDFTick)
end
local function _____5C1D_8BD5_6307_4EE4_4E2D_65AD_5145_80FD(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____5145_80FDID = _____5355_4F4D_5F53_524D_5145_80FD[_____5355_4F4DID]
    if _____5145_80FDID == nil then
        return
    end
    local _____5B9E_4F8B = _____5145_80FD_6620_5C04[_____5145_80FDID]
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["强制硬直"] == true or _____5B9E_4F8B["指令中断"] ~= true then
        return
    end
    ____exports["停止充能"](_____5145_80FDID)
end
local function ____on_5145_80FD_5355_4F4D_7ACB_5373_6307_4EE4(_____5355_4F4D, _orderId)
    _____5C1D_8BD5_6307_4EE4_4E2D_65AD_5145_80FD(_____5355_4F4D)
end
local function ____on_5145_80FD_5355_4F4D_70B9_6307_4EE4(_____5355_4F4D, _orderId, _x, _y)
    _____5C1D_8BD5_6307_4EE4_4E2D_65AD_5145_80FD(_____5355_4F4D)
end
local function ____on_5145_80FD_5355_4F4D_76EE_6807_6307_4EE4(_____5355_4F4D, _orderId, _targetUnit, _targetItem, _targetDestructable)
    _____5C1D_8BD5_6307_4EE4_4E2D_65AD_5145_80FD(_____5355_4F4D)
end
local function _____786E_4FDD_6CE8_518C_6307_4EE4_4E2D_65AD_76D1_542C()
    if _____5DF2_6CE8_518C_6307_4EE4_4E2D_65AD_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_6307_4EE4_4E2D_65AD_76D1_542C = true
    registerImmediateOrderListener(____on_5145_80FD_5355_4F4D_7ACB_5373_6307_4EE4)
    registerPointOrderListener(____on_5145_80FD_5355_4F4D_70B9_6307_4EE4)
    registerTargetOrderListener(____on_5145_80FD_5355_4F4D_76EE_6807_6307_4EE4)
end
____exports["停止单位充能"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____5145_80FDID = _____5355_4F4D_5F53_524D_5145_80FD[_____5355_4F4DID]
    if _____5145_80FDID == nil then
        return false
    end
    return ____exports["停止充能"](_____5145_80FDID)
end
____exports["单位是否正在充能"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    return _____5355_4F4D_5F53_524D_5145_80FD[_____5355_4F4DID] ~= nil
end
____exports["获取单位当前充能ID"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return 0
    end
    return _____5355_4F4D_5F53_524D_5145_80FD[_____5355_4F4DID] or 0
end
____exports["获取活跃充能数量"] = function()
    return #_____6D3B_52A8_5145_80FD_5217_8868
end
____exports["获取充能进度"] = function(_____5145_80FDID)
    local _____5B9E_4F8B = _____5145_80FD_6620_5C04[_____5145_80FDID]
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["总持续时间"] <= 0 then
        return 0
    end
    local _____5DF2_8FDB_884C_65F6_95F4 = _____5B9E_4F8B["总持续时间"] - _____5B9E_4F8B["剩余时间"]
    local _____767E_5206_6BD4 = _____5DF2_8FDB_884C_65F6_95F4 / _____5B9E_4F8B["总持续时间"]
    if _____767E_5206_6BD4 <= 0 then
        return 0
    end
    if _____767E_5206_6BD4 >= 1 then
        return 1
    end
    return _____767E_5206_6BD4
end
____exports["注册充能打断回调"] = function(_____56DE_8C03)
    if _____56DE_8C03 == nil then
        return
    end
    if __TS__ArrayIndexOf(_____5145_80FD_6253_65AD_56DE_8C03_5217_8868, _____56DE_8C03) >= 0 then
        return
    end
    _____5145_80FD_6253_65AD_56DE_8C03_5217_8868[#_____5145_80FD_6253_65AD_56DE_8C03_5217_8868 + 1] = _____56DE_8C03
end
____exports["取消注册充能打断回调"] = function(_____56DE_8C03)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____5145_80FD_6253_65AD_56DE_8C03_5217_8868, _____56DE_8C03)
    if _____7D22_5F15 < 0 then
        return
    end
    __TS__ArraySplice(_____5145_80FD_6253_65AD_56DE_8C03_5217_8868, _____7D22_5F15, 1)
end
____exports["开始充能"] = function(_____5355_4F4D, _____53C2_6570)
    debugLogForce(_____8C03_8BD5_6A21_5757_540D, "开始充能被调用")
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or _____53C2_6570["持续时间"] <= 0 then
        debugLogForce(_____8C03_8BD5_6A21_5757_540D, "单位不存在或持续时间无效")
        return 0
    end
    ____exports["停止单位充能"](_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    local _____6301_7EED_65F6_95F4 = _____53C2_6570["持续时间"]
    local ____4E0B_4E00_4E2A_5145_80FDID_5 = _____4E0B_4E00_4E2A_5145_80FDID
    _____4E0B_4E00_4E2A_5145_80FDID = ____4E0B_4E00_4E2A_5145_80FDID_5 + 1
    local _____5145_80FDID = ____4E0B_4E00_4E2A_5145_80FDID_5
    local _____663E_793A_8FDB_5EA6_6761_7279_6548 = _____53C2_6570["显示进度条特效"] ~= false
    local _____8FC7_7A0B_7279_6548 = _____53C2_6570["过程特效"]
    local _____8FC7_7A0B_7279_6548_751F_547D_5468_671F = _____5F52_4E00_5316_65F6_95F4(_____53C2_6570["过程特效生命周期"], DEFAULT_EFFECT_DURATION)
    local _____5B8C_6210_7279_6548 = _____53C2_6570["完成特效"]
    local _____5B8C_6210_7279_6548_751F_547D_5468_671F = _____5F52_4E00_5316_65F6_95F4(_____53C2_6570["完成特效生命周期"], DEFAULT_EFFECT_DURATION)
    local _____5468_671F_56DE_8C03_95F4_9694 = _____5F52_4E00_5316_65F6_95F4(_____53C2_6570["周期回调间隔"], TICK_INTERVAL)
    local _____5F3A_5236_786C_76F4 = _____53C2_6570["强制硬直"] == true
    local _____5F3A_5236_786C_76F4_6765_6E90 = _____5F3A_5236_786C_76F4 and "充能强制硬直#" .. tostring(_____5145_80FDID) or nil
    local _____65B0_5B9E_4F8B = {
        id = _____5145_80FDID,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["主单位"] = _____53C2_6570["主单位"],
        ["主单位死亡时中断"] = _____53C2_6570["主单位死亡时中断"] ~= false,
        ["指令中断"] = not _____5F3A_5236_786C_76F4 and _____53C2_6570["指令中断"] == true,
        ["强制硬直"] = _____5F3A_5236_786C_76F4,
        ["强制硬直来源"] = _____5F3A_5236_786C_76F4_6765_6E90,
        ["总持续时间"] = _____6301_7EED_65F6_95F4,
        ["剩余时间"] = _____6301_7EED_65F6_95F4,
        ["显示进度条特效"] = _____663E_793A_8FDB_5EA6_6761_7279_6548,
        ["过程特效"] = _____8FC7_7A0B_7279_6548,
        ["过程特效间隔"] = _____8BA1_7B97_8FC7_7A0B_7279_6548_95F4_9694(_____6301_7EED_65F6_95F4, _____53C2_6570),
        ["过程特效生命周期"] = _____8FC7_7A0B_7279_6548_751F_547D_5468_671F,
        ["完成特效"] = _____5B8C_6210_7279_6548,
        ["完成特效生命周期"] = _____5B8C_6210_7279_6548_751F_547D_5468_671F,
        ["下次过程特效倒计时"] = 0,
        ["周期回调"] = _____53C2_6570["周期回调"],
        ["周期回调间隔"] = _____5468_671F_56DE_8C03_95F4_9694,
        ["下次周期回调倒计时"] = 0,
        ["开始回调"] = _____53C2_6570["开始回调"],
        ["充能完成回调"] = _____53C2_6570["充能完成回调"],
        ["结束回调"] = _____53C2_6570["结束回调"]
    }
    _____6D3B_52A8_5145_80FD_5217_8868[#_____6D3B_52A8_5145_80FD_5217_8868 + 1] = _____65B0_5B9E_4F8B
    _____5145_80FD_6620_5C04[_____5145_80FDID] = _____65B0_5B9E_4F8B
    _____5355_4F4D_5F53_524D_5145_80FD[_____5355_4F4DID] = _____5145_80FDID
    if _____5F3A_5236_786C_76F4 and _____5F3A_5236_786C_76F4_6765_6E90 ~= nil then
        _____6DFB_52A0_5355_4F4D_6682_505C(_____5355_4F4D, _____5F3A_5236_786C_76F4_6765_6E90)
    end
    if _____65B0_5B9E_4F8B["指令中断"] then
        _____786E_4FDD_6CE8_518C_6307_4EE4_4E2D_65AD_76D1_542C()
    end
    if _____663E_793A_8FDB_5EA6_6761_7279_6548 then
        _____521B_5EFA_8FDB_5EA6_6761_7279_6548(
            _____5355_4F4D,
            {
                ["高度偏移"] = _____53C2_6570["进度条特效高度偏移"] or 233,
                ["动画序号"] = _____53C2_6570["进度条特效动画序号"] or 0,
                ["动画速度"] = _____8BA1_7B97_8FDB_5EA6_6761_52A8_753B_901F_5EA6(_____6301_7EED_65F6_95F4, _____53C2_6570)
            }
        )
    end
    if type(_____65B0_5B9E_4F8B["开始回调"]) == "function" then
        _____65B0_5B9E_4F8B["开始回调"](_____5355_4F4D, _____5145_80FDID)
    end
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    return _____5145_80FDID
end
local g = _G
if type(g["开始充能"]) ~= "function" then
    g["开始充能"] = ____exports["开始充能"]
end
return ____exports
