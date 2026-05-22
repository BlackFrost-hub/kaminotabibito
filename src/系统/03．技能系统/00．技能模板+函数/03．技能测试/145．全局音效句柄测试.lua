--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_1.PlaySoundBJ
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local _____6A21_5757_540D = "全局音效句柄测试"
local _____6D4B_8BD5_547D_4EE4 = "145"
local function ____on_804A_5929145_6D4B_8BD5()
    debugLogForce(_____6A21_5757_540D, "准备播放 gg_snd_SecretFound", "handle=", gg_snd_SecretFound)
    PlaySoundBJ(gg_snd_SecretFound)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929145_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "播放 gg_snd_SecretFound")
return ____exports
