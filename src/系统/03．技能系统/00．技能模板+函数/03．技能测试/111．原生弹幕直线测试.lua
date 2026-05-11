--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
--- 原生弹幕直线测试
-- 
-- 输入 "1011"：
-- - 从 gg_unit_Hamg_0002 前方 80 码发射 eaaa 默认弹幕马甲。
-- - 普通直线弹幕按单位当前面向推进。
-- - 穿透路径，对路径上的每个敌人最多造成一次伤害。
-- - 测试命中单位回调、到达目标点回调、结束回调。
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
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local Cos = jass.Cos
local Sin = jass.Sin
local _____6A21_5757_540D = "原生弹幕直线测试"
local _____6D4B_8BD5_547D_4EE4 = "1011"
local _____5DF2_6CE8_518C = false
local function _____53D6_524D_65B9X(_____5355_4F4D, _____8DDD_79BB)
    local _____671D_5411 = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitX(_____5355_4F4D) + Cos(_____671D_5411) * _____8DDD_79BB
end
local function _____53D6_524D_65B9Y(_____5355_4F4D, _____8DDD_79BB)
    local _____671D_5411 = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitY(_____5355_4F4D) + Sin(_____671D_5411) * _____8DDD_79BB
end
local function _____76F4_7EBF_5F39_5E55__547D_4E2D_5355_4F4D(_____76EE_6807_5355_4F4D, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "命中单位",
        "弹幕ID=",
        _____5F39_5E55ID,
        "目标=",
        GetUnitName(_____76EE_6807_5355_4F4D),
        "#",
        GetHandleId(_____76EE_6807_5355_4F4D)
    )
end
local function _____76F4_7EBF_5F39_5E55__5230_8FBE_76EE_6807_70B9(_____5F39_5E55ID, _____539F_56E0)
    debugLogForce(
        _____6A21_5757_540D,
        "到达目标点",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function _____76F4_7EBF_5F39_5E55__7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function ____on_804A_59291011_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____8D77_70B9X = _____53D6_524D_65B9X(_____5927_6CD5_5E08, 80)
    local _____8D77_70B9Y = _____53D6_524D_65B9Y(_____5927_6CD5_5E08, 80)
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____5927_6CD5_5E08,
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        ["方向角"] = GetUnitFacing(_____5927_6CD5_5E08),
        ["速度"] = 650,
        ["最大距离"] = 900,
        ["命中半径"] = 96,
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = 35,
        ["影响目标"] = "敌方",
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["飞行高度"] = 75,
        ["on命中单位"] = _____76F4_7EBF_5F39_5E55__547D_4E2D_5355_4F4D,
        ["on到达目标点"] = _____76F4_7EBF_5F39_5E55__5230_8FBE_76EE_6807_70B9,
        ["on结束"] = _____76F4_7EBF_5F39_5E55__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已发射直线弹幕",
        "弹幕ID=",
        _____5B9E_4F8B["弹幕ID"],
        "起点=(",
        _____8D77_70B9X,
        ",",
        _____8D77_70B9Y,
        ")"
    )
end
local function _____6CE8_518C_804A_59291011_6D4B_8BD5()
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
    TriggerAddAction(trig, ____on_804A_59291011_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "发射原生直线弹幕")
end
_____6CE8_518C_804A_59291011_6D4B_8BD5()
return ____exports
