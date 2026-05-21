/** @noSelfInFile */
/**
 * 特效封装函数
 * 创建和管理特效
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const effectDestroyCtxByTimerHid = {};
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const AddSpecialEffect = jass.AddSpecialEffect;
const DestroyEffect = jass.DestroyEffect;
const DzBindEffect = japi.DzBindEffect;
const DzUnbindEffect = japi.DzUnbindEffect;
const EXSetEffectSize = japi.EXSetEffectSize;
function onTimedEffectTimerExpire() {
    const t = jass.GetExpiredTimer();
    const eff = effectDestroyCtxByTimerHid[jass.GetHandleId(t)];
    delete effectDestroyCtxByTimerHid[jass.GetHandleId(t)];
    if (eff)
        jass.DestroyEffect(eff);
    safeDestroyTimer(t);
}
/**
 * 创建特效并在指定时间后自动销毁
 * @param modelPath 特效模型路径
 * @param x x坐标
 * @param y y坐标
 * @param z z坐标，可选，默认 0
 * @param duration 持续时间秒数，默认 2 秒
 * @returns 特效句柄
 */
export function createTimedEffect(modelPath, x, y, z = 0, duration = 2) {
    const eff = jass.AddSpecialEffect(modelPath, x, y);
    if (!eff)
        return null;
    if (z !== 0) {
        japi.EXSetEffectZ(eff, z);
    }
    const t = jass.CreateTimer();
    if (t) {
        effectDestroyCtxByTimerHid[jass.GetHandleId(t)] = eff;
        safeTimerStart(t, duration, false, onTimedEffectTimerExpire);
    }
    return eff;
}
const unitEffectMap = new Map();
function getUnitEffectHandleId(unit) {
    if (!unit)
        return 0;
    return jass.GetHandleId(unit);
}
function getUnitEffectKey(unit, effectKey) {
    const handleId = getUnitEffectHandleId(unit);
    if (!handleId)
        return "";
    return `${handleId}:${effectKey}`;
}
function destroyBoundEffect(effect) {
    if (!effect)
        return;
    jass.DestroyEffect(effect);
}
const boundEffectCtxByTimerHid = {};
function onBoundEffectTimerExpire() {
    const t = jass.GetExpiredTimer();
    const ctx = boundEffectCtxByTimerHid[jass.GetHandleId(t)];
    delete boundEffectCtxByTimerHid[jass.GetHandleId(t)];
    if (!ctx)
        return;
    const currentEffect = unitEffectMap.get(ctx.key);
    if (currentEffect === ctx.effect) {
        destroyBoundEffect(ctx.effect);
        unitEffectMap.delete(ctx.key);
    }
    safeDestroyTimer(t);
}
/**
 * 在单位上创建绑定特效
 * @param unit 目标单位
 * @param attachPoint 绑定点，如 "overhead"、"origin"、"chest"
 * @param modelPath 特效模型路径
 * @param duration 持续时间；不传则常驻，直到手动销毁
 * @returns 特效句柄；创建失败返回 null
 */
export function createUnitEffect(unit, attachPoint, modelPath, duration, effectKey = "default") {
    if (!unit)
        return null;
    const key = getUnitEffectKey(unit, effectKey);
    if (key === "")
        return null;
    const existingEffect = unitEffectMap.get(key);
    if (existingEffect) {
        destroyBoundEffect(existingEffect);
    }
    const effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint);
    if (!effect)
        return null;
    unitEffectMap.set(key, effect);
    if (duration != null && duration > 0) {
        const t = jass.CreateTimer();
        if (t) {
            boundEffectCtxByTimerHid[jass.GetHandleId(t)] = { key, effect };
            safeTimerStart(t, duration, false, onBoundEffectTimerExpire);
        }
    }
    return effect;
}
/**
 * 销毁单位上的绑定特效
 * @param unit 目标单位
 */
export function destroyUnitEffect(unit, effectKey = "default") {
    if (!unit)
        return;
    const key = getUnitEffectKey(unit, effectKey);
    if (key === "")
        return;
    const effect = unitEffectMap.get(key);
    if (effect) {
        destroyBoundEffect(effect);
    }
    unitEffectMap.delete(key);
}
const Dz绑定单位特效表 = new Map();
function 隐藏并销毁Dz绑定特效(effect) {
    if (!effect)
        return;
    DzUnbindEffect(effect);
    EXSetEffectSize(effect, 0);
    DestroyEffect(effect);
}
export function 创建Dz绑定单位特效(unit, attachPoint, modelPath, effectKey = "default") {
    if (!unit || modelPath === "")
        return null;
    const key = getUnitEffectKey(unit, effectKey);
    if (key === "")
        return null;
    const existingEffect = Dz绑定单位特效表.get(key);
    if (existingEffect) {
        隐藏并销毁Dz绑定特效(existingEffect);
    }
    const effect = AddSpecialEffect(modelPath, GetUnitX(unit), GetUnitY(unit));
    if (!effect)
        return null;
    DzBindEffect(unit, attachPoint, effect);
    Dz绑定单位特效表.set(key, effect);
    return effect;
}
export function 是否已有Dz绑定单位特效(unit, effectKey = "default") {
    if (!unit)
        return false;
    const key = getUnitEffectKey(unit, effectKey);
    if (key === "")
        return false;
    const effect = Dz绑定单位特效表.get(key);
    return effect != null && effect !== 0;
}
export function 销毁Dz绑定单位特效(unit, effectKey = "default") {
    if (!unit)
        return;
    const key = getUnitEffectKey(unit, effectKey);
    if (key === "")
        return;
    const effect = Dz绑定单位特效表.get(key);
    if (effect) {
        隐藏并销毁Dz绑定特效(effect);
    }
    Dz绑定单位特效表.delete(key);
}
