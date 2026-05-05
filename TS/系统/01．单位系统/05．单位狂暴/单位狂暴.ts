/**
 * 单位狂暴：装备掉落表里 `berserkUnit`（旧名 `berserk`）非空的单位死亡时，按默认 6.25% 概率在原地创建该四码单位、继承面向，并震动击杀者镜头。
 */
const jass = require("jass.common") as JassCommon;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.index") as {
  EXSetUnitFacing: (u: any, angle: number) => void;
};
const cameraShakeMod = require("lib.扩展函数.封装函数.07．镜头函数.index") as {
  CameraShakeForPlayer?: any;
};
const cameraShakeForPlayerRaw = cameraShakeMod.CameraShakeForPlayer as any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (cb: (dyingUnit: any, killingUnit: any) => void) => void;
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

function onDeath(dying: any, killer: any): void {
  if (dying == null) return;
  const typeId = (jass as any).GetUnitTypeId(dying) as number;
  const unitId = typeIdToUnitId(typeId);
  const entry = unitId ? (idData as Record<string, DropBerserkEntry>)[unitId] : undefined;
  const spawnRaw = entry?.berserkUnit ?? entry?.berserk;
  if (spawnRaw == null) return;
  const spawnUnitId = String(spawnRaw).trim();
  if (spawnUnitId === "") return;

  const BERSERK_PROC = 1; // 100% for test
  if ((jass as any).GetRandomInt(1, 10000) as number > BERSERK_PROC * 10000) return;

  let x = 0;
  let y = 0;
  let facingDeg = 270;
  x = (jass as any).GetUnitX(dying) as number;
  y = (jass as any).GetUnitY(dying) as number;
  facingDeg = ((jass as any).GetUnitFacing(dying) as number) * (180 / 3.14159265359);

  const four = stringToFourCC(spawnUnitId.substring(0, 4));
  const owner = (jass as any).GetOwningPlayer(dying);
  let created: any = undefined;
  created = (jass as any).CreateUnit(owner, four, x, y, facingDeg);
  const killerPlayer = killer ? (jass as any).GetOwningPlayer(killer) : undefined;
  if (created && killerPlayer) {
    EXSetUnitFacing(created, facingDeg);
    if (typeof cameraShakeForPlayerRaw === "function") cameraShakeForPlayerRaw(killerPlayer, 20, 3.0);
  }
}

registerDeathListener(onDeath);

export {};
