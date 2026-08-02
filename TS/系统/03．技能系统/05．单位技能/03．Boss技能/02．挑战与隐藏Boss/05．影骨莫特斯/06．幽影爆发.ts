/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取影骨莫特斯上下文, 获取或创建影骨莫特斯上下文, 刷新影骨幽灵形态Buff, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯模型动画配置, 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置, 影骨莫特斯音效配置 } from "./02．数值与表现配置";
import { 创建影骨召唤物 } from "./04．骸骨召唤";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y } from "./11．公共工具";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 执行非伤害生命移除 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除") as {
  执行非伤害生命移除: (this: void, params: any) => number;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 施加战斗视野压制 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制") as {
  施加战斗视野压制: (this: void, 参数: any) => void;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 幽影爆发技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.幽影爆发);
const 骷髅盗贼ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅盗贼单位类型);
const 骷髅射手ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅射手单位类型);

let 已注册幽影爆发 = false;
let 已注册幽影承伤 = false;

interface 影骨幽影爆发结束变量 {
  context: 影骨莫特斯运行时上下文;
  aura: any;
  已销毁: boolean;
}

interface 影骨幽影爆发召唤变量 {
  context: 影骨莫特斯运行时上下文;
  count: number;
  id: number;
}

function 关闭影骨幽影爆发状态吟唱条(this: void): void {
  关闭吟唱条("大招");
}

function on影骨幽影承伤修正(this: void, damageContext: any): number {
  if (!单位有效(damageContext.target) || GetUnitTypeId(damageContext.target) !== 影骨单位类型ID) return damageContext.currentDamage;
  const context = 获取影骨莫特斯上下文(damageContext.target);
  if (context == null || !context.幽影爆发中 || damageContext.target !== context.Boss单位) return damageContext.currentDamage;
  const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
  if (damageContext.isPhysicalDamage === true) return damageContext.currentDamage * (1 - cfg.物理承伤降低);
  if (damageContext.isMagicDamage === true) return damageContext.currentDamage * (1 + cfg.魔法承伤提高);
  return damageContext.currentDamage;
}

function 满足影骨幽影承伤条件(this: void, damageContext: any): boolean {
  if (damageContext == null || !单位有效(damageContext.target)) return false;
  if (GetUnitTypeId(damageContext.target) !== 影骨单位类型ID) return false;
  const context = 获取影骨莫特斯上下文(damageContext.target);
  return context != null && context.幽影爆发中 && damageContext.target === context.Boss单位;
}

function 确保幽影承伤修正(this: void): void {
  if (已注册幽影承伤) return;
  已注册幽影承伤 = true;
  创建条件伤害修正({
    名称: "影骨幽影爆发承伤修正",
    优先级: 52,
    条件: 满足影骨幽影承伤条件,
    修正: on影骨幽影承伤修正,
  });
}

function 幽影爆发召唤Tick(this: void, variable?: any): void {
  const data = variable as 影骨幽影爆发召唤变量 | undefined;
  if (data == null) return;
  const context = data.context;
  if (!单位有效(context.Boss单位) || !context.幽影爆发中) {
    removePeriodicCallback(data.id);
    return;
  }
  data.count += 1;
  const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
  const angle = GetRandomReal(0, 360);
  const x = 极坐标X(cfg.召唤中心X, cfg.召唤半径, angle);
  const y = 极坐标Y(cfg.召唤中心Y, cfg.召唤半径, angle);
  const unitType = data.count % 2 === 0 ? 骷髅射手ID : 骷髅盗贼ID;
  const instance = 创建影骨召唤物(context, unitType, x, y);
  if (instance != null && instance.单位 != null) context.幽影召唤物.push(instance.单位);
  if (data.count * cfg.召唤间隔秒 >= cfg.召唤持续秒) {
    removePeriodicCallback(data.id);
  }
}

function 结束影骨幽影爆发(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!context.幽影爆发中) return;
  context.幽影爆发中 = false;
  关闭影骨幽影爆发状态吟唱条();
  刷新影骨幽灵形态Buff(context);
  if (单位有效(context.Boss单位)) SetUnitVertexColor(context.Boss单位, 255, 255, 255, 255);
  const lossRatio = 影骨莫特斯数值与表现配置.幽影爆发.结束召唤物损血比例;
  for (let i = 0; i < context.幽影召唤物.length; i++) {
    const unit = context.幽影召唤物[i];
    if (!单位有效(unit)) continue;
    执行非伤害生命移除({
      目标: unit,
      数值: GetUnitState(unit, UNIT_STATE_LIFE) * lossRatio,
      不致死: true,
      显示文字: false,
      显示特效: false,
    });
  }
  context.幽影召唤物 = [];
}

function 销毁影骨幽灵形态特效(this: void, variable: 影骨幽影爆发结束变量): void {
  if (variable == null || variable.已销毁 || variable.aura == null || variable.aura === 0) return;
  variable.已销毁 = true;
  DestroyEffect(variable.aura);
}

function 影骨幽影爆发结束(this: void, variable: 影骨幽影爆发结束变量): void {
  if (variable == null) return;
  结束影骨幽影爆发(variable.context);
  销毁影骨幽灵形态特效(variable);
}

export function 释放影骨幽影爆发(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!单位有效(context.Boss单位) || context.幽影爆发中) return;
  const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
  启动基础施法时间线({
    名称: "影骨-幽影爆发起手",
    施法者: context.Boss单位,
    硬直秒: cfg.动画播放秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 影骨莫特斯模型动画配置.战斗待机编号,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.动画播放秒,
      颜色ID: 4,
      标题文本: "幽影爆发",
      提示文本: "幽影领域正在展开",
    },
    清理: context.清理,
    on生效: function 影骨幽影爆发起手时间线生效(this: void): void {},
  });
  显示大招吟唱条({
    通道: "大招",
    总时长: cfg.持续秒,
    颜色ID: 4,
    标题文本: "幽影爆发",
    提示文本: "幽影领域持续中",
  });
  context.清理.登记清理("影骨-幽影爆发状态吟唱条", 关闭影骨幽影爆发状态吟唱条);
  播放影骨莫特斯台词(context.Boss单位, "幽影爆发");
  创建点特效({
    模型路径: 影骨莫特斯表现配置.幽影爆发开场,
    X: cfg.召唤中心X,
    Y: cfg.召唤中心Y,
    持续秒: cfg.瞬时特效持续秒,
  });
  播放Boss坐标音效(影骨莫特斯音效配置.幽影爆发.领域展开, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心X, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心Y, 影骨莫特斯音效配置.默认裁断距离);
  播放Boss坐标音效(影骨莫特斯音效配置.幽影爆发.召唤潮开始, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心X, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心Y, 影骨莫特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 影骨莫特斯音效配置.怪物拟声.标识,
    音效路径列表: 影骨莫特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(context.Boss单位),
    Y: GetUnitY(context.Boss单位),
    裁断距离: 影骨莫特斯音效配置.默认裁断距离,
    冷却Ms: 影骨莫特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 影骨莫特斯音效配置.怪物拟声.爆发触发概率百分比,
  });
  const aura = AddSpecialEffectTarget(影骨莫特斯表现配置.幽灵形态持续, context.Boss单位, "origin");
  const endVariable = { context, aura, 已销毁: false } as 影骨幽影爆发结束变量;
  if (aura != null && aura !== 0) context.清理.登记清理("影骨-幽灵形态", 销毁影骨幽灵形态特效, endVariable);
  context.幽影爆发中 = true;
  context.幽影召唤物 = [];
  刷新影骨幽灵形态Buff(context);
  SetUnitVertexColor(context.Boss单位, 170, 80, 255, 150);
  施加战斗视野压制({
    清理: context.清理,
    名称: "影骨-幽影视野压制",
    来源单位: context.Boss单位,
    目标列表: 获取Boss技能敌对英雄列表(context.Boss单位),
    持续时间: 影骨莫特斯数值与表现配置.幽影爆发.持续秒,
    视野减少值: 影骨莫特斯数值与表现配置.幽影爆发.视野降低,
    图标路径: "BuffIcon\\Boss\\ShadowboneMortes\\shadow_vision.blp",
    叠加键: "影骨-幽影视野压制",
  });

  const summonVariable: 影骨幽影爆发召唤变量 = { context, count: 0, id: 0 };
  summonVariable.id = addPeriodicCallback(
    影骨莫特斯数值与表现配置.幽影爆发.召唤间隔秒 * 1000,
    幽影爆发召唤Tick,
    summonVariable,
  );
  context.清理.登记周期回调("影骨-幽影爆发召唤", summonVariable.id);
  context.清理.登记延迟回调("影骨-幽影爆发结束", addDelayedCallback(影骨莫特斯数值与表现配置.幽影爆发.持续秒 * 1000, 影骨幽影爆发结束, endVariable));
}

function on影骨幽影爆发施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 幽影爆发技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context != null) 释放影骨幽影爆发(context);
}

export function 注册影骨莫特斯幽影爆发(this: void): void {
  if (已注册幽影爆发) return;
  已注册幽影爆发 = true;
  确保幽影承伤修正();
  注册单位技能壳监听({
    名称: "06．幽影爆发",
    单位类型ID: 影骨单位类型ID,
    技能ID: 幽影爆发技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨幽影爆发施法(boss, 幽影爆发技能ID);
    },
  });
}
