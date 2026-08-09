--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local globals = require("jass.globals")
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_1["是允许测试玩家"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_2.directRegisterPlayerHero
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local _____73A9_5BB6 = jass.Player
local _____6D4B_8BD5_547D_4EE4 = "zc"
local _____6A21_5757_540D = "玩家英雄注册测试"
local function ____on_73A9_5BB6_82F1_96C4_6CE8_518C_6D4B_8BD5(______89E6_53D1_73A9_5BB6, ______547D_4EE4)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(______89E6_53D1_73A9_5BB6) then
        return
    end
    local _____73A9_5BB61_82F1_96C4 = globals.gg_unit_Hamg_0002
    local _____73A9_5BB62_82F1_96C4 = globals.gg_unit_Obla_0004
    if _____73A9_5BB61_82F1_96C4 == nil or _____73A9_5BB61_82F1_96C4 == 0 or _____73A9_5BB62_82F1_96C4 == nil or _____73A9_5BB62_82F1_96C4 == 0 then
        debugLogForce(
            _____6A21_5757_540D,
            "地图预置英雄句柄不存在",
            "玩家1英雄",
            _____73A9_5BB61_82F1_96C4,
            "玩家2英雄",
            _____73A9_5BB62_82F1_96C4
        )
        return
    end
    directRegisterPlayerHero(
        _____73A9_5BB6(0),
        _____73A9_5BB61_82F1_96C4
    )
    directRegisterPlayerHero(
        _____73A9_5BB6(1),
        _____73A9_5BB62_82F1_96C4
    )
    debugLogForce(
        _____6A21_5757_540D,
        "已完成玩家英雄注册",
        "玩家1",
        "gg_unit_Hamg_0002",
        "玩家2",
        "gg_unit_Obla_0004"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_73A9_5BB6_82F1_96C4_6CE8_518C_6D4B_8BD5)
return ____exports
