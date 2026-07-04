--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____542F_7528_88C5_5907_8C03_8BD5_65E5_5FD7 = false
local _____542F_7528_4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = false
____exports["装备调试日志"] = function(module, ...)
    if not _____542F_7528_88C5_5907_8C03_8BD5_65E5_5FD7 then
        return
    end
    debugLogForce(module, ...)
end
____exports["主动物品调试日志"] = function(module, ...)
    if not _____542F_7528_4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 then
        return
    end
    debugLogForce(module, ...)
end
return ____exports
