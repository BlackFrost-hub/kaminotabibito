--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.index")
local _____5F00_59CB_539F_5730_51FB_98DE = ____index["开始原地击飞"]
--- 原地击飞水流冲击测试
-- 
-- 输入 "1016"：
-- - 在 gg_unit_Hamg_0002 脚下持续创建娜迦死亡特效。
-- - 将大法师原地顶飞，Z 高度在 200-250 间随机抖动。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local _____6A21_5757_540D = "原地击飞水流冲击测试"
local _____6D4B_8BD5_547D_4EE4 = "1016"
local _____5A1C_8FE6_6B7B_4EA1_7279_6548 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
local _____5DF2_6CE8_518C = false
local function _____539F_5730_51FB_98DE__7ED3_675F(_____5355_4F4D, _____539F_56E0, _____51FB_98DEID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "原因=",
        _____539F_56E0,
        "击飞ID=",
        _____51FB_98DEID
    )
end
local function ____on_804A_59291016_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____51FB_98DEID = _____5F00_59CB_539F_5730_51FB_98DE(_____5927_6CD5_5E08, {
        ["持续时间"] = 3,
        ["最小高度"] = 200,
        ["最大高度"] = 250,
        ["冲击波模型"] = _____5A1C_8FE6_6B7B_4EA1_7279_6548,
        ["持续特效模型"] = _____5A1C_8FE6_6B7B_4EA1_7279_6548,
        ["持续特效间隔"] = 0.08,
        ["结束回调"] = _____539F_5730_51FB_98DE__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "开始",
        "击飞ID=",
        _____51FB_98DEID,
        "特效=",
        _____5A1C_8FE6_6B7B_4EA1_7279_6548
    )
end
local function _____6CE8_518C_804A_59291016_6D4B_8BD5()
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
    TriggerAddAction(trig, ____on_804A_59291016_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "开始原地击飞水流冲击测试")
end
_____6CE8_518C_804A_59291016_6D4B_8BD5()
return ____exports
