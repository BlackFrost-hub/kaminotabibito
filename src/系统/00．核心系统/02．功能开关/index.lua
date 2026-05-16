--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local ____QWERD_663E_793A_5F00_5173_6A21_5757 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local _____81EA_6740_547D_4EE4_6A21_5757 = require("系统.00．核心系统.02．功能开关.02．英雄自杀系统")
local _____529F_80FD_5F00_5173_5DF2_521D_59CB_5316 = false
____exports["初始化功能开关"] = function()
    if _____529F_80FD_5F00_5173_5DF2_521D_59CB_5316 then
        return
    end
    _____529F_80FD_5F00_5173_5DF2_521D_59CB_5316 = true
    ____QWERD_663E_793A_5F00_5173_6A21_5757["初始化QWERD显示开关"]()
    _____81EA_6740_547D_4EE4_6A21_5757["初始化自杀命令"]()
end
____exports["初始化功能开关"]()
return ____exports
