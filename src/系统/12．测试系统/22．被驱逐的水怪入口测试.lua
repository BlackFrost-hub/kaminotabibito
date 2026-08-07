--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
---
-- @noSelfInFile
common = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
_____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_1["是允许测试玩家"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_3.debugLogForce
KillUnit = common.KillUnit
_____6D4B_8BD5_547D_4EE4 = "测试杀死水龙蛇"
_____6A21_5757_540D = "被驱逐的水怪入口测试"
function ____on_6D4B_8BD5_6740_6B7B_6C34_9F99_86C7(_____73A9_5BB6, ______547D_4EE4)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(_____73A9_5BB6) then
        return
    end
    local _____6C34_9F99_86C7 = YDUserDataGetSafe("string", "Boss", "水龙蛇", "unit")
    if _____6C34_9F99_86C7 == nil or _____6C34_9F99_86C7 == 0 then
        debugLogForce(_____6A21_5757_540D, "水龙蛇尚未完成初始注册，请等待地图 Boss 初始化后重试")
        return
    end
    KillUnit(_____6C34_9F99_86C7)
    debugLogForce(_____6A21_5757_540D, "已执行水龙蛇死亡，沃利尔斯应按正式死亡监听出现")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6D4B_8BD5_6740_6B7B_6C34_9F99_86C7)
