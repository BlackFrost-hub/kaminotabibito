local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
____exports["持续伤害属性名"] = "持续伤害"
____exports["读取持续伤害加成"] = function(source)
    if source == nil or source == 0 then
        return 0
    end
    local owner = jass.GetOwningPlayer(source)
    if owner == nil then
        return 0
    end
    local value = __TS__Number(YDUserDataGetSafe("player", owner, ____exports["持续伤害属性名"], "real")) or 0
    return value > -0.95 and value or -0.95
end
____exports["计算持续伤害最终值"] = function(source, amount)
    if not (amount > 0) then
        return 0
    end
    local finalAmount = amount * (1 + ____exports["读取持续伤害加成"](source))
    return finalAmount > 0 and finalAmount or 0
end
____exports["造成持续伤害"] = function(source, target, amount, damageType, ranged, attackType, weaponType)
    if ranged == nil then
        ranged = false
    end
    if attackType == nil then
        attackType = ATTACK_TYPE_NORMAL
    end
    if weaponType == nil then
        weaponType = WEAPON_TYPE_WHOKNOWS
    end
    local finalAmount = ____exports["计算持续伤害最终值"](source, amount)
    if not (finalAmount > 0) then
        return false
    end
    return UnitDamageTarget(
        source,
        target,
        finalAmount,
        false,
        ranged,
        attackType,
        damageType,
        weaponType
    )
end
return ____exports
