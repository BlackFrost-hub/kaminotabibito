--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
local ____02_FF0E_4E3B_7EBF_5267_60C5_5165_53E3_521D_59CB_5316 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.02．主线剧情入口初始化")
local _____52A8_6001_521B_5EFA_5E76_6CE8_518C_4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3 = ____02_FF0E_4E3B_7EBF_5267_60C5_5165_53E3_521D_59CB_5316["动态创建并注册主线剧情全局单位入口"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local CreateQuestBJ = ____require_result_1.CreateQuestBJ
local GetLastCreatedQuestBJ = ____require_result_1.GetLastCreatedQuestBJ
do
    local ____18_FF0E_7CBE_7075_57CE_7AE0_8282_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.18．精灵城章节承接")
    ____exports["精灵城章节承接剧情片段"] = ____18_FF0E_7CBE_7075_57CE_7AE0_8282_627F_63A5["精灵城章节承接剧情片段"]
end
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local QuestSetCompleted = jass.QuestSetCompleted
local ShowDestructable = jass.ShowDestructable
local bj_QUESTTYPE_REQ_DISCOVERED = jglobals.bj_QUESTTYPE_REQ_DISCOVERED
local function _____786E_4FDD_7B2C_4E8C_5E55_4E3B_7EBF_4EFB_52A1_5DF2_521B_5EFA()
    local _____4E3B_7EBF_4EFB_52A1_6570_7EC4 = jglobals.udg_ZX
    if _____4E3B_7EBF_4EFB_52A1_6570_7EC4 == nil then
        return
    end
    local _____7B2C_4E00_5E55_4EFB_52A1 = _____4E3B_7EBF_4EFB_52A1_6570_7EC4[1]
    if _____7B2C_4E00_5E55_4EFB_52A1 ~= nil and _____7B2C_4E00_5E55_4EFB_52A1 ~= 0 then
        QuestSetCompleted(_____7B2C_4E00_5E55_4EFB_52A1, true)
    end
    if _____4E3B_7EBF_4EFB_52A1_6570_7EC4[2] ~= nil and _____4E3B_7EBF_4EFB_52A1_6570_7EC4[2] ~= 0 then
        return
    end
    CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED, "第二幕：旧怨与战火", "", "ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
    _____4E3B_7EBF_4EFB_52A1_6570_7EC4[2] = GetLastCreatedQuestBJ()
end
____exports["执行精灵城章节承接"] = function()
    _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(false, false)
end
local function _____6267_884C_7CBE_7075_57CE_7AE0_8282_627F_63A5_6F14_51FA(_____53C2_6570)
    local _____957F_8001 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.精灵村长老")
    if _____957F_8001 ~= nil and _____957F_8001 ~= 0 then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
            X = GetUnitX(_____957F_8001),
            Y = GetUnitY(_____957F_8001),
            ["面向角度"] = 270,
            ["缩放"] = 2,
            ["动画速度"] = 1,
            ["持续秒"] = 1.5
        })
    end
    local _____963B_6321_540D = type(_____53C2_6570["隐藏阻挡"]) == "string" and _____53C2_6570["隐藏阻挡"] or "gg_dest_B00X_0013"
    local _____963B_6321 = jglobals[_____963B_6321_540D]
    if _____963B_6321 ~= nil and _____963B_6321 ~= 0 then
        ShowDestructable(_____963B_6321, false)
    end
end
local function _____6267_884C_524D_5F80_738B_57CE()
    local _____901A_884C_5355_4F4D = _____52A8_6001_521B_5EFA_5E76_6CE8_518C_4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3("精灵森谷传送抵达")
    _____786E_4FDD_7B2C_4E8C_5E55_4E3B_7EBF_4EFB_52A1_5DF2_521B_5EFA()
end
____exports["精灵城章节承接剧情动作注册表"] = {["JLC精灵城_章节承接"] = ____exports["执行精灵城章节承接"], ["JLC精灵城_章节承接演出"] = _____6267_884C_7CBE_7075_57CE_7AE0_8282_627F_63A5_6F14_51FA, ["JLC精灵城_前往王城"] = _____6267_884C_524D_5F80_738B_57CE}
return ____exports
