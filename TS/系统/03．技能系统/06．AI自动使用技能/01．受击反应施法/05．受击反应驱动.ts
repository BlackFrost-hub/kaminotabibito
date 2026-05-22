/** @noSelfInFile */

const jass = require("jass.common") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (
    this: void,
    cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void
  ) => void;
};

import type { 受击反应配置 } from "./00．配置类型";
import { 按名字反查任意单位ID } from "./01．单位名反查";
import { 受击反应配置表 } from "./02．受击反应配置表";
import { 执行受击反应特殊逻辑 } from "./03．受击反应特殊逻辑";
import { 尝试执行受击技能 } from "./04．受击反应执行";

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;

interface 已解析受击反应配置 extends 受击反应配置 {
  单位类型ID: number;
}

let 已初始化 = false;
const 受击反应配置索引: Record<number, 已解析受击反应配置[]> = {};
const 单位独立冷却表: Record<number, number> = {};

function 构建配置索引(this: void): void {
  const 列表 = 受击反应配置表;
  for (let i = 0; i < 列表.length; i++) {
    const 配置 = 列表[i];
    const rawcode = 按名字反查任意单位ID(配置.单位名);
    if (rawcode == null || rawcode === "") continue;

    const typeId = stringToFourCC(rawcode);
    const 解析配置: 已解析受击反应配置 = {
      ...配置,
      单位类型ID: typeId,
    };
    if (受击反应配置索引[typeId] == null) {
      受击反应配置索引[typeId] = [];
    }
    受击反应配置索引[typeId].push(解析配置);
  }
}

function 伤害来源是否注册玩家英雄(this: void, attacker: any): boolean {
  if (attacker == null || attacker === 0) return false;
  const owner = GetOwningPlayer(attacker);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === attacker;
}

function 处于单位独立冷却中(this: void, unit: any): boolean {
  const handleId = GetHandleId(unit);
  const dueTime = 单位独立冷却表[handleId] ?? 0;
  return dueTime > getServerTime();
}

function 刷新单位独立冷却(this: void, unit: any, cooldownMs: number): void {
  const handleId = GetHandleId(unit);
  单位独立冷却表[handleId] = getServerTime() + cooldownMs;
}

function 执行表驱动受击反应(this: void, config: 已解析受击反应配置, target: any, attacker: any): boolean {
  const skills = config.技能列表;
  if (skills == null || skills.length <= 0) return false;

  let executed = false;
  for (let i = 0; i < skills.length; i++) {
    if (尝试执行受击技能(skills[i], target, attacker)) {
      executed = true;
    }
  }
  return executed;
}

function onAppliedFinalDamage(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (target == null || target === 0 || attacker == null || attacker === 0) return;
  if (applied < 1) return;
  if (!伤害来源是否注册玩家英雄(attacker)) return;

  const typeId = GetUnitTypeId(target);
  const configs = 受击反应配置索引[typeId];
  if (configs == null || configs.length <= 0) return;
  if (处于单位独立冷却中(target)) return;

  for (let i = 0; i < configs.length; i++) {
    const config = configs[i];
    if ((config.最小受伤值 ?? 1) > applied) continue;
    if (config.要求伤害来源为注册玩家英雄 !== false && !伤害来源是否注册玩家英雄(attacker)) continue;

    let executed = false;
    if (config.特殊逻辑名 != null && config.特殊逻辑名 !== "") {
      executed = 执行受击反应特殊逻辑(config, target, attacker);
    } else {
      executed = 执行表驱动受击反应(config, target, attacker);
    }

    if (executed) {
      刷新单位独立冷却(target, config.单位独立冷却Ms ?? 1050);
      return;
    }
  }
}

export function init受击反应施法(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  构建配置索引();
  registerAppliedFinalDamageListener(onAppliedFinalDamage);
}
