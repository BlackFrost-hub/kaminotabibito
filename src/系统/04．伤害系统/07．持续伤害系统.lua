local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF["造成技能伤害"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
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
____exports["造成持续伤害"] = function(source, target, amount, damageType, ranged, attackType, weaponType, _____9009_9879)
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
    return _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = finalAmount,
        ["伤害类型"] = damageType,
        attack = false,
        ranged = ranged,
        attackType = attackType,
        weaponType = weaponType,
        ["来源类型"] = _____9009_9879 and _____9009_9879["来源类型"] or _____9009_9879 and _____9009_9879["装备技能类型"] or "单位技能",
        ["装备技能类型"] = _____9009_9879 and _____9009_9879["装备技能类型"],
        ["技能ID"] = _____9009_9879 and _____9009_9879["技能ID"],
        ["技能实例ID"] = _____9009_9879 and _____9009_9879["技能实例ID"],
        ["标签"] = _____9009_9879 and _____9009_9879["标签"],
        ["伤害形态"] = _____9009_9879 and _____9009_9879["伤害形态"] or "单体",
        ["参与技能伤害加成"] = _____9009_9879 and _____9009_9879["参与技能伤害加成"]
    })
end
return ____exports
