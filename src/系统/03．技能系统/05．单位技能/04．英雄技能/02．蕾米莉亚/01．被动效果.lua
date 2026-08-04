--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_2.YDWESetUnitAbilityStateSafe
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.06．死亡前置判断")
local _____5355_4F4D_6EE1_8DB3_51FB_6740_524D_7F6E_6761_4EF6 = ____require_result_3["单位满足击杀前置条件"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_4["蕾米莉亚单位技能配置"]
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
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
    YDWESetUnitAbilityStateSafe(killerUnit, _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.D["技能类型ID"], 1, 0)
end
local function _____5904_7406_857E_7C73_8389_4E9A_51FB_6740_88AB_52A8(dyingUnit, killingUnit)
    if not _____5355_4F4D_6EE1_8DB3_51FB_6740_524D_7F6E_6761_4EF6(dyingUnit) then
        return
    end
    _____5237_65B0_857E_7C73_8389_4E9A_6076_9B54_7A81_88AD_672C_6B21_51B7_5374(killingUnit)
end
____exports["注册蕾米莉亚击杀被动"] = function()
    registerDeathListener(_____5904_7406_857E_7C73_8389_4E9A_51FB_6740_88AB_52A8)
end
____exports["注册蕾米莉亚击杀被动"]()
return ____exports
