--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 嘲讽 测试
-- 
-- 输入 "1019"：
-- - 先给玩家1写入 50% 眩晕抗性
-- - 再让大法师周围1000码内的第一个敌人，对大法师施加5秒单体嘲讽
-- - 用于测试嘲讽是否正确吃到玩家级控制抗性
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____5632_8BBD_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.index")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataSet = ____require_result_2.YDUserDataSet
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "嘲讽测试"
local _____6D4B_8BD5_547D_4EE4 = "1019"
local _____5DF2_6CE8_518C = false
local function _____65BD_52A0_5355_4F53_5632_8BBD(sourceUnit, targetUnit, options)
    return _____5632_8BBD_7CFB_7EDF["施加嘲讽"](_____5632_8BBD_7CFB_7EDF, sourceUnit, targetUnit, options)
end
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    YDUserDataSet(
        nil,
        "player",
        Player(0),
        "眩晕抗性",
        "real",
        0.3
    )
    local _____654C_4EBA_5217_8868 = getEnemyUnitsInRange(_____5927_6CD5_5E08, x, y, 1000)
    local _____7B2C_4E00_4E2A_654C_4EBA = _____654C_4EBA_5217_8868[1]
    if _____7B2C_4E00_4E2A_654C_4EBA == nil or _____7B2C_4E00_4E2A_654C_4EBA == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：大法师周围1000码内没有敌人，无法测试单体嘲讽")
        return
    end
    local _____7ED3_679C = _____65BD_52A0_5355_4F53_5632_8BBD(_____7B2C_4E00_4E2A_654C_4EBA, _____5927_6CD5_5E08, {["持续时间"] = 5, ["反伤倍率"] = 1})
    debugLogForce(_____6A21_5757_540D, "已给玩家1写入50%眩晕抗性")
    debugLogForce(
        _____6A21_5757_540D,
        "单体嘲讽 结果=",
        _____7ED3_679C,
        "来源=",
        _____7B2C_4E00_4E2A_654C_4EBA,
        "目标=gg_unit_Hamg_0002"
    )
    debugLogForce(_____6A21_5757_540D, "提示：理论持续时间应缩短到2.5秒，来源为周围第一个敌人")
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
    TriggerAddAction(trig, ____on_804A_5929_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给玩家1加50%控制抗性，再让周围第一个敌人嘲讽大法师")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
