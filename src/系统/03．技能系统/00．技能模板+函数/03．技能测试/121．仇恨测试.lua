--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 仇恨系统 测试
-- 
-- 步骤1 — 链路验证：
-- 输入 "1021"：直接对大法师周围敌人手动加仇恨（addThreat），验证驱动层让敌人攻击大法师
-- 
-- 步骤2 — 真实伤害：
-- 大法师手动攻击敌人，日志观察仇恨建立
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.index")
local _____521D_59CB_5316_4EC7_6068_7CFB_7EDF = ____require_result_1["初始化仇恨系统"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local addThreat = ____require_result_2.addThreat
local clearAllThreat = ____require_result_2.clearAllThreat
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "仇恨测试"
local _____6D4B_8BD5_547D_4EE4 = "1021"
local _____5DF2_6CE8_518C = false
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____521D_59CB_5316_4EC7_6068_7CFB_7EDF()
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local _____654C_4EBA_5217_8868 = getEnemyUnitsInRange(_____5927_6CD5_5E08, x, y, 1000)
    if #_____654C_4EBA_5217_8868 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：大法师周围1000码内没有敌人")
        return
    end
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                    goto __continue6
                end
                clearAllThreat(_____654C_4EBA)
                addThreat(_____654C_4EBA, _____5927_6CD5_5E08, 30)
                debugLogForce(
                    _____6A21_5757_540D,
                    "加仇恨 敌人ID=",
                    jass.GetHandleId(_____654C_4EBA),
                    "对大法师 仇恨=30"
                )
            end
            ::__continue6::
            i = i + 1
        end
    end
    debugLogForce(_____6A21_5757_540D, "步骤1完成：已在", #_____654C_4EBA_5217_8868, "个敌人上注册仇恨，驱动将使其攻击大法师")
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
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给周围敌人加30仇恨，验证驱动攻击")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
