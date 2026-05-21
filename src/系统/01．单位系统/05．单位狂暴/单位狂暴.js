/** @noSelfInFile */
/**
 * 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
 */
const jass = require("jass.common");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.index");
const cameraShakeMod = require("lib.扩展函数.封装函数.07．镜头函数.index");
const cameraShakeForPlayerRaw = cameraShakeMod.CameraShakeForPlayer;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
const idData = require("系统.02．物品系统.02．装备掉落表").default ?? {};
function typeIdToUnitId(typeId) {
    for (const id in idData) {
        if (stringToFourCC(id) === typeId)
            return id;
    }
    return undefined;
}
function onDeath(dying, killer) {
    if (dying == null)
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
    if (jass.GetRandomInt(1, 10000) > BERSERK_PROC * 10000)
        return;
    let x = 0;
    let y = 0;
    let facingDeg = 270;
    x = jass.GetUnitX(dying);
    y = jass.GetUnitY(dying);
    facingDeg = jass.GetUnitFacing(dying) * (180 / 3.14159265359);
    const four = stringToFourCC(spawnUnitId.substring(0, 4));
    const owner = jass.GetOwningPlayer(dying);
    let created = undefined;
    created = jass.CreateUnit(owner, four, x, y, facingDeg);
    const killerPlayer = killer ? jass.GetOwningPlayer(killer) : undefined;
    if (created && killerPlayer) {
        EXSetUnitFacing(created, facingDeg);
        if (typeof cameraShakeForPlayerRaw === "function")
            cameraShakeForPlayerRaw(killerPlayer, 20, 3.0);
    }
}
registerDeathListener(onDeath);
export {};
