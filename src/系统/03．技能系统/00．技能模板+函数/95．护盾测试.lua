--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index")
local _____5F00_59CB_62A4_76FE = ____index["开始护盾"]
local _____67E5_8BE2_5355_4F4D_603B_62A4_76FE_503C = ____index["查询单位总护盾值"]
local _____62A4_76FE_7C7B_578B = ____index["护盾类型"]
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
local _____6A21_5757_540D = "护盾测试"
local _____6D4B_8BD5_547D_4EE4 = "1001"
local _____5DF2_6CE8_518C = false
local function ____on_804A_59291001_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____5F00_59CB_62A4_76FE(_____5927_6CD5_5E08, {["类型"] = _____62A4_76FE_7C7B_578B["物理"], ["数值"] = 100, ["持续时间"] = 3, ["显示护盾条"] = false})
    _____5F00_59CB_62A4_76FE(_____5927_6CD5_5E08, {["类型"] = _____62A4_76FE_7C7B_578B["通用"], ["数值"] = 200, ["持续时间"] = 30, ["显示护盾条"] = true})
    local _____603B_62A4_76FE = _____67E5_8BE2_5355_4F4D_603B_62A4_76FE_503C(_____5927_6CD5_5E08)
    debugLogForce(_____6A21_5757_540D, "当前总护盾值:", _____603B_62A4_76FE)
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
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
    TriggerAddAction(trig, ____on_804A_59291001_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "添加100通用+100物理护盾")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
