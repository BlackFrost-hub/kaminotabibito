/** @noSelfInFile */

const jass = require("jass.common") as any;
import { 造成技能伤害, type 技能伤害来源类型, type 技能伤害形态, type 装备技能伤害类型 } from "./08．技能伤害系统";
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const R2I = jass.R2I as (value: number) => number;

export const 持续伤害属性名 = "持续伤害";

export function 读取持续伤害加成(this: void, source: any): number {
  if (source == null || source === 0) return 0;
  const owner = jass.GetOwningPlayer(source);
  if (owner == null) return 0;
  const value = Number(YDUserDataGetSafe("player", owner, 持续伤害属性名, "real")) || 0;
  return value > -0.95 ? value : -0.95;
}

export function 计算持续伤害最终值(this: void, source: any, amount: number): number {
  if (!(amount > 0)) return 0;
  const finalAmount = amount * (1 + 读取持续伤害加成(source));
  return finalAmount > 0 ? finalAmount : 0;
}

export interface 持续伤害选项 {
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  伤害形态?: 技能伤害形态;
  参与技能伤害加成?: boolean;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
}

export interface 持续伤害调度参数 {
  来源: any;
  目标: any;
  总伤害: number;
  持续秒数: number;
  间隔秒数?: number;
  伤害类型: any;
  ranged?: boolean;
  attackType?: any;
  weaponType?: any;
  选项?: 持续伤害选项;
}

interface 持续伤害调度记录 {
  来源: any;
  目标: any;
  每跳伤害: number;
  伤害类型: any;
  ranged: boolean;
  attackType: any;
  weaponType: any;
  选项?: 持续伤害选项;
  剩余跳数: number;
  下次跳时刻: number;
  间隔毫秒: number;
}

const 持续伤害调度列表: 持续伤害调度记录[] = [];
let 持续伤害调度Tick已注册 = false;

function 单位有效存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (GetUnitTypeId(unit) === 0) return false;
  return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 注册持续伤害调度Tick(this: void): void {
  if (持续伤害调度Tick已注册) return;
  持续伤害调度Tick已注册 = true;
  addPeriodicCallback(100, on持续伤害调度Tick);
}

function on持续伤害调度Tick(this: void): void {
  const now = getServerTime();
  let write = 0;
  for (let i = 0; i < 持续伤害调度列表.length; i++) {
    const record = 持续伤害调度列表[i];
    if (record == null || record.剩余跳数 <= 0 || !单位有效存活(record.来源) || !单位有效存活(record.目标)) continue;
    if (now >= record.下次跳时刻) {
      造成持续伤害(record.来源, record.目标, record.每跳伤害, record.伤害类型, record.ranged, record.attackType, record.weaponType, record.选项);
      record.剩余跳数 -= 1;
      record.下次跳时刻 = now + record.间隔毫秒;
    }
    if (record.剩余跳数 > 0) {
      持续伤害调度列表[write] = record;
      write++;
    }
  }
  while (持续伤害调度列表.length > write) 持续伤害调度列表.pop();
}

export function 造成持续伤害(
  this: void,
  source: any,
  target: any,
  amount: number,
  damageType: any,
  ranged: boolean = false,
  attackType: any = ATTACK_TYPE_NORMAL,
  weaponType: any = WEAPON_TYPE_WHOKNOWS,
  选项?: 持续伤害选项
): boolean {
  const finalAmount = 计算持续伤害最终值(source, amount);
  if (!(finalAmount > 0)) return false;
  return 造成技能伤害({
    来源: source,
    目标: target,
    伤害: finalAmount,
    伤害类型: damageType,
    attack: false,
    ranged,
    attackType,
    weaponType,
    来源类型: 选项?.来源类型 ?? 选项?.装备技能类型 ?? "单位技能",
    装备技能类型: 选项?.装备技能类型,
    技能ID: 选项?.技能ID,
    技能实例ID: 选项?.技能实例ID,
    标签: 选项?.标签,
    伤害形态: 选项?.伤害形态 ?? "单体",
    参与技能伤害加成: 选项?.参与技能伤害加成,
  });
}

export function 开始持续伤害(this: void, 参数: 持续伤害调度参数): number {
  if (参数 == null) return 0;
  const intervalSec = 参数.间隔秒数 ?? 1;
  if (!(参数.总伤害 > 0) || !(参数.持续秒数 > 0) || !(intervalSec > 0)) return 0;
  if (!单位有效存活(参数.来源) || !单位有效存活(参数.目标)) return 0;
  const ticks = R2I(参数.持续秒数 / intervalSec);
  if (!(ticks > 0)) return 0;
  持续伤害调度列表.push({
    来源: 参数.来源,
    目标: 参数.目标,
    每跳伤害: 参数.总伤害 / ticks,
    伤害类型: 参数.伤害类型,
    ranged: 参数.ranged === true,
    attackType: 参数.attackType ?? ATTACK_TYPE_NORMAL,
    weaponType: 参数.weaponType ?? WEAPON_TYPE_WHOKNOWS,
    选项: 参数.选项,
    剩余跳数: ticks,
    下次跳时刻: getServerTime() + intervalSec * 1000,
    间隔毫秒: intervalSec * 1000,
  });
  注册持续伤害调度Tick();
  return ticks;
}

export {};
