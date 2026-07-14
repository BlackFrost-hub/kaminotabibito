local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____5185_90E8_79FB_9664_8DF3_8DC3, offTick10ms, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local CENTER_TIMER_TICKS = ____00_FF0E_5171_4EAB.CENTER_TIMER_TICKS
local DEFAULT_JUMP_EFFECT_MODEL = ____00_FF0E_5171_4EAB.DEFAULT_JUMP_EFFECT_MODEL
local X_GAFC = ____00_FF0E_5171_4EAB.X_GAFC
local _____6DFB_52A0_5355_4F4D_6682_505C = ____00_FF0E_5171_4EAB["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____00_FF0E_5171_4EAB["移除单位暂停"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["单位是否存在其他暂停占用"]
local _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____00_FF0E_5171_4EAB["零秒后重置单位动画"]
local _____6D3B_52A8_8DF3_8DC3_5217_8868 = ____00_FF0E_5171_4EAB["活动跳跃列表"]
local _____8DF3_8DC3_6620_5C04 = ____00_FF0E_5171_4EAB["跳跃映射"]
local _____5355_4F4D_5F53_524D_8DF3_8DC3 = ____00_FF0E_5171_4EAB["单位当前跳跃"]
local _____5206_914D_65B0_8DF3_8DC3ID = ____00_FF0E_5171_4EAB["分配新跳跃ID"]
local _____53D6_53E5_67C4ID = ____00_FF0E_5171_4EAB["取句柄ID"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____8BA1_7B97_6BCFtick_4F4D_79FB = ____00_FF0E_5171_4EAB["计算每tick位移"]
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____00_FF0E_5171_4EAB["确保单位可设置飞行高度"]
local _____5355_4F4D_5DF2_88AB_6682_505C = ____00_FF0E_5171_4EAB["单位已被暂停"]
local GetUnitX = ____00_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____00_FF0E_5171_4EAB.GetUnitY
local GetUnitFlyHeight = ____00_FF0E_5171_4EAB.GetUnitFlyHeight
local SetUnitFlyHeight = ____00_FF0E_5171_4EAB.SetUnitFlyHeight
local ____01_FF0E_79FB_52A8_4E0E_78B0_649E = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.01．移动与碰撞")
local _____63A8_8FDB_4E00_6B65 = ____01_FF0E_79FB_52A8_4E0E_78B0_649E["推进一步"]
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____exports["on跳跃系统Tick"])
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
____exports["结束跳跃实例"] = function(_____5B9E_4F8B, _____539F_56E0)
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
        _____79FB_9664_5355_4F4D_6682_505C(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    if _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and _____539F_56E0 ~= "死亡" and _____539F_56E0 ~= "主单位死亡" then
        _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B(_____5355_4F4D)
    end
    _____5185_90E8_79FB_9664_8DF3_8DC3(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
    end
end
____exports["on跳跃系统Tick"] = function()
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
                goto __continue23
            end
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                ____exports["结束跳跃实例"](_____5B9E_4F8B, "死亡")
                goto __continue23
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                ____exports["结束跳跃实例"](_____5B9E_4F8B, "主单位死亡")
                goto __continue23
            end
            if _____5355_4F4D_5DF2_88AB_6682_505C(_____5B9E_4F8B["单位"]) then
                if not _____5B9E_4F8B["暂停单位"] or _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(_____5B9E_4F8B["单位"], _____5B9E_4F8B["暂停来源"]) then
                    i = i + 1
                    goto __continue23
                end
            end
            local _____7ED3_679C = _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
            if _____7ED3_679C["停止"] then
                ____exports["结束跳跃实例"](_____5B9E_4F8B, _____7ED3_679C["原因"] or "完成")
                goto __continue23
            end
            i = i + 1
        end
        ::__continue23::
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____exports["on跳跃系统Tick"])
end
____exports["结束跳跃ID"] = function(_____8DF3_8DC3ID, _____539F_56E0)
    local _____5B9E_4F8B = _____8DF3_8DC3_6620_5C04[_____8DF3_8DC3ID]
    if not _____5B9E_4F8B then
        return false
    end
    ____exports["结束跳跃实例"](_____5B9E_4F8B, _____539F_56E0)
    return true
end
____exports["停止单位跳跃"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____8DF3_8DC3ID = _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    if not _____8DF3_8DC3ID then
        return false
    end
    return ____exports["结束跳跃ID"](_____8DF3_8DC3ID, _____539F_56E0)
end
____exports["解析跳跃角度"] = function(_____5355_4F4D, _____53C2_6570)
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
____exports["创建跳跃实例"] = function(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
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
    local _____8DF3_8DC3ID = _____5206_914D_65B0_8DF3_8DC3ID()
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
        _____6DFB_52A0_5355_4F4D_6682_505C(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if type(_____53C2_6570["开始回调"]) == "function" then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____8DF3_8DC3ID)
    end
    return _____8DF3_8DC3ID
end
return ____exports
