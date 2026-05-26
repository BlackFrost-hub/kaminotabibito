--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
do
    local ____32_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_8FC7_7A0B = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.32．第二章王子Boss战过程")
    ____exports["第二章王子Boss战过程剧情片段"] = ____32_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_8FC7_7A0B["第二章王子Boss战过程剧情片段"]
end
____exports["执行第二章王子Boss战前置"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
end
____exports["第二章王子Boss战过程剧情动作注册表"] = {["JLC精灵城_第二章王子Boss战前置"] = ____exports["执行第二章王子Boss战前置"]}
return ____exports
