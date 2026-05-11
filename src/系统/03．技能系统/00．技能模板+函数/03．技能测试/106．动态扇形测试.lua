--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____52A8_6001_6247_5F62_6D4B_8BD5__5468_671F, _____52A8_6001_6247_5F62_6D4B_8BD5__9500_6BC1, debugLogForce, _____6A21_5757_540D
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.index")
local _____521B_5EFA_52A8_6001_6247_5F62 = ____index["创建动态扇形"]
function _____52A8_6001_6247_5F62_6D4B_8BD5__5468_671F(_____5F53_524D_547D_4E2D_5355_4F4D, _____5F53_524D_534A_5F84, _____4E0A_6B21_534A_5F84)
    if #_____5F53_524D_547D_4E2D_5355_4F4D <= 0 then
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "周期命中：",
        #_____5F53_524D_547D_4E2D_5355_4F4D,
        "个单位，半径=",
        _____4E0A_6B21_534A_5F84,
        "→",
        _____5F53_524D_534A_5F84
    )
end
function _____52A8_6001_6247_5F62_6D4B_8BD5__9500_6BC1()
    debugLogForce(_____6A21_5757_540D, "动态扇形效果已结束")
end
--- 动态扇形测试
-- 
-- 输入"1006"后，以 `gg_unit_Hamg_0002` 当前朝向创建一个动态扇形波前，
-- 每 0.02 秒从近到远扫过一次，对扇形敌人各造成 100 伤害。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
_____6A21_5757_540D = "动态扇形测试"
local _____6D4B_8BD5_547D_4EE4 = "1006"
local _____5DF2_6CE8_518C = false
local function ____on_804A_59291006_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____521B_5EFA_52A8_6001_6247_5F62({
        X = GetUnitX(_____5927_6CD5_5E08),
        Y = GetUnitY(_____5927_6CD5_5E08),
        ["方向角"] = GetUnitFacing(_____5927_6CD5_5E08),
        ["扇形角度"] = 90,
        ["起始半径"] = 0,
        ["结束半径"] = 512,
        ["变化时间"] = 1,
        ["检测间隔"] = 0.02,
        ["影响目标"] = "敌方",
        ["所有者"] = _____5927_6CD5_5E08,
        ["伤害值"] = 100,
        ["只命中新增范围"] = true,
        ["允许重复命中"] = false,
        ["显示提示特效"] = true,
        ["on周期"] = _____52A8_6001_6247_5F62_6D4B_8BD5__5468_671F,
        ["on销毁"] = _____52A8_6001_6247_5F62_6D4B_8BD5__9500_6BC1
    })
    debugLogForce(_____6A21_5757_540D, "已创建动态扇形：90度，0→512，1秒，每个敌方单位100伤害")
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
    TriggerAddAction(trig, ____on_804A_59291006_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "触发动态扇形伤害")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
