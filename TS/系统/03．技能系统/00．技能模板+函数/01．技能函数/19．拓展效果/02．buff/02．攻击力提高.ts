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
      onRemove?: (this: void, unit: any, buffID: string, row: { effect: number }) => void;
    }
  ) => void;
};

const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { matchUnitFilter, isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  matchUnitFilter: (this: void, targetUnit: any, sourceUnit: any, options: 攻击力提高范围筛选) => boolean;
  isValidUnit: (this: void, unit: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const 默认攻击力提高BuffID = "C028";
const 攻击力属性ID = 1;

interface 攻击力提高运行状态 {
  数值: number;
}

export interface 攻击力提高范围筛选 {
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

export interface 攻击力提高Buff参数 {
  BuffID?: string;
  持续时间: number;
  攻击力: number;
  图标路径?: string;
  特效路径?: string;
}

export interface 范围攻击力提高Buff参数 extends 攻击力提高Buff参数 {
  x?: number;
  y?: number;
  中心单位?: any;
  范围: number;
  筛选?: 攻击力提高范围筛选;
}

const 攻击力提高状态表: Record<string, 攻击力提高运行状态 | undefined> = {};

function 取单位键(this: void, 单位: any, BuffID: string): string {
  if (单位 == null || 单位 === 0 || BuffID === "") return "";
  return GetHandleId(单位) + "|" + BuffID;
}

function 取有效BuffID(this: void, BuffID: string | undefined): string {
  return BuffID != null && BuffID !== "" ? BuffID : 默认攻击力提高BuffID;
}

function 调整单位攻击力(this: void, 单位: any, 数值: number): void {
  if (单位 == null || 单位 === 0 || 数值 === 0) return;
  SGSS_SetState(单位, 攻击力属性ID, 数值);
}

function on攻击力提高移除(this: void, 单位: any, BuffID: string, _row: { effect: number }): void {
  const key = 取单位键(单位, BuffID);
  if (key === "") return;

  const 状态 = 攻击力提高状态表[key];
  delete 攻击力提高状态表[key];
  if (状态 == null) return;

  调整单位攻击力(单位, -状态.数值);
}

export function 施加单体攻击力提高Buff(this: void, 来源单位: any, 目标单位: any, 参数: 攻击力提高Buff参数): boolean {
  if (来源单位 == null || 来源单位 === 0) return false;
  if (目标单位 == null || 目标单位 === 0) return false;
  if (!(参数.持续时间 > 0) || !(参数.攻击力 > 0)) return false;
  if (!isValidUnit(目标单位)) return false;

  const BuffID = 取有效BuffID(参数.BuffID);
  const key = 取单位键(目标单位, BuffID);
  if (key === "") return false;

  const 旧状态 = 攻击力提高状态表[key];
  let 生效攻击力 = 参数.攻击力;
  if (旧状态 != null && 旧状态.数值 >= 生效攻击力) {
    生效攻击力 = 旧状态.数值;
  }

  const 旧值 = 旧状态 != null ? 旧状态.数值 : 0;
  const 差值 = 生效攻击力 - 旧值;
  if (差值 !== 0) {
    调整单位攻击力(目标单位, 差值);
  }

  攻击力提高状态表[key] = { 数值: 生效攻击力 };

  registerManualBuff(目标单位, BuffID, 参数.持续时间, 生效攻击力, {
    sourceName: GetUnitName(来源单位),
    iconOverride: 参数.图标路径,
    effectModelOverride: 参数.特效路径,
    onRemove: on攻击力提高移除,
  });

  return true;
}

export function 施加范围攻击力提高Buff(this: void, 来源单位: any, 参数: 范围攻击力提高Buff参数): number {
  if (来源单位 == null || 来源单位 === 0) return 0;
  if (!(参数.范围 > 0)) return 0;

  const 中心单位 = 参数.中心单位 != null && 参数.中心单位 !== 0 ? 参数.中心单位 : 来源单位;
  const x = 参数.x != null ? 参数.x : GetUnitX(中心单位);
  const y = 参数.y != null ? 参数.y : GetUnitY(中心单位);
  const 单位列表 = getUnitsInRange(x, y, 参数.范围);
  const 筛选 = 参数.筛选 ?? { 仅友军: true, 排除自身: false };
  let 成功数量 = 0;

  for (let i = 0; i < 单位列表.length; i++) {
    const 目标单位 = 单位列表[i];
    if (!matchUnitFilter(目标单位, 来源单位, 筛选)) continue;
    if (施加单体攻击力提高Buff(来源单位, 目标单位, 参数)) {
      成功数量 = 成功数量 + 1;
    }
  }

  return 成功数量;
}

export {};
