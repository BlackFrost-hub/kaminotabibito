--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
do
    local ____31_FF0E_738B_57CE_7D27_6025_4F1A_8BAE = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.31．王城紧急会议")
    ____exports["王城紧急会议剧情片段"] = ____31_FF0E_738B_57CE_7D27_6025_4F1A_8BAE["王城紧急会议剧情片段"]
end
____exports["执行紧急会议"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
end
____exports["王城紧急会议剧情动作注册表"] = {["JLC精灵城_紧急会议"] = ____exports["执行紧急会议"]}
return ____exports
