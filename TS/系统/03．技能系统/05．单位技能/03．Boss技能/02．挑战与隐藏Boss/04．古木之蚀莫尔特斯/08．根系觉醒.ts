/** @noSelfInFile */

import { 增加玩家腐败值, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 播放莫尔特斯限时动作, 显示莫尔特斯大招吟唱条, 关闭莫尔特斯大招吟唱条 } from "./16．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";

const { 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const ShowUnit = jass.ShowUnit as (unit: any, show: boolean) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { 创建限时摧毁目标组 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.02．限时摧毁目标组") as {
  创建限时摧毁目标组: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, data: any) => void, data?: any) => number;
};

const 莫尔特斯根系觉醒暂停来源 = "Boss:Moltes:根系觉醒";

function 延迟隐藏根系觉醒Boss(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.腐败之源组 != null && 单位有效(context.Boss单位)) {
    ShowUnit(context.Boss单位, false);
  }
}

function 治疗Boss最大生命比例(this: void, boss: any, ratio: number): void {
  if (!单位有效(boss) || !(ratio > 0)) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio, ItemHeal: false, HealEffect: false });
}

function 选择腐败之源格子(this: void, context: 莫尔特斯运行时上下文): any[] {
  const result: any[] = [];
  const grid = context.根须宫格;
  if (grid == null) return result;
  const pool: any[] = [];
  const 格子列表 = grid.格子列表 as any[];
  for (let i = 0; i < 格子列表.length; i++) pool.push(格子列表[i]);
  const count = 莫尔特斯数值与表现配置.根系觉醒.腐败之源数量;
  for (let i = 0; i < count && pool.length > 0; i++) {
    const index = GetRandomInt(0, pool.length - 1);
    result.push(pool[index]);
    pool.splice(index, 1);
  }
  return result;
}

function 根系觉醒失败爆发(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.根系觉醒;
  治疗Boss最大生命比例(boss, cfg.失败回血比例);
  创建点特效({ 模型路径: cfg.全屏爆发特效路径, X: GetUnitX(boss), Y: GetUnitY(boss), 缩放: cfg.全屏爆发特效缩放, 持续秒: cfg.瞬时特效持续秒 });
  播放Boss坐标音效(莫尔特斯音效配置.根系觉醒.失败爆发, GetUnitX(boss), GetUnitY(boss), 莫尔特斯音效配置.默认裁断距离);
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "莫尔特斯根系觉醒",
    持续时间秒: 2,
  });
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    执行BossAOE技能伤害({
      来源: boss,
      目标: hero,
      伤害公式: { 来源攻击力比例: cfg.全屏爆发伤害Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      技能实例ID,
      标签: "莫尔特斯根系觉醒",
    });
    增加玩家腐败值(context, hero, cfg.全屏爆发腐败值);
  }
}

function 创建腐败之源目标列表(this: void, context: 莫尔特斯运行时上下文): any[] {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.根系觉醒;
  const cells = 选择腐败之源格子(context);
  const targets: any[] = [];
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    targets.push({
      清理: context.清理,
      名称: "莫尔特斯-腐败之源",
      主人单位: boss,
      所属玩家: GetOwningPlayer(boss),
      单位类型: cfg.腐败之源单位类型,
      模型路径: cfg.腐败之源模型路径,
      X: cell.中心X,
      Y: cell.中心Y,
      最大生命: cfg.腐败之源生命值,
      缩放: cfg.腐败之源缩放,
      固定站桩: true,
      on死亡: 莫尔特斯腐败之源死亡,
      on销毁: 莫尔特斯腐败之源销毁,
    });
    const circle = AddSpecialEffect(cfg.腐败之源脚下特效路径, cell.中心X, cell.中心Y);
    context.清理.登记特效("莫尔特斯-腐败之源脚下圈", circle);
  }
  return targets;
}

function 莫尔特斯腐败之源死亡(this: void, unit: any): void {
  const cfg = 莫尔特斯数值与表现配置.根系觉醒;
  创建点特效({ 模型路径: cfg.腐败之源摧毁特效路径, X: GetUnitX(unit), Y: GetUnitY(unit), 缩放: cfg.腐败之源摧毁特效缩放, 持续秒: cfg.瞬时特效持续秒 });
  播放Boss坐标音效(莫尔特斯音效配置.根系觉醒.腐败之源摧毁, GetUnitX(unit), GetUnitY(unit), 莫尔特斯音效配置.默认裁断距离);
}

function 莫尔特斯腐败之源销毁(this: void, unit: any): void {
  const cfg = 莫尔特斯数值与表现配置.根系觉醒;
  创建点特效({ 模型路径: cfg.腐败之源摧毁特效路径, X: GetUnitX(unit), Y: GetUnitY(unit), 缩放: cfg.腐败之源摧毁特效缩放, 持续秒: cfg.瞬时特效持续秒 });
  播放Boss坐标音效(莫尔特斯音效配置.根系觉醒.腐败之源摧毁, GetUnitX(unit), GetUnitY(unit), 莫尔特斯音效配置.默认裁断距离);
}

function 莫尔特斯根系觉醒超时(this: void, _剩余数量: number, context: 莫尔特斯运行时上下文): void {
  根系觉醒失败爆发(context);
}

function 莫尔特斯根系觉醒结束(this: void, _是否成功: boolean, _剩余数量: number, context: 莫尔特斯运行时上下文): void {
  关闭莫尔特斯大招吟唱条();
  if (单位有效(context.Boss单位)) {
    ShowUnit(context.Boss单位, true);
    移除单位暂停(context.Boss单位, 莫尔特斯根系觉醒暂停来源);
  }
  context.腐败之源组 = undefined;
}

export function 触发莫尔特斯根系觉醒(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.根系觉醒已触发 || !单位有效(context.Boss单位)) return;
  context.根系觉醒已触发 = true;
  const cfg = 莫尔特斯数值与表现配置.根系觉醒;
  显示莫尔特斯大招吟唱条(cfg.限时秒, "根系觉醒", "在时间结束前摧毁全部腐败之源");
  播放莫尔特斯限时动作(context.Boss单位, cfg.动画编号, cfg.动画速度, cfg.动作播放秒);
  播放莫尔特斯台词(context.Boss单位, "根系觉醒");
  播放Boss坐标音效(莫尔特斯音效配置.根系觉醒.机制开始, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 莫尔特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 莫尔特斯音效配置.怪物拟声.标识,
    音效路径列表: 莫尔特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(context.Boss单位),
    Y: GetUnitY(context.Boss单位),
    裁断距离: 莫尔特斯音效配置.默认裁断距离,
    冷却Ms: 莫尔特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 莫尔特斯音效配置.怪物拟声.转阶段触发概率百分比,
  });
  添加单位暂停(context.Boss单位, 莫尔特斯根系觉醒暂停来源);
  context.腐败之源组 = 创建限时摧毁目标组({
    清理: context.清理,
    名称: "莫尔特斯-根系觉醒",
    持续秒: cfg.限时秒,
    目标列表: 创建腐败之源目标列表(context),
    变量: context,
    on超时: 莫尔特斯根系觉醒超时,
    on结束: 莫尔特斯根系觉醒结束,
  });
  const hideId = addDelayedCallback(cfg.显形动作秒 * 1000, 延迟隐藏根系觉醒Boss, context);
  context.清理.登记延迟回调("莫尔特斯-根系觉醒显形动作", hideId);
}
