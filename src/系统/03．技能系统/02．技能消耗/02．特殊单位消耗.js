/** @noSelfInFile */
/**
 * 特殊单位消耗处理
 */
const jass = require("jass.common");
const { 是否指定玩家英雄 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具");
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接");
const { EDWARD_HERO_ID, SPECIAL_UNIT_COST_CONFIG, } = require("系统.03．技能系统.02．技能消耗.00．消耗常量");
/**
 * 获取爱德华单位。
 * 通过玩家英雄注册桥接查当前已登记的玩家英雄，再按配置 rawcode 过滤。
 */
export function getEdwardUnit() {
    for (let playerId = 0; playerId <= 4; playerId++) {
        const hero = heroBridge.getRegisteredPlayerHero(jass.Player(playerId));
        if (是否指定玩家英雄(hero, EDWARD_HERO_ID))
            return hero;
    }
    return null;
}
/**
 * 检查单位是否为爱德华。
 */
export function isEdwardUnit(unit) {
    return 是否指定玩家英雄(unit, EDWARD_HERO_ID);
}
/**
 * 爱德华被动处理：扣血代替扣蓝。
 */
export function handleEdwardPassiveCost(unit, manaCost) {
    if (!isEdwardUnit(unit))
        return;
    const currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE);
    const lifeKeep = currentLife - 1;
    const deductAmount = manaCost < lifeKeep ? manaCost : lifeKeep;
    if (deductAmount > 0) {
        jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount);
    }
}
