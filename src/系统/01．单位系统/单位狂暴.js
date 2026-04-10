/**
 * 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
 */
const jass = require("jass.common");
const { stringToFourCC } = require("系统.00．核心系统.01．封装函数");
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.index");
const { CameraShakeForPlayer } = require("系统.00．核心系统.13．镜头函数");
const idData = require("系统.02．物品系统.02．装备掉落表").default ?? {};
function typeIdToUnitId(typeId) {
    for (const id in idData) {
        if (stringToFourCC(id) === typeId)
            return id;
    }
    return undefined;
}
function onDeath() {
    const dying = jass.GetTriggerUnit();
    if (!dying)
        return;
    if (typeof jass.GetUnitTypeId !== "function")
        return;
    const typeId = jass.GetUnitTypeId(dying);
    const unitId = typeIdToUnitId(typeId);
    const entry = unitId ? idData[unitId] : undefined;
    const spawnRaw = entry?.berserkUnit ?? entry?.berserk;
    if (spawnRaw == null)
        return;
    const spawnUnitId = String(spawnRaw).trim();
    if (spawnUnitId === "")
        return;
    const BERSERK_PROC = 1; // 100% for test
    if (math.random(1, 10000) > BERSERK_PROC * 10000)
        return;
    // 先记录死亡单位的位置和面向（死亡瞬间仍有效），再创建单位并设成同一角度
    let x = 0;
    let y = 0;
    let facingDeg = 270;
    if (typeof jass.GetUnitX === "function" && typeof jass.GetUnitY === "function") {
        x = jass.GetUnitX(dying);
        y = jass.GetUnitY(dying);
    }
    if (typeof jass.GetUnitFacingDegrees === "function") {
        facingDeg = jass.GetUnitFacingDegrees(dying);
    }
    else if (typeof jass.GetUnitFacing === "function") {
        facingDeg = jass.GetUnitFacing(dying) * (180 / 3.14159265359);
    }
    const four = stringToFourCC(spawnUnitId.substring(0, 4));
    const owner = typeof jass.GetOwningPlayer === "function" ? jass.GetOwningPlayer(dying) : jass.Player(15);
    let created = undefined;
    if (typeof jass.CreateUnit === "function") {
        created = jass.CreateUnit(owner, four, x, y, facingDeg);
    }
    const killer = typeof jass.GetKillingUnit === "function" ? jass.GetKillingUnit() : undefined;
    const killerPlayer = killer && typeof jass.GetOwningPlayer === "function" ? jass.GetOwningPlayer(killer) : undefined;
    if (created && killerPlayer) {
        EXSetUnitFacing(created, facingDeg);
        CameraShakeForPlayer(killerPlayer, 20, 3.0);
    }
}
function init() {
    const trig = jass.CreateTrigger();
    const eventId = jass.EVENT_PLAYER_UNIT_DEATH ?? 52;
    for (let i = 0; i < 16; i++) {
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined);
    }
    const neutral = jass.Player?.(jass.PLAYER_NEUTRAL_AGGRESSIVE ?? 12);
    if (neutral != null)
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, undefined);
    const neutralPassive = jass.Player?.(jass.PLAYER_NEUTRAL_PASSIVE ?? 15);
    if (neutralPassive != null)
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, undefined);
    jass.TriggerAddAction(trig, onDeath);
}
init();
export {};
