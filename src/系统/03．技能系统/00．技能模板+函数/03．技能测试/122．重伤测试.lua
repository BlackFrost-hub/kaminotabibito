--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 重伤系统 测试
-- 
-- 输入 "1022"：给大法师施加50%重伤，然后治疗100，验证治疗量减少
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.04．伤害系统.03．重伤系统.index")
local _____83B7_53D6_5355_4F4D_91CD_4F24 = ____require_result_1["获取单位重伤"]
local _____65BD_52A0_91CD_4F24 = ____require_result_1["施加重伤"]
local _____79FB_9664_5355_4F4D_91CD_4F24 = ____require_result_1["移除单位重伤"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local spellHeal = ____require_result_2.spellHeal
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____6A21_5757_540D = "重伤测试"
local _____6D4B_8BD5_547D_4EE4 = "1022"
local _____5DF2_6CE8_518C = false
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    debugLogForce(_____6A21_5757_540D, "===== 重伤测试 =====")
    _____65BD_52A0_91CD_4F24(_____5927_6CD5_5E08, 0.5, 3)
    debugLogForce(
        _____6A21_5757_540D,
        "重伤值：",
        _____83B7_53D6_5355_4F4D_91CD_4F24(_____5927_6CD5_5E08)
    )
    debugLogForce(
        _____6A21_5757_540D,
        "治疗前血量：",
        GetUnitState(_____5927_6CD5_5E08, UNIT_STATE_LIFE)
    )
    local heal = spellHeal(nil, _____5927_6CD5_5E08, 100, false)
    debugLogForce(
        _____6A21_5757_540D,
        "治疗量：",
        heal,
        "治疗后血量：",
        GetUnitState(_____5927_6CD5_5E08, UNIT_STATE_LIFE)
    )
    if heal < 100 then
        debugLogForce(_____6A21_5757_540D, "[PASS] 重伤减少治疗：", heal, "< 100")
    else
        debugLogForce(_____6A21_5757_540D, "[FAIL] 重伤未减少治疗：", heal, ">= 100")
    end
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
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "测试重伤对治疗的影响")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
