/**
 * 单位狂暴：装备掉落表里 berserk 非空的单位死亡时，按默认 6.25% 概率在原地创建指定单位、继承面向，并震动击杀者镜头。
 * 面向与镜头震动通过 JASS 全局 udg_TempUnit/udg_TempReal/udg_TempPlayer 调用 SetUnitFacingAndCameraNoise。
 */
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempUnit?: any; udg_TempReal?: number; udg_TempPlayer?: any; [k: string]: any };
const idData =
  (require("系统.装备.装备掉落表") as { default?: Record<string, { berserk?: string | number }> }).default ?? {};

function stringToFourCC(s: string): number {
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

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
  const entry = unitId ? (idData as Record<string, { berserk?: string | number }>)[unitId] : undefined;
  const berserkRaw = entry?.berserk;
  if (berserkRaw == null) return;
  const berserkId = String(berserkRaw).trim();
  if (berserkId === "") return;

  const BERSERK_PROC = 0.0625;
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

  const four = stringToFourCC(berserkId.substring(0, 4));
  const owner = typeof (jass as any).GetOwningPlayer === "function" ? (jass as any).GetOwningPlayer(dying) : (jass as any).Player(15);
  let created: any = undefined;
  if (typeof (jass as any).CreateUnit === "function") {
    created = (jass as any).CreateUnit(owner, four, x, y, facingDeg);
  }
  const killer = typeof (jass as any).GetKillingUnit === "function" ? (jass as any).GetKillingUnit() : undefined;
  const killerPlayer = killer && typeof (jass as any).GetOwningPlayer === "function" ? (jass as any).GetOwningPlayer(killer) : undefined;
  if (created && killerPlayer) {
    g.udg_TempUnit = created;
    g.udg_TempFacing = facingDeg;
    g.udg_TempPlayer = killerPlayer;
    jass.ExecuteFunc("UnitBerserk");
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
