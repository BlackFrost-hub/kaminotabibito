--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
____exports["处理审判之锋长剑伤害修正"] = function(context)
    local damage = context.currentDamage
    if not (damage > 0) then
        return damage
    end
    if context.isPhysicalDamage ~= true or context.isNormalAttack ~= true then
        return damage
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["审判之锋长剑"]) then
        return damage
    end
    local maxHp = _____53D6_6700_5927_751F_547D(context.target)
    if not (maxHp > 0) then
        return damage
    end
    if _____53D6_5F53_524D_751F_547D(context.target) <= maxHp * 0.7 then
        return damage
    end
    return damage + damage * 0.2
end
return ____exports
