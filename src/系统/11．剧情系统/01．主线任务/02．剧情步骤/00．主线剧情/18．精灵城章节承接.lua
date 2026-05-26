--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local CreateQuestBJ = ____require_result_1.CreateQuestBJ
local GetLastCreatedQuestBJ = ____require_result_1.GetLastCreatedQuestBJ
do
    local ____18_FF0E_7CBE_7075_57CE_7AE0_8282_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.18．精灵城章节承接")
    ____exports["精灵城章节承接剧情片段"] = ____18_FF0E_7CBE_7075_57CE_7AE0_8282_627F_63A5["精灵城章节承接剧情片段"]
end
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Player = jass.Player
local QuestSetCompleted = jass.QuestSetCompleted
local SetUnitOwner = jass.SetUnitOwner
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
    local _____957F_8001 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.精灵村长老")
    if _____957F_8001 ~= nil and _____957F_8001 ~= 0 then
        EC_CreateEffect(
            "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
            GetUnitX(_____957F_8001),
            GetUnitY(_____957F_8001),
            0,
            270,
            2,
            1,
            1.5
        )
    end
    local _____963B_6321 = jglobals.gg_dest_B00X_0013
    if _____963B_6321 ~= nil and _____963B_6321 ~= 0 then
        ShowDestructable(_____963B_6321, false)
    end
    local _____901A_884C_5355_4F4D = jglobals.gg_unit_n025_0033
    if _____901A_884C_5355_4F4D ~= nil and _____901A_884C_5355_4F4D ~= 0 then
        SetUnitOwner(
            _____901A_884C_5355_4F4D,
            Player(6),
            true
        )
    end
end
local function _____6267_884C_524D_5F80_738B_57CE()
    _____786E_4FDD_7B2C_4E8C_5E55_4E3B_7EBF_4EFB_52A1_5DF2_521B_5EFA()
end
____exports["精灵城章节承接剧情动作注册表"] = {["JLC精灵城_章节承接"] = ____exports["执行精灵城章节承接"], ["JLC精灵城_前往王城"] = _____6267_884C_524D_5F80_738B_57CE}
return ____exports
