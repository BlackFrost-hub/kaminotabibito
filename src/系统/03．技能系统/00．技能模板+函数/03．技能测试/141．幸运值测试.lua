--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____8BBE_7F6E_73A9_5BB6_5E78_8FD0_503C = ____require_result_1["设置玩家幸运值"]
local _____53D6_73A9_5BB6_5E78_8FD0_503C = ____require_result_1["取玩家幸运值"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local _____6A21_5757_540D = "幸运值测试"
local _____6D4B_8BD5_547D_4EE4 = "1043"
local function ____on_804A_59291043_5E78_8FD0_503C_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____5927_6CD5_5E08)
    _____8BBE_7F6E_73A9_5BB6_5E78_8FD0_503C(_____73A9_5BB6, 5)
    debugLogForce(
        _____6A21_5757_540D,
        "已设置大法师所属玩家幸运值",
        "playerId=",
        GetPlayerId(_____73A9_5BB6),
        "幸运值=",
        _____53D6_73A9_5BB6_5E78_8FD0_503C(_____73A9_5BB6)
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291043_5E78_8FD0_503C_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "给大法师所属玩家设置500%幸运值")
return ____exports
