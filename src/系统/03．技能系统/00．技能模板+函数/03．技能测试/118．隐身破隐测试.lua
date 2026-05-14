--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.15．隐身.index")
local _____65BD_52A0_9690_8EAB = ____index["施加隐身"]
local _____79FB_9664_9690_8EAB = ____index["移除隐身"]
local _____5355_4F4D_662F_5426_9690_8EAB_4E2D = ____index["单位是否隐身中"]
--- 隐身 + 破隐一击 测试
-- 
-- 输入 "1018"：对大法师施加隐身5秒
-- - 普攻敌人时破隐，附加额外伤害（倍率1.5 + 固定200）
-- - 释放技能时破隐（无额外伤害）
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local _____6A21_5757_540D = "隐身破隐测试"
local _____6D4B_8BD5_547D_4EE4 = "1018"
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    if _____5355_4F4D_662F_5426_9690_8EAB_4E2D(_____5927_6CD5_5E08) then
        debugLogForce(_____6A21_5757_540D, "大法师已隐身中，先移除")
        _____79FB_9664_9690_8EAB(_____5927_6CD5_5E08)
    end
    local _____7ED3_679C = _____65BD_52A0_9690_8EAB(_____5927_6CD5_5E08, {["持续时间"] = 5, ["破隐固定额外伤害"] = 200, ["破隐伤害倍率"] = 1.5})
    debugLogForce(
        _____6A21_5757_540D,
        "施加隐身结果=",
        _____7ED3_679C,
        "隐身中=",
        _____5355_4F4D_662F_5426_9690_8EAB_4E2D(_____5927_6CD5_5E08)
    )
    debugLogForce(_____6A21_5757_540D, "提示：普攻敌人会破隐附加额外伤害，释放技能也会破隐")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "对大法师施加隐身")
return ____exports
