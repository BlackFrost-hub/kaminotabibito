/** @noSelfInFile */
/**
 * Star扩展库 - 单位判定与筛选函数
 *
 * 提供单位有效性、敌我、无敌、建筑、生命周期基础判断，以及常用筛选条件。
 */
const jass = require("jass.common");
const AVUL = 0x4176756c; // 'Avul'
const BVUL = 0x4276756c; // 'Bvul'
const BHDS = 0x42486473; // 'BHds'
const ALIVE_LIFE_THRESHOLD = 0.405;
export function SUC_IsValidUnit(u) {
    return u != null && u !== 0;
}
// 取当前枚举中的筛选单位。
export function SUC_GetFilterUnitOrNull() {
    return jass.GetFilterUnit();
}
// 读取单位当前生命值。
export function SUC_GetUnitLife(u) {
    if (!SUC_IsValidUnit(u))
        return 0;
    return jass.GetUnitState(u, jass.UNIT_STATE_LIFE);
}
// 判断单位是否还活着。
export function SUC_IsUnitAlive(u) {
    return SUC_GetUnitLife(u) > ALIVE_LIFE_THRESHOLD;
}
// 判断单位是否为建筑。
export function SUC_IsUnitStructure(u) {
    if (!SUC_IsValidUnit(u))
        return false;
    return jass.IsUnitType(u, jass.UNIT_TYPE_STRUCTURE);
}
// 判断单位是否带无敌相关状态。
export function SUC_IsUnitInvincible(u) {
    if (!SUC_IsValidUnit(u))
        return false;
    const avul = jass.GetUnitAbilityLevel(u, AVUL);
    const bvul = jass.GetUnitAbilityLevel(u, BVUL);
    const bhds = jass.GetUnitAbilityLevel(u, BHDS);
    return avul !== 0 || bvul !== 0 || bhds !== 0;
}
// 判断目标是否敌对来源单位。
export function SUC_IsUnitEnemyToUnit(target, source) {
    if (!SUC_IsValidUnit(target) || !SUC_IsValidUnit(source))
        return false;
    return jass.IsUnitEnemy(target, jass.GetOwningPlayer(source));
}
// 判断目标是否友方来源单位。
export function SUC_IsUnitAllyToUnit(target, source) {
    if (!SUC_IsValidUnit(target) || !SUC_IsValidUnit(source))
        return false;
    return !jass.IsUnitEnemy(target, jass.GetOwningPlayer(source));
}
// 统一基础目标过滤。
export function SUC_MatchBasicTarget(target, source, wantEnemy) {
    if (!SUC_IsValidUnit(target) || !SUC_IsValidUnit(source))
        return false;
    if (SUC_IsUnitInvincible(target))
        return false;
    if (SUC_IsUnitStructure(target))
        return false;
    if (!SUC_IsUnitAlive(target))
        return false;
    return wantEnemy
        ? SUC_IsUnitEnemyToUnit(target, source)
        : SUC_IsUnitAllyToUnit(target, source);
}
// 枚举里筛敌方有效目标。
export function SUF_Base_1(u) {
    if (!SUC_IsValidUnit(u))
        return false;
    const fu = SUC_GetFilterUnitOrNull();
    return SUC_MatchBasicTarget(fu, u, true);
}
// 枚举里筛友方有效目标。
export function SUF_Base_2(u) {
    if (!SUC_IsValidUnit(u))
        return false;
    const fu = SUC_GetFilterUnitOrNull();
    return SUC_MatchBasicTarget(fu, u, false);
}
// 直接判断敌方有效目标。
export function SUF_Base_3(fu, u) {
    return SUC_MatchBasicTarget(fu, u, true);
}
