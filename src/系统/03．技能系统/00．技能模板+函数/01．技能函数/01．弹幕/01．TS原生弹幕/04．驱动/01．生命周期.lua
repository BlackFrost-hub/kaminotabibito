--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____68C0_67E5_751F_547D_5468_671F_7ED3_675F, _____66F4_65B0_5355_4E2A_5F39_5E55, _____539F_751F_5F39_5E55Tick, _____5982_679C_7A7A_5219_505C_6B62_9A71_52A8, offTick10ms, _____9A71_52A8_5DF2_6CE8_518C
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local DestroyEffect = ____01_FF0E_5171_4EAB.DestroyEffect
local RemoveUnit = ____01_FF0E_5171_4EAB.RemoveUnit
local _____53D6_53E5_67C4ID = ____01_FF0E_5171_4EAB["取句柄ID"]
local _____5F39_5E55Tick_95F4_9694 = ____01_FF0E_5171_4EAB["弹幕Tick间隔"]
local ____02_FF0E_6CE8_518C_8868 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．注册表")
local _____539F_751F_5F39_5E55ID_5217_8868 = ____02_FF0E_6CE8_518C_8868["原生弹幕ID列表"]
local _____539F_751F_5F39_5E55_5B9E_4F8B_8868 = ____02_FF0E_6CE8_518C_8868["原生弹幕实例表"]
local _____79FB_9664_539F_751F_5F39_5E55_5B9E_4F8B = ____02_FF0E_6CE8_518C_8868["移除原生弹幕实例"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．事件.index")
local _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6 = ____index["触发原生弹幕STES事件"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．命中.index")
local _____5904_7406_5F39_5E55_547D_4E2D = ____index["处理弹幕命中"]
local ____00_FF0E_79FB_52A8_5904_7406 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.04．驱动.00．移动处理")
local _____5F39_5E55_5355_4F4D_5B58_6D3B = ____00_FF0E_79FB_52A8_5904_7406["弹幕单位存活"]
local _____63A8_8FDB_5F39_5E55_79FB_52A8 = ____00_FF0E_79FB_52A8_5904_7406["推进弹幕移动"]
____exports["结束原生弹幕实例"] = function(_____5B9E_4F8B, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "手动销毁"
    end
    if _____5B9E_4F8B["已结束"] then
        return
    end
    _____5B9E_4F8B["已结束"] = true
    if _____5B9E_4F8B["附加特效1"] ~= nil and _____5B9E_4F8B["附加特效1"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["附加特效1"])
    end
    if _____5B9E_4F8B["附加特效2"] ~= nil and _____5B9E_4F8B["附加特效2"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["附加特效2"])
    end
    _____5B9E_4F8B["附加特效1"] = nil
    _____5B9E_4F8B["附加特效2"] = nil
    local _____56DE_8C03 = _____5B9E_4F8B["参数"]["on结束"]
    if _____56DE_8C03 ~= nil then
        _____56DE_8C03(_____539F_56E0, _____5B9E_4F8B.id)
    end
    local _____5230_8FBE_56DE_8C03 = _____5B9E_4F8B["参数"]["on到达目标点"]
    if _____5230_8FBE_56DE_8C03 ~= nil and (_____539F_56E0 == "完成" or _____539F_56E0 == "距离结束") then
        _____5230_8FBE_56DE_8C03(_____5B9E_4F8B.id, _____539F_56E0)
    end
    local ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_3 = _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6
    local ____opt_1 = _____5B9E_4F8B["参数"].STES
    ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_3(____opt_1 and ____opt_1["结束事件名"], _____5B9E_4F8B, {["结束原因"] = _____539F_56E0})
    if _____5B9E_4F8B["参数"]["死亡时移除单位"] ~= false and _____5B9E_4F8B["弹幕单位"] ~= nil and _____5B9E_4F8B["弹幕单位"] ~= 0 then
        RemoveUnit(_____5B9E_4F8B["弹幕单位"])
    end
    _____79FB_9664_539F_751F_5F39_5E55_5B9E_4F8B(
        _____5B9E_4F8B.id,
        _____53D6_53E5_67C4ID(_____5B9E_4F8B["弹幕单位"])
    )
    _____5982_679C_7A7A_5219_505C_6B62_9A71_52A8()
end
function _____68C0_67E5_751F_547D_5468_671F_7ED3_675F(_____5B9E_4F8B)
    if not _____5F39_5E55_5355_4F4D_5B58_6D3B(_____5B9E_4F8B["弹幕单位"]) then
        return "单位死亡"
    end
    local _____751F_547D_5468_671F = _____5B9E_4F8B["参数"]["生命周期"] or 0
    if _____751F_547D_5468_671F > 0 and _____5B9E_4F8B["已运行时间"] >= _____751F_547D_5468_671F then
        return "生命周期结束"
    end
    local _____6700_5927_8DDD_79BB = _____5B9E_4F8B["参数"]["最大距离"] or 0
    if _____6700_5927_8DDD_79BB > 0 and _____5B9E_4F8B["已飞行距离"] >= _____6700_5927_8DDD_79BB then
        return "距离结束"
    end
    return nil
end
function _____66F4_65B0_5355_4E2A_5F39_5E55(_____5B9E_4F8B)
    _____5B9E_4F8B["已运行时间"] = _____5B9E_4F8B["已运行时间"] + _____5F39_5E55Tick_95F4_9694
    if not _____5F39_5E55_5355_4F4D_5B58_6D3B(_____5B9E_4F8B["弹幕单位"]) then
        ____exports["结束原生弹幕实例"](_____5B9E_4F8B, "单位死亡")
        return
    end
    local _____79FB_52A8_5B8C_6210 = _____63A8_8FDB_5F39_5E55_79FB_52A8(_____5B9E_4F8B, _____5F39_5E55Tick_95F4_9694)
    if _____5904_7406_5F39_5E55_547D_4E2D(_____5B9E_4F8B) then
        ____exports["结束原生弹幕实例"](_____5B9E_4F8B, "命中消失")
        return
    end
    if _____79FB_52A8_5B8C_6210 then
        ____exports["结束原生弹幕实例"](_____5B9E_4F8B, "完成")
        return
    end
    local _____751F_547D_5468_671F_539F_56E0 = _____68C0_67E5_751F_547D_5468_671F_7ED3_675F(_____5B9E_4F8B)
    if _____751F_547D_5468_671F_539F_56E0 ~= nil then
        ____exports["结束原生弹幕实例"](_____5B9E_4F8B, _____751F_547D_5468_671F_539F_56E0)
    end
end
function _____539F_751F_5F39_5E55Tick(self)
    local i = 0
    while i < #_____539F_751F_5F39_5E55ID_5217_8868 do
        local id = _____539F_751F_5F39_5E55ID_5217_8868[i + 1]
        local _____5B9E_4F8B = _____539F_751F_5F39_5E55_5B9E_4F8B_8868[id]
        if _____5B9E_4F8B ~= nil and not _____5B9E_4F8B["已结束"] then
            _____66F4_65B0_5355_4E2A_5F39_5E55(_____5B9E_4F8B)
        end
        if _____539F_751F_5F39_5E55ID_5217_8868[i + 1] == id then
            i = i + 1
        end
    end
    _____5982_679C_7A7A_5219_505C_6B62_9A71_52A8()
end
function _____5982_679C_7A7A_5219_505C_6B62_9A71_52A8()
    if _____9A71_52A8_5DF2_6CE8_518C and #_____539F_751F_5F39_5E55ID_5217_8868 <= 0 then
        offTick10ms(_____539F_751F_5F39_5E55Tick)
        _____9A71_52A8_5DF2_6CE8_518C = false
    end
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
_____9A71_52A8_5DF2_6CE8_518C = false
____exports["确保原生弹幕驱动"] = function()
    if _____9A71_52A8_5DF2_6CE8_518C then
        return
    end
    onTick10ms(_____539F_751F_5F39_5E55Tick)
    _____9A71_52A8_5DF2_6CE8_518C = true
end
return ____exports
