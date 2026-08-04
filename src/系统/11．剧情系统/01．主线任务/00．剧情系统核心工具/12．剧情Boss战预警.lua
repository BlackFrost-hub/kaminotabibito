--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_0.GetPlayersAll
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_1.QuestMessageBJ
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
--- 从该进度起，Boss 预置完成后提前向全队发出战前提示。
local _____4E3B_7EBFBoss_6218_524D_63D0_793A_6700_4F4E_8FDB_5EA6 = 22
local _____5DF2_53D1_5E03_4E3B_7EBFBoss_6218_524D_63D0_793A = {}
____exports["发布主线Boss战前提示"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() < _____4E3B_7EBFBoss_6218_524D_63D0_793A_6700_4F4E_8FDB_5EA6 then
        return
    end
    local handleId = GetHandleId(bossUnit)
    if not (handleId > 0) or _____5DF2_53D1_5E03_4E3B_7EBFBoss_6218_524D_63D0_793A[handleId] == true then
        return
    end
    _____5DF2_53D1_5E03_4E3B_7EBFBoss_6218_524D_63D0_793A[handleId] = true
    local bossName = GetUnitName(bossUnit) or "未知Boss"
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_ALWAYSHINT,
        ("|cffffff00『系统消息』：|r|cffff0000接下来将挑战 Boss：" .. bossName) .. "，请做好战斗准备。|r"
    )
end
return ____exports
