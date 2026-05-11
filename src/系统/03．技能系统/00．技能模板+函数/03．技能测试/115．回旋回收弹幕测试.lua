--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.03．回旋回收.index")
local _____521B_5EFA_56DE_65CB_56DE_6536_5F39_5E55 = ____index["创建回旋回收弹幕"]
--- 回旋回收弹幕测试
-- 
-- 输入 "1015"：
-- - 从 gg_unit_Hamg_0002 面向方向发射回旋弹幕。
-- - 去程和回程分别造成伤害，最终回调打印结束。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "回旋回收弹幕测试"
local _____6D4B_8BD5_547D_4EE4 = "1015"
local _____5DF2_6CE8_518C = false
local function _____56DE_65CB_56DE_6536__7ED3_675F()
    debugLogForce(_____6A21_5757_540D, "回旋回收弹幕完整结束")
end
local function ____on_804A_59291015_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____521B_5EFA_56DE_65CB_56DE_6536_5F39_5E55({
        ["施法者"] = _____5927_6CD5_5E08,
        ["距离"] = 850,
        ["速度"] = 620,
        ["曲线偏移"] = 260,
        ["命中半径"] = 110,
        ["去程伤害"] = 40,
        ["回程伤害"] = 65,
        ["去程每单位最大命中次数"] = 1,
        ["回程每单位最大命中次数"] = 1,
        ["回程锁定施法者"] = true,
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["on结束"] = _____56DE_65CB_56DE_6536__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已发射回旋回收弹幕",
        "起点=(",
        GetUnitX(_____5927_6CD5_5E08),
        ",",
        GetUnitY(_____5927_6CD5_5E08),
        ")"
    )
end
local function _____6CE8_518C_804A_59291015_6D4B_8BD5()
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
    TriggerAddAction(trig, ____on_804A_59291015_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "发射回旋回收弹幕")
end
_____6CE8_518C_804A_59291015_6D4B_8BD5()
return ____exports
