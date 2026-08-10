--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local function _____53D6_7269_54C1ID(_____88C5_5907_540D)
    return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D))
end
____exports["采集配置列表"] = {{
    ["装备名"] = "荧光草",
    ["物品ID"] = _____53D6_7269_54C1ID("荧光草"),
    ["刷新区域名称"] = "荧光草.刷新区域",
    ["刷新延迟秒"] = 15
}}
return ____exports
