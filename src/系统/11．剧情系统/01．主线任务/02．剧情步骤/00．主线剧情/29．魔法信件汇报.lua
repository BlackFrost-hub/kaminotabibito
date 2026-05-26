--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
do
    local ____29_FF0E_9B54_6CD5_4FE1_4EF6_6C47_62A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.29．魔法信件汇报")
    ____exports["魔法信件汇报剧情片段"] = ____29_FF0E_9B54_6CD5_4FE1_4EF6_6C47_62A5["魔法信件汇报剧情片段"]
end
____exports["执行魔法信件汇报"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
end
local function _____6267_884C_524D_5F80_8D6B_514B_63D0_5C14()
end
____exports["魔法信件汇报剧情动作注册表"] = {["JLC精灵城_魔法信件汇报"] = ____exports["执行魔法信件汇报"], ["JLC精灵城_前往赫克提尔"] = _____6267_884C_524D_5F80_8D6B_514B_63D0_5C14}
return ____exports
