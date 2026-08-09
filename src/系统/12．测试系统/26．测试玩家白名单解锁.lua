--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____767B_8BB0_6D4B_8BD5_73A9_5BB6 = ____require_result_1["登记测试玩家"]
local _____6D4B_8BD5_547D_4EE4 = "test"
local function ____on_6D4B_8BD5_73A9_5BB6_767D_540D_5355_89E3_9501(_____73A9_5BB6, _____547D_4EE4)
    if _____547D_4EE4 ~= _____6D4B_8BD5_547D_4EE4 or _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    _____767B_8BB0_6D4B_8BD5_73A9_5BB6(_____73A9_5BB6)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6D4B_8BD5_73A9_5BB6_767D_540D_5355_89E3_9501)
return ____exports
