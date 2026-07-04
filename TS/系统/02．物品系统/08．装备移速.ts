/** @noSelfInFile */

/**
 * 装备移速（movespeed2）：不叠加，取当前装备中 movespeed2 最大值
 * 直接调用 TS 端 SGSS_SetState(unit, 9, value)；减速需传负数，故先减掉旧值再加新值。
 */
const jass = require("jass.common") as JassCommon;
const GetItemTypeId = (jass as any).GetItemTypeId as (this: void, item: any) => number;
const GetUnitDefaultMoveSpeed = (jass as any).GetUnitDefaultMoveSpeed as (this: void, unit: any) => number;
const GetUnitMoveSpeed = (jass as any).GetUnitMoveSpeed as (this: void, unit: any) => number;
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { movespeed2?: number; name?: string; type?: string }> }).default;
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, u: any, id: number, v: number) => void;
};
const { SOS_SetUnitSpeed, SOS_GetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_SetUnitSpeed: (this: void, unit: any, speed: number) => void;
  SOS_GetUnitSpeed: (this: void, unit: any) => number;
  SOS_UnSetUnitSpeed: (this: void, unit: any) => void;
};
const { IsUnitIllusionBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitIllusionBJ: (unit: any) => boolean;
};
const R2I: any = (jass as any).R2I;
const stringChar: any = string.char;

/** 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加） */
const applied: Record<string, number> = {};
const EQUIP_SPEED_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 13] as const;
const 引擎移速上限 = 522;

function getUnitKey(unit: any): string {
  // Lua 环境 tostring(handle) 是稳定且唯一的（如 "unit:0x..."）
  return tostring(unit);
}

function fourCCToStringCompat(four: number): string {
  const c1 = stringChar(four % 256);
  const c2 = stringChar(R2I(four / 256) % 256);
  const c3 = stringChar(R2I(four / 65536) % 256);
  const c4 = stringChar(R2I(four / 16777216) % 256);
  return `${String(c4)}${String(c3)}${String(c2)}${String(c1)}`;
}

function getMaxMovespeed2(unit: any, ignoreItem?: any): number {
  const info = getMaxMovespeed2Info(unit, ignoreItem);
  return normalizeMovespeed2(unit, info.value);
}

function normalizeMovespeed2(unit: any, value: number): number {
  if (!(value > 0)) return 0;
  if (value < 1) return GetUnitDefaultMoveSpeed(unit) * value;
  return value;
}

function 取单位真实移速(unit: any): number {
  const 突破移速 = SOS_GetUnitSpeed(unit) || 0;
  if (突破移速 > 引擎移速上限) return 突破移速;
  return GetUnitMoveSpeed(unit) || 0;
}

function 同步装备移速突破(unit: any, 变化前真实移速: number, 移速差值: number): void {
  const 变化后真实移速 = 变化前真实移速 + 移速差值;
  if (变化后真实移速 > 引擎移速上限) {
    SOS_SetUnitSpeed(unit, 变化后真实移速);
  } else {
    SOS_UnSetUnitSpeed(unit);
  }
}

/** 返回当前生效的移速值、提供该移速的装备名、以及带移速的装备件数（≥2 时才提示“只生效某装备”） */
function getMaxMovespeed2Info(unit: any, ignoreItem?: any): { value: number; name: string; count: number } {
  let max = 0;
  let name = "";
  let count = 0;
  for (let slot = 0; slot <= 5; slot++) {
    const item = (jass as any).UnitItemInSlot(unit, slot);
    if (!item) continue;
    if (ignoreItem && item === ignoreItem) continue;
    const tid = GetItemTypeId(item) as number;
    const idStr = fourCCToStringCompat(tid);
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
  const 变化前真实移速 = 取单位真实移速(unit);
  const 移速差值 = newSpeed - oldSpeed;
  if (oldSpeed !== 0) {
    SGSS_SetState(unit, 9, -oldSpeed);
  }
  if (newSpeed !== 0) {
    SGSS_SetState(unit, 9, newSpeed);
  }
  同步装备移速突破(unit, 变化前真实移速, 移速差值);
  applied[key] = newSpeed;
}

function onItemChange(unit: any, item: any, isPickup: boolean): void {
  if (unit === null || unit === 0) return;
  if (jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (IsUnitIllusionBJ(unit)) return;
  const isDrop = !isPickup;
  const newSpeed = isDrop ? getMaxMovespeed2(unit, item) : getMaxMovespeed2(unit);
  const key = getUnitKey(unit);
  const cur = applied[key] != null ? applied[key] : 0;
  if (isPickup && newSpeed <= cur) return;
  applyMovespeed2(unit, newSpeed);
}

function init(): void {
  // 使用物品事件中心注册，减少触发器数量
  onItemPickup((unit, item) => {
    onItemChange(unit, item, true);
  });
  onItemDrop((unit, item) => {
    onItemChange(unit, item, false);
  });
}

init();
/** 供装备系统在「当前装备加成」里显示移速：返回当前生效的移速值及提供该移速的装备名 */
export { getMaxMovespeed2Info };
