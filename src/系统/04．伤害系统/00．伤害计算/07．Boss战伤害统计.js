/** @noSelfInFile */
/**
 * Boss战伤害统计
 *
 * 对齐：JASS/jass复制粘贴/伤害显示.j 末尾统计逻辑
 * - 玩家对 Boss战单位造成伤害 -> 累计到玩家「造成伤害」
 * - Boss战单位对玩家（非召唤物）造成伤害 -> 累计到玩家「承受伤害」
 */
const jass = require("jass.common");
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const GetOwningPlayer = jass.GetOwningPlayer;
const IsPlayerInForce = jass.IsPlayerInForce;
const IsUnitType = jass.IsUnitType;
const GetUnitState = jass.GetUnitState;
const R2I = jass.R2I;
const UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const Boss战表 = "Boss战";
const Boss战单位 = "单位";
const 玩家组表 = "玩家";
const 玩家组势力 = "玩家组";
const 造成伤害 = "造成伤害";
const 承受伤害 = "承受伤害";
let 已初始化 = false;
function 最小实数(a, b) {
    if (a <= b)
        return a;
    return b;
}
function 转为统计整数伤害(applied) {
    if (!(applied > 0))
        return 0;
    // 与旧 JASS 对齐：R2I(GetEventDamage())，不做四舍五入。
    return R2I(applied);
}
function 添加玩家统计(whichPlayer, attrName, delta) {
    if (whichPlayer == null || !(delta > 0))
        return;
    const current = YDUserDataGet("player", whichPlayer, attrName, "real");
    const base = typeof current === "number" ? current : 0;
    YDUserDataSet("player", whichPlayer, attrName, "real", base + delta);
}
function Boss战最终伤害(target, attacker, applied) {
    if (target == null || attacker == null)
        return;
    const damageInt = 转为统计整数伤害(applied);
    if (damageInt <= 0)
        return;
    const bossBattleUnit = YDUserDataGet("string", Boss战表, Boss战单位, "unit");
    if (bossBattleUnit == null)
        return;
    const playerForce = YDUserDataGet("string", 玩家组表, 玩家组势力, "force");
    if (playerForce == null)
        return;
    if (target === bossBattleUnit) {
        const attackerPlayer = GetOwningPlayer(attacker);
        if (IsPlayerInForce(attackerPlayer, playerForce)) {
            const dealt = 最小实数(GetUnitState(target, UNIT_STATE_LIFE), damageInt);
            添加玩家统计(attackerPlayer, 造成伤害, dealt);
        }
    }
    if (attacker === bossBattleUnit && !IsUnitType(target, UNIT_TYPE_SUMMONED)) {
        const targetPlayer = GetOwningPlayer(target);
        if (IsPlayerInForce(targetPlayer, playerForce)) {
            // 与旧 JASS 保持一致：承受伤害分支用的是攻击者（Boss）当前生命做上限裁剪。
            const taken = 最小实数(GetUnitState(attacker, UNIT_STATE_LIFE), damageInt);
            添加玩家统计(targetPlayer, 承受伤害, taken);
        }
    }
}
export function initBossBattleDamageStats() {
    if (已初始化)
        return;
    已初始化 = true;
    registerAppliedFinalDamageListener(Boss战最终伤害);
}
