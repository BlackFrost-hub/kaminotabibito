--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- JASS随机数测试
-- 
-- 输入 1038：
-- - 连续打印 10 次 GetRandomInt(1, 100)
-- - 连续打印 10 次 GetRandomReal(0, 1)
-- 
-- 目的：排查是不是引擎随机数本身被固定。
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local _____6A21_5757_540D = "JASS随机数测试"
local _____6D4B_8BD5_547D_4EE4 = "1038"
local function ____on_804A_59291038_6D4B_8BD5()
    local _____6574_6570_7ED3_679C = {}
    local _____5B9E_6570_7ED3_679C = {}
    do
        local i = 0
        while i < 10 do
            _____6574_6570_7ED3_679C[#_____6574_6570_7ED3_679C + 1] = tostring(GetRandomInt(1, 100))
            i = i + 1
        end
    end
    do
        local i = 0
        while i < 10 do
            _____5B9E_6570_7ED3_679C[#_____5B9E_6570_7ED3_679C + 1] = tostring(GetRandomReal(0, 1))
            i = i + 1
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "GetRandomInt(1,100) x10 =",
        table.concat(_____6574_6570_7ED3_679C, ",")
    )
    debugLogForce(
        _____6A21_5757_540D,
        "GetRandomReal(0,1) x10 =",
        table.concat(_____5B9E_6570_7ED3_679C, ",")
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291038_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "打印JASS随机数序列")
return ____exports
