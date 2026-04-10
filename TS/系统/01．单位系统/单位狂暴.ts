/**
 * 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
 */
const jass = require("jass.common") as JassCommon;
const { stringToFourCC } = require("系统.00．核心系统.01．封装函数") as {
  stringToFourCC: (s: string) => number;
};
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.index") as {
  EXSetUnitFacing: (u: any, angle: number) => void;
};
const { CameraShakeForPlayer } = require("系统.00．核心系统.13．镜头函数") as {
  CameraShakeForPlayer: (p: any, magnitude: number, duration: number) => void;
};
type DropBerserkEntry = { berserkUnit?: string | number; berserk?: string | number };
const idData =
  (require("系统.02．物品系统.02．装备掉落表") as { default?: Record<string, DropBerserkEntry> }).default ?? {};

function typeIdToUnitId(typeId: number): string | undefined {
  for (const id in idData) {
    if (stringToFourCC(id) === typeId) return id;
  }
  return undefined;
}

function onDeath(): void {
  const dying = jass.GetTriggerUnit();
  if (!dying) return;
  if (typeof (jass as any).GetUnitTypeId !== "function") return;
  const typeId = (jass as any).GetUnitTypeId(dying) as number;
  const unitId = typeIdToUnitId(typeId);
  const entry = unitId ? (idData as Record<string, DropBerserkEntry>)[unitId] : undefined;
  const spawnRaw = entry?.berserkUnit ?? entry?.berserk;
  if (spawnRaw == null) return;
  const spawnUnitId = String(spawnRaw).trim();
  if (spawnUnitId === "") return;

  const BERSERK_PROC = 1; // 100% for test
  if ((math as any).random(1, 10000) as number > BERSERK_PROC * 10000) return;

  // 先记录死亡单位的位置和面向（死亡瞬间仍有效），再创建单位并设成同一角度
  let x = 0;
  let y = 0;
  let facingDeg = 270;
  if (typeof (jass as any).GetUnitX === "function" && typeof (jass as any).GetUnitY === "function") {
    x = (jass as any).GetUnitX(dying) as number;
    y = (jass as any).GetUnitY(dying) as number;
  }
  if (typeof (jass as any).GetUnitFacingDegrees === "function") {
    facingDeg = (jass as any).GetUnitFacingDegrees(dying) as number;
  } else if (typeof (jass as any).GetUnitFacing === "function") {
    facingDeg = ((jass as any).GetUnitFacing(dying) as number) * (180 / 3.14159265359);
  }

  const four = stringToFourCC(spawnUnitId.substring(0, 4));
  const owner = typeof (jass as any).GetOwningPlayer === "function" ? (jass as any).GetOwningPlayer(dying) : (jass as any).Player(15);
  let created: any = undefined;
  if (typeof (jass as any).CreateUnit === "function") {
    created = (jass as any).CreateUnit(owner, four, x, y, facingDeg);
  }
  const killer = typeof (jass as any).GetKillingUnit === "function" ? (jass as any).GetKillingUnit() : undefined;
  const killerPlayer = killer && typeof (jass as any).GetOwningPlayer === "function" ? (jass as any).GetOwningPlayer(killer) : undefined;
  if (created && killerPlayer) {
    EXSetUnitFacing(created, facingDeg);
    CameraShakeForPlayer(killerPlayer, 20, 3.0);
  }
}

function init(): void {
  const trig = jass.CreateTrigger();
  const eventId = (jass as any).EVENT_PLAYER_UNIT_DEATH ?? 52;
  for (let i = 0; i < 16; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined!);
  }
  const neutral = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_AGGRESSIVE ?? 12);
  if (neutral != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, undefined!);
  const neutralPassive = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_PASSIVE ?? 15);
  if (neutralPassive != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, undefined!);
  jass.TriggerAddAction(trig, onDeath);
}

init();
export {};
