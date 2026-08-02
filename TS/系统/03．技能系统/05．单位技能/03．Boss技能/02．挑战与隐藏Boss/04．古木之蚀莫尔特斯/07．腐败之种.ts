/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 取坐标角度, 极坐标X, 极坐标Y, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建世界坐标进度UI, 更新世界坐标进度UI, 销毁世界坐标进度UI, type 世界坐标进度UI } from "../../../../../09．表现系统/15．世界坐标进度UI";
import { 创建二阶贝塞尔XYZ轨迹, 创建原生弹幕 } from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";
import { 创建持续危险区域, type 持续危险区域实例 } from "../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域";
import type { 可攻击机制单位实例 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位";
import { 创建限次周期执行器, type 限次周期执行器实例 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/22．限次周期执行器";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getServerTime: (this: void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
interface 幼树实例 {
  context: 莫尔特斯运行时上下文;
  幼树单位: any;
  机制单位实例: 可攻击机制单位实例;
  区域实例?: 持续危险区域实例;
  剩余跳数: number;
}

interface 种子成长变量 {
  context: 莫尔特斯运行时上下文;
  seed: any;
  x: number;
  y: number;
  强化倒计时: 种子强化倒计时变量;
}

interface 种子强化倒计时变量 {
  seed: any;
  UI: 世界坐标进度UI | null;
  周期?: 限次周期执行器实例;
  到期时间毫秒: number;
}

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐败之种技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐败之种.技能槽位);
let 已注册 = false;

function 莫尔特斯腐败种子成长(this: void, variable?: any): void {
  const data = variable as 种子成长变量 | undefined;
  if (data == null) return;
  清理莫尔特斯腐败种子强化倒计时(data.强化倒计时);
  if (!data.seed.是否存活()) return;
  data.seed.销毁();
  创建腐败幼树(data.context, data.x, data.y);
}

function 清理莫尔特斯腐败种子强化倒计时(this: void, data: 种子强化倒计时变量 | undefined): void {
  if (data == null) return;
  if (data.周期 != null) {
    data.周期.停止();
    data.周期 = undefined;
  }
  销毁世界坐标进度UI(data.UI);
  data.UI = null;
}

function on莫尔特斯腐败种子死亡(this: void, _unit: any, _killer: any, variable?: any): void {
  清理莫尔特斯腐败种子强化倒计时(variable as 种子强化倒计时变量 | undefined);
}

function on莫尔特斯腐败种子销毁(this: void, _unit: any, variable?: any): void {
  清理莫尔特斯腐败种子强化倒计时(variable as 种子强化倒计时变量 | undefined);
}

function 莫尔特斯腐败种子强化倒计时(this: void, variable?: any): boolean {
  const data = variable as 种子强化倒计时变量 | undefined;
  if (data == null) return false;
  if (data.seed == null || !data.seed.是否存活()) {
    清理莫尔特斯腐败种子强化倒计时(data);
    return false;
  }
  const now = getServerTime();
  let remaining = (data.到期时间毫秒 - now) / 1000;
  if (remaining < 0) remaining = 0;
  更新世界坐标进度UI(data.UI, remaining);
  return true;
}

function 创建腐败幼树(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const data: 幼树实例 = {
    context,
    幼树单位: null,
    机制单位实例: undefined as any,
    剩余跳数: cfg.持续秒 / cfg.波动间隔秒,
  };
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败幼树",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.幼树单位类型,
    模型路径: cfg.幼树模型路径,
    X: x,
    Y: y,
    最大生命: cfg.幼树生命值,
    缩放: cfg.幼树缩放,
    固定站桩: true,
    禁止普攻: true,
    持续时间: 0,
    on死亡: function 莫尔特斯腐败幼树死亡(this: void): void {
      data.区域实例?.销毁();
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  data.机制单位实例 = instance;
  data.幼树单位 = instance.单位;
  data.区域实例 = 创建持续危险区域({
    X: GetUnitX(instance.单位),
    Y: GetUnitY(instance.单位),
    锚点单位: instance.单位,
    半径: cfg.波动半径,
    持续时间: cfg.持续秒 + cfg.波动间隔秒,
    检测间隔: cfg.波动间隔秒,
    所有者: boss,
    影响目标: "敌方",
    提示圈: {
      类型: "敌方圆形",
      锚点单位: instance.单位,
      半径: cfg.波动半径,
      持续时间: cfg.持续秒 + cfg.波动间隔秒,
      来源单位: boss,
      可手动销毁: true,
    },
    on周期: function 莫尔特斯腐败幼树区域周期(this: void, 区域内单位: any[]): void {
      幼树波动Tick(data, 区域内单位);
    },
    on销毁: function 莫尔特斯腐败幼树区域销毁(this: void): void {
      if (data.机制单位实例.是否存活()) data.机制单位实例.销毁();
    },
  });
  context.清理.登记清理("莫尔特斯-腐败幼树区域", function 莫尔特斯腐败幼树区域清理(this: void): void {
    data.区域实例?.销毁();
  });
}

function 幼树波动Tick(this: void, data: 幼树实例, 区域内单位: any[]): void {
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const boss = data.context.Boss单位;
  const tree = data.幼树单位;
  if (!单位有效(boss) || !data.机制单位实例.是否存活() || !单位有效(tree) || data.剩余跳数 <= 0) {
    data.区域实例?.销毁();
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  创建点特效({
    模型路径: cfg.幼树Tick特效路径,
    X: GetUnitX(tree),
    Y: GetUnitY(tree),
    持续秒: cfg.幼树Tick特效持续秒,
  });
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
      技能ID: 腐败之种技能ID,
      来源: boss,
      目标: hero,
      伤害公式: { 来源攻击力比例: cfg.每跳Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
    });
    应用莫尔特斯腐败值(data.context, hero, cfg.每跳腐败值);
  }
  if (data.剩余跳数 <= 0) data.区域实例?.销毁();
}

function 创建落地种子(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const 强化倒计时: 种子强化倒计时变量 = {
    seed: null,
    UI: null,
    周期: undefined,
    到期时间毫秒: getServerTime() + cfg.生长延迟秒 * 1000,
  };
  const seed = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败种子",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.种子单位类型,
    模型路径: cfg.投射物模型路径,
    X: x,
    Y: y,
    最大生命: cfg.种子生命值,
    缩放: cfg.落地种子缩放,
    固定站桩: true,
    禁止普攻: true,
    持续时间: cfg.生长延迟秒 + 1,
    变量: 强化倒计时,
    on死亡: on莫尔特斯腐败种子死亡,
    on销毁: on莫尔特斯腐败种子销毁,
  });
  if (seed == null) return;
  强化倒计时.seed = seed;
  强化倒计时.UI = 创建世界坐标进度UI({
    X: x,
    Y: y,
    Z: cfg.强化进度UI高度,
    最大值: cfg.生长延迟秒,
    当前值: cfg.生长延迟秒,
    标题: "强化",
    数值后缀: "秒",
    类型: "自然",
    平滑过渡秒: cfg.强化进度刷新间隔毫秒 / 1000,
    初始显示: true,
    雾中可见: false,
  });
  强化倒计时.周期 = 创建限次周期执行器<种子强化倒计时变量>({
    名称: "莫尔特斯-腐败种子强化倒计时",
    间隔毫秒: cfg.强化进度刷新间隔毫秒,
    最大执行次数: cfg.生长延迟秒 * 1000 / cfg.强化进度刷新间隔毫秒,
    变量: 强化倒计时,
    清理: context.清理,
    onTick: function 莫尔特斯腐败种子强化倒计时周期(this: void, _执行次数: number, variable?: 种子强化倒计时变量): boolean {
      return 莫尔特斯腐败种子强化倒计时(variable);
    },
  });
  播放Boss坐标音效(莫尔特斯音效配置.腐败之种.扎根成长, x, y, 莫尔特斯音效配置.默认裁断距离);
  const id = addDelayedCallback(cfg.生长延迟秒 * 1000, 莫尔特斯腐败种子成长, { context, seed, x, y, 强化倒计时 } as 种子成长变量);
  context.清理.登记延迟回调("莫尔特斯-腐败种子成长", id);
}

function 销毁腐败之种弹幕(this: void, 弹幕?: any): void {
  if (弹幕 == null || 弹幕 === 0 || 弹幕.销毁 == null) return;
  弹幕.销毁("手动销毁");
}

function 发射腐败之种(this: void, context: 莫尔特斯运行时上下文, tx: number, ty: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const sx = GetUnitX(boss);
  const sy = GetUnitY(boss);
  const angle = 取坐标角度(sx, sy, tx, ty) + 90;
  const distance = 莫尔特斯数值与表现配置.根须领域.单格边长 * cfg.中点偏移比例;
  const midX = 极坐标X((sx + tx) / 2, angle, distance);
  const midY = 极坐标Y((sy + ty) / 2, angle, distance);
  const 弹幕 = 创建原生弹幕({
    所有者: boss,
    载体模式: "特效",
    X: sx,
    Y: sy,
    方向角: 取坐标角度(sx, sy, tx, ty),
    速度: 0,
    生命周期: cfg.飞行秒,
    命中半径: 0,
    碰撞消失: false,
    禁用碰撞: true,
    不可阻挡: true,
    飞行高度: 0,
    附加特效1: {
      模型: cfg.投射物模型路径,
      跟随主弹幕参数: true,
      跟随轨迹俯仰: true,
      缩放: cfg.投射物缩放,
    },
    轨迹采样器: 创建二阶贝塞尔XYZ轨迹(
      sx,
      sy,
      0,
      midX,
      midY,
      cfg.弧线高度 * 2,
      tx,
      ty,
      0,
    ),
    on到达目标点: function 莫尔特斯腐败之种弹幕到达(this: void, _弹幕ID: number, _原因: "完成" | "距离结束"): void {
      创建落地种子(context, tx, ty);
    },
  });
  context.清理.登记清理("莫尔特斯-腐败之种弹幕", 销毁腐败之种弹幕, 弹幕);
}

export function 释放莫尔特斯腐败之种(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const spellTarget = GetSpellTargetUnit();
  const target = 单位有效(spellTarget) ? spellTarget : 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  创建技能提示圈({
    类型: "敌方圆形",
    X: targetX,
    Y: targetY,
    半径: cfg.波动半径,
    持续时间: cfg.动作播放秒 + cfg.飞行秒 + cfg.生长延迟秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    名称: "莫尔特斯-腐败之种",
    施法者: boss,
    目标X: targetX,
    目标Y: targetY,
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
    播放台词: function 莫尔特斯腐败之种台词(this: void): void {
      播放莫尔特斯台词(boss, "腐败之种");
    },
    on生效: function 莫尔特斯腐败之种时间线生效(this: void): void {
      发射腐败之种(context, targetX, targetY);
    },
  });
}

function on莫尔特斯腐败之种施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐败之种技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯腐败之种(context);
}

export function 注册莫尔特斯腐败之种(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "07．腐败之种",
    单位类型ID: 莫尔特斯单位类型ID,
    技能ID: 腐败之种技能ID,
    获取或创建上下文: 获取或创建莫尔特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 莫尔特斯运行时上下文, boss: any): void {
      on莫尔特斯腐败之种施法(boss, 腐败之种技能ID);
    },
  });
}
