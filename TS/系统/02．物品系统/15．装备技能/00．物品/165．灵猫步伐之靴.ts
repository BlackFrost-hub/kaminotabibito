/** @noSelfInFile */

import { 单位有效存活, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const jass = require("jass.common") as any;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (unit: any) => number;
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 单位持有装备, 取装备冷却键, 装备冷却中, 进入装备冷却 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却: (this: void, key: string, 秒数: number) => void;
};

const 灵猫跃步冷却秒数 = 10;
const 灵猫跃步移速比例 = 0.3;
const 灵猫跃步持续秒数 = 2;
const 灵猫跃步特效 = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl";
const 叠加移动速度属性ID = 9;
const 灵猫临时移速移除队列: Array<{ 单位: any; 移速比例: number; 到期时间: number }> = [];
let 灵猫临时移速Tick已启动 = false;

function 处理灵猫临时移速移除(this: void): void {
  const now = getServerTime();
  for (let i = 灵猫临时移速移除队列.length - 1; i >= 0; i--) {
    const 记录 = 灵猫临时移速移除队列[i];
    if (记录 == null || now < 记录.到期时间) continue;
    SGSS_SetState(记录.单位, 叠加移动速度属性ID, -记录.移速比例);
    灵猫临时移速移除队列.splice(i, 1);
  }
}

function 确保灵猫临时移速Tick(this: void): void {
  if (灵猫临时移速Tick已启动) return;
  灵猫临时移速Tick已启动 = true;
  addPeriodicCallback(100, 处理灵猫临时移速移除);
}

function 计算灵猫移速增量(this: void, unit: any, 移速比例: number): number {
  return GetUnitDefaultMoveSpeed(unit) * 移速比例;
}

function 施加灵猫临时移速(this: void, unit: any, 移速比例: number, 持续秒数: number): void {
  if (unit == null || unit === 0 || 移速比例 === 0 || !(持续秒数 > 0)) return;
  const 移速增量 = 计算灵猫移速增量(unit, 移速比例);
  SGSS_SetState(unit, 叠加移动速度属性ID, 移速增量);
  灵猫临时移速移除队列.push({ 单位: unit, 移速比例: 移速增量, 到期时间: getServerTime() + 持续秒数 * 1000 });
  确保灵猫临时移速Tick();
}

function on灵猫步伐之靴最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!单位有效存活(target)) return;
  if (!单位持有装备(target, "灵猫步伐之靴")) return;
  const key = 取装备冷却键(target, "灵猫步伐之靴:灵猫跃步", "米亚战利品");
  if (装备冷却中(key)) return;
  进入装备冷却(key, 灵猫跃步冷却秒数);
  施加灵猫临时移速(target, 灵猫跃步移速比例, 灵猫跃步持续秒数);
  播放单位特效(target, 灵猫跃步特效, "origin", 1);
}

registerAppliedFinalDamageListener(on灵猫步伐之靴最终伤害);

export {};
