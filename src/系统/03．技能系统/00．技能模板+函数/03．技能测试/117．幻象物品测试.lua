--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 幻象物品测试
-- 
-- 输入 "1017"：
-- - 对 gg_unit_Hamg_0002 施放快速 Buff 马甲版“幻象物品”。
-- - 默认持续时间 15 秒。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local GetUnitName = jass.GetUnitName
local _____6A21_5757_540D = "幻象物品测试"
local _____6D4B_8BD5_547D_4EE4 = "1017"
local _____5E7B_8C61_6301_7EED_65F6_95F4 = 15
local function ____on_804A_59291017_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local ok = fastBuff.SFB_setItemIllusion(_____5927_6CD5_5E08, _____5927_6CD5_5E08, _____5E7B_8C61_6301_7EED_65F6_95F4)
    debugLogForce(
        _____6A21_5757_540D,
        "施放结果=",
        ok,
        "目标=",
        GetUnitName(_____5927_6CD5_5E08),
        "持续=",
        _____5E7B_8C61_6301_7EED_65F6_95F4
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291017_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "对大法师施放幻象物品")
return ____exports
