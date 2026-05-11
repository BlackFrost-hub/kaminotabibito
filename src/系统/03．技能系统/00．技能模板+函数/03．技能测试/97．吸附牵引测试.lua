--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.index")
local _____5F00_59CB_5355_4F4D_7EC4_7275_5F15 = ____index["开始单位组牵引"]
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
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local DestroyGroup = jass.DestroyGroup
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "吸附牵引测试"
local _____804A_5929_547D_4EE4 = "111"
local _____6700_5927_7275_5F15_8DDD_79BB = 600
local _____5DF2_6CE8_518C = false
local function _____5438_9644_7275_5F15_6D4B_8BD5__7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____7275_5F15ID)
    debugLogForce(
        nil,
        _____6A21_5757_540D,
        "牵引结束",
        "ID=",
        _____7275_5F15ID,
        " 原因=",
        _____539F_56E0,
        " 单位=",
        _____5355_4F4D
    )
end
local function _____6267_884C_5438_9644_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(nil, _____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        GetUnitX(_____5927_6CD5_5E08),
        GetUnitY(_____5927_6CD5_5E08),
        1000,
        nil
    )
    _____5F00_59CB_5355_4F4D_7EC4_7275_5F15(group, {
        ["中心单位"] = _____5927_6CD5_5E08,
        ["每秒速度"] = 220,
        ["持续时间"] = 4,
        ["最小距离"] = 140,
        ["最大牵引距离"] = _____6700_5927_7275_5F15_8DDD_79BB,
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["暂停单位"] = false,
        ["朝向跟随牵引"] = true,
        ["外部暂停时中断"] = true,
        ["启用闪电效果"] = true,
        ["闪电效果代码"] = "CLPB",
        ["闪电高度"] = 60,
        ["结束回调"] = _____5438_9644_7275_5F15_6D4B_8BD5__7ED3_675F_56DE_8C03
    })
    DestroyGroup(group)
    debugLogForce(
        nil,
        _____6A21_5757_540D,
        "已开始测试",
        "输入=" .. _____804A_5929_547D_4EE4,
        " 最大牵引距离=",
        _____6700_5927_7275_5F15_8DDD_79BB
    )
end
local function ____on_804A_5929111_6D4B_8BD5()
    _____6267_884C_5438_9644_6D4B_8BD5()
end
local function _____6CE8_518C_804A_5929111_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____804A_5929_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_5929111_6D4B_8BD5)
    debugLogForce(nil, _____6A21_5757_540D, "已注册聊天测试", ("输入 " .. _____804A_5929_547D_4EE4) .. " 开始")
end
_____6CE8_518C_804A_5929111_6D4B_8BD5()
return ____exports
