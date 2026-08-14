--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_2["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local jass = require("jass.common")
local SetUnitAnimation = jass.SetUnitAnimation
local function _____663E_793ABoss_65BD_6CD5_541F_5531_6761(_____914D_7F6E, _____65BD_6CD5_79D2)
    local _____53C2_6570 = {
        ["通道"] = _____914D_7F6E["通道"],
        ["总时长"] = _____65BD_6CD5_79D2,
        ["颜色ID"] = _____914D_7F6E["颜色ID"],
        ["标题文本"] = _____914D_7F6E["标题文本"],
        ["提示文本"] = _____914D_7F6E["提示文本"]
    }
    if _____914D_7F6E["类型"] == "大招" then
        _____663E_793A_5927_62DB_541F_5531_6761(_____53C2_6570)
    else
        _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761(_____53C2_6570)
    end
end
local function ____onBoss_65BD_6CD5_65F6_95F4_7EBF_5230_65F6(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil then
        return
    end
    local _____53C2_6570 = _____72B6_6001["参数"]
    if _____53C2_6570["吟唱条"] ~= nil then
        _____5173_95ED_541F_5531_6761(_____53C2_6570["吟唱条"]["通道"])
    end
    if _____53C2_6570["生效回调"] ~= nil then
        _____53C2_6570["生效回调"](_____53C2_6570["单位"], _____53C2_6570["生效变量"])
    end
end
local function ____onBoss_65BD_6CD5_65F6_95F4_7EBF_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["参数"]["吟唱条"] == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____72B6_6001["参数"]["吟唱条"]["通道"])
end
--- 统一 Boss 的硬直、动作、吟唱条与延迟生效时间线。
-- 技能自身的目标选择、伤害和机制清理由调用方的具名回调继续持有。
____exports["执行Boss施法时间线"] = function(_____53C2_6570)
    local ____temp_4 = _____53C2_6570["单位"] == nil or _____53C2_6570["单位"] == 0 or not (_____53C2_6570["施法秒"] >= 0)
    if not ____temp_4 then
        local ____self_3 = _____53C2_6570["清理"]
        ____temp_4 = ____self_3["已清理"](____self_3)
    end
    if ____temp_4 then
        return false
    end
    local _____72B6_6001 = {["参数"] = _____53C2_6570}
    _____5F00_59CB_786C_76F4(_____53C2_6570["单位"], _____53C2_6570["施法秒"])
    if _____53C2_6570["动作名"] ~= nil and _____53C2_6570["动作名"] ~= "" then
        SetUnitAnimation(_____53C2_6570["单位"], _____53C2_6570["动作名"])
    end
    if _____53C2_6570["开始回调"] ~= nil then
        _____53C2_6570["开始回调"](_____53C2_6570["单位"], _____53C2_6570["开始变量"])
    end
    if _____53C2_6570["吟唱条"] ~= nil then
        _____663E_793ABoss_65BD_6CD5_541F_5531_6761(_____53C2_6570["吟唱条"], _____53C2_6570["施法秒"])
    end
    local ____self_5 = _____53C2_6570["清理"]
    ____self_5["登记清理"](____self_5, _____53C2_6570["延迟登记名"] or _____53C2_6570["名称"] .. "-施法时间线", ____onBoss_65BD_6CD5_65F6_95F4_7EBF_6E05_7406, _____72B6_6001)
    local _____56DE_8C03ID = addDelayedCallback(_____53C2_6570["施法秒"] * 1000, ____onBoss_65BD_6CD5_65F6_95F4_7EBF_5230_65F6, _____72B6_6001)
    local ____self_6 = _____53C2_6570["清理"]
    ____self_6["登记延迟回调"](____self_6, _____53C2_6570["延迟登记名"] or _____53C2_6570["名称"] .. "-施法时间线", _____56DE_8C03ID)
    return true
end
return ____exports
