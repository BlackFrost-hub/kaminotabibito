/** @noSelfInFile */
/**
 * 便捷短函数 - 不死、等一次性效果
 */
const jass = require("jass.common");
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调");
const GetHandleId = jass.GetHandleId;
const GetUnitState = jass.GetUnitState;
const 不死集合 = {};
function on不死伤害修正(context) {
    const target = context.target;
    if (target == null || target === 0)
        return context.currentDamage;
    const 单位ID = GetHandleId(target);
    if (单位ID === 0)
        return context.currentDamage;
    if (不死集合[单位ID] == null)
        return context.currentDamage;
    const 当前血量 = GetUnitState(target, jass.UNIT_STATE_LIFE);
    if (当前血量 - context.currentDamage < 1) {
        return 当前血量 - 1;
    }
    return context.currentDamage;
}
let 修正器已注册 = false;
function 确保修正器注册() {
    if (修正器已注册)
        return;
    修正器已注册 = true;
    registerDamageModifier(on不死伤害修正, 60);
}
/**
 * 令单位进入不死状态，受到致命伤害时保留1点血量。
 * 需调用方自行管理生命周期（搭配Buff到期回调等调用 移除单位不死）。
 */
export function 令单位不死(单位) {
    if (单位 == null || 单位 === 0)
        return;
    确保修正器注册();
    const 单位ID = GetHandleId(单位);
    if (单位ID === 0)
        return;
    不死集合[单位ID] = true;
}
/**
 * 移除单位的不死状态。
 */
export function 移除单位不死(单位) {
    if (单位 == null || 单位 === 0)
        return;
    const 单位ID = GetHandleId(单位);
    if (单位ID === 0)
        return;
    delete 不死集合[单位ID];
}
/**
 * 查询单位是否处于不死状态。
 */
export function 单位是否不死(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    const 单位ID = GetHandleId(单位);
    return 单位ID !== 0 && 不死集合[单位ID] != null;
}
