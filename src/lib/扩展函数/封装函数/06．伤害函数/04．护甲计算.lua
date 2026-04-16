--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 护甲减伤系数（游戏常数，默认0.06）
-- 公式：减伤比例 = 护甲 * 系数 / (护甲 * 系数 + 1)
-- 等价于：减伤比例 = 护甲 / (护甲 + 1/系数) = 护甲 / (护甲 + 50)
local ARMOR_FACTOR = 0.06
--- 计算护甲减伤比例
-- 公式：减伤比例 = 护甲 / (护甲 + 50)
-- 
-- @param armor 护甲值
-- @returns 减伤比例（0~1）
function ____exports.calcArmorReduction(armor)
    if armor <= 0 then
        return 0
    end
    return armor * ARMOR_FACTOR / (armor * ARMOR_FACTOR + 1)
end
--- 计算穿透后的护甲减伤
-- 
-- @param originalArmor 原始护甲
-- @param armorPierce 护甲穿透比例（0~1）
-- @param ignoreArmor 是否无视护甲
-- @returns 减伤比例
function ____exports.calcPiercedArmorReduction(originalArmor, armorPierce, ignoreArmor)
    if ignoreArmor then
        return ____exports.calcArmorReduction(0.01)
    end
    local effectiveArmor = originalArmor
    if armorPierce > 0 then
        effectiveArmor = originalArmor * (1 - armorPierce)
    end
    return ____exports.calcArmorReduction(effectiveArmor)
end
--- 根据减伤比例反算护甲值
-- 
-- @param reduction 减伤比例（0~1）
-- @returns 护甲值
function ____exports.calcArmorFromReduction(reduction)
    if reduction <= 0 then
        return 0
    end
    if reduction >= 1 then
        return math.huge
    end
    return reduction / (ARMOR_FACTOR * (1 - reduction))
end
return ____exports
