/** @noSelfInFile */

import {
  单位持有攻击效果装备,
  单位有效存活,
  攻击者类型满足,
  距离满足限制,
  取攻击力,
  攻击效果造成伤害,
  获取敌方范围单位,
  临时修改攻速,
} from "../08．攻击效果/00．公共/01．攻击效果工具";
import { 读取玩家暴击伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 装备触发概率通过 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/22．幸运值";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

const 装备名 = "狂暴熔刃";
const 触发概率 = 0.1;
const 冷却毫秒 = 2000;
const 最大攻击距离 = 200;
const 攻速增加 = 300;
const 持续毫秒 = 2000;
const 范围 = 500;
const 攻击力倍率 = 2;

interface 攻速恢复记录 {
  unit: any;
  value: number;
}

const 冷却表: Record<number, number> = {};
const 攻速恢复列表: 攻速恢复记录[] = [];

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit);
}

function 计算暴击伤害(this: void, attacker: any): number {
  return 取攻击力(attacker) * 攻击力倍率 * (1 + 读取玩家暴击伤害(attacker));
}

function on狂暴熔刃攻速恢复(this: void): void {
  const record = 攻速恢复列表.shift();
  if (record == null) return;
  if (!单位有效存活(record.unit)) return;
  临时修改攻速(record.unit, -record.value);
}

function 施加狂暴熔刃攻速(this: void, attacker: any): void {
  临时修改攻速(attacker, 攻速增加);
  攻速恢复列表.push({ unit: attacker, value: 攻速增加 });
  addDelayedCallback(持续毫秒, on狂暴熔刃攻速恢复);
}

function 冷却通过(this: void, attacker: any): boolean {
  const id = 取单位句柄ID(attacker);
  if (id === 0) return false;
  const now = getServerTime();
  const last = 冷却表[id];
  if (last != null && now - last < 冷却毫秒) return false;
  冷却表[id] = now;
  return true;
}

function on狂暴熔刃最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (snapshot == null || snapshot.isNormalAttack !== true || snapshot.isTrueDamage === true) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有攻击效果装备(attacker, 装备名)) return;
  if (!攻击者类型满足(attacker, "近战")) return;
  if (!距离满足限制(attacker, target, undefined, 最大攻击距离)) return;
  if (!装备触发概率通过(触发概率, attacker)) return;
  if (!冷却通过(attacker)) return;

  施加狂暴熔刃攻速(attacker);
  const damage = 计算暴击伤害(attacker);
  const enemies = 获取敌方范围单位(attacker, target, 范围, true);
  for (let i = 0; i < enemies.length; i++) {
    攻击效果造成伤害(attacker, enemies[i], damage, "物理");
  }
}

registerAppliedFinalDamageListener(on狂暴熔刃最终伤害);

export {};
