--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____83B7_53D6_73A9_5BB6_7F16_53F7 = jass.GetPlayerId
local _____663E_793A_9650_65F6_6587_672C = jass.DisplayTimedTextToPlayer
local _____83B7_53D6_672C_5730_73A9_5BB6 = jass.GetLocalPlayer
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____672C_5730_5B58_6863 = require("系统.10．存档系统.01．本地存档.index")
local _____51B7_5374_663E_793A_547D_4EE4 = "-cool"
local _____9B54_6CD5_6D88_8017_663E_793A_547D_4EE4 = "-cost"
local _____52A8_6001_6280_80FD_6587_672C_547D_4EE4 = "-动态技能"
local _____4EC7_6068_6587_5B57_547D_4EE4 = "-仇恨文字"
local _____4EC7_6068_6587_5B57_82F1_6587_547D_4EE4 = "-hate"
local _____7CFB_7EDF_63D0_793A_524D_7F00 = "|cffffff00[System]|r "
local _____63D0_793A_6301_7EED_65F6_95F4 = 5
local _____51B7_5374_663E_793A_5F00_5173_8868 = {}
local _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868 = {}
local _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868 = {}
local _____4EC7_6068_6587_5B57_5F00_5173_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local _____5DF2_52A0_8F7D_672C_673A_663E_793A_914D_7F6E = false
local function _____5E94_7528_73A9_5BB6_663E_793A_914D_7F6E(player)
    if player == nil or player == 0 then
        return
    end
    _____672C_5730_5B58_6863["加载玩家本地存档"](player)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(player)
    local _____5B57_6BB5 = _____672C_5730_5B58_6863["本地存档字段"]
    _____51B7_5374_663E_793A_5F00_5173_8868[playerId] = _____672C_5730_5B58_6863["读取本地存档布尔"](player, _____5B57_6BB5["QWERD冷却显示开关"], true)
    _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868[playerId] = _____672C_5730_5B58_6863["读取本地存档布尔"](player, _____5B57_6BB5["QWERD蓝耗显示开关"], true)
    _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868[playerId] = _____672C_5730_5B58_6863["读取本地存档布尔"](player, _____5B57_6BB5["动态技能文本开关"], true)
    _____4EC7_6068_6587_5B57_5F00_5173_8868[playerId] = _____672C_5730_5B58_6863["读取本地存档布尔"](player, _____5B57_6BB5["仇恨漂浮文字开关"], true)
end
local function _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    if _____5DF2_52A0_8F7D_672C_673A_663E_793A_914D_7F6E then
        return
    end
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return
    end
    _____5DF2_52A0_8F7D_672C_673A_663E_793A_914D_7F6E = true
    _____5E94_7528_73A9_5BB6_663E_793A_914D_7F6E(localPlayer)
end
local function _____5F3A_5236_52A0_8F7D_547D_4EE4_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    if whichPlayer == nil or whichPlayer == 0 then
        return
    end
    _____5E94_7528_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    if whichPlayer == _____83B7_53D6_672C_5730_73A9_5BB6() then
        _____5DF2_52A0_8F7D_672C_673A_663E_793A_914D_7F6E = true
    end
end
local function _____4FDD_5B58_663E_793A_5F00_5173_914D_7F6E(whichPlayer, field, enabled)
    _____672C_5730_5B58_6863["设置本地存档布尔"](whichPlayer, field, enabled, true)
end
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
local function _____8BFB_53D6_4EC7_6068_6587_5B57_5F00_5173(playerId)
    local value = _____4EC7_6068_6587_5B57_5F00_5173_8868[playerId]
    local ____temp_3
    if value == nil then
        ____temp_3 = true
    else
        ____temp_3 = value
    end
    return ____temp_3
end
local function _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, label, enabled)
    local _____72B6_6001_6587_672C = enabled and "ON" or "OFF"
    _____663E_793A_9650_65F6_6587_672C(
        whichPlayer,
        0,
        0.02,
        _____63D0_793A_6301_7EED_65F6_95F4,
        ((_____7CFB_7EDF_63D0_793A_524D_7F00 .. label) .. "=") .. _____72B6_6001_6587_672C
    )
end
local function _____5207_6362_51B7_5374_663E_793A_547D_4EE4_52A8_4F5C(whichPlayer)
    _____5F3A_5236_52A0_8F7D_547D_4EE4_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local _____5F53_524D_503C = _____8BFB_53D6_51B7_5374_663E_793A_5F00_5173(playerId)
    local nextValue = not _____5F53_524D_503C
    _____51B7_5374_663E_793A_5F00_5173_8868[playerId] = nextValue
    _____4FDD_5B58_663E_793A_5F00_5173_914D_7F6E(whichPlayer, _____672C_5730_5B58_6863["本地存档字段"]["QWERD冷却显示开关"], nextValue)
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "lengque", nextValue)
end
local function _____5207_6362_9B54_6CD5_6D88_8017_663E_793A_547D_4EE4_52A8_4F5C(whichPlayer)
    _____5F3A_5236_52A0_8F7D_547D_4EE4_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local _____5F53_524D_503C = _____8BFB_53D6_9B54_6CD5_6D88_8017_663E_793A_5F00_5173(playerId)
    local nextValue = not _____5F53_524D_503C
    _____9B54_6CD5_6D88_8017_663E_793A_5F00_5173_8868[playerId] = nextValue
    _____4FDD_5B58_663E_793A_5F00_5173_914D_7F6E(whichPlayer, _____672C_5730_5B58_6863["本地存档字段"]["QWERD蓝耗显示开关"], nextValue)
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "lanhao", nextValue)
end
local function _____5207_6362_52A8_6001_6280_80FD_6587_672C_547D_4EE4_52A8_4F5C(whichPlayer)
    _____5F3A_5236_52A0_8F7D_547D_4EE4_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local _____5F53_524D_503C = _____8BFB_53D6_52A8_6001_6280_80FD_6587_672C_5F00_5173(playerId)
    local nextValue = not _____5F53_524D_503C
    _____52A8_6001_6280_80FD_6587_672C_5F00_5173_8868[playerId] = nextValue
    _____4FDD_5B58_663E_793A_5F00_5173_914D_7F6E(whichPlayer, _____672C_5730_5B58_6863["本地存档字段"]["动态技能文本开关"], nextValue)
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "dongtai", nextValue)
end
local function _____5207_6362_4EC7_6068_6587_5B57_547D_4EE4_52A8_4F5C(whichPlayer)
    _____5F3A_5236_52A0_8F7D_547D_4EE4_73A9_5BB6_663E_793A_914D_7F6E(whichPlayer)
    local playerId = _____83B7_53D6_73A9_5BB6_7F16_53F7(whichPlayer)
    local _____5F53_524D_503C = _____8BFB_53D6_4EC7_6068_6587_5B57_5F00_5173(playerId)
    local nextValue = not _____5F53_524D_503C
    _____4EC7_6068_6587_5B57_5F00_5173_8868[playerId] = nextValue
    _____4FDD_5B58_663E_793A_5F00_5173_914D_7F6E(whichPlayer, _____672C_5730_5B58_6863["本地存档字段"]["仇恨漂浮文字开关"], nextValue)
    _____8F93_51FA_5F00_5173_63D0_793A(whichPlayer, "chouhen", nextValue)
end
____exports["本地玩家是否开启冷却显示"] = function()
    _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_51B7_5374_663E_793A_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["本地玩家是否开启魔法消耗显示"] = function()
    _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_9B54_6CD5_6D88_8017_663E_793A_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["本地玩家是否开启动态技能文本"] = function()
    _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_52A8_6001_6280_80FD_6587_672C_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["本地玩家是否开启仇恨文字"] = function()
    _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    local localPlayer = _____83B7_53D6_672C_5730_73A9_5BB6()
    if localPlayer == nil or localPlayer == 0 then
        return true
    end
    return _____8BFB_53D6_4EC7_6068_6587_5B57_5F00_5173(_____83B7_53D6_73A9_5BB6_7F16_53F7(localPlayer))
end
____exports["初始化QWERD显示开关"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____52A0_8F7D_672C_673A_663E_793A_914D_7F6E()
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____51B7_5374_663E_793A_547D_4EE4, _____5207_6362_51B7_5374_663E_793A_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____9B54_6CD5_6D88_8017_663E_793A_547D_4EE4, _____5207_6362_9B54_6CD5_6D88_8017_663E_793A_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____52A8_6001_6280_80FD_6587_672C_547D_4EE4, _____5207_6362_52A8_6001_6280_80FD_6587_672C_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____4EC7_6068_6587_5B57_547D_4EE4, _____5207_6362_4EC7_6068_6587_5B57_547D_4EE4_52A8_4F5C)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____4EC7_6068_6587_5B57_82F1_6587_547D_4EE4, _____5207_6362_4EC7_6068_6587_5B57_547D_4EE4_52A8_4F5C)
end
return ____exports
