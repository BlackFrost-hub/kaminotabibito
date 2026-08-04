local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C = ____require_result_1["注册聊天命令前缀监听"]
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____require_result_2["写入剧情进度"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____require_result_2["读取剧情进度"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____4E3B_7EBF_8FDB_5EA6_547D_4EE4_524D_7F00 = "进度"
local _____6A21_5757_540D = "主线进度测试"
local function _____53D1_9001_6D4B_8BD5_63D0_793A(player, text)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        "[测试] " .. text
    )
end
local function _____89E3_6790_4E3B_7EBF_8FDB_5EA6(command)
    if __TS__StringSubstring(command, 0, #_____4E3B_7EBF_8FDB_5EA6_547D_4EE4_524D_7F00) ~= _____4E3B_7EBF_8FDB_5EA6_547D_4EE4_524D_7F00 then
        return nil
    end
    local text = __TS__StringTrim(__TS__StringSubstring(command, #_____4E3B_7EBF_8FDB_5EA6_547D_4EE4_524D_7F00))
    if text == "" then
        return nil
    end
    local progress = __TS__Number(text)
    if progress ~= progress or progress < 0 or progress ~= math.floor(progress) then
        return nil
    end
    return progress
end
local function ____on_4E3B_7EBF_8FDB_5EA6_547D_4EE4(player, command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local progress = _____89E3_6790_4E3B_7EBF_8FDB_5EA6(command)
    if progress == nil then
        _____53D1_9001_6D4B_8BD5_63D0_793A(player, "命令格式：进度+数字，例如：进度15")
        debugLogForce(_____6A21_5757_540D, "命令格式无效", "command", command)
        return
    end
    local previousProgress = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    _____5199_5165_5267_60C5_8FDB_5EA6(progress)
    _____53D1_9001_6D4B_8BD5_63D0_793A(
        player,
        ((("主线剧情进度已设置为 " .. tostring(progress)) .. "（原进度 ") .. tostring(previousProgress)) .. "）"
    )
    debugLogForce(
        _____6A21_5757_540D,
        "设置主线剧情进度",
        "command",
        command,
        "previousProgress",
        previousProgress,
        "progress",
        progress
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C(_____4E3B_7EBF_8FDB_5EA6_547D_4EE4_524D_7F00, ____on_4E3B_7EBF_8FDB_5EA6_547D_4EE4)
return ____exports
