/**
 * 装备移速（movespeed2）：不叠加，取当前装备中 movespeed2 最大值
 * 直接调用 TS 端 SGSS_SetState(unit, 9, value)；减速需传负数，故先减掉旧值再加新值。
 */
const jass = require("jass.common") as JassCommon;
const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { movespeed2?: number; name?: string; type?: string }> }).default;
const { fourCCToString } = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (four: number) => string;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (u: any, id: number, v: number) => void;
};

/** 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加） */
const applied: Record<string, number> = {};

function getUnitKey(unit: any): string {
  // Lua 环境 tostring(handle) 是稳定且唯一的（如 "unit:0x..."）
  return tostring(unit);
}

function getMaxMovespeed2(unit: any, ignoreItem?: any): number {
  const info = getMaxMovespeed2Info(unit, ignoreItem);
  return info.value;
}

/** 返回当前生效的移速值、提供该移速的装备名、以及带移速的装备件数（≥2 时才提示“只生效某装备”） */
function getMaxMovespeed2Info(unit: any, ignoreItem?: any): { value: number; name: string; count: number } {
  let max = 0;
  let name = "";
  let count = 0;
  if (typeof (jass as any).UnitItemInSlot !== "function") return { value: 0, name: "", count: 0 };
  if (typeof (jass as any).GetItemTypeId !== "function") return { value: 0, name: "", count: 0 };
  for (let slot = 0; slot <= 5; slot++) {
    const item = (jass as any).UnitItemInSlot(unit, slot);
    if (!item) continue;
    if (ignoreItem && item === ignoreItem) continue;
    const tid = (jass as any).GetItemTypeId(item) as number;
    const idStr = fourCCToString(tid);
    const entry = (itemsData as Record<string, { movespeed2?: number; type?: string; name?: string }>)[idStr];
    const typ = entry?.type;
    if (typ === "任务" || typ === "药剂" || typ === "食品") continue;
    const v = entry?.movespeed2;
    if (typeof v === "number" && v > 0) count++;
    if (typeof v === "number" && v > max) {
      max = v;
      name = (entry?.name != null ? String(entry.name).trim() : "") || "未知";
    }
  }
  return { value: max, name, count };
}

function applyMovespeed2(unit: any, newSpeed: number): void {
  const key = getUnitKey(unit);
  const oldSpeed = applied[key] != null ? applied[key] : 0;
  if (newSpeed === oldSpeed) return;
  if (oldSpeed !== 0) {
    SGSS_SetState(unit, 9, -oldSpeed);
  }
  if (newSpeed !== 0) {
    SGSS_SetState(unit, 9, newSpeed);
  }
  applied[key] = newSpeed;
}

function onItemChange(): void {
  const unit = jass.GetManipulatingUnit();
  if (!unit) return;
  if (typeof (jass as any).IsUnitType === "function" && jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return;
  const eventId = jass.GetTriggerEventId();
  const isPickup = eventId === ((jass as any).EVENT_PLAYER_UNIT_PICKUP_ITEM ?? 38);
  const isDrop = eventId === ((jass as any).EVENT_PLAYER_UNIT_DROP_ITEM ?? 39);
  const manipulated = typeof (jass as any).GetManipulatedItem === "function" ? (jass as any).GetManipulatedItem() : undefined;
  const newSpeed = isDrop ? getMaxMovespeed2(unit, manipulated) : getMaxMovespeed2(unit);
  const key = getUnitKey(unit);
  const cur = applied[key] != null ? applied[key] : 0;
  if (isPickup && newSpeed <= cur) return;
  applyMovespeed2(unit, newSpeed);
}

function init(): void {
  const trig = jass.CreateTrigger();
  const pickup = (jass as any).EVENT_PLAYER_UNIT_PICKUP_ITEM ?? 38;
  const drop = (jass as any).EVENT_PLAYER_UNIT_DROP_ITEM ?? 39;
  for (let i = 0; i <= 7; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), pickup, undefined!);
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), drop, undefined!);
  }
  const p13 = (jass as any).Player?.(13);
  if (p13 != null) {
    jass.TriggerRegisterPlayerUnitEvent(trig, p13, pickup, undefined!);
    jass.TriggerRegisterPlayerUnitEvent(trig, p13, drop, undefined!);
  }
  jass.TriggerAddAction(trig, onItemChange);
}

init();
/** 供装备系统在「当前装备加成」里显示移速：返回当前生效的移速值及提供该移速的装备名 */
export { getMaxMovespeed2Info };
