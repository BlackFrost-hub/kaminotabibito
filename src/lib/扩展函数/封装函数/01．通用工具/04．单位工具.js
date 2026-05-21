/**
 * 单位工具函数
 * 判断单位类型、查找单位等
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const g = require("jass.globals");
const groupScratchPool = [];
function acquireScratchGroup() {
    const scratch = groupScratchPool.pop();
    if (scratch)
        return scratch;
    return jass.CreateGroup();
}
function releaseScratchGroup(group) {
    if (!group || group === 0)
        return;
    while (true) {
        const unit = jass.FirstOfGroup(group);
        if (!unit || unit === 0)
            break;
        jass.GroupRemoveUnit(group, unit);
    }
    groupScratchPool.push(group);
}
/**
 * 判断单位是否为英雄单位
 */
export function isHeroUnit(unit) {
    if (!unit)
        return false;
    const utHero = jass.UNIT_TYPE_HERO ?? g.UNIT_TYPE_HERO;
    if (utHero != null) {
        return jass.IsUnitType(unit, utHero) === true;
    }
    return jass.GetHeroLevel(unit) > 0;
}
/**
 * 判断单位是否为玩家单位（玩家0-4）
 * 用于区分玩家单位和敌对单位
 *
 * @param unit 目标单位
 * @returns 是否为玩家单位
 */
export function isPlayerUnit(unit) {
    if (unit == null)
        return false;
    const owner = jass.GetOwningPlayer(unit);
    if (owner == null)
        return false;
    const playerId = jass.GetPlayerId(owner);
    return playerId >= 0 && playerId <= 4;
}
/**
 * 判断单位是否为马甲单位（古老单位）
 * 马甲单位造成的伤害，吸血/吸魔效果转给玩家英雄
 *
 * @param unit 目标单位
 * @returns 是否为马甲单位
 */
export function isAncientUnit(unit) {
    if (unit == null)
        return false;
    return jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT);
}
/**
 * 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
 */
export function isSpecialUnit(unit) {
    if (!unit)
        return true;
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return true;
    if (jass.IsUnitIllusion(unit))
        return true;
    return false;
}
/**
 * 查找指定玩家的英雄单位
 * @param playerId 玩家索引（0-15）
 * @returns 英雄单位，如果没有找到返回 null
 */
export function findHeroOfPlayer(playerId) {
    const group = jass.CreateGroup();
    jass.GroupEnumUnitsOfPlayer(group, jass.Player(playerId), null);
    const unit = jass.FirstOfGroup(group);
    jass.DestroyGroup(group);
    if (unit && isHeroUnit(unit))
        return unit;
    return null;
}
/**
 * 用 `FirstOfGroup + while` 在 Lua 层遍历单位组，并在遍历结束后恢复原组成员。
 * 不把业务 action 挂到 JASS 的 `ForGroup` 回调里，适合联机场景逐步替换原生 `ForGroup`。
 */
export function forEachUnitInGroup(group, action) {
    if (!group || typeof action !== "function")
        return;
    const scratch = acquireScratchGroup();
    try {
        while (true) {
            const unit = jass.FirstOfGroup(group);
            if (!unit || unit === 0)
                break;
            jass.GroupRemoveUnit(group, unit);
            jass.GroupAddUnit(scratch, unit);
            action(unit);
        }
        while (true) {
            const unit = jass.FirstOfGroup(scratch);
            if (!unit || unit === 0)
                break;
            jass.GroupRemoveUnit(scratch, unit);
            jass.GroupAddUnit(group, unit);
        }
    }
    finally {
        releaseScratchGroup(scratch);
    }
}
/**
 * 获取单位的攻击类型（Attack Type）
 * 单位状态0x23对应攻击类型，使用ConvertUnitState转换
 */
export function Ir_GetUnitAttackType(u) {
    return jass.R2I(japi.GetUnitState(u, jass.ConvertUnitState(0x23)));
}
export function Ir_SetUnitAttackType(u, atp) {
    japi.SetUnitState(u, jass.ConvertUnitState(0x23), atp);
}
/**
 * 获取单位所属玩家的ID
 * @param unit 单位句柄
 * @returns 玩家ID（0-11），如果单位无效则返回 -1
 */
export function getUnitOwnerId(unit) {
    if (!unit || unit === 0)
        return -1;
    const owner = jass.GetOwningPlayer(unit);
    if (!owner || owner === 0)
        return -1;
    return jass.GetPlayerId(owner);
}
/**
 * 检查句柄是否有效（非 null、非 0、非 undefined）
 * @param handle 任何句柄类型
 * @returns 是否有效
 */
export function isHandleValid(handle) {
    return handle != null && handle !== 0;
}
