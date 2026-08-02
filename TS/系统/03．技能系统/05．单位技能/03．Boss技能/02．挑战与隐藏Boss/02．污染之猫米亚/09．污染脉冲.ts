/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心X, 取米亚平台中心Y, 取米亚单位所在安全域 } from "./01．场地配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
import { 创建原生弹幕 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 显示场地常驻AOE吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示场地常驻AOE吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((effect: any, angle: number) => void) | undefined;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 污染脉冲弹幕飞行秒 = 0.5;

interface 米亚污染脉冲弹幕上下文 {
  上下文: 米亚运行时上下文;
  技能实例ID?: number;
  可命中目标ID表: Record<number, true | undefined>;
  本波已命中目标ID表: Record<number, true | undefined>;
}

const 米亚污染脉冲弹幕上下文表: Record<number, 米亚污染脉冲弹幕上下文 | undefined> = {};

function 销毁米亚污染脉冲扩散特效(this: void, effect: any): void {
  if (effect == null || effect === 0) return;
  DestroyEffect(effect);
}

function 米亚安全域当前有效(this: void, context: 米亚运行时上下文, 区域: any): boolean {
  if (区域 == null) return false;
  const id = 区域.配置.ID ?? 区域.配置.名称 ?? "";
  if (id !== "" && context.腐化转移污染平台ID === id) return false;
  if (id !== "" && context.超载平台ID表[id] === true) return false;
  return true;
}

function 单位在有效安全域内(this: void, context: 米亚运行时上下文, unit: any): boolean {
  return 米亚安全域当前有效(context, 取米亚单位所在安全域(unit, context.安全域区域组));
}

function 创建米亚污染脉冲可命中目标ID表(this: void, boss: any): Record<number, true | undefined> {
  const 目标ID表: Record<number, true | undefined> = {};
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < 目标列表.length; i++) {
    const target = 目标列表[i];
    if (!单位有效(target)) continue;
    const targetId = GetHandleId(target);
    if (targetId !== 0) 目标ID表[targetId] = true;
  }
  return 目标ID表;
}

function 米亚污染脉冲弹幕目标筛选(this: void, target: any, 弹幕ID: number): boolean {
  const 弹幕上下文 = 米亚污染脉冲弹幕上下文表[弹幕ID];
  if (弹幕上下文 == null || !单位有效(target)) return false;
  const targetId = GetHandleId(target);
  return 弹幕上下文.可命中目标ID表[targetId] === true;
}

function 米亚污染脉冲弹幕命中(this: void, target: any, 弹幕ID: number): void {
  const 弹幕上下文 = 米亚污染脉冲弹幕上下文表[弹幕ID];
  if (弹幕上下文 == null || !单位有效(target)) return;
  const targetId = GetHandleId(target);
  if (targetId === 0 || 弹幕上下文.本波已命中目标ID表[targetId] === true) return;
  弹幕上下文.本波已命中目标ID表[targetId] = true;

  const context = 弹幕上下文.上下文;
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return;
  if (单位在有效安全域内(context, target)) return;

  const config = 米亚技能数值配置.污染脉冲;
  执行BossAOE技能伤害({
    来源: boss,
    目标: target,
    伤害公式: {
      目标最大生命比例: config.每波最大生命伤害比例,
      总倍率: 取米亚平台超载伤害倍率(target),
    },
    attackType: jass.ATTACK_TYPE_NORMAL,
    伤害类型: jass.DAMAGE_TYPE_POISON,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    技能实例ID: 弹幕上下文.技能实例ID,
    标签: "米亚污染脉冲",
  });
  添加米亚腐化感染(context, target, config.每波腐化层数, "污染脉冲");
}

function 清理米亚污染脉冲弹幕上下文(this: void, _原因: any, 弹幕ID: number): void {
  delete 米亚污染脉冲弹幕上下文表[弹幕ID];
}

function 显示污染脉冲波预警(this: void, context: 米亚运行时上下文, waveIndex: number, 持续秒: number): void {
  const boss = context.Boss单位;
  const config = 米亚技能数值配置.污染脉冲;
  const radius = config.波次半径[waveIndex];
  if (!单位有效(boss) || radius == null || radius <= 0 || 持续秒 <= 0) return;
  创建技能提示圈({
    类型: "敌方圆形",
    X: 取米亚平台中心X(),
    Y: 取米亚平台中心Y(),
    半径: radius,
    持续时间: 持续秒,
    来源单位: boss,
  });
  const 区域列表 = context.安全域区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    const 区域 = 区域列表[i];
    if (!米亚安全域当前有效(context, 区域)) continue;
    const width = 区域.配置.右 - 区域.配置.左;
    const height = 区域.配置.上 - 区域.配置.下;
    创建技能提示圈({
      类型: "白色安全圆",
      X: 区域.中心X,
      Y: 区域.中心Y,
      半径: (width < height ? width : height) * 0.5,
      持续时间: 持续秒,
    });
  }
}

function 创建朝向点特效(this: void, model: string, x: number, y: number, scale: number, duration: number, yawDeg: number, z?: number): any {
  return 创建点特效({ 模型路径: model, X: x, Y: y, Z: z, 缩放: scale, Z轴角度: yawDeg, 持续秒: duration });
}

function 播放脉冲中心预警(this: void): void {
  const config = 米亚技能数值配置.污染脉冲;
  创建点特效({
    模型路径: config.中心预警特效,
    X: 取米亚平台中心X(),
    Y: 取米亚平台中心Y(),
    Z: 30,
    缩放: 3.0,
    持续秒: config.预警秒 + 0.2,
    红: 255,
    绿: 20,
    蓝: 20,
    透明度: 255,
  });
}

function 播放脉冲波表现(this: void, context: 米亚运行时上下文, waveIndex: number, 技能实例ID?: number, 上一波扩散特效?: any): any {
  const config = 米亚技能数值配置.污染脉冲;
  const boss = context.Boss单位;
  const centerX = 取米亚平台中心X();
  const centerY = 取米亚平台中心Y();
  const 波次半径 = config.波次半径[waveIndex];
  const 命中半径 = config.波次命中半径[waveIndex];
  const waveNo = waveIndex + 1;
  const angles = [0, 90, 180, 270];
  销毁米亚污染脉冲扩散特效(上一波扩散特效);
  if (!单位有效(boss) || 波次半径 == null || 波次半径 <= 0 || 命中半径 == null || 命中半径 <= 0) return null;

  const 可命中目标ID表 = 创建米亚污染脉冲可命中目标ID表(boss);
  const 本波已命中目标ID表: Record<number, true | undefined> = {};
  for (let i = 0; i < angles.length; i++) {
    const 弹幕 = 创建原生弹幕({
      所有者: boss,
      载体模式: "单位",
      X: centerX,
      Y: centerY,
      方向角: angles[i],
      速度: 波次半径 / 污染脉冲弹幕飞行秒,
      最大距离: 波次半径,
      生命周期: 污染脉冲弹幕飞行秒,
      命中半径,
      影响目标: "敌方",
      碰撞消失: false,
      每单位最大命中次数: 1,
      不可阻挡: true,
      禁用碰撞: true,
      显式改向后锁定方向: true,
      模型: config.脉冲中心特效,
      缩放: 1.0,
      攻击类型: jass.ATTACK_TYPE_NORMAL,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      武器类型: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
      技能实例ID,
      技能标签: "米亚污染脉冲",
      伤害形态: "AOE",
      目标筛选: 米亚污染脉冲弹幕目标筛选,
      on命中: 米亚污染脉冲弹幕命中,
      on结束: 清理米亚污染脉冲弹幕上下文,
    });
    米亚污染脉冲弹幕上下文表[弹幕.弹幕ID] = {
      上下文: context,
      技能实例ID,
      可命中目标ID表,
      本波已命中目标ID表,
    };
  }
  const effect = 创建朝向点特效(config.扩散波特效, centerX, centerY, 1.5 * waveNo, 2.0, 270, 0);
  return effect;
}

function 结算污染脉冲波(this: void, context: 米亚运行时上下文, waveIndex: number, 技能实例ID?: number, 上一波扩散特效?: any): any {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) {
    销毁米亚污染脉冲扩散特效(上一波扩散特效);
    return null;
  }

  const config = 米亚技能数值配置.污染脉冲;
  const centerX = 取米亚平台中心X();
  const centerY = 取米亚平台中心Y();
  const effect = 播放脉冲波表现(context, waveIndex, 技能实例ID, 上一波扩散特效);
  播放Boss坐标音效(米亚音效配置.污染脉冲.扩散波, centerX, centerY, 米亚音效配置.默认裁断距离);
  播放米亚台词(boss, "污染脉冲", waveIndex + 2);
  return effect;
}


function 创建污染脉冲时间轴事件(this: void, context: 米亚运行时上下文): 固定时间轴事件[] {
  const config = 米亚技能数值配置.污染脉冲;
  const boss = context.Boss单位;
  let 技能实例ID = 0;
  let 上一波扩散特效: any = null;
  const 事件列表: 固定时间轴事件[] = [{
    时点毫秒: 0,
    名称: "污染脉冲开始",
    执行: function 米亚污染脉冲开始(this: void): void {
      if (!单位有效(boss) || context.阶段 !== 2) return;
      技能实例ID = 创建独立技能伤害实例({
        来源类型: "Boss技能",
        标签: "米亚污染脉冲",
        持续时间秒: config.预警秒 + config.波次半径.length + 2,
      });
      播放脉冲中心预警();
      显示污染脉冲波预警(context, 0, config.预警秒);
      播放米亚台词(boss, "污染脉冲", 0);
      显示场地常驻AOE吟唱条({
        总时长: config.预警秒,
        颜色ID: 3,
        标题文本: "污染脉冲",
        提示文本: `预警${config.预警秒}秒后扩散${config.波次半径.length}波，进入白色安全平台可规避（避开红色扩散区）。`,
      });
    },
  }, {
    时点毫秒: (config.预警秒 - 3) * 1000,
    名称: "污染脉冲三秒提醒",
    执行: function 米亚污染脉冲三秒提醒(this: void): void {
      if (单位有效(context.Boss单位) && context.阶段 === 2) 播放米亚台词(context.Boss单位, "污染脉冲", 1);
    },
  }];
  for (let i = 0; i < config.波次半径.length; i++) {
    const waveIndex = i;
    if (waveIndex > 0) {
      事件列表.push({
        时点毫秒: (config.预警秒 + waveIndex - 1) * 1000,
        名称: "污染脉冲第" + (waveIndex + 1) + "波预警",
        执行: function 米亚污染脉冲后续波预警(this: void): void {
          显示污染脉冲波预警(context, waveIndex, 1);
        },
      });
    }
    事件列表.push({
      时点毫秒: (config.预警秒 + waveIndex) * 1000,
      名称: "污染脉冲第" + (waveIndex + 1) + "波",
      执行: function 米亚污染脉冲波次结算(this: void): void {
        上一波扩散特效 = 结算污染脉冲波(context, waveIndex, 技能实例ID, 上一波扩散特效);
      },
    });
  }
  return 事件列表;
}

export function 释放米亚污染脉冲(this: void, context: 米亚运行时上下文): boolean {
  const config = 米亚技能数值配置.污染脉冲;
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return false;
  if (context.污染脉冲组合执行器 == null) {
    context.污染脉冲组合执行器 = 创建固定组合技能执行器<米亚运行时上下文>({
      名称: "米亚-污染脉冲",
      清理: context.清理,
      互斥组: "米亚场地技能",
    });
  }
  const 执行ID = context.污染脉冲组合执行器.开始({
    key: "污染脉冲",
    单位: boss,
    上下文: context,
    最大持续毫秒: (config.预警秒 + config.波次半径.length) * 1000 + 500,
    阶段列表: 创建固定时间轴阶段列表(创建污染脉冲时间轴事件(context)),
    结束回调: function 米亚污染脉冲时间轴结束(this: void, event): void {
      if (event.原因 !== "完成") 关闭吟唱条("场地常驻AOE");
    },
  });
  return 执行ID !== 0;
}
