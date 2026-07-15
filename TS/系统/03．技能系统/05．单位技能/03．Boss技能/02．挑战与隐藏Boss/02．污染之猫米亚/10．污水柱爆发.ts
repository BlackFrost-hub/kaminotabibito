/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 距离平方XY as 距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心X, 取米亚平台中心Y } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 开始原地击飞 } from "../../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/index";
import { 计算组合技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害";
import { 创建点名预警执行器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/05．点名预警执行器";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 造成AOE技能伤害, 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};

const jass = require("jass.common") as any;

const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

interface 污水柱落点 {
  x: number;
  y: number;
}

function 计算污水柱爆发伤害(this: void, boss: any, target: any): number {
  const config = 米亚技能数值配置.污水柱爆发;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.爆发伤害Boss攻击力比例,
    目标最大生命比例: config.爆发伤害目标最大生命比例,
    总倍率: config.爆发伤害总倍率,
  });
}

function 计算污水柱水坑伤害(this: void, boss: any, target: any): number {
  const config = 米亚技能数值配置.污水柱爆发;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.水坑每秒伤害Boss攻击力比例,
    目标最大生命比例: config.水坑每秒伤害目标最大生命比例,
    总倍率: config.水坑每秒伤害总倍率,
  });
}

function 取污水柱数量(this: void): number {
  const playerCount = 取当前有效玩家人数();
  const config = 米亚技能数值配置.污水柱爆发;
  return playerCount <= 2 ? config.单双人数量 : config.三四人数量;
}

function 选择污水柱落点(this: void, boss: any): 污水柱落点[] {
  const count = 取污水柱数量();
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const candidates: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    if (单位有效(heroes[i])) candidates.push(heroes[i]);
  }

  const result: 污水柱落点[] = [];
  while (result.length < count && candidates.length > 0) {
    const index = GetRandomInt(0, candidates.length - 1);
    const hero = candidates[index];
    candidates.splice(index, 1);
    result.push({ x: GetUnitX(hero), y: GetUnitY(hero) });
  }
  while (result.length < count) {
    result.push({ x: 取米亚平台中心X(), y: 取米亚平台中心Y() });
  }
  return result;
}

function 播放污水柱锁定表现(this: void, point: 污水柱落点): void {
  const config = 米亚技能数值配置.污水柱爆发;
  创建点特效({
    模型路径: 米亚单位技能配置.特效.平台预警底圈,
    X: point.x,
    Y: point.y,
    Z: 20,
    缩放: 0.9,
    红: 80,
    绿: 255,
    蓝: 80,
    透明度: 210,
    持续秒: config.预警秒,
  });
}

function 播放污水柱爆发表现(this: void, point: 污水柱落点): void {
  const config = 米亚技能数值配置.污水柱爆发;
  const effects = config.爆发特效;
  for (let i = 0; i < effects.length; i++) {
    创建点特效({
      模型路径: effects[i],
      X: point.x,
      Y: point.y,
      缩放: config.爆发特效缩放,
      持续秒: config.爆发特效持续秒,
    });
  }
}

function 创建污水柱残留水坑(this: void, context: 米亚运行时上下文, point: 污水柱落点, 技能实例ID?: number): void {
  const config = 米亚技能数值配置.污水柱爆发;
  创建持续危险区域({
    X: point.x,
    Y: point.y,
    半径: config.水坑半径,
    持续时间: config.水坑持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: context.Boss单位,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    提示圈: { 类型: "敌方圆形" },
    on周期: function 米亚污水柱残留水坑周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        const target = 区域内单位[i];
        if (!单位有效(target)) continue;
        造成AOE技能伤害({
          来源: context.Boss单位,
          目标: target,
          伤害: 计算污水柱水坑伤害(context.Boss单位, target) * 取米亚平台超载伤害倍率(target),
          attackType: jass.ATTACK_TYPE_CHAOS,
          伤害类型: jass.DAMAGE_TYPE_POISON,
          weaponType: jass.WEAPON_TYPE_WHOKNOWS,
          来源类型: "Boss技能",
          技能实例ID,
          标签: "米亚污水柱爆发",
        });
        添加米亚腐化感染(context, target, config.水坑每秒腐化层数, "污水柱残留水坑");
      }
    },
  });
}

function 结算污水柱爆发(this: void, context: 米亚运行时上下文, point: 污水柱落点, 技能实例ID?: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return;

  const config = 米亚技能数值配置.污水柱爆发;
  const radius2 = config.爆发半径 * config.爆发半径;
  播放Boss坐标音效(米亚音效配置.污水柱爆发.爆发, point.x, point.y, 米亚音效配置.默认裁断距离);
  播放污水柱爆发表现(point);
  播放米亚台词(boss, "污水柱爆发", 2);

  const targets = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target)) continue;
    if (距离平方(point.x, point.y, GetUnitX(target), GetUnitY(target)) > radius2) continue;
    造成AOE技能伤害({
      来源: boss,
      目标: target,
      伤害: 计算污水柱爆发伤害(boss, target) * 取米亚平台超载伤害倍率(target),
      attackType: jass.ATTACK_TYPE_CHAOS,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
      技能实例ID,
      标签: "米亚污水柱爆发",
    });
    添加米亚腐化感染(context, target, config.命中腐化层数, "污水柱爆发");
    开始原地击飞(target, {
      持续时间: config.原地击飞持续秒,
      最小高度: config.原地击飞最小高度,
      最大高度: config.原地击飞最大高度,
      冲击波模型: "",
      持续特效模型: "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",
      持续特效间隔: 0.12,
      主单位: boss,
    });
  }

  创建污水柱残留水坑(context, point, 技能实例ID);
  播放米亚台词(boss, "污水柱爆发", 3);
}


export function 释放米亚污水柱爆发(this: void, context: 米亚运行时上下文): boolean {
  const config = 米亚技能数值配置.污水柱爆发;
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return false;
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "米亚污水柱爆发",
    持续时间秒: config.预警秒 + config.水坑持续秒 + 2,
  });

  const points = 选择污水柱落点(boss);
  播放米亚台词(boss, "污水柱爆发", 0);
  for (let i = 0; i < points.length; i++) {
    const point = points[i];
    创建点名预警执行器({
      清理: context.清理,
      名称: "米亚-污水柱爆发-" + (i + 1),
      锁定X: point.x,
      锁定Y: point.y,
      延迟秒: config.预警秒,
      锁定坐标: true,
      提示圈: {
        类型: "圆形",
        半径: config.爆发半径,
        动画速度: 1 / config.预警秒,
        来源单位: boss,
      },
      on锁定: function 米亚污水柱坐标锁定(this: void, result): void {
        播放污水柱锁定表现({ x: result.锁定X, y: result.锁定Y });
      },
      on结算: function 米亚污水柱坐标结算(this: void, result): void {
        结算污水柱爆发(context, { x: result.锁定X, y: result.锁定Y }, 技能实例ID);
      },
    });
  }
  const reminderId = addDelayedCallback(config.前提醒延迟毫秒, function 米亚污水柱爆发前提醒(this: void): void {
    if (!单位有效(context.Boss单位) || context.阶段 !== 2) return;
    播放米亚台词(context.Boss单位, "污水柱爆发", 1);
  });
  context.清理.登记延迟回调("米亚-污水柱爆发前提醒", reminderId);
  return true;
}
