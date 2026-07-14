/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建点特效, 创建单位脚下点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建单位脚下点特效: (this: void, unit: any, 参数: any) => any;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const GetUnitStateJapi = japi.GetUnitState as ((unit: any, state: any) => number) | undefined;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位攻击力(this: void, unit: any): number {
  if (!单位有效(unit) || typeof GetUnitStateJapi !== "function") return 1000;
  const value = GetUnitStateJapi(unit, ConvertUnitState(0x15));
  return value > 0 ? value : 1000;
}

function 播放分身出生表现(this: void, x: number, y: number): void {
  创建点特效({
    模型路径: "Common\\Effect\\Element\\magic\\WhiteElement.mdx",
    X: x,
    Y: y,
    持续秒: 1.5,
    缩放: 1,
  });
}

function 恢复Boss生命(this: void, boss: any, amount: number): void {
  if (!单位有效(boss) || amount <= 0) return;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const current = GetUnitState(boss, UNIT_STATE_LIFE);
  const next = current + amount > maxLife ? maxLife : current + amount;
  SetUnitState(boss, UNIT_STATE_LIFE, next);
}

function 安排分身到期结算(this: void, context: 米亚运行时上下文, summons: any[]): void {
  const config = 米亚技能数值配置.灵猫分身;
  addDelayedCallback((config.持续秒 - 5) * 1000, function 米亚灵猫分身剩余5秒提示(this: void): void {
    for (let i = 0; i < summons.length; i++) {
      if (单位有效(summons[i])) {
        播放米亚台词(context.Boss单位, "灵猫分身", 2);
        break;
      }
    }
  });
  addDelayedCallback(config.持续秒 * 1000, function 米亚灵猫分身到期结算(this: void): void {
    const boss = context.Boss单位;
    if (!单位有效(boss)) return;
    const healPerSummon = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * config.未击杀每只恢复生命比例;
    let aliveCount = 0;
    for (let i = 0; i < summons.length; i++) {
      const summon = summons[i];
      if (!单位有效(summon)) continue;
      aliveCount++;
      创建单位脚下点特效(summon, {
        模型路径: "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
        持续秒: 1.2,
        缩放: 1,
      });
      RemoveUnit(summon);
    }
    if (aliveCount > 0) {
      恢复Boss生命(boss, healPerSummon * aliveCount);
      播放米亚台词(boss, "灵猫分身", 3);
    } else {
      播放米亚台词(boss, "灵猫分身", 4);
    }
  });
}

function 触发米亚灵猫分身(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  const config = 米亚技能数值配置.灵猫分身;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const facing = GetUnitFacing(boss);
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const attack = 取单位攻击力(boss);
  const summons: any[] = [];

  播放米亚台词(boss, "灵猫分身", 0);
  播放Boss坐标音效(米亚音效配置.灵猫分身.主辨识音, bossX, bossY, 米亚音效配置.默认裁断距离);
  延迟播放Boss坐标音效(米亚音效配置.灵猫分身.凝形补层, bossX, bossY, 米亚音效配置.灵猫分身.凝形补层延迟Ms, 米亚音效配置.默认裁断距离);
  创建单位脚下点特效(boss, {
    模型路径: "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
    持续秒: 1.2,
    缩放: 1,
  });

  const offsets = [-1, 1];
  for (let i = 0; i < config.分身数量; i++) {
    const side = offsets[i % offsets.length];
    const angle = facing + 90 * side;
    const x = bossX + CosBJ(angle) * config.召唤距离;
    const y = bossY + SinBJ(angle) * config.召唤距离;
    播放分身出生表现(x, y);
    const summon = 创建召唤物({
      主人单位: boss,
      单位名称: "腐化灵猫幻影",
      X: x,
      Y: y,
      朝向: facing,
      持续时间: config.持续秒 + 0.5,
      模型文件: 米亚单位技能配置.模型.Boss,
      生命值: maxLife * config.分身生命比例,
      生命值受小怪倍率: false,
      攻击力: attack * config.分身攻击力比例,
      攻击间隔: config.分身攻击间隔,
      攻击范围: config.分身攻击范围,
      索敌范围: config.分身索敌范围,
      缩放: config.分身缩放,
    });
    if (单位有效(summon)) {
      X_FixUnitStandingSafe(summon);
      summons.push(summon);
    }
  }

  if (summons.length > 0) {
    播放米亚台词(boss, "灵猫分身", 1);
    安排分身到期结算(context, summons);
  }
}

export function 注册米亚灵猫分身(this: void): void {
}

export function 尝试触发米亚灵猫分身(this: void, context: 米亚运行时上下文): void {
  if (context.阶段 !== 1) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  const thresholds = 米亚技能数值配置.灵猫分身.触发生命比例;

  if (!context.已触发分身80 && ratio <= thresholds[0]) {
    context.已触发分身80 = true;
    触发米亚灵猫分身(context);
    return;
  }
  if (!context.已触发分身50 && ratio <= thresholds[1]) {
    context.已触发分身50 = true;
    触发米亚灵猫分身(context);
  }
}
