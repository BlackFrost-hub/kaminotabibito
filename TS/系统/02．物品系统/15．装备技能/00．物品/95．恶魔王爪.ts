/** @noSelfInFile */

import {
  单位持有攻击效果装备,
  单位有效存活,
  攻击者类型满足,
  取当前生命,
  取最大生命,
} from "../08．攻击效果/00．公共/01．攻击效果工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 装备名 = "|cff993300恶魔王爪|r";
const 恶魔伤害提高 = 0.15;
const 撕裂持续毫秒 = 3000;
const 撕裂间隔毫秒 = 1000;
const 已损失生命真实伤害比例 = 0.02;
const 减速比例 = 0.15;
const 减速持续秒 = 3;

interface 撕裂记录 {
  key: string;
  source: any;
  target: any;
  expireTime: number;
  nextTickTime: number;
}

const 撕裂记录列表: 撕裂记录[] = [];
let 撕裂Tick已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit);
}

function 取撕裂键(this: void, source: any, target: any): string {
  const sourceId = 取单位句柄ID(source);
  const targetId = 取单位句柄ID(target);
  if (sourceId === 0 || targetId === 0) return "";
  return sourceId + ":" + targetId;
}

function 计算已损失生命真实伤害(this: void, target: any): number {
  const maxLife = 取最大生命(target);
  const currentLife = 取当前生命(target);
  if (!(maxLife > currentLife)) return 0;
  return (maxLife - currentLife) * 已损失生命真实伤害比例;
}

function 造成恶魔王爪真实伤害(this: void, source: any, target: any): void {
  if (!单位有效存活(source) || !单位有效存活(target)) return;
  const amount = 计算已损失生命真实伤害(target);
  if (!(amount > 0)) return;
  UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
}

function on恶魔王爪撕裂Tick(this: void): void {
  const now = getServerTime();
  let write = 0;
  for (let i = 0; i < 撕裂记录列表.length; i++) {
    const record = 撕裂记录列表[i];
    if (record == null) continue;
    if (now >= record.expireTime || !单位有效存活(record.source) || !单位有效存活(record.target)) continue;
    if (now >= record.nextTickTime) {
      造成恶魔王爪真实伤害(record.source, record.target);
      record.nextTickTime = now + 撕裂间隔毫秒;
    }
    撕裂记录列表[write] = record;
    write++;
  }
  while (撕裂记录列表.length > write) 撕裂记录列表.pop();
}

function 确保注册撕裂Tick(this: void): void {
  if (撕裂Tick已注册) return;
  撕裂Tick已注册 = true;
  addPeriodicCallback(100, on恶魔王爪撕裂Tick);
}

function 施加或刷新撕裂(this: void, source: any, target: any): void {
  const key = 取撕裂键(source, target);
  if (key === "") return;
  const now = getServerTime();
  for (let i = 0; i < 撕裂记录列表.length; i++) {
    const record = 撕裂记录列表[i];
    if (record == null || record.key !== key) continue;
    record.expireTime = now + 撕裂持续毫秒;
    return;
  }
  撕裂记录列表.push({
    key,
    source,
    target,
    expireTime: now + 撕裂持续毫秒,
    nextTickTime: now + 撕裂间隔毫秒,
  });
  确保注册撕裂Tick();
}

function on恶魔王爪最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (snapshot == null || snapshot.isPhysicalDamage !== true || snapshot.isTrueDamage === true) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有攻击效果装备(attacker, 装备名)) return;
  if (!攻击者类型满足(attacker, "近战")) return;
  SFB_setSlow(attacker, target, 0, 减速比例, 减速持续秒);
  施加或刷新撕裂(attacker, target);
}

registerAppliedFinalDamageListener(on恶魔王爪最终伤害);

export {};
