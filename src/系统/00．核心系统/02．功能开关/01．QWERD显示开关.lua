--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____83B7_53D6_73A9_5BB6_7F16_53F7 = jass.GetPlayerId
local _____663E_793A_9650_65F6_6587_672C = jass.DisplayTimedTextToPlayer
local _____83B7_53D6_672C_5730_73A9_5BB6 = jass.GetLocalPlayer
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____51B7_5374_663E_793A_547D_4EE4 = "-cool"
local _____9B54_6CD5_6D88_8017_663E_793A_547D_4EE4 = "-cost"
local _____52A8_6001_6280_80FD_6587_672C_547D_4EE4 = "-动态技能"
local _____7CFB_7EDF_63D0_793A_524D_7F00 = "|cffffff00『系统提示』：|r"
local _____63D0_793A_6301_7EED_65F6_95F4 = 5
local _____51B7_5374_663E_793A_5F00_5173_8868 = {}
local _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868 = {}
local _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local function _____8BFB_53D6_51B7_5374_663E_793A_5F00_5173(playerId)
    local value = _____51B7_5374_663E_793A_5F00_5173_8868[playerId]
    local ____temp_0
    if value == nil then
        ____temp_0 = true
    else
        ____temp_0 = value
    end
    return ____temp_0
end
local function _____8BFB_53D6_9B54_6CD5_6D88_8017_663E_793A_5F00_5173(playerId)
    local value = _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868[playerId]
    local ____temp_1
    if value == nil then
        ____temp_1 = true
    else
        ____temp_1 = value
    end
    return ____temp_1
end
local function _____8BFB_53D6_52A8_6001_6280_80FD_6587_672C_5F00_5173(playerId)
    local value = _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868[playerId]
    local ____temp_2
    if value == nil then
        ____temp_2 = true
    else
        ____temp_2 = value
    end
    return ____temp_2
end
local function _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, label, enabled)
    local _____72B6_6001_6587_672C = enabled and "已开启" or "已关闭"
    _____663E_793A_9650_65F6_6587_672C(
        whichPlayer,
        0,
        0.02,
        _____63D0_793A_6301_7EED_65F6_95F4,
        (_____7CFB_7EDF_63D0_793A_524D_7F00 .. label) .. _____72B6_6001_6587_672C
    )
end
local function _____5207_6362_51B7_5374_663E_793A_547D_4EE4_52A8_4F5C(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local nextValue = not _____8BFB_53D6_51B7_5374_663E_793A_5F00_5173(playerId)
    _____51B7_5374_663E_793A_5F00_5173_8868[playerId] = nextValue
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "技能冷却显示", nextValue)
end
local function _____5207_6362_9B54_6CD5_6D88_8017_663E_793A_547D_4EE4_52A8_4F5C(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local nextValue = not _____8BFB_53D6_9B54_6CD5_6D88_8017_663E_793A_5F00_5173(playerId)
    _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868[playerId] = nextValue
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "魔法消耗显示", nextValue)
end
local function _____5207_6362_52A8_6001_6280_80FD_6587_672C_547D_4EE4_52A8_4F5C(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local nextValue = not _____8BFB_53D6_52A8_6001_6280_80FD_6587_672C_5F00_5173(playerId)
    _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868[playerId] = nextValue
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "动态技能文本", nextValue)
end
____exports["本地玩家是否开启冷却显示"] = function()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_51B7_5374_663E_793A_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["本地玩家是否开启魔法消耗显示"] = function()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_9B54_6CD5_6D88_8017_663E_793A_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["本地玩家是否开启动态技能文本"] = function()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_52A8_6001_6280_80FD_6587_672C_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["初始化QWERD显示开关"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____51B7_5374_663E_793A_547D_4EE4, _____5207_6362_51B7_5374_663E_793A_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____9B54_6CD5_6D88_8017_663E_793A_547D_4EE4, _____5207_6362_9B54_6CD5_6D88_8017_663E_793A_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____52A8_6001_6280_80FD_6587_672C_547D_4EE4, _____5207_6362_52A8_6001_6280_80FD_6587_672C_547D_4EE4_52A8_4F5C)
end
return ____exports
