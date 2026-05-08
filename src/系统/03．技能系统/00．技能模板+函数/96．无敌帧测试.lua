--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index")
local _____5F00_59CB_65E0_654C_5E27 = ____index["开始无敌帧"]
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local _____6A21_5757_540D = "无敌帧测试"
local _____6D4B_8BD5_5F00_5173 = true
local _____6D4B_8BD5_547D_4EE4 = "112"
local _____6D4B_8BD5_6301_7EED_65F6_95F4 = 3
local _____5DF2_6CE8_518C = false
local function _____6267_884C_65E0_654C_5E27_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(nil, _____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    _____5F00_59CB_65E0_654C_5E27(_____5927_6CD5_5E08, _____6D4B_8BD5_6301_7EED_65F6_95F4)
    debugLogForce(
        nil,
        _____6A21_5757_540D,
        "已对 gg_unit_Hamg_0002 施加无敌",
        "持续秒数=",
        _____6D4B_8BD5_6301_7EED_65F6_95F4
    )
end
local function ____on_804A_5929112_6D4B_8BD5()
    _____6267_884C_65E0_654C_5E27_6D4B_8BD5()
end
local function _____6CE8_518C_804A_5929112_6D4B_8BD5()
    if not _____6D4B_8BD5_5F00_5173 or _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_5929112_6D4B_8BD5)
    debugLogForce(
        nil,
        _____6A21_5757_540D,
        "已注册聊天测试",
        "输入",
        _____6D4B_8BD5_547D_4EE4,
        "对 gg_unit_Hamg_0002 施加 3 秒无敌"
    )
end
_____6CE8_518C_804A_5929112_6D4B_8BD5()
return ____exports
