/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 极坐标X, 极坐标Y, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建持续危险区域, type 持续危险区域实例 } from "../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域";
import type { 可攻击机制单位实例 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const IssuePointOrder = jass.IssuePointOrder as (unit: any, order: string, x: number, y: number) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};

interface 孢子云实例 {
  context: 莫尔特斯运行时上下文;
  孢子单位: any;
  机制单位实例: 可攻击机制单位实例;
  区域实例?: 持续危险区域实例;
  剩余跳数: number;
}

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐败孢子云技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐败孢子云.技能槽位);
let 已注册 = false;

function 销毁孢子云(this: void, data: 孢子云实例): void {
  const 区域实例 = data.区域实例;
  data.区域实例 = undefined;
  if (区域实例 != null) 区域实例.销毁();
  if (data.机制单位实例.是否存活()) data.机制单位实例.销毁();
}

function 孢子云Tick(this: void, data: 孢子云实例, 区域内单位: any[]): void {
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  const boss = data.context.Boss单位;
  const spore = data.孢子单位;
  if (!单位有效(boss) || !data.机制单位实例.是否存活() || !单位有效(spore) || data.剩余跳数 <= 0) {
    销毁孢子云(data);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const currentX = GetUnitX(spore);
  const currentY = GetUnitY(spore);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const 区域单位表: Record<number, boolean> = {};
  for (let i = 0; i < 区域内单位.length; i++) {
    const unit = 区域内单位[i];
    if (单位有效(unit)) 区域单位表[GetHandleId(unit)] = true;
  }
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (!区域单位表[GetHandleId(hero)]) continue;
    执行BossAOE技能伤害({
      技能ID: 腐败孢子云技能ID,
      来源: boss,
      目标: hero,
      伤害公式: { 目标最大生命比例: cfg.每秒目标最大生命比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
    });
    创建点特效({ 模型路径: cfg.命中特效路径, X: GetUnitX(hero), Y: GetUnitY(hero), 持续秒: cfg.瞬时特效持续秒 });
    应用莫尔特斯腐败值(data.context, hero, cfg.每秒腐败值);
  }
  const angle = GetRandomReal(0, 360);
  const destinationX = 极坐标X(currentX, angle, cfg.移动距离);
  const destinationY = 极坐标Y(currentY, angle, cfg.移动距离);
  IssuePointOrder(spore, "move", destinationX, destinationY);
  if (data.剩余跳数 <= 0) 销毁孢子云(data);
}

function 创建单团孢子云(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  const bossMaxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  const sporeCloudMaxLife = cfg.基础生命值 + bossMaxLife * cfg.Boss最大生命比例;
  const data: 孢子云实例 = {
    context,
    孢子单位: null,
    机制单位实例: undefined as any,
    剩余跳数: cfg.持续秒,
  };
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败孢子云",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.单位类型,
    模型路径: cfg.模型路径,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    朝向: GetRandomReal(0, 360),
    最大生命: sporeCloudMaxLife,
    生命值受小怪倍率: cfg.受小怪倍率生命,
    缩放: cfg.缩放,
    持续时间: 0,
    on死亡: function 莫尔特斯孢子云死亡(this: void): void {
      销毁孢子云(data);
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  data.机制单位实例 = instance;
  data.孢子单位 = instance.单位;
  播放Boss坐标音效(莫尔特斯音效配置.腐败孢子云.成形, GetUnitX(instance.单位), GetUnitY(instance.单位), 莫尔特斯音效配置.默认裁断距离);
  data.区域实例 = 创建持续危险区域({
    X: GetUnitX(instance.单位),
    Y: GetUnitY(instance.单位),
    锚点单位: instance.单位,
    半径: cfg.半径,
    持续时间: cfg.持续秒 + cfg.Tick间隔毫秒 / 1000,
    检测间隔: cfg.Tick间隔毫秒 / 1000,
    所有者: boss,
    影响目标: "敌方",
    提示圈: {
      类型: "敌方圆形",
      锚点单位: instance.单位,
      半径: cfg.半径,
      持续时间: cfg.持续秒 + cfg.Tick间隔毫秒 / 1000,
      来源单位: boss,
      可手动销毁: true,
    },
    on周期: function 莫尔特斯腐败孢子云区域周期(this: void, 区域内单位: any[]): void {
      孢子云Tick(data, 区域内单位);
    },
    on销毁: function 莫尔特斯腐败孢子云区域销毁(this: void): void {
      if (data.机制单位实例.是否存活()) data.机制单位实例.销毁();
    },
  });
  context.清理.登记清理("莫尔特斯-腐败孢子云区域", function 莫尔特斯腐败孢子云区域清理(this: void): void {
    data.区域实例?.销毁();
  });
}

function 追加孢子云创建时间轴(this: void, 事件列表: 固定时间轴事件[], context: 莫尔特斯运行时上下文, index: number): void {
  事件列表.push({
    时点毫秒: index * 1000,
    名称: "腐败孢子云第" + String(index + 1) + "团",
    执行: function 莫尔特斯创建孢子云(this: void): void {
      创建单团孢子云(context);
    },
  });
}

export function 释放莫尔特斯腐败孢子云(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  if (cfg.数量 <= 0) return;
  if (context.腐败孢子云组合执行器 == null) {
    context.腐败孢子云组合执行器 = 创建固定组合技能执行器<莫尔特斯运行时上下文>({
      名称: "莫尔特斯-腐败孢子云",
      清理: context.清理,
      互斥组: "莫尔特斯腐败孢子云",
    });
  }
  if (context.腐败孢子云组合执行器.是否运行中()) return;
  const 事件列表: 固定时间轴事件[] = [];
  for (let i = 0; i < cfg.数量; i++) 追加孢子云创建时间轴(事件列表, context, i);
  context.腐败孢子云组合执行器.开始({
    key: "腐败孢子云",
    单位: boss,
    上下文: context,
    最大持续毫秒: cfg.数量 * 1000,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  });
  启动基础施法时间线({
    名称: "莫尔特斯-腐败孢子云",
    施法者: boss,
    硬直秒: cfg.动作播放秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.动作播放秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 莫尔特斯腐败孢子云台词(this: void): void {
      播放莫尔特斯台词(boss, "腐败孢子云");
    },
    on生效: function 莫尔特斯腐败孢子云时间线生效(this: void): void {
    },
  });
}

function on莫尔特斯腐败孢子云施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐败孢子云技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯腐败孢子云(context);
}

export function 注册莫尔特斯腐败孢子云(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "05．腐败孢子云",
    单位类型ID: 莫尔特斯单位类型ID,
    技能ID: 腐败孢子云技能ID,
    获取或创建上下文: 获取或创建莫尔特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 莫尔特斯运行时上下文, boss: any): void {
      on莫尔特斯腐败孢子云施法(boss, 腐败孢子云技能ID);
    },
  });
}
