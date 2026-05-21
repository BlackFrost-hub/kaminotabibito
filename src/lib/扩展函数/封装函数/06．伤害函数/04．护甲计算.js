/** @noSelfInFile */
/**
 * 护甲计算函数
 * 护甲减伤公式、穿透计算等
 */
/**
 * 护甲减伤系数（游戏常数，默认0.06）
 * 公式：减伤比例 = 护甲 * 系数 / (护甲 * 系数 + 1)
 * 等价于：减伤比例 = 护甲 / (护甲 + 1/系数) = 护甲 / (护甲 + 50)
 */
const ARMOR_FACTOR = 0.06;
/**
 * 计算护甲减伤比例
 * 公式：减伤比例 = 护甲 / (护甲 + 50)
 *
 * @param armor 护甲值
 * @returns 减伤比例（0~1）
 */
export function calcArmorReduction(armor) {
    if (armor <= 0)
        return 0;
    return armor * ARMOR_FACTOR / (armor * ARMOR_FACTOR + 1);
}
/**
 * 计算穿透后的护甲减伤
 *
 * @param originalArmor 原始护甲
 * @param armorPierce 护甲穿透比例（0~1）
 * @param ignoreArmor 是否无视护甲
 * @returns 减伤比例
 */
export function calcPiercedArmorReduction(originalArmor, armorPierce, ignoreArmor) {
    // 无视护甲：护甲视为0.01
    if (ignoreArmor) {
        return calcArmorReduction(0.01);
    }
    // 有护甲穿透：护甲降低
    let effectiveArmor = originalArmor;
    if (armorPierce > 0) {
        effectiveArmor = originalArmor * (1 - armorPierce);
    }
    return calcArmorReduction(effectiveArmor);
}
/**
 * 根据减伤比例反算护甲值
 *
 * @param reduction 减伤比例（0~1）
 * @returns 护甲值
 */
export function calcArmorFromReduction(reduction) {
    if (reduction <= 0)
        return 0;
    if (reduction >= 1)
        return Infinity;
    // reduction = armor * 0.06 / (armor * 0.06 + 1)
    // reduction * (armor * 0.06 + 1) = armor * 0.06
    // reduction * armor * 0.06 + reduction = armor * 0.06
    // reduction = armor * 0.06 - reduction * armor * 0.06
    // reduction = armor * 0.06 * (1 - reduction)
    // armor = reduction / (0.06 * (1 - reduction))
    return reduction / (ARMOR_FACTOR * (1 - reduction));
}
