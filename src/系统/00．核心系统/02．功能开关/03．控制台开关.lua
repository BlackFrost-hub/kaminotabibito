--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local runtime = require("jass.runtime")
local _____83B7_53D6_73A9_5BB6_7F16_53F7 = jass.GetPlayerId
local _____663E_793A_9650_65F6_6587_672C = jass.DisplayTimedTextToPlayer
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____63A7_5236_53F0_5207_6362_547D_4EE4 = "-console"
local _____63A7_5236_53F0_5F00_542F_547D_4EE4 = "-console-on"
local _____63A7_5236_53F0_5173_95ED_547D_4EE4 = "-console-off"
local _____7BA1_7406_5458_73A9_5BB6_7F16_53F7 = 0
local _____63D0_793A_6301_7EED_65F6_95F4 = 5
local _____7CFB_7EDF_63D0_793A_524D_7F00 = "|cffffff00[System]|r "
local function _____662F_63A7_5236_53F0_7BA1_7406_5458(whichPlayer)
    return whichPlayer ~= nil and whichPlayer ~= 0 and _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer) == _____7BA1_7406_5458_73A9_5BB6_7F16_53F7
end
local function _____8F93_51FA_63A7_5236_53F0_72B6_6001(whichPlayer)
    local _____72B6_6001 = runtime.console == true and "ON" or "OFF"
    _____663E_793A_9650_65F6_6587_672C(
        whichPlayer,
        0,
        0.02,
        _____63D0_793A_6301_7EED_65F6_95F4,
        (_____7CFB_7EDF_63D0_793A_524D_7F00 .. "console=") .. _____72B6_6001
    )
end
local function _____8BBE_7F6E_63A7_5236_53F0(whichPlayer, enabled)
    if not _____662F_63A7_5236_53F0_7BA1_7406_5458(whichPlayer) then
        return
    end
    runtime.console = enabled
    _____8F93_51FA_63A7_5236_53F0_72B6_6001(whichPlayer)
end
local function _____5207_6362_63A7_5236_53F0_547D_4EE4(whichPlayer, command)
    if not _____662F_63A7_5236_53F0_7BA1_7406_5458(whichPlayer) then
        return
    end
    runtime.console = runtime.console ~= true
    _____8F93_51FA_63A7_5236_53F0_72B6_6001(whichPlayer)
end
local function _____5F00_542F_63A7_5236_53F0_547D_4EE4(whichPlayer, command)
    _____8BBE_7F6E_63A7_5236_53F0(whichPlayer, true)
end
local function _____5173_95ED_63A7_5236_53F0_547D_4EE4(whichPlayer, command)
    _____8BBE_7F6E_63A7_5236_53F0(whichPlayer, false)
end
local _____5DF2_521D_59CB_5316 = false
____exports["初始化控制台开关"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____63A7_5236_53F0_5207_6362_547D_4EE4, _____5207_6362_63A7_5236_53F0_547D_4EE4)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____63A7_5236_53F0_5F00_542F_547D_4EE4, _____5F00_542F_63A7_5236_53F0_547D_4EE4)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____63A7_5236_53F0_5173_95ED_547D_4EE4, _____5173_95ED_63A7_5236_53F0_547D_4EE4)
end
return ____exports
