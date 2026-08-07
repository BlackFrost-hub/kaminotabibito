--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包")
local _____79FB_9664_73A9_5BB6_4E3B_526F_80CC_5305_7269_54C1 = ____require_result_1["移除玩家主副背包物品"]
do
    local ____30_FF0E_8D6B_514B_63D0_5C14_89E3_6790 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.30．赫克提尔解析")
    ____exports["赫克提尔解析信件剧情片段"] = ____30_FF0E_8D6B_514B_63D0_5C14_89E3_6790["赫克提尔解析信件剧情片段"]
end
local bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING
local _____6B8B_7F3A_9B54_6CD5_4FE1_4EF6_7269_54C1ID = stringToFourCCSafe("I0ES")
____exports["执行赫克提尔解析信件"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not (_____6B8B_7F3A_9B54_6CD5_4FE1_4EF6_7269_54C1ID > 0) then
        return
    end
    _____79FB_9664_73A9_5BB6_4E3B_526F_80CC_5305_7269_54C1(_____89E6_53D1_5355_4F4D, _____6B8B_7F3A_9B54_6CD5_4FE1_4EF6_7269_54C1ID)
end
____exports["执行敌袭紧急传讯警告"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_3 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__6587_672C_2 = _____53C2_6570["文本"]
    if ____53C2_6570__6587_672C_2 == nil then
        ____53C2_6570__6587_672C_2 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_3({
        ["消息类型"] = bj_QUESTMESSAGE_WARNING,
        ["文本"] = tostring(____53C2_6570__6587_672C_2)
    })
end
____exports["赫克提尔解析剧情动作注册表"] = {["JLC精灵城_赫克提尔解析信件"] = ____exports["执行赫克提尔解析信件"], ["JLC精灵城_敌袭紧急传讯警告"] = ____exports["执行敌袭紧急传讯警告"]}
return ____exports
