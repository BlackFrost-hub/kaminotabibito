/** @noSelfInFile */

import { 单位存活 as 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 读取单位攻击力, 对单位造成强化伤害 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  对单位造成强化伤害: (this: void, source: any, target: any, amount: number) => void;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条, 显示致命惩罚吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  显示致命惩罚吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitScale = jass.SetUnitScale as (unit: any, x: number, y: number, z: number) => void;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const R2I = jass.R2I as (value: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const 攻击力属性ID = 1;
const 叠加移动速度属性ID = 9;

interface 月光灌注运行状态 {
  攻击力: number;
  移速扣减: number;
}

const 月光灌注状态表: Record<string, 月光灌注运行状态 | undefined> = {};
let 当前月光灌注Boss: any = null;

function 取月光灌注Key(this: void, unit: any): string {
  if (unit == null || unit === 0) return "";
  return tostring(取单位ID(unit));
}

function 回滚月光灌注状态(this: void, unit: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光灌注;
  const key = 取月光灌注Key(unit);
  if (key === "") return;
  const state = 月光灌注状态表[key];
  delete 月光灌注状态表[key];
  if (state == null) return;
  SGSS_SetState(unit, 攻击力属性ID, -state.攻击力);
  SGSS_SetState(unit, 叠加移动速度属性ID, state.移速扣减);
  SetUnitScale(unit, config.基础模型缩放, config.基础模型缩放, config.基础模型缩放);
  if (当前月光灌注Boss === unit) 当前月光灌注Boss = null;
}

function on月光灌注Buff移除(this: void, unit: any, _buffID: string, _row: any): void {
  if (unit == null || unit === 0) return;
  回滚月光灌注状态(unit);
}

function 播放神罚特效(this: void, x: number, y: number): void {
  const config = 瑟兰迪尔数值与表现配置.月光灌注;
  创建点特效({ 模型路径: config.神罚特效1, X: x, Y: y, 持续秒: 2 });
  创建点特效({ 模型路径: config.神罚特效2, X: x, Y: y, 持续秒: 2 });
}

export function 释放瑟兰迪尔月光灌注(this: void, context: 瑟兰迪尔运行时上下文): boolean {
  const config = 瑟兰迪尔数值与表现配置.月光灌注;
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.已触发月光灌注) return false;
  if (context.月光灌注组合执行器 == null) {
    context.月光灌注组合执行器 = 创建固定组合技能执行器<瑟兰迪尔运行时上下文>({
      名称: "瑟兰迪尔-月光灌注",
      清理: context.清理,
      互斥组: "瑟兰迪尔月光灌注",
    });
  }
  const 执行ID = context.月光灌注组合执行器.开始({
    key: "月光灌注",
    单位: boss,
    上下文: context,
    最大持续毫秒: R2I(config.施法硬直秒 * 1000) + 1000,
    阶段列表: 创建固定时间轴阶段列表([{
      时点毫秒: config.举剑冻结延迟Ms,
      名称: "月光灌注举剑停顿",
      执行: function 瑟兰迪尔月光灌注举剑停顿(this: void): void {
        if (单位有效(boss)) SetUnitTimeScale(boss, config.冻结动画速度);
      },
    }, {
      时点毫秒: R2I(config.施法硬直秒 * 1000),
      名称: "月光灌注生效",
      执行: function 瑟兰迪尔月光灌注生效(this: void): void {
        关闭吟唱条("常规技能");
        if (!单位有效(boss)) return;
        SetUnitTimeScale(boss, config.恢复动画速度);
        SetUnitAnimationByIndex(boss, config.恢复动画编号);
        结算瑟兰迪尔月光灌注(boss);
      },
    }]),
    结束回调: function 瑟兰迪尔月光灌注组合结束(this: void, event): void {
      if (event.原因 === "完成") return;
      关闭吟唱条("常规技能");
      if (!单位有效(boss)) return;
      SetUnitTimeScale(boss, config.恢复动画速度);
      SetUnitAnimationByIndex(boss, config.恢复动画编号);
    },
  });
  if (执行ID === 0) return false;
  context.已触发月光灌注 = true;

  播放瑟兰迪尔台词(boss, "月光灌注");
  开始硬直(boss, config.施法硬直秒);
  显示常规技能吟唱条({
    总时长: config.施法硬直秒,
    颜色ID: config.吟唱条颜色ID,
    标题文本: config.吟唱条标题文本,
    提示文本: config.吟唱条提示文本,
  });
  SetUnitTimeScale(boss, config.施法动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
  createTimedUnitEffect(boss, "origin", config.特效, config.施法硬直秒);
  return true;
}

function 结算瑟兰迪尔月光灌注(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光灌注;
  const duration = config.狂暴秒;
  移除单位指定Buff(boss, config.BuffID);
  const 攻击力加成 = 读取单位攻击力(boss) * config.攻击力加成;
  const 移速扣减 = GetUnitDefaultMoveSpeed(boss) * config.移动速度降低;
  SGSS_SetState(boss, 攻击力属性ID, 攻击力加成);
  SGSS_SetState(boss, 叠加移动速度属性ID, -移速扣减);
  月光灌注状态表[取月光灌注Key(boss)] = {
    攻击力: 攻击力加成,
    移速扣减,
  };
  当前月光灌注Boss = boss;
  registerManualBuff(boss, config.BuffID, duration, 攻击力加成, {
    sourceName: GetUnitName(boss),
    iconOverride: "BuffIcon\\Boss\\Thranduil\\yueguangguanzhu.blp",
    effectModelOverride: config.特效,
    effectValue2: -移速扣减,
    onRemove: on月光灌注Buff移除,
  });
  const 狂暴模型缩放 = config.基础模型缩放 * (1 + config.模型缩放加成);
  SetUnitScale(boss, 狂暴模型缩放, 狂暴模型缩放, 狂暴模型缩放);
  Sound3DII_CooPlayReuse(config.灌注完成音效, GetUnitX(boss), GetUnitY(boss), 0, config.灌注完成音效裁断距离);

  显示致命惩罚吟唱条({
    总时长: duration,
    颜色ID: config.惩罚吟唱条颜色ID,
    标题文本: config.惩罚吟唱条标题文本,
    提示文本: config.惩罚吟唱条提示文本,
  });

  addDelayedCallback(R2I(duration * 1000), function 瑟兰迪尔精灵神罚倒计时结束(this: void): void {
    关闭吟唱条("致命惩罚");
    if (!单位有效(boss)) return;
    移除单位指定Buff(boss, config.BuffID);
    播放瑟兰迪尔台词(boss, "精灵神罚");
    结算瑟兰迪尔精灵神罚(boss);
  });
}

function 结算瑟兰迪尔精灵神罚(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光灌注;
  Sound3DII_CooPlayReuse(config.神罚结算音效, GetUnitX(boss), GetUnitY(boss), 0, config.神罚结算音效裁断距离);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target)) continue;
    播放神罚特效(GetUnitX(target), GetUnitY(target));
    对单位造成强化伤害(boss, target, GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.神罚伤害最大生命比例);
  }
}


export function 清理瑟兰迪尔月光灌注(this: void): void {
  关闭吟唱条("致命惩罚");
  if (当前月光灌注Boss != null && 当前月光灌注Boss !== 0) {
    移除单位指定Buff(当前月光灌注Boss, 瑟兰迪尔数值与表现配置.月光灌注.BuffID);
    当前月光灌注Boss = null;
  }
}
