--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.09．表现系统.08．吟唱条.03．吟唱条核心")
local _____6838_5FC3_542F_52A8_541F_5531_6761 = ____require_result_0["启动吟唱条"]
local _____6838_5FC3_5173_95ED_541F_5531_6761 = ____require_result_0["关闭吟唱条"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____5E38_91CF = require("系统.09．表现系统.08．吟唱条.00．常量定义")
local function _____89C4_8303_5316_53C2_6570(self, _____8F93_5165)
    if _____8F93_5165 == nil then
        _____8F93_5165 = {}
    end
    local _____603B_65F6_957F = _____8F93_5165["总时长"]
    if _____603B_65F6_957F == nil or _____603B_65F6_957F == 0 then
        _____603B_65F6_957F = _____8F93_5165.sj
    end
    if _____603B_65F6_957F == nil or _____603B_65F6_957F == 0 then
        _____603B_65F6_957F = _____8F93_5165.time
    end
    local _____989C_8272ID = _____8F93_5165["颜色ID"]
    if _____989C_8272ID == nil or _____989C_8272ID == 0 then
        _____989C_8272ID = _____8F93_5165["颜色"]
    end
    if _____989C_8272ID == nil or _____989C_8272ID == 0 then
        _____989C_8272ID = _____5E38_91CF["默认颜色ID"]
    end
    local _____6807_9898_6587_672C = _____8F93_5165["标题文本"]
    if _____6807_9898_6587_672C == nil or _____6807_9898_6587_672C == "" then
        _____6807_9898_6587_672C = _____8F93_5165["标题"]
    end
    if _____6807_9898_6587_672C == nil or _____6807_9898_6587_672C == "" then
        _____6807_9898_6587_672C = _____5E38_91CF["默认标题文本"]
    end
    local _____63D0_793A_6587_672C = _____8F93_5165["提示文本"]
    if _____63D0_793A_6587_672C == nil or _____63D0_793A_6587_672C == "" then
        _____63D0_793A_6587_672C = _____8F93_5165["文本"]
    end
    if _____63D0_793A_6587_672C == nil or _____63D0_793A_6587_672C == "" then
        _____63D0_793A_6587_672C = _____8F93_5165.string
    end
    if _____63D0_793A_6587_672C == nil or _____63D0_793A_6587_672C == "" then
        _____63D0_793A_6587_672C = _____5E38_91CF["默认提示文本"]
    end
    return {["总时长"] = _____603B_65F6_957F or 0, ["颜色ID"] = _____989C_8272ID, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C}
end
____exports["显示吟唱条"] = function(self, _____7B2C_4E00_53C2_6570, _____7B2C_4E8C_53C2_6570)
    local _____8F93_5165 = _____7B2C_4E8C_53C2_6570
    if _____8F93_5165 == nil then
        _____8F93_5165 = _____7B2C_4E00_53C2_6570
    end
    if _____8F93_5165 == nil then
        _____8F93_5165 = self
    end
    if _____8F93_5165 == nil then
        _____8F93_5165 = {}
    end
    local ____debugLogForce_13 = debugLogForce
    local ____opt_result_4
    if self ~= nil then
        ____opt_result_4 = self["总时长"]
    end
    local ____opt_result_7
    if _____7B2C_4E00_53C2_6570 ~= nil then
        ____opt_result_7 = _____7B2C_4E00_53C2_6570["总时长"]
    end
    local ____opt_result_10
    if _____7B2C_4E00_53C2_6570 ~= nil then
        ____opt_result_10 = _____7B2C_4E00_53C2_6570.sj
    end
    ____debugLogForce_13(
        "吟唱条对外接口",
        "收到显示请求",
        "self总时长=",
        ____opt_result_4,
        "第一参数总时长=",
        ____opt_result_7,
        "第一参数sj=",
        ____opt_result_10,
        "第二参数总时长=",
        _____7B2C_4E8C_53C2_6570 and _____7B2C_4E8C_53C2_6570["总时长"]
    )
    local _____53C2_6570 = _____89C4_8303_5316_53C2_6570(nil, _____8F93_5165)
    debugLogForce(
        "吟唱条对外接口",
        "规范化后",
        "总时长=",
        _____53C2_6570["总时长"],
        "颜色ID=",
        _____53C2_6570["颜色ID"],
        "提示=",
        _____53C2_6570["提示文本"]
    )
    _____6838_5FC3_542F_52A8_541F_5531_6761(_____53C2_6570)
end
____exports["关闭吟唱条"] = function(self, ______7B2C_4E00_53C2_6570)
    _____6838_5FC3_5173_95ED_541F_5531_6761()
end
return ____exports
