/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import type { 米亚安全域运行时矩形 } from "./01．场地配置";
import { 米亚平台配置, 米亚技能数值配置 } from "./02．数值与表现配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";

const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
};
const { 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建循环点特效: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 平台超载效果表: Record<string, boolean | undefined> = {};
const 平台超载持续台词间隔Ms = 3000;

function 取平台ID(this: void, 区域: 米亚安全域运行时矩形): string {
  return 区域.配置.ID ?? 区域.配置.名称 ?? "";
}

function 单位在平台内(this: void, unit: any, 区域: 米亚安全域运行时矩形): boolean {
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  return x >= 区域.配置.左 && x <= 区域.配置.右 && y >= 区域.配置.下 && y <= 区域.配置.上;
}

function 取平台容量(this: void, 当前有效玩家人数: number): number {
  return 当前有效玩家人数 <= 2 ? 米亚平台配置.单双人平台容量 : 米亚平台配置.三四人平台容量;
}

function 取平台超载测试容量覆盖(this: void, context: 米亚运行时上下文): number {
  const 覆盖值 = Number((context as any).平台超载测试容量覆盖) || 0;
  return 覆盖值 > 0 ? 覆盖值 : 0;
}

function 取平台内英雄(this: void, 区域: 米亚安全域运行时矩形, heroes: any[]): any[] {
  const result: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (单位在平台内(hero, 区域)) result.push(hero);
  }
  return result;
}

function 确保平台超载表现(this: void, context: 米亚运行时上下文, 区域: 米亚安全域运行时矩形, id: string): void {
  const key = "mia-overload:" + id;
  if (平台超载效果表[key] === true) return;
  平台超载效果表[key] = true;
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    X: 区域.中心X,
    Y: 区域.中心Y,
    Z: 0,
    缩放: 0.8,
    重建间隔秒: 3,
    单次持续秒: 2.8,
    存活条件: function 米亚平台超载表现存活(this: void): boolean {
      const alive = 单位有效(context.Boss单位) && context.超载平台ID表[id] === true;
      if (!alive) 平台超载效果表[key] = undefined;
      return alive;
    },
  });
}

function 刷新平台超载Buff(this: void, target: any): void {
  registerManualBuff(target, 米亚单位技能配置.BuffID.平台超载, 1.2, 0.3, {
    sourceName: "平台超载",
    effectModelOverride: 米亚单位技能配置.特效.腐化高层,
  });
}

function 处理超载平台(this: void, context: 米亚运行时上下文, 区域: 米亚安全域运行时矩形, units: any[], nowMs: number): void {
  const id = 取平台ID(区域);
  if (id === "") return;
  context.超载平台ID表[id] = true;
  确保平台超载表现(context, 区域, id);

  if (context.超载平台下次叠层Ms表[id] == null || nowMs >= (context.超载平台下次叠层Ms表[id] ?? 0)) {
    context.超载平台下次叠层Ms表[id] = nowMs + 1000;
    for (let i = 0; i < units.length; i++) {
      添加米亚腐化感染(context, units[i], 1, "平台超载惩罚");
    }
  }

  for (let i = 0; i < units.length; i++) {
    刷新平台超载Buff(units[i]);
  }

  if (context.上次平台超载台词Ms <= 0) {
    播放米亚台词(context.Boss单位, "平台超载惩罚", 0);
    context.上次平台超载台词Ms = nowMs;
  } else if (nowMs - context.上次平台超载台词Ms >= 平台超载持续台词间隔Ms) {
    播放米亚台词(context.Boss单位, "平台超载惩罚", 1);
    context.上次平台超载台词Ms = nowMs;
  }
}

export function 取米亚平台超载伤害倍率(this: void, target: any): number {
  if (target == null || target === 0) return 1;
  const 有平台超载 = getBuffRuntime(target, 米亚单位技能配置.BuffID.平台超载) != null;
  return 有平台超载 ? 1.3 : 1;
}


export function 刷新米亚平台超载惩罚(this: void, context: 米亚运行时上下文, nowMs: number): void {
  if (context.阶段 < 2) return;
  if (context.上次平台超载检测Ms > 0 && nowMs - context.上次平台超载检测Ms < 米亚平台配置.超载检测间隔Ms) return;
  context.上次平台超载检测Ms = nowMs;
  if (!单位有效(context.Boss单位)) return;

  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位) ?? [];
  const 当前玩家人数 = 取当前有效玩家人数();
  const 测试容量覆盖 = 取平台超载测试容量覆盖(context);
  const capacity = 测试容量覆盖 > 0 ? 测试容量覆盖 : 取平台容量(当前玩家人数);
  const 本轮超载表: Record<string, boolean | undefined> = {};
  const 区域列表 = context.安全域区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    const 区域 = 区域列表[i];
    const id = 取平台ID(区域);
    if (id === "" || context.腐化转移污染平台ID === id) continue;
    const units = 取平台内英雄(区域, heroes);
    if (units.length > capacity) {
      本轮超载表[id] = true;
      处理超载平台(context, 区域, units, nowMs);
    }
  }

  let 仍有超载 = false;
  for (let i = 0; i < 区域列表.length; i++) {
    const id = 取平台ID(区域列表[i]);
    if (id === "") continue;
    if (本轮超载表[id] === true) {
      仍有超载 = true;
    } else {
      context.超载平台ID表[id] = undefined;
      context.超载平台下次叠层Ms表[id] = undefined;
    }
  }
  if (!仍有超载) {
    context.上次平台超载台词Ms = 0;
  }
}
