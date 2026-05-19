/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: {
      sourceName?: string;
      iconOverride?: string;
      effectModelOverride?: string;
      effectValue2?: number;
    }
  ) => void;
};

const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { icon?: string; effect?: string }>;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { matchUnitFilter } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  matchUnitFilter: (this: void, targetUnit: any, sourceUnit: any, options: 易伤范围筛选) => boolean;
};

const 默认易伤BuffID = "C026";

function 读取Buff图标(this: void, BuffID: string): string | undefined {
  const meta = buffTableMod.buffs[BuffID];
  return meta != null && meta.icon != null && meta.icon !== "" ? meta.icon : undefined;
}

function 读取Buff特效(this: void, BuffID: string): string | undefined {
  const meta = buffTableMod.buffs[BuffID];
  return meta != null && meta.effect != null && meta.effect !== "" ? meta.effect : undefined;
}

export interface 易伤参数 {
  BuffID?: string;
  图标路径?: string;
  特效路径?: string;
  持续时间: number;
  伤害增加百分比: number;
}

export interface 易伤范围筛选 {
  仅敌人?: boolean;
  仅友军?: boolean;
  排除自身?: boolean;
  要求有效单位?: boolean;
  允许建筑?: boolean;
  允许机械?: boolean;
  允许古树?: boolean;
  允许无敌?: boolean;
  允许死亡?: boolean;
  自定义条件?: (targetUnit: any, sourceUnit?: any) => boolean;
}

export interface 范围易伤参数 extends 易伤参数 {
  x?: number;
  y?: number;
  中心单位?: any;
  范围: number;
  筛选?: 易伤范围筛选;
}

function 规范化易伤比例(this: void, value: number): number {
  if (typeof value !== "number" || !isFinite(value)) return 0;
  if (value > -1 && value < 1) return value;
  return value / 100;
}

export function 施加易伤(this: void, 来源单位: any, 目标单位: any, 参数: 易伤参数): void {
  if (来源单位 == null || 来源单位 === 0) return;
  if (目标单位 == null || 目标单位 === 0) return;
  if (参数.持续时间 <= 0) return;

  const BuffID = 参数.BuffID ?? 默认易伤BuffID;

  registerManualBuff(目标单位, BuffID, 参数.持续时间, 参数.伤害增加百分比, {
    sourceName: GetUnitName(来源单位),
    iconOverride: 参数.图标路径 ?? 读取Buff图标(BuffID),
    effectModelOverride: 参数.特效路径 ?? 读取Buff特效(BuffID),
  });
}

export function 施加范围易伤(this: void, 来源单位: any, 参数: 范围易伤参数): number {
  if (来源单位 == null || 来源单位 === 0) return 0;
  if (!(参数.范围 > 0) || !(参数.持续时间 > 0)) return 0;

  const 中心单位 = 参数.中心单位 != null && 参数.中心单位 !== 0 ? 参数.中心单位 : 来源单位;
  const x = 参数.x != null ? 参数.x : GetUnitX(中心单位);
  const y = 参数.y != null ? 参数.y : GetUnitY(中心单位);
  const 单位列表 = getUnitsInRange(x, y, 参数.范围);
  const 筛选 = 参数.筛选 ?? { 仅敌人: true, 排除自身: false };
  let 成功数量 = 0;

  for (let i = 0; i < 单位列表.length; i++) {
    const 目标单位 = 单位列表[i];
    if (!matchUnitFilter(目标单位, 来源单位, 筛选)) continue;
    施加易伤(来源单位, 目标单位, 参数);
    成功数量 = 成功数量 + 1;
  }

  return 成功数量;
}

export function 施加AOE易伤(this: void, 来源单位: any, 参数: 范围易伤参数): number {
  return 施加范围易伤(来源单位, 参数);
}

export function 获取易伤倍率(this: void, 数值: number): number {
  return 规范化易伤比例(数值);
}

export {};
