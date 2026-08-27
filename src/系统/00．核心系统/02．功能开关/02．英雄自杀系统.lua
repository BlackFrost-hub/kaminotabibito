--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____83B7_53D6_672C_5730_73A9_5BB6 = jass.GetLocalPlayer
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_0["创建单位并登记排泄安全"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_1["立即移除单位并取消排泄登记"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_4.getRegisteredPlayerHero
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local KillUnit = jass.KillUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Player = jass.Player
local _____547D_4EE4 = "-zs"
local _____7CBE_795E_4F24_5BB3_547D_4EE4 = "-自杀"
local _____7CBE_795E_4F24_5BB3_6570_503C = 99999
local _____81EA_6740_4F24_5BB3_9A6C_7532_5355_4F4DID = stringToFourCCSafe("hfoo")
local _____81EA_6740_4F24_5BB3_9A6C_7532_73A9_5BB6 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____63D0_793A_65F6_95F4 = 5
local function _____4F7F_7528_81EA_6740_4F24_5BB3_9A6C_7532(hero)
    local avatar = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____81EA_6740_4F24_5BB3_9A6C_7532_73A9_5BB6,
        _____81EA_6740_4F24_5BB3_9A6C_7532_5355_4F4DID,
        GetUnitX(hero),
        GetUnitY(hero),
        0
    )
    if avatar == nil or avatar == 0 then
        return
    end
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = avatar,
        ["目标"] = hero,
        ["伤害"] = _____7CBE_795E_4F24_5BB3_6570_503C,
        ["伤害类型"] = jass.DAMAGE_TYPE_MIND,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "其他",
        ["标签"] = "测试命令-自杀",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    addDelayedCallback(
        500,
        function()
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(avatar)
        end
    )
end
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
    if command == _____7CBE_795E_4F24_5BB3_547D_4EE4 then
        _____4F7F_7528_81EA_6740_4F24_5BB3_9A6C_7532(hero)
        return
    end
    KillUnit(hero)
end
____exports["初始化自杀命令"] = function()
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____547D_4EE4, _____81EA_6740_547D_4EE4)
    _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____7CBE_795E_4F24_5BB3_547D_4EE4, _____81EA_6740_547D_4EE4)
end
return ____exports
