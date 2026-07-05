--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 落点打击系统 - 共享类型、常量与工具函数
local jass = require("jass.common")
____exports.AddSpecialEffect = jass.AddSpecialEffect
____exports.DestroyEffect = jass.DestroyEffect
____exports.GetRandomReal = jass.GetRandomReal
____exports["默认落雷特效"] = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
____exports["默认攻击类型"] = jass.ATTACK_TYPE_NORMAL
____exports["默认伤害类型"] = jass.DAMAGE_TYPE_NORMAL
____exports["默认武器类型"] = jass.WEAPON_TYPE_WHOKNOWS
____exports["落点打击实例表"] = {}
____exports["下一个落点打击ID"] = 0
____exports["推进下一个落点打击ID"] = function()
    ____exports["下一个落点打击ID"] = ____exports["下一个落点打击ID"] + 1
    return ____exports["下一个落点打击ID"]
end
____exports["单位是否受影响"] = function(_____76EE_6807_5355_4F4D, _____53C2_6570)
    local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
    local isUnitEnemy = ____require_result_0.isUnitEnemy
    local isUnitAlly = ____require_result_0.isUnitAlly
    local _____5F71_54CD_76EE_6807 = _____53C2_6570["影响目标"] or "敌方"
    local _____6240_6709_8005 = _____53C2_6570["所有者"]
    if _____5F71_54CD_76EE_6807 == "全部" then
        return true
    end
    if _____6240_6709_8005 == nil or _____6240_6709_8005 == 0 then
        return true
    end
    if _____5F71_54CD_76EE_6807 == "敌方" then
        return isUnitEnemy(_____76EE_6807_5355_4F4D, _____6240_6709_8005)
    end
    return isUnitAlly(_____76EE_6807_5355_4F4D, _____6240_6709_8005)
end
return ____exports
