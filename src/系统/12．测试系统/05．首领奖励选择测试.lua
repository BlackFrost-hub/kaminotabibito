--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____9996_9886_5956_52B1_914D_7F6E = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index")
local _____9996_9886_5956_52B1_754C_9762 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____9996_9886_5956_52B1_9886_53D6_72B6_6001 = require("系统.02．物品系统.18．首领奖励选择.02．领取状态")
local _____6D4B_8BD5_547D_4EE4 = "brtest"
local _____91CD_7F6E_6D4B_8BD5_547D_4EE4 = "brreset"
local GetPlayerId = jass.GetPlayerId
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local function _____63D0_793A(_____73A9_5BB6, _____6587_672C)
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        8,
        "[首领奖励测试] " .. _____6587_672C
    )
end
local function _____6253_5F00_5956_52B1_9009_62E9_6D4B_8BD5(_____73A9_5BB6)
    _____9996_9886_5956_52B1_754C_9762["打开首领奖励选择界面"](_____9996_9886_5956_52B1_914D_7F6E["瑟兰迪尔奖励池ID"], _____73A9_5BB6)
    _____63D0_793A(_____73A9_5BB6, "已打开正式首领奖励界面。")
end
local function _____91CD_7F6E_5956_52B1_9009_62E9_6D4B_8BD5_9886_53D6_72B6_6001(_____73A9_5BB6)
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local _____5DF2_6E05_9664 = _____9996_9886_5956_52B1_9886_53D6_72B6_6001["清除首领奖励领取记录"](_____9996_9886_5956_52B1_914D_7F6E["瑟兰迪尔奖励池ID"], _____73A9_5BB6ID)
    _____63D0_793A(_____73A9_5BB6, _____5DF2_6E05_9664 and "已重置本局领取记录，可再次测试。" or "当前没有领取记录。")
end
_____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____6D4B_8BD5_547D_4EE4, _____6253_5F00_5956_52B1_9009_62E9_6D4B_8BD5)
_____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____91CD_7F6E_6D4B_8BD5_547D_4EE4, _____91CD_7F6E_5956_52B1_9009_62E9_6D4B_8BD5_9886_53D6_72B6_6001)
return ____exports
