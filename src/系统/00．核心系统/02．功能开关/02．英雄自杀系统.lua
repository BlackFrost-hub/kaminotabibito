--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____83B7_53D6_672C_5730_73A9_5BB6 = jass.GetLocalPlayer
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local KillUnit = jass.KillUnit
local _____547D_4EE4 = "-zs"
local _____63D0_793A_65F6_95F4 = 5
local function _____81EA_6740_547D_4EE4(whichPlayer, command)
    local hero = getRegisteredPlayerHero(whichPlayer)
    if hero == nil or hero == 0 then
        jass:DisplayTimedTextToPlayer(
            whichPlayer,
            0,
            0.02,
            _____63D0_793A_65F6_95F4,
            "|cffffff00『系统提示』|r：没有找到英雄！"
        )
        return
    end
    if jass:IsUnitType(hero, jass.UNIT_TYPE_DEAD) then
        jass:DisplayTimedTextToPlayer(
            whichPlayer,
            0,
            0.02,
            _____63D0_793A_65F6_95F4,
            "|cffffff00『系统提示』|r：英雄已死亡！"
        )
        return
    end
    KillUnit(hero)
end
____exports["初始化自杀命令"] = function()
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____547D_4EE4, _____81EA_6740_547D_4EE4)
end
return ____exports
