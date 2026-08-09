/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "../00．配置";
import { 巴尔扎罗斯技能数值配置 } from "../02．数值与表现配置";
import { 播放巴尔扎罗斯台词, 播放格鲁姆台词 } from "../14．台词播放";
import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 开始充能, 停止充能, 单位是否正在充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, 参数: any) => number;
  停止充能: (this: void, id: number) => boolean;
  单位是否正在充能: (this: void, unit: any) => boolean;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, ms: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建单位绑定闪电, 销毁单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
  销毁单位绑定闪电: (this: void, 闪电句柄: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 显示大招吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示大招吟唱条: (this: void, 参数: any) => void;
};
const { 创建单位动画守护 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护") as {
  创建单位动画守护: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;

function 周期(this: void, ms: number, callback: (this: void) => void): number {
  return addPeriodicCallback(ms, callback);
}

function 停止周期(this: void, id: number): void {
  removePeriodicCallback(id);
}

function 清理炙热奉献连接(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.炙热奉献连接 != null) 销毁单位绑定闪电(context.炙热奉献连接);
  context.炙热奉献连接 = undefined;
}

function 恢复格鲁姆动画(this: void, grum: any): void {
  if (!单位有效(grum)) return;
  SetUnitTimeScale(grum, 1);
  SetUnitAnimationByIndex(grum, 0);
}

function on炙热奉献开始(this: void, context: 巴尔扎罗斯运行时上下文, grum: any, _chargeId: number): void {
  const config = 巴尔扎罗斯技能数值配置.炙热奉献;
  context.炙热奉献进行中 = true;
  registerManualBuff(grum, 巴尔扎罗斯单位技能配置.BuffID.炙热奉献, config.引导秒, 1, {
    stack: 1,
    sourceName: "巴尔扎罗斯-炙热奉献",
  });
  SetUnitAnimationByIndex(grum, config.动画编号);
  SetUnitTimeScale(grum, config.动画速度);
  播放巴尔扎罗斯台词(context.Boss单位, "炙热奉献", 0);
  显示大招吟唱条({
    总时长: config.引导秒,
    颜色ID: config.吟唱条颜色ID,
    标题文本: config.吟唱条标题文本,
    提示文本: config.吟唱条提示文本,
  });
  context.炙热奉献连接 = 创建单位绑定闪电({
    效果代码: config.火焰连接效果代码,
    起点单位: grum,
    终点单位: context.Boss单位,
    持续时间: config.引导秒,
    起点高度偏移: config.连接起点高度,
    终点高度偏移: config.连接终点高度,
    任一死亡时销毁: true,
  });
  context.清理.登记清理("巴尔扎罗斯-炙热奉献连接", function 巴尔扎罗斯炙热奉献连接清理(this: void): void {
    清理炙热奉献连接(context);
  });
}

function on炙热奉献完成(this: void, context: 巴尔扎罗斯运行时上下文, grum: any): void {
  const config = 巴尔扎罗斯技能数值配置.炙热奉献;
  if (!单位有效(context.Boss单位) || !单位有效(grum)) {
    return;
  }
  const healAmount = 取最大生命(context.Boss单位) * config.Boss治疗最大生命比例;
  doHeal({
    HealSource: grum,
    HealTarget: context.Boss单位,
    HealAmount: healAmount,
    ItemHeal: false,
    HealEffect: false,
  });
  registerManualBuff(context.Boss单位, 巴尔扎罗斯单位技能配置.BuffID.熔岩暴走, config.熔岩暴走持续秒, 1, {
    stack: 1,
    sourceName: "巴尔扎罗斯-炙热奉献",
  });
  context.炙热奉献进行中 = false;
  context.炙热奉献充能ID = 0;
  移除单位指定Buff(grum, 巴尔扎罗斯单位技能配置.BuffID.炙热奉献);
  清理炙热奉献连接(context);
  KillUnit(grum);
}

function on炙热奉献结束(this: void, context: 巴尔扎罗斯运行时上下文, grum: any, 原因: string): void {
  context.炙热奉献进行中 = false;
  context.炙热奉献充能ID = 0;
  移除单位指定Buff(grum, 巴尔扎罗斯单位技能配置.BuffID.炙热奉献);
  清理炙热奉献连接(context);
  if (原因 !== "完成") {
    播放格鲁姆台词(grum, "死亡", 0);
  }
  恢复格鲁姆动画(grum);
}

function 取最大生命(this: void, unit: any): number {
  return (GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE) as number) || 0;
}

export function 触发格鲁姆炙热奉献(this: void, context: 巴尔扎罗斯运行时上下文): number {
  const grum = context.格鲁姆;
  const boss = context.Boss单位;
  if (context.炙热奉献进行中 || context.炙热奉献已触发 || !单位有效(grum) || !单位有效(boss)) return 0;
  const config = 巴尔扎罗斯技能数值配置.炙热奉献;
  const life = jass.GetUnitState(grum, jass.UNIT_STATE_LIFE) as number;
  const maxLife = 取最大生命(grum);
  if (maxLife <= 0 || life > maxLife * config.触发生命比例) return 0;
  context.炙热奉献已触发 = true;
  const chargeId = 开始充能(grum, {
    持续时间: config.引导秒,
    主单位: boss,
    主单位死亡时中断: true,
    强制硬直: true,
    显示进度条特效: true,
    进度条特效动画序号: 0,
    开始回调: function 巴尔扎罗斯炙热奉献开始(this: void, unit: any, id: number): void { on炙热奉献开始(context, unit, id); },
    充能完成回调: function 巴尔扎罗斯炙热奉献完成(this: void, unit: any, _id: number): void { on炙热奉献完成(context, unit); },
    结束回调: function 巴尔扎罗斯炙热奉献结束(this: void, unit: any, reason: string, _id: number): void { on炙热奉献结束(context, unit, reason); },
  });
  context.炙热奉献充能ID = chargeId;
  return chargeId;
}

export function 中断格鲁姆炙热奉献(this: void, context: 巴尔扎罗斯运行时上下文): boolean {
  const chargeId = context.炙热奉献充能ID;
  if (chargeId <= 0) {
    return false;
  }
  return 停止充能(chargeId);
}

export function 初始化巴尔扎罗斯炙热奉献(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.炙热奉献已初始化) return;
  context.炙热奉献已初始化 = true;
  const timerId = 周期(500, function 巴尔扎罗斯炙热奉献检测(this: void): void {
    if (!单位有效(context.Boss单位) || !单位有效(context.格鲁姆)) {
      停止周期(timerId);
      return;
    }
    if (!context.炙热奉献进行中) 触发格鲁姆炙热奉献(context);
  });
  context.清理.登记周期回调("巴尔扎罗斯-炙热奉献检测", timerId);
  context.清理.登记清理("巴尔扎罗斯-炙热奉献充能", function 巴尔扎罗斯炙热奉献充能清理(this: void): void {
    if (单位是否正在充能(context.格鲁姆)) 中断格鲁姆炙热奉献(context);
  });
}
