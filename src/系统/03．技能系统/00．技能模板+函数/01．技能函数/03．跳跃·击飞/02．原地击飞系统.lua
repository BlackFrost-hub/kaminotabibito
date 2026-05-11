local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4DID, _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____521B_5EFA_811A_4E0B_7279_6548, _____5185_90E8_79FB_9664_539F_5730_51FB_98DE, _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B, _____66F4_65B0_539F_5730_51FB_98DE_9AD8_5EA6, _____66F4_65B0_6301_7EED_7279_6548, ____on_539F_5730_51FB_98DE_7CFB_7EDFTick, offTick10ms, _____6D3B_52A8_539F_5730_51FB_98DE_5217_8868, _____539F_5730_51FB_98DE_6620_5C04, _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local CENTER_TIMER_TICKS = ____00_FF0E_5171_4EAB.CENTER_TIMER_TICKS
local TICK_INTERVAL = ____00_FF0E_5171_4EAB.TICK_INTERVAL
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["申请单位暂停占用"]
local _____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["释放单位暂停占用"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["单位是否存在其他暂停占用"]
local _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____00_FF0E_5171_4EAB["零秒后重置单位动画"]
local GetHandleId = ____00_FF0E_5171_4EAB.GetHandleId
local GetRandomReal = ____00_FF0E_5171_4EAB.GetRandomReal
local AddSpecialEffect = ____00_FF0E_5171_4EAB.AddSpecialEffect
local DestroyEffect = ____00_FF0E_5171_4EAB.DestroyEffect
local GetUnitX = ____00_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____00_FF0E_5171_4EAB.GetUnitY
local GetUnitFlyHeight = ____00_FF0E_5171_4EAB.GetUnitFlyHeight
local SetUnitFlyHeight = ____00_FF0E_5171_4EAB.SetUnitFlyHeight
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____00_FF0E_5171_4EAB["确保单位可设置飞行高度"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____5355_4F4D_5DF2_88AB_6682_505C = ____00_FF0E_5171_4EAB["单位已被暂停"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____505C_6B62_5355_4F4D_8DF3_8DC3 = ____03_FF0E_5BF9_5916_63A5_53E3["停止单位跳跃"]
function _____53D6_5355_4F4DID(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetHandleId(_____5355_4F4D) or 0 or 0
end
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_539F_5730_51FB_98DE_7CFB_7EDFTick)
end
function _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868 ~= 0 then
        return
    end
    ____tick_8BA1_6570 = 0
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
function _____521B_5EFA_811A_4E0B_7279_6548(_____5355_4F4D, _____6A21_578B)
    if _____6A21_578B == "" then
        return
    end
    local _____7279_6548 = AddSpecialEffect(
        _____6A21_578B,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        DestroyEffect(_____7279_6548)
    end
end
function _____5185_90E8_79FB_9664_539F_5730_51FB_98DE(_____5B9E_4F8B)
    local _____51FB_98DEID = _____5B9E_4F8B.id
    local _____5355_4F4DID = _____5B9E_4F8B["单位ID"]
    __TS__Delete(_____539F_5730_51FB_98DE_6620_5C04, _____51FB_98DEID)
    if _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE[_____5355_4F4DID] == _____51FB_98DEID then
        __TS__Delete(_____5355_4F4D_5F53_524D_539F_5730_51FB_98DE, _____5355_4F4DID)
    end
    local idx = _____5B9E_4F8B.listIndex
    local lastIdx = #_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868 - 1
    if idx ~= lastIdx then
        local last = _____6D3B_52A8_539F_5730_51FB_98DE_5217_8868[lastIdx + 1]
        _____6D3B_52A8_539F_5730_51FB_98DE_5217_8868[idx + 1] = last
        last.listIndex = idx
    end
    table.remove(_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868)
    _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____539F_5730_51FB_98DE_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____51FB_98DEID = _____5B9E_4F8B.id
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
    _____5185_90E8_79FB_9664_539F_5730_51FB_98DE(_____5B9E_4F8B)
    if _____7ED3_675F_56DE_8C03 ~= nil then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____51FB_98DEID)
    end
end
function _____66F4_65B0_539F_5730_51FB_98DE_9AD8_5EA6(_____5B9E_4F8B)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____5355_4F4D)
    local _____65B0_9644_52A0_9AD8_5EA6 = GetRandomReal(_____5B9E_4F8B["最小高度"], _____5B9E_4F8B["最大高度"])
    SetUnitFlyHeight(_____5355_4F4D, _____5F53_524D_9AD8_5EA6 - _____5B9E_4F8B["上次附加高度"] + _____65B0_9644_52A0_9AD8_5EA6, 0)
    _____5B9E_4F8B["上次附加高度"] = _____65B0_9644_52A0_9AD8_5EA6
end
function _____66F4_65B0_6301_7EED_7279_6548(_____5B9E_4F8B)
    if _____5B9E_4F8B["持续特效模型"] == "" then
        return
    end
    _____5B9E_4F8B["持续特效计时"] = _____5B9E_4F8B["持续特效计时"] + TICK_INTERVAL
    if _____5B9E_4F8B["持续特效计时"] < _____5B9E_4F8B["持续特效间隔"] then
        return
    end
    _____5B9E_4F8B["持续特效计时"] = 0
    _____521B_5EFA_811A_4E0B_7279_6548(_____5B9E_4F8B["单位"], _____5B9E_4F8B["持续特效模型"])
end
function ____on_539F_5730_51FB_98DE_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_539F_5730_51FB_98DE_5217_8868[i + 1]
            if _____539F_5730_51FB_98DE_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                i = i + 1
                goto __continue33
            end
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B(_____5B9E_4F8B, "死亡")
                goto __continue33
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
                goto __continue33
            end
            if _____5355_4F4D_5DF2_88AB_6682_505C(_____5B9E_4F8B["单位"]) then
                if not _____5B9E_4F8B["暂停单位"] or _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(_____5B9E_4F8B["单位"], _____5B9E_4F8B["暂停来源"]) then
                    i = i + 1
                    goto __continue33
                end
            end
            _____5B9E_4F8B["已运行时间"] = _____5B9E_4F8B["已运行时间"] + TICK_INTERVAL
            _____66F4_65B0_539F_5730_51FB_98DE_9AD8_5EA6(_____5B9E_4F8B)
            _____66F4_65B0_6301_7EED_7279_6548(_____5B9E_4F8B)
            if _____5B9E_4F8B["已运行时间"] >= _____5B9E_4F8B["持续时间"] then
                _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B(_____5B9E_4F8B, "完成")
                goto __continue33
            end
            i = i + 1
        end
        ::__continue33::
    end
end
____exports["停止原地击飞"] = function(_____51FB_98DEID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____5B9E_4F8B = _____539F_5730_51FB_98DE_6620_5C04[_____51FB_98DEID]
    if _____5B9E_4F8B == nil then
        return false
    end
    _____7ED3_675F_539F_5730_51FB_98DE_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    return true
end
____exports["停止单位原地击飞"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____51FB_98DEID = _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE[_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
    if _____51FB_98DEID <= 0 then
        return false
    end
    return ____exports["停止原地击飞"](_____51FB_98DEID, _____539F_56E0)
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local _____9ED8_8BA4_51B2_51FB_6CE2_6A21_578B = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868 = {}
_____539F_5730_51FB_98DE_6620_5C04 = {}
_____5355_4F4D_5F53_524D_539F_5730_51FB_98DE = {}
local _____4E0B_4E00_4E2A_539F_5730_51FB_98DEID = 0
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____5206_914D_539F_5730_51FB_98DEID()
    _____4E0B_4E00_4E2A_539F_5730_51FB_98DEID = _____4E0B_4E00_4E2A_539F_5730_51FB_98DEID + 1
    return _____4E0B_4E00_4E2A_539F_5730_51FB_98DEID
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_539F_5730_51FB_98DE_7CFB_7EDFTick)
end
local function _____89E3_6790_9AD8_5EA6_533A_95F4(_____53C2_6570)
    local _____6700_5C0F_9AD8_5EA6 = _____53C2_6570["最小高度"] or 200
    local _____6700_5927_9AD8_5EA6 = _____53C2_6570["最大高度"] or 250
    if _____6700_5927_9AD8_5EA6 < _____6700_5C0F_9AD8_5EA6 then
        local oldMin = _____6700_5C0F_9AD8_5EA6
        _____6700_5C0F_9AD8_5EA6 = _____6700_5927_9AD8_5EA6
        _____6700_5927_9AD8_5EA6 = oldMin
    end
    return {["最小高度"] = _____6700_5C0F_9AD8_5EA6, ["最大高度"] = _____6700_5927_9AD8_5EA6}
end
local function _____64AD_653E_51B2_51FB_6CE2(_____5355_4F4D, _____6A21_578B)
    local _____6700_7EC8_6A21_578B = _____6A21_578B == nil and _____9ED8_8BA4_51B2_51FB_6CE2_6A21_578B or _____6A21_578B
    if _____6700_7EC8_6A21_578B == "" then
        return
    end
    local _____7279_6548 = AddSpecialEffect(
        _____6700_7EC8_6A21_578B,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        DestroyEffect(_____7279_6548)
    end
end
____exports["开始原地击飞"] = function(_____5355_4F4D, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return 0
    end
    if _____53C2_6570["持续时间"] == nil or _____53C2_6570["持续时间"] <= 0 then
        return 0
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return 0
    end
    ____exports["停止单位原地击飞"](_____5355_4F4D, "中断")
    if _____53C2_6570["中断已有跳跃"] ~= false then
        _____505C_6B62_5355_4F4D_8DF3_8DC3(_____5355_4F4D, "中断")
    end
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
    local _____51FB_98DEID = _____5206_914D_539F_5730_51FB_98DEID()
    local _____9AD8_5EA6_533A_95F4 = _____89E3_6790_9AD8_5EA6_533A_95F4(_____53C2_6570)
    local _____5B9E_4F8B = {
        id = _____51FB_98DEID,
        listIndex = #_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868,
        ["单位"] = _____5355_4F4D,
        ["单位ID"] = _____5355_4F4DID,
        ["主单位"] = _____53C2_6570["主单位"],
        ["主单位死亡时中断"] = _____53C2_6570["主单位死亡时中断"] ~= false,
        ["持续时间"] = _____53C2_6570["持续时间"],
        ["已运行时间"] = 0,
        ["最小高度"] = _____9AD8_5EA6_533A_95F4["最小高度"],
        ["最大高度"] = _____9AD8_5EA6_533A_95F4["最大高度"],
        ["上次附加高度"] = 0,
        ["持续特效模型"] = _____53C2_6570["持续特效模型"] or "",
        ["持续特效间隔"] = _____53C2_6570["持续特效间隔"] ~= nil and _____53C2_6570["持续特效间隔"] > 0 and _____53C2_6570["持续特效间隔"] or 0.08,
        ["持续特效计时"] = 0,
        ["暂停单位"] = _____53C2_6570["暂停单位"] ~= false,
        ["暂停来源"] = "原地击飞系统:" .. tostring(_____51FB_98DEID),
        ["结束回调"] = _____53C2_6570["结束回调"]
    }
    _____539F_5730_51FB_98DE_6620_5C04[_____51FB_98DEID] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE[_____5355_4F4DID] = _____51FB_98DEID
    _____6D3B_52A8_539F_5730_51FB_98DE_5217_8868[#_____6D3B_52A8_539F_5730_51FB_98DE_5217_8868 + 1] = _____5B9E_4F8B
    if _____5B9E_4F8B["暂停单位"] then
        _____7533_8BF7_5355_4F4D_6682_505C_5360_7528(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    _____64AD_653E_51B2_51FB_6CE2(_____5355_4F4D, _____53C2_6570["冲击波模型"])
    if _____5B9E_4F8B["持续特效模型"] ~= "" then
        _____521B_5EFA_811A_4E0B_7279_6548(_____5355_4F4D, _____5B9E_4F8B["持续特效模型"])
    end
    _____66F4_65B0_539F_5730_51FB_98DE_9AD8_5EA6(_____5B9E_4F8B)
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____53C2_6570["开始回调"] ~= nil then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____51FB_98DEID)
    end
    return _____51FB_98DEID
end
____exports["单位是否正在原地击飞"] = function(_____5355_4F4D)
    local _____51FB_98DEID = _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE[_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
    return _____51FB_98DEID > 0 and _____539F_5730_51FB_98DE_6620_5C04[_____51FB_98DEID] ~= nil
end
____exports["获取单位当前原地击飞ID"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_539F_5730_51FB_98DE[_____53D6_5355_4F4DID(_____5355_4F4D)] or 0
end
return ____exports
