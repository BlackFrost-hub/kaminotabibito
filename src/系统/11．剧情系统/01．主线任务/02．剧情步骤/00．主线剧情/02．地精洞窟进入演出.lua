--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicModeBJ = ____require_result_1.CinematicModeBJ
local CinematicFilterGenericBJ = ____require_result_1.CinematicFilterGenericBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_2.GetPlayersAll
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_3.TriggerRegisterEnterRectSimple
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local IsUnitInGroup = jass.IsUnitInGroup
local SetTimeOfDay = jass.SetTimeOfDay
local TriggerAddAction = jass.TriggerAddAction
local _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 = false
local _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA = false
local function _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    return _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 and IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4)
end
local function ____on_5730_7CBE_6D1E_7A9F_8FDB_5165_89E6_53D1()
    if _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 1 then
        return
    end
    local _____7247_6BB5ID = "jlc_goblin_cave_intro"
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "地精洞窟进入演出核心", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "地精洞窟进入演出核心", ["触发单位"] = _____89E6_53D1_5355_4F4D}) then
        _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA = true
    end
end
____exports["执行地精洞窟演出前置"] = function(_____53C2_6570)
    SetTimeOfDay(0)
    CinematicModeBJ(
        true,
        GetPlayersAll()
    )
    CinematicFilterGenericBJ(
        2,
        1,
        "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
        50,
        50,
        50,
        50,
        0,
        0,
        0,
        0
    )
end
____exports["地精洞窟进入演出剧情动作注册表"] = {["JLC精灵村_地精洞窟演出前置"] = ____exports["执行地精洞窟演出前置"]}
____exports["初始化进度02_地精洞窟进入演出核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 = true
    local rect = jglobals.gg_rct______________020
    if rect == nil or rect == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterEnterRectSimple(trigger, rect)
    TriggerAddAction(trigger, ____on_5730_7CBE_6D1E_7A9F_8FDB_5165_89E6_53D1)
end
return ____exports
