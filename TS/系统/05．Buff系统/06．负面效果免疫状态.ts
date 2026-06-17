/** @noSelfInFile */

const jass = require("jass.common") as any;
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { type?: string } | undefined>;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitAddType = jass.UnitAddType as (unit: any, unitType: any) => boolean;
const UnitRemoveType = jass.UnitRemoveType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_SAPPER = jass.UNIT_TYPE_SAPPER;

export type 负面效果免疫范围 = "全部负面" | "控制" | "魔法负面";

export interface 施加单位负面效果免疫参数 {
  /** 默认“全部负面”。控制是负面效果的子集，因此“全部负面”会包含控制。 */
  范围?: 负面效果免疫范围 | 负面效果免疫范围[];
  /** 默认 true。用自爆工兵类别配合物编 targetsAllowed=nonsapper 拦截原生技能目标。 */
  同步原生技能目标免疫?: boolean;
}

interface 负面效果免疫行 {
  单位: any;
  原本是自爆工兵: boolean;
  全部负面免疫到期: number;
  控制负面免疫到期: number;
  魔法负面免疫到期: number;
}

const 负面效果免疫表: Record<number, 负面效果免疫行 | undefined> = {};

function 取单位句柄(单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 类型匹配(typeName: string | undefined, typePrefix: string): boolean {
  if (typeof typeName !== "string" || typeName === "" || typePrefix === "") return false;
  return typeName.substring(0, typePrefix.length) === typePrefix;
}

function 范围包含(配置范围: 负面效果免疫范围 | 负面效果免疫范围[] | undefined, 目标范围: 负面效果免疫范围): boolean {
  if (配置范围 == null) return 目标范围 === "全部负面";
  if (typeof 配置范围 === "string") return 配置范围 === 目标范围;
  for (let i = 0; i < 配置范围.length; i++) {
    if (配置范围[i] === 目标范围) return true;
  }
  return false;
}

function 取或建负面效果免疫行(单位: any): 负面效果免疫行 | undefined {
  const hid = 取单位句柄(单位);
  if (hid === 0) return undefined;
  let row = 负面效果免疫表[hid];
  if (row == null) {
    row = {
      单位,
      原本是自爆工兵: IsUnitType(单位, UNIT_TYPE_SAPPER) === true,
      全部负面免疫到期: 0,
      控制负面免疫到期: 0,
      魔法负面免疫到期: 0,
    };
    负面效果免疫表[hid] = row;
  } else {
    row.单位 = 单位;
  }
  return row;
}

function 行是否仍有负面效果免疫(row: 负面效果免疫行, now: number): boolean {
  return row.全部负面免疫到期 > now || row.控制负面免疫到期 > now || row.魔法负面免疫到期 > now;
}

function 尝试清理负面效果免疫行(this: void, 单位: any): void {
  const hid = 取单位句柄(单位);
  if (hid === 0) return;
  const row = 负面效果免疫表[hid];
  if (row == null) return;

  const now = getServerTime();
  if (行是否仍有负面效果免疫(row, now)) return;

  if (!row.原本是自爆工兵) {
    UnitRemoveType(row.单位, UNIT_TYPE_SAPPER);
  }
  delete 负面效果免疫表[hid];
}

function on负面效果免疫到期(this: void): void {
  const now = getServerTime();
  for (const key in 负面效果免疫表) {
    const hid = key as any as number;
    const row = 负面效果免疫表[hid];
    if (row != null && !行是否仍有负面效果免疫(row, now)) {
      if (!row.原本是自爆工兵) {
        UnitRemoveType(row.单位, UNIT_TYPE_SAPPER);
      }
      delete 负面效果免疫表[hid];
    }
  }
}

export function 施加单位负面效果免疫(单位: any, 持续时间: number, 参数: 施加单位负面效果免疫参数 = {}): void {
  if (单位 == null || 单位 === 0 || !(持续时间 > 0)) return;
  const row = 取或建负面效果免疫行(单位);
  if (row == null) return;

  const now = getServerTime();
  const until = now + 持续时间 * 1000;
  const 范围 = 参数.范围;

  if (范围包含(范围, "全部负面")) row.全部负面免疫到期 = row.全部负面免疫到期 > until ? row.全部负面免疫到期 : until;
  if (范围包含(范围, "控制")) row.控制负面免疫到期 = row.控制负面免疫到期 > until ? row.控制负面免疫到期 : until;
  if (范围包含(范围, "魔法负面")) row.魔法负面免疫到期 = row.魔法负面免疫到期 > until ? row.魔法负面免疫到期 : until;

  if (参数.同步原生技能目标免疫 !== false) {
    UnitAddType(单位, UNIT_TYPE_SAPPER);
  }

  addDelayedCallback(持续时间 * 1000 + 50, on负面效果免疫到期);
}

export function 施加单位控制负面效果免疫(单位: any, 持续时间: number, 同步原生技能目标免疫: boolean = true): void {
  施加单位负面效果免疫(单位, 持续时间, { 范围: "控制", 同步原生技能目标免疫 });
}

export function 施加单位魔法负面效果免疫(单位: any, 持续时间: number, 同步原生技能目标免疫: boolean = true): void {
  施加单位负面效果免疫(单位, 持续时间, { 范围: "魔法负面", 同步原生技能目标免疫 });
}

export function 清除单位负面效果免疫(单位: any): void {
  const hid = 取单位句柄(单位);
  if (hid === 0) return;
  const row = 负面效果免疫表[hid];
  if (row == null) return;
  row.全部负面免疫到期 = 0;
  row.控制负面免疫到期 = 0;
  row.魔法负面免疫到期 = 0;
  尝试清理负面效果免疫行(单位);
}

export function 单位是否免疫负面效果类型(单位: any, typeName: string | undefined): boolean {
  const hid = 取单位句柄(单位);
  if (hid === 0) return false;
  const row = 负面效果免疫表[hid];
  if (row == null) return false;

  const now = getServerTime();
  if (!行是否仍有负面效果免疫(row, now)) {
    尝试清理负面效果免疫行(单位);
    return false;
  }

  if (row.全部负面免疫到期 > now && 类型匹配(typeName, "Debuff:")) return true;
  if (row.控制负面免疫到期 > now && 类型匹配(typeName, "Debuff:control")) return true;
  if (row.魔法负面免疫到期 > now && 类型匹配(typeName, "Debuff:magic")) return true;
  return false;
}

export function 单位是否免疫负面效果BuffID(单位: any, buffID: string): boolean {
  const meta = buffTableMod.buffs[buffID];
  return 单位是否免疫负面效果类型(单位, meta?.type);
}

export {};
