/** @noSelfInFile */
/**
 * 控制抗性系统初始化
 *
 * 通过统一技能事件系统监听控制技能
 */
const jass = require("jass.common");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const { isExcludedFromControlResist, isControlAbility, isUnitControlled } = require("系统.05．Buff系统.01．控制抗性.01．控制检测");
const { calcReducedControlTime } = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算");
const { recastControlAbility } = require("系统.05．Buff系统.01．控制抗性.03．控制重施放");
const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心");
const ALLOWED_PLAYERS = [0, 1, 2, 3, 6, 7, jass.PLAYER_NEUTRAL_AGGRESSIVE];
const controlResistCtxByTimerHid = {};
function onControlResistTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = controlResistCtxByTimerHid[hid];
    delete controlResistCtxByTimerHid[hid];
    safeDestroyTimer(t);
    if (!ctx)
        return;
    if (isUnitControlled(ctx.target)) {
        recastControlAbility(ctx.caster, ctx.target, ctx.abilityId, ctx.duration);
    }
}
function isAllowedPlayer(player) {
    const id = jass.GetPlayerId(player);
    for (let i = 0; i < ALLOWED_PLAYERS.length; i++) {
        if (ALLOWED_PLAYERS[i] === id)
            return true;
    }
    return false;
}
function onSpellChannel(caster, abilityId) {
    if (!isAllowedPlayer(jass.GetOwningPlayer(caster)))
        return;
    if (isExcludedFromControlResist(caster))
        return;
    const target = jass.GetSpellTargetUnit();
    if (target == null)
        return;
    if (!isControlAbility(abilityId))
        return;
    if (!isUnitControlled(target))
        return;
    const duration = calcReducedControlTime(target, abilityId);
    const t = jass.CreateTimer();
    if (t) {
        controlResistCtxByTimerHid[jass.GetHandleId(t)] = { caster, target, abilityId, duration };
        safeTimerStart(t, 0, false, onControlResistTimerExpire);
    }
}
let _initialized = false;
export function initControlResist() {
    if (_initialized)
        return;
    _initialized = true;
    registerSpellChannelListener(onSpellChannel);
}
