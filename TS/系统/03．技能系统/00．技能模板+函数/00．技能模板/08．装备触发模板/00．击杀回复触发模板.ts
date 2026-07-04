/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    HealManaAmount?: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    HealEffectPath?: string;
    UseDefaultHealEffect?: boolean;
    ManaEffect?: boolean;
    ManaEffectPath?: string;
    UseDefaultManaEffect?: boolean;
    ManaShowText?: boolean;
    DelayOneTick?: boolean;
  }) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, whichType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (whichUnit: any, whichPlayer: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

export interface 击杀回复触发事件 {
  击杀单位: any;
  死亡单位: any;
  配置: 击杀回复触发模板配置;
}

export interface 击杀回复触发模板配置 {
  名称?: string;
  冷却秒数?: number;
  恢复生命值?: number;
  恢复最大生命比例?: number;
  恢复魔法值?: number;
  恢复最大魔法比例?: number;
  只触发敌方死亡?: boolean;
  触发条件?: (this: void, event: 击杀回复触发事件) => boolean;
  生命特效路径?: string;
  魔法特效路径?: string;
  使用默认生命特效?: boolean;
  使用默认魔法特效?: boolean;
  on触发后?: (this: void, event: 击杀回复触发事件, 恢复生命: number, 恢复魔法: number) => void;
}

export interface 击杀回复触发控制器 {
  readonly 名称: string;
  停止(this: void): void;
}

interface 击杀回复触发记录 extends 击杀回复触发控制器 {
  ID: number;
  配置: 击杀回复触发模板配置;
  已停止: boolean;
}

const 击杀回复触发记录表: Record<number, 击杀回复触发记录 | undefined> = {};
const 击杀回复冷却表: Record<string, number | undefined> = {};
let 击杀回复触发计数 = 0;
let 已注册击杀回复死亡监听 = false;

function 单位有效存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0.405;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取最大生命(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) || GetUnitState(unit, UNIT_STATE_MAX_LIFE) || 0;
}

function 取最大魔法(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA) || GetUnitState(unit, UNIT_STATE_MAX_MANA) || 0;
}

function 取冷却键(this: void, unit: any, record: 击杀回复触发记录): string {
  const id = 取单位ID(unit);
  if (id === 0) return "";
  return String(record.ID) + ":" + String(id);
}

function 冷却通过并记录(this: void, unit: any, record: 击杀回复触发记录): boolean {
  const cd = record.配置.冷却秒数 ?? 0;
  if (!(cd > 0)) return true;
  const key = 取冷却键(unit, record);
  if (key === "") return false;
  const now = getServerTime();
  const end = 击杀回复冷却表[key];
  if (end != null && now < end) return false;
  击杀回复冷却表[key] = now + cd * 1000;
  return true;
}

function 计算恢复生命(this: void, unit: any, config: 击杀回复触发模板配置): number {
  return (config.恢复生命值 ?? 0) + 取最大生命(unit) * (config.恢复最大生命比例 ?? 0);
}

function 计算恢复魔法(this: void, unit: any, config: 击杀回复触发模板配置): number {
  return (config.恢复魔法值 ?? 0) + 取最大魔法(unit) * (config.恢复最大魔法比例 ?? 0);
}

function 尝试执行击杀回复(this: void, dyingUnit: any, killingUnit: any, record: 击杀回复触发记录): void {
  if (record.已停止 || !单位有效存活(killingUnit)) return;
  if (dyingUnit == null || dyingUnit === 0 || dyingUnit === killingUnit) return;
  if (record.配置.只触发敌方死亡 !== false && !IsUnitEnemy(dyingUnit, GetOwningPlayer(killingUnit))) return;

  const event: 击杀回复触发事件 = { 击杀单位: killingUnit, 死亡单位: dyingUnit, 配置: record.配置 };
  if (record.配置.触发条件 != null && !record.配置.触发条件(event)) return;
  if (!冷却通过并记录(killingUnit, record)) return;

  const heal = 计算恢复生命(killingUnit, record.配置);
  const mana = 计算恢复魔法(killingUnit, record.配置);
  if (!(heal > 0) && !(mana > 0)) return;

  doHeal({
    HealSource: killingUnit,
    HealTarget: killingUnit,
    HealAmount: heal,
    HealManaAmount: mana,
    ItemHeal: true,
    HealEffect: record.配置.使用默认生命特效 === true || (record.配置.生命特效路径 != null && record.配置.生命特效路径 !== ""),
    HealEffectPath: record.配置.生命特效路径,
    UseDefaultHealEffect: record.配置.使用默认生命特效 === true,
    ManaEffect: record.配置.使用默认魔法特效 === true || (record.配置.魔法特效路径 != null && record.配置.魔法特效路径 !== ""),
    ManaEffectPath: record.配置.魔法特效路径,
    UseDefaultManaEffect: record.配置.使用默认魔法特效 === true,
    ManaShowText: mana > 0,
  });

  if (record.配置.on触发后 != null) record.配置.on触发后(event, heal, mana);
}

function on击杀回复死亡事件(this: void, dyingUnit: any, killingUnit: any): void {
  for (const key in 击杀回复触发记录表) {
    const record = 击杀回复触发记录表[Number(key) || 0];
    if (record != null) 尝试执行击杀回复(dyingUnit, killingUnit, record);
  }
}

function 确保击杀回复死亡监听(this: void): void {
  if (已注册击杀回复死亡监听) return;
  已注册击杀回复死亡监听 = true;
  registerDeathListener(on击杀回复死亡事件);
}

export function 注册击杀回复触发模板(this: void, 配置: 击杀回复触发模板配置): 击杀回复触发控制器 {
  确保击杀回复死亡监听();
  const id = ++击杀回复触发计数;
  const record: 击杀回复触发记录 = {
    ID: id,
    名称: 配置.名称 ?? ("击杀回复触发#" + String(id)),
    配置,
    已停止: false,
    停止: function 停止击杀回复触发(this: void): void {
      record.已停止 = true;
      delete 击杀回复触发记录表[id];
    },
  };
  击杀回复触发记录表[id] = record;
  return record;
}

export {};
