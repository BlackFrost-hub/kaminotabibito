local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_1.registerPlayerHeroListener
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_2["调整玩家属性"]
local ____require_result_3 = require("平台扩展API动作")
local _____81EA_5B9A_4E49_6307_5B9A_5355_4F4D_7684_5C0F_5730_56FE_56FE_6807 = ____require_result_3["自定义指定单位的小地图图标"]
local _____5F00_542F__5173_95ED_81EA_5B9A_4E49_6307_5B9A_5355_4F4D_7684_5C0F_5730_56FE_56FE_6807 = ____require_result_3["开启_关闭自定义指定单位的小地图图标"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_4.YDWESetUnitAbilityStateSafe
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.06．死亡前置判断")
local _____5355_4F4D_6EE1_8DB3_51FB_6740_524D_7F6E_6761_4EF6 = ____require_result_5["单位满足击杀前置条件"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_6["蕾米莉亚单位技能配置"]
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local Player = jass.Player
local UnitSetUsesAltIcon = jass.UnitSetUsesAltIcon
local _____5DF2_5E94_7528_857E_7C73_8389_4E9A_88AB_52A8_82F1_96C4 = {}
local function _____662F_857E_7C73_8389_4E9A(hero)
    return hero ~= nil and hero ~= 0 and GetUnitTypeId(hero) == _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]
end
local function _____6E05_7406_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8(hero)
    if hero == nil or hero == 0 then
        return
    end
    local _____88AB_52A8 = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["被动"]
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "伤害吸血上限", -_____88AB_52A8["伤害吸血上限"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "伤害吸血", -_____88AB_52A8["伤害吸血"])
    UnitSetUsesAltIcon(false, hero)
    _____5F00_542F__5173_95ED_81EA_5B9A_4E49_6307_5B9A_5355_4F4D_7684_5C0F_5730_56FE_56FE_6807(hero, false)
end
local function _____66F4_65B0_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8(player, hero)
    if player == nil or player == 0 then
        return
    end
    local playerId = GetPlayerId(player)
    local previousHero = _____5DF2_5E94_7528_857E_7C73_8389_4E9A_88AB_52A8_82F1_96C4[playerId]
    if previousHero == hero then
        return
    end
    if previousHero ~= nil and previousHero ~= 0 then
        _____6E05_7406_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8(previousHero)
    end
    __TS__Delete(_____5DF2_5E94_7528_857E_7C73_8389_4E9A_88AB_52A8_82F1_96C4, playerId)
    if not _____662F_857E_7C73_8389_4E9A(hero) then
        return
    end
    local _____88AB_52A8 = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["被动"]
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "伤害吸血上限", _____88AB_52A8["伤害吸血上限"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "伤害吸血", _____88AB_52A8["伤害吸血"])
    if _____88AB_52A8["开启小地图特殊标志"] then
        UnitSetUsesAltIcon(true, hero)
    end
    if _____88AB_52A8["小地图图标路径"] ~= "" then
        _____81EA_5B9A_4E49_6307_5B9A_5355_4F4D_7684_5C0F_5730_56FE_56FE_6807(hero, _____88AB_52A8["小地图图标路径"])
        _____5F00_542F__5173_95ED_81EA_5B9A_4E49_6307_5B9A_5355_4F4D_7684_5C0F_5730_56FE_56FE_6807(hero, true)
    end
    _____5DF2_5E94_7528_857E_7C73_8389_4E9A_88AB_52A8_82F1_96C4[playerId] = hero
end
local function _____521D_59CB_5316_5DF2_6709_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8()
    do
        local i = 0
        while i < 16 do
            local player = Player(i)
            _____66F4_65B0_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8(
                player,
                getRegisteredPlayerHero(player)
            )
            i = i + 1
        end
    end
end
local function _____5237_65B0_857E_7C73_8389_4E9A_6076_9B54_7A81_88AD_672C_6B21_51B7_5374(killerUnit)
    if killerUnit == nil or killerUnit == 0 then
        return
    end
    if GetUnitTypeId(killerUnit) ~= _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"] then
        return
    end
    local owner = GetOwningPlayer(killerUnit)
    if owner == nil or owner == 0 then
        return
    end
    if getRegisteredPlayerHero(owner) ~= killerUnit then
        return
    end
    YDWESetUnitAbilityStateSafe(killerUnit, _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["额外D"]["技能类型ID"], 1, 0)
end
local function _____5904_7406_857E_7C73_8389_4E9A_51FB_6740_88AB_52A8(dyingUnit, killingUnit)
    if not _____5355_4F4D_6EE1_8DB3_51FB_6740_524D_7F6E_6761_4EF6(dyingUnit) then
        return
    end
    _____5237_65B0_857E_7C73_8389_4E9A_6076_9B54_7A81_88AD_672C_6B21_51B7_5374(killingUnit)
end
____exports["注册蕾米莉亚击杀被动"] = function()
    registerPlayerHeroListener(_____66F4_65B0_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8)
    registerDeathListener(_____5904_7406_857E_7C73_8389_4E9A_51FB_6740_88AB_52A8)
    _____521D_59CB_5316_5DF2_6709_857E_7C73_8389_4E9A_9009_62E9_88AB_52A8()
end
____exports["注册蕾米莉亚击杀被动"]()
return ____exports
