--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitManaPercentBJ = ____require_result_3.SetUnitManaPercentBJ
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却")
local _____6E05_7A7A_5355_4F4D_88C5_5907_51B7_5374 = ____require_result_5["清空单位装备冷却"]
local ____require_result_6 = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示")
local _____6E05_9664_5355_4F4D_5168_90E8_7269_54C1_680F_51B7_5374 = ____require_result_6["清除单位全部物品栏冷却"]
local UnitResetCooldown = jass.UnitResetCooldown
local _____6A21_5757_540D = "重置玩家英雄技能冷却测试"
local _____6D4B_8BD5_547D_4EE4 = "-cd"
local function ____on_91CD_7F6E_73A9_5BB6_82F1_96C4_6280_80FD_51B7_5374(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local hero = getRegisteredPlayerHero(player)
    if hero == nil or hero == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到当前玩家已注册英雄")
        return
    end
    UnitResetCooldown(hero)
    _____6E05_7A7A_5355_4F4D_88C5_5907_51B7_5374(hero)
    _____6E05_9664_5355_4F4D_5168_90E8_7269_54C1_680F_51B7_5374(hero)
    SetUnitManaPercentBJ(hero, 100)
    debugLogForce(_____6A21_5757_540D, "已重置当前玩家英雄全部技能/装备冷却、物品栏冷却UI并回满魔法")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_91CD_7F6E_73A9_5BB6_82F1_96C4_6280_80FD_51B7_5374)
debugLogForce(_____6A21_5757_540D, "已注册测试命令：输入", _____6D4B_8BD5_547D_4EE4, "重置当前玩家英雄全部技能冷却")
return ____exports
