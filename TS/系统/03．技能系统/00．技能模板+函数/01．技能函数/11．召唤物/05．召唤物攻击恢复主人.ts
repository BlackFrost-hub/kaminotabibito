/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetHandleId = jass.GetHandleId as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

export interface 召唤物攻击恢复主人参数 {
  召唤单位: any;
  主人单位: any;
  固定生命恢复?: number;
  主人最大生命恢复比例?: number;
  固定魔法恢复?: number;
  主人最大魔法恢复比例?: number;
  仅普通攻击?: boolean;
  要求实际造成伤害?: boolean;
  生命恢复条件?: (this: void, 召唤单位: any, 主人单位: any, 目标单位: any, snapshot: any) => boolean;
  魔法恢复条件?: (this: void, 召唤单位: any, 主人单位: any, 目标单位: any, snapshot: any) => boolean;
  显示生命恢复特效?: boolean;
  显示魔法恢复特效?: boolean;
  显示魔法恢复文字?: boolean;
  on触发?: (this: void, 结果: 召唤物攻击恢复主人结果) => void;
}

export interface 召唤物攻击恢复主人结果 {
  召唤单位: any;
  主人单位: any;
  目标单位: any;
  请求生命恢复: number;
  实际生命恢复: number;
  请求魔法恢复: number;
  实际魔法恢复: number;
  snapshot: any;
}

const 召唤物攻击恢复主人表: Record<number, 召唤物攻击恢复主人参数 | undefined> = {};
let 召唤物攻击恢复主人监听已注册 = false;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 计算恢复值(this: void, 固定值: number | undefined, 最大值比例: number | undefined, 最大值: number): number {
  const amount = (固定值 ?? 0) + 最大值 * (最大值比例 ?? 0);
  return amount > 0 ? amount : 0;
}

function on召唤物攻击恢复主人(this: void, target: any, _attacker: any, applied: number, snapshot: any): void {
  const summon = snapshot?.originalAttacker;
  const 参数 = 召唤物攻击恢复主人表[取单位ID(summon)];
  if (参数 == null || 参数.主人单位 == null || 参数.主人单位 === 0) return;
  if ((参数.仅普通攻击 ?? true) && snapshot?.isNormalAttack !== true) return;
  if ((参数.要求实际造成伤害 ?? true) && !(applied > 0)) return;

  const owner = 参数.主人单位;
  const lifeEnabled = 参数.生命恢复条件 == null || 参数.生命恢复条件(summon, owner, target, snapshot);
  const manaEnabled = 参数.魔法恢复条件 == null || 参数.魔法恢复条件(summon, owner, target, snapshot);
  const lifeAmount = lifeEnabled
    ? 计算恢复值(参数.固定生命恢复, 参数.主人最大生命恢复比例, GetUnitStateJapi(owner, UNIT_STATE_MAX_LIFE))
    : 0;
  const manaAmount = manaEnabled
    ? 计算恢复值(参数.固定魔法恢复, 参数.主人最大魔法恢复比例, GetUnitStateJapi(owner, UNIT_STATE_MAX_MANA))
    : 0;
  if (!(lifeAmount > 0) && !(manaAmount > 0)) return;

  const manaBefore = GetUnitState(owner, UNIT_STATE_MANA);
  const actualLife = doHeal({
    HealSource: summon,
    HealTarget: owner,
    HealAmount: lifeAmount,
    HealManaAmount: manaAmount,
    ItemHeal: false,
    HealEffect: 参数.显示生命恢复特效 ?? false,
    ManaEffect: 参数.显示魔法恢复特效 ?? false,
    ManaShowText: 参数.显示魔法恢复文字 ?? false,
  });
  const actualMana = GetUnitState(owner, UNIT_STATE_MANA) - manaBefore;
  if (参数.on触发 != null) {
    参数.on触发({
      召唤单位: summon,
      主人单位: owner,
      目标单位: target,
      请求生命恢复: lifeAmount,
      实际生命恢复: actualLife,
      请求魔法恢复: manaAmount,
      实际魔法恢复: actualMana > 0 ? actualMana : 0,
      snapshot,
    });
  }
}

function on召唤物攻击恢复主人单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  注销召唤物攻击恢复主人(dyingUnit);
}

function 确保召唤物攻击恢复主人监听(this: void): void {
  if (召唤物攻击恢复主人监听已注册) return;
  召唤物攻击恢复主人监听已注册 = true;
  registerAppliedFinalDamageListener(on召唤物攻击恢复主人);
  registerDeathListener(on召唤物攻击恢复主人单位死亡);
}

export function 登记召唤物攻击恢复主人(this: void, 参数: 召唤物攻击恢复主人参数): void {
  const id = 取单位ID(参数.召唤单位);
  if (id === 0 || 参数.主人单位 == null || 参数.主人单位 === 0) return;
  确保召唤物攻击恢复主人监听();
  召唤物攻击恢复主人表[id] = 参数;
}

export function 注销召唤物攻击恢复主人(this: void, 召唤单位: any): void {
  const id = 取单位ID(召唤单位);
  if (id !== 0) delete 召唤物攻击恢复主人表[id];
}
