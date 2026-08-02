local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4DID, _____5C1D_8BD5_6CE8_9500Tick, _____79FB_9664_5B9E_4F8B, _____7ED3_675F_5B9E_4F8B, ____on_7EBF_6027_5347_964DTick, offTick10ms, _____6D3B_52A8_7EBF_6027_5347_964D_5217_8868, _____7EBF_6027_5347_964D_6620_5C04, _____5355_4F4D_5F53_524D_7EBF_6027_5347_964D, _____5DF2_6CE8_518CTick, ____tick_8BA1_6570
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local TICK_INTERVAL = ____00_FF0E_5171_4EAB.TICK_INTERVAL
local CENTER_TIMER_TICKS = ____00_FF0E_5171_4EAB.CENTER_TIMER_TICKS
local GetHandleId = ____00_FF0E_5171_4EAB.GetHandleId
local GetUnitFlyHeight = ____00_FF0E_5171_4EAB.GetUnitFlyHeight
local SetUnitFlyHeight = ____00_FF0E_5171_4EAB.SetUnitFlyHeight
local _____6DFB_52A0_5355_4F4D_6682_505C = ____00_FF0E_5171_4EAB["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____00_FF0E_5171_4EAB["移除单位暂停"]
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____00_FF0E_5171_4EAB["确保单位可设置飞行高度"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____9650_5236_8FDB_5EA6 = ____00_FF0E_5171_4EAB["限制进度"]
function _____53D6_5355_4F4DID(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetHandleId(_____5355_4F4D) or 0 or 0
end
function _____5C1D_8BD5_6CE8_9500Tick()
    if not _____5DF2_6CE8_518CTick or #_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868 ~= 0 then
        return
    end
    _____5DF2_6CE8_518CTick = false
    ____tick_8BA1_6570 = 0
    offTick10ms(____on_7EBF_6027_5347_964DTick)
end
function _____79FB_9664_5B9E_4F8B(_____5B9E_4F8B)
    __TS__Delete(_____7EBF_6027_5347_964D_6620_5C04, _____5B9E_4F8B.id)
    if _____5355_4F4D_5F53_524D_7EBF_6027_5347_964D[_____5B9E_4F8B["单位ID"]] == _____5B9E_4F8B.id then
        __TS__Delete(_____5355_4F4D_5F53_524D_7EBF_6027_5347_964D, _____5B9E_4F8B["单位ID"])
    end
    local lastIndex = #_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868 - 1
    if _____5B9E_4F8B.listIndex ~= lastIndex then
        local last = _____6D3B_52A8_7EBF_6027_5347_964D_5217_8868[lastIndex + 1]
        _____6D3B_52A8_7EBF_6027_5347_964D_5217_8868[_____5B9E_4F8B.listIndex + 1] = last
        last.listIndex = _____5B9E_4F8B.listIndex
    end
    table.remove(_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868)
    _____5C1D_8BD5_6CE8_9500Tick()
end
function _____7ED3_675F_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____7EBF_6027_5347_964D_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    if _____539F_56E0 == "完成" and _____5B9E_4F8B["单位"] ~= nil and _____5B9E_4F8B["单位"] ~= 0 then
        SetUnitFlyHeight(_____5B9E_4F8B["单位"], _____5B9E_4F8B["目标高度"], 0)
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____79FB_9664_5355_4F4D_6682_505C(_____5B9E_4F8B["单位"], _____5B9E_4F8B["暂停来源"])
    end
    local callback = _____5B9E_4F8B["结束回调"]
    _____79FB_9664_5B9E_4F8B(_____5B9E_4F8B)
    if callback ~= nil then
        callback(_____5B9E_4F8B["单位"], _____539F_56E0, _____5B9E_4F8B.id)
    end
end
function ____on_7EBF_6027_5347_964DTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local _____672CTick_5B9E_4F8BID = {}
    do
        local i = 0
        while i < #_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868 do
            _____672CTick_5B9E_4F8BID[#_____672CTick_5B9E_4F8BID + 1] = _____6D3B_52A8_7EBF_6027_5347_964D_5217_8868[i + 1].id
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____672CTick_5B9E_4F8BID do
            do
                local _____5B9E_4F8B = _____7EBF_6027_5347_964D_6620_5C04[_____672CTick_5B9E_4F8BID[i + 1]]
                if _____5B9E_4F8B == nil then
                    goto __continue21
                end
                if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                    _____7ED3_675F_5B9E_4F8B(_____5B9E_4F8B, "死亡")
                    goto __continue21
                end
                if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                    _____7ED3_675F_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
                    goto __continue21
                end
                _____5B9E_4F8B["已运行时间"] = _____5B9E_4F8B["已运行时间"] + TICK_INTERVAL
                local progress = _____9650_5236_8FDB_5EA6(_____5B9E_4F8B["已运行时间"] / _____5B9E_4F8B["持续时间"])
                SetUnitFlyHeight(_____5B9E_4F8B["单位"], _____5B9E_4F8B["起始高度"] + (_____5B9E_4F8B["目标高度"] - _____5B9E_4F8B["起始高度"]) * progress, 0)
                if progress >= 1 then
                    _____7ED3_675F_5B9E_4F8B(_____5B9E_4F8B, "完成")
                    goto __continue21
                end
            end
            ::__continue21::
            i = i + 1
        end
    end
end
____exports["停止线性升降"] = function(id, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____5B9E_4F8B = _____7EBF_6027_5347_964D_6620_5C04[id]
    if _____5B9E_4F8B == nil then
        return false
    end
    _____7ED3_675F_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
____exports["停止单位线性升降"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local id = _____5355_4F4D_5F53_524D_7EBF_6027_5347_964D[_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
    local ____temp_1
    if id > 0 then
        ____temp_1 = ____exports["停止线性升降"](id, _____539F_56E0)
    else
        ____temp_1 = false
    end
    return ____temp_1
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868 = {}
_____7EBF_6027_5347_964D_6620_5C04 = {}
_____5355_4F4D_5F53_524D_7EBF_6027_5347_964D = {}
local _____4E0B_4E00_4E2A_7EBF_6027_5347_964DID = 0
_____5DF2_6CE8_518CTick = false
____tick_8BA1_6570 = 0
local function _____5206_914D_7EBF_6027_5347_964DID()
    _____4E0B_4E00_4E2A_7EBF_6027_5347_964DID = _____4E0B_4E00_4E2A_7EBF_6027_5347_964DID + 1
    return _____4E0B_4E00_4E2A_7EBF_6027_5347_964DID
end
local function _____6CE8_518CTick()
    if _____5DF2_6CE8_518CTick then
        return
    end
    _____5DF2_6CE8_518CTick = true
    onTick10ms(____on_7EBF_6027_5347_964DTick)
end
____exports["开始线性升降"] = function(_____5355_4F4D, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or _____53C2_6570["持续时间"] <= 0 then
        return 0
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return 0
    end
    ____exports["停止单位线性升降"](_____5355_4F4D, "中断")
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
    local id = _____5206_914D_7EBF_6027_5347_964DID()
    local _____8D77_59CB_9AD8_5EA6 = GetUnitFlyHeight(_____5355_4F4D)
    local _____5B9E_4F8B = {
        id = id,
        listIndex = #_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["主单位"] = _____53C2_6570["主单位"],
        ["主单位死亡时中断"] = _____53C2_6570["主单位死亡时中断"] ~= false,
        ["持续时间"] = _____53C2_6570["持续时间"],
        ["已运行时间"] = 0,
        ["起始高度"] = _____8D77_59CB_9AD8_5EA6,
        ["目标高度"] = _____8D77_59CB_9AD8_5EA6 + _____53C2_6570["高度变化"],
        ["暂停单位"] = _____53C2_6570["暂停单位"] == true,
        ["暂停来源"] = "线性升降系统:" .. tostring(id),
        ["结束回调"] = _____53C2_6570["结束回调"]
    }
    _____7EBF_6027_5347_964D_6620_5C04[id] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_7EBF_6027_5347_964D[_____5355_4F4DID] = id
    _____6D3B_52A8_7EBF_6027_5347_964D_5217_8868[#_____6D3B_52A8_7EBF_6027_5347_964D_5217_8868 + 1] = _____5B9E_4F8B
    if _____5B9E_4F8B["暂停单位"] then
        _____6DFB_52A0_5355_4F4D_6682_505C(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    _____6CE8_518CTick()
    return id
end
____exports["单位是否正在线性升降"] = function(_____5355_4F4D)
    local id = _____5355_4F4D_5F53_524D_7EBF_6027_5347_964D[_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
    return id > 0 and _____7EBF_6027_5347_964D_6620_5C04[id] ~= nil
end
return ____exports
