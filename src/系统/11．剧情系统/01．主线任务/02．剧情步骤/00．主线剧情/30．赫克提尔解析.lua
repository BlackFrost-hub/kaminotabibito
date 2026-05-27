--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local jglobals = require("jass.globals")
do
    local ____30_FF0E_8D6B_514B_63D0_5C14_89E3_6790 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.30．赫克提尔解析")
    ____exports["赫克提尔解析信件剧情片段"] = ____30_FF0E_8D6B_514B_63D0_5C14_89E3_6790["赫克提尔解析信件剧情片段"]
end
local bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING
____exports["执行赫克提尔解析信件"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
end
____exports["执行敌袭紧急传讯警告"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_1 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__6587_672C_0 = _____53C2_6570["文本"]
    if ____53C2_6570__6587_672C_0 == nil then
        ____53C2_6570__6587_672C_0 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_1({
        ["消息类型"] = bj_QUESTMESSAGE_WARNING,
        ["文本"] = tostring(____53C2_6570__6587_672C_0)
    })
end
____exports["赫克提尔解析剧情动作注册表"] = {["JLC精灵城_赫克提尔解析信件"] = ____exports["执行赫克提尔解析信件"], ["JLC精灵城_敌袭紧急传讯警告"] = ____exports["执行敌袭紧急传讯警告"]}
return ____exports
