/** @noSelfInFile */

import {
  单位持有攻击效果装备,
  单位有效存活,
  攻击者类型满足,
  距离满足限制,
  取攻击力,
  攻击效果造成伤害,
} from "../08．攻击效果/00．公共/01．攻击效果工具";
import { 装备触发概率通过 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/22．幸运值";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { SFB_setCurse } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setCurse: (this: void, sourceUnit: any, u: any, time: number) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

const 装备名 = "|cffcc99ff黑暗猎人手套|r";
const 触发概率 = 0.15;
const 冷却毫秒 = 8000;
const 最大攻击距离 = 200;
const 攻击力系数 = 2;
const 诅咒持续秒 = 1.5;

const 冷却表: Record<number, number> = {};

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit);
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

function on黑暗猎人手套最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (snapshot == null || snapshot.isNormalAttack !== true || snapshot.isTrueDamage === true) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有攻击效果装备(attacker, 装备名)) return;
  if (!攻击者类型满足(attacker, "近战")) return;
  if (!距离满足限制(attacker, target, undefined, 最大攻击距离)) return;
  if (!装备触发概率通过(触发概率, attacker)) return;
  if (!冷却通过(attacker)) return;

  SFB_setCurse(attacker, target, 诅咒持续秒);
  攻击效果造成伤害(attacker, target, 取攻击力(attacker) * 攻击力系数, "暗影");
}

registerAppliedFinalDamageListener(on黑暗猎人手套最终伤害);

export {};
