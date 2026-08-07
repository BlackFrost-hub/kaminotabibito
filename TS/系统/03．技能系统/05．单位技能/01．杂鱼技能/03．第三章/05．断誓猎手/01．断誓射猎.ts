/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../00．封印守卫战公共/00．类型";
import { 断誓猎手配置 } from "./00．配置";
import {
  命令攻击目标,
  命令移动到点,
  取单位X,
  取单位Y,
  取单位距离平方,
  取最近玩家英雄,
  读取封印守卫战核心,
  封印守卫战单位存活,
} from "../00．封印守卫战公共/01．共享";

const jass = require("jass.common") as any;
const { 单位_设置每秒生命恢复 } = require("平台扩展API动作") as {
  单位_设置每秒生命恢复: (this: void, unit: any, regen: number) => boolean;
};
const { 单位_获取每秒生命恢复 } = require("平台扩展API取值") as {
  单位_获取每秒生命恢复: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 封印守卫战BuffID } = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战") as {
  封印守卫战BuffID: { 核心生命回复压制: string };
};
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;

let 压制核心: any = null;
let 核心原生命恢复 = 0;
let 核心恢复压制结束毫秒 = 0;
let 核心恢复已压制 = false;

function 恢复核心生命恢复(this: void): void {
  if (核心恢复已压制 && 封印守卫战单位存活(压制核心)) {
    单位_设置每秒生命恢复(压制核心, 核心原生命恢复);
  }
  if (压制核心 != null && 压制核心 !== 0) 移除单位指定Buff(压制核心, 封印守卫战BuffID.核心生命回复压制);
  压制核心 = null;
  核心原生命恢复 = 0;
  核心恢复压制结束毫秒 = 0;
  核心恢复已压制 = false;
}

function 应用核心生命恢复压制(this: void, source: any, core: any, 当前毫秒: number): void {
  if (核心恢复已压制 && 压制核心 !== core) 恢复核心生命恢复();
  if (!核心恢复已压制) {
    压制核心 = core;
    核心原生命恢复 = 单位_获取每秒生命恢复(core) || 0;
    单位_设置每秒生命恢复(core, 核心原生命恢复 * (1 - 断誓猎手配置.回血压制比例));
    核心恢复已压制 = true;
  }
  核心恢复压制结束毫秒 = 当前毫秒 + 断誓猎手配置.回血压制持续毫秒;
  registerManualBuff(
    core,
    封印守卫战BuffID.核心生命回复压制,
    断誓猎手配置.回血压制持续毫秒 / 1000,
    断誓猎手配置.回血压制比例,
    {
      sourceUnit: source,
      effectSourceName: "断誓猎手-断誓射猎",
      effectSourceType: "技能",
    },
  );
}

export function 刷新断誓猎手核心压制(this: void, 当前毫秒: number): void {
  if (!核心恢复已压制) return;
  if (!封印守卫战单位存活(压制核心) || 当前毫秒 >= 核心恢复压制结束毫秒) 恢复核心生命恢复();
}

export function 修正断誓猎手核心普攻(
  this: void,
  record: 封印守卫战敌人记录,
  context: any,
  当前毫秒: number,
): number {
  const core = 读取封印守卫战核心();
  if (context?.isNormalAttack !== true || context.target !== core || !封印守卫战单位存活(core)) return context.currentDamage;
  record.普攻计数 += 1;
  if (record.普攻计数 < 4) return context.currentDamage;
  record.普攻计数 = 0;
  应用核心生命恢复压制(record.单位, core, 当前毫秒);
  return context.currentDamage * 断誓猎手配置.第四击伤害倍率;
}

export function 刷新断誓猎手AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 断誓猎手配置.AI刷新毫秒;
  const closeHero = 取最近玩家英雄(record.单位, 断誓猎手配置.转火玩家范围);
  if (封印守卫战单位存活(closeHero)) {
    record.当前目标 = closeHero;
    命令攻击目标(record.单位, closeHero);
    return;
  }
  const core = 读取封印守卫战核心();
  if (!封印守卫战单位存活(core)) return;
  const distanceSq = 取单位距离平方(record.单位, core);
  if (distanceSq < 断誓猎手配置.核心最小站位距离 * 断誓猎手配置.核心最小站位距离) {
    const ux = 取单位X(record.单位);
    const uy = 取单位Y(record.单位);
    const cx = 取单位X(core);
    const cy = 取单位Y(core);
    const dx = ux - cx;
    const dy = uy - cy;
    const distance = SquareRoot(distanceSq);
    if (distance > 0) {
      命令移动到点(
        record.单位,
        cx + dx / distance * 断誓猎手配置.核心理想站位距离,
        cy + dy / distance * 断誓猎手配置.核心理想站位距离,
      );
      return;
    }
  }
  record.当前目标 = core;
  命令攻击目标(record.单位, core);
}

export function 清理断誓猎手全局机制(this: void): void {
  恢复核心生命恢复();
}
