/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 获取或创建教派学者上下文, 教派学者单位存活, type 教派学者运行时上下文 } from './01．运行时上下文';
import { 教派学者技能配置, 教派学者音效配置 } from './02．数值与表现配置';
import { 播放教派学者台词 } from './09．台词播放';
import { 创建教派学者暗影弹幕 } from './03．暗影索命';
import { 创建固定受击次数机制单位, type 固定受击次数机制单位实例 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/03．固定受击次数机制单位';
import { 创建持续单位连线, type 持续单位连线实例 } from '../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线';
import { 按比例移除最大生命 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 开始硬直, 施加快速减速Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 常规BuffID } = require('系统.05．Buff系统.03．Buff表.00．Buff登记') as {
  常规BuffID: { 减速: string };
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { 吟唱条通道_大招 } = require('系统.09．表现系统.08．吟唱条.00．常量定义') as {
  吟唱条通道_大招: string;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_N?: number; [key: string]: any };
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;

interface 邪狱追魂状态 {
  已结束: boolean;
  上下文: 教派学者运行时上下文;
  锁链列表: 邪狱锁链状态[];
  已运行秒: number;
  周期回调ID: number;
  已发射弹幕: boolean;
}

interface 邪狱锁链状态 {
  已结束: boolean;
  父状态: 邪狱追魂状态;
  目标单位: any;
  机制实例?: 固定受击次数机制单位实例;
  连线实例?: 持续单位连线实例;
  减速Buff运行时?: any;
  下次减速刷新秒: number;
}

interface 邪狱追魂释放请求 {
  上下文: 教派学者运行时上下文;
}

interface 邪狱追魂读条关闭请求 {
  Boss单位: any;
}

const 邪狱追魂冥法技能ID = stringToFourCCSafe(教派学者单位技能配置.技能壳.邪狱追魂冥法);
const 锁链单位状态表: Record<number, 邪狱锁链状态 | undefined> = {};
const 邪狱追魂锁链减速来源 = '教派学者-邪狱追魂锁链';
let 邪狱追魂冥法已注册 = false;

function 读取当前难度N(this: void): number {
  const value = Number(globals.udg_N);
  return value === value && value > 0 ? value : 0;
}

function on邪狱追魂读条关闭(this: void, variable?: any): void {
  const 请求 = variable as 邪狱追魂读条关闭请求 | undefined;
  if (请求 == null) return;
  关闭吟唱条(吟唱条通道_大招);
}

function 开始邪狱追魂施法表现(this: void, 上下文: 教派学者运行时上下文): void {
  const boss = 上下文.Boss单位;
  const 公共 = 教派学者技能配置.公共施法;
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  开始硬直(boss, 公共.通魔施法秒);
  SetUnitAnimation(boss, 公共.动作名);
  播放教派学者台词(boss, '邪狱追魂冥法');
  显示大招吟唱条({ 总时长: 公共.通魔施法秒, 颜色ID: 公共.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 回调ID = addDelayedCallback(公共.通魔施法秒 * 1000, on邪狱追魂读条关闭, { Boss单位: boss } as 邪狱追魂读条关闭请求);
  上下文.清理.登记延迟回调('教派学者-邪狱追魂读条关闭', 回调ID);
}

function 结束单条邪狱锁链(this: void, 锁链: 邪狱锁链状态, 原因: string): void {
  if (锁链.已结束) return;
  锁链.已结束 = true;
  const 机制实例 = 锁链.机制实例;
  锁链.机制实例 = undefined;
  if (机制实例 != null) {
    delete 锁链单位状态表[机制实例.ID];
    机制实例.销毁('主动销毁');
  }
  if (锁链.连线实例 != null) {
    锁链.连线实例.停止(原因);
    锁链.连线实例 = undefined;
  }
  const 减速Buff运行时 = 锁链.减速Buff运行时;
  锁链.减速Buff运行时 = undefined;
  let 已移除减速 = false;
  if (减速Buff运行时 != null && getBuffRuntime(锁链.目标单位, 常规BuffID.减速) === 减速Buff运行时) {
    已移除减速 = 移除单位指定Buff(锁链.目标单位, 常规BuffID.减速);
  }
  移除单位指定Buff(锁链.目标单位, 教派学者技能配置.Buff.邪狱追魂锁链);
}

function 刷新邪狱锁链减速(this: void, 锁链: 邪狱锁链状态): void {
  const boss = 锁链.父状态.上下文.Boss单位;
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  施加快速减速Buff(boss, 锁链.目标单位, 0, 配置.锁链移动减速比例, 配置.锁链单次减速持续秒, 邪狱追魂锁链减速来源, '技能');
  const 当前减速Buff运行时 = getBuffRuntime(锁链.目标单位, 常规BuffID.减速);
  if (当前减速Buff运行时 != null && 当前减速Buff运行时.effectSourceName === 邪狱追魂锁链减速来源) 锁链.减速Buff运行时 = 当前减速Buff运行时;
}

function on邪狱锁链受击(this: void, unit: any, remaining: number, context: any): void {
}

function on邪狱锁链击破(this: void, unit: any, context: any): void {
  const 锁链 = 锁链单位状态表[GetHandleId(unit)];
}

function on邪狱锁链机制结束(this: void, unit: any, reason: any, _killer?: any, variable?: any): void {
  const 锁链 = variable as 邪狱锁链状态 | undefined;
  if (锁链 == null) return;
  delete 锁链单位状态表[GetHandleId(unit)];
  锁链.机制实例 = undefined;
  结束单条邪狱锁链(锁链, reason === '被击杀' || reason === '主动销毁' ? '锁链被击破' : String(reason));
}

function 结束邪狱追魂(this: void, 状态: 邪狱追魂状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  if (状态.周期回调ID !== 0) {
    removePeriodicCallback(状态.周期回调ID);
    状态.周期回调ID = 0;
  }
  for (let i = 0; i < 状态.锁链列表.length; i++) 结束单条邪狱锁链(状态.锁链列表[i], 原因);
  if (状态.上下文.邪狱追魂状态 === 状态) 状态.上下文.邪狱追魂状态 = undefined;
}

function on邪狱追魂清理(this: void, variable?: any): void {
  const 状态 = variable as 邪狱追魂状态 | undefined;
  if (状态 != null) 结束邪狱追魂(状态, '上下文清理');
}

function on邪狱追魂周期(this: void, variable?: any): void {
  const 状态 = variable as 邪狱追魂状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  const boss = 状态.上下文.Boss单位;
  if (!教派学者单位存活(boss)) {
    结束邪狱追魂(状态, 'Boss失效');
    return;
  }
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  状态.已运行秒 += 配置.锁链跟随间隔秒;
  for (let i = 0; i < 状态.锁链列表.length; i++) {
    const 锁链 = 状态.锁链列表[i];
    if (锁链.已结束) continue;
    if (!教派学者单位存活(锁链.目标单位) || 锁链.机制实例 == null || !锁链.机制实例.是否存活()) {
      结束单条邪狱锁链(锁链, '目标或机制单位失效');
      continue;
    }
    SetUnitX(锁链.机制实例.单位, GetUnitX(锁链.目标单位));
    SetUnitY(锁链.机制实例.单位, GetUnitY(锁链.目标单位));
    if (状态.已运行秒 + 0.001 >= 锁链.下次减速刷新秒) {
      刷新邪狱锁链减速(锁链);
      锁链.下次减速刷新秒 += 配置.锁链刷新减速间隔秒;
    }
  }
  if (状态.已运行秒 + 0.001 >= 配置.锁链持续秒) 结束邪狱追魂(状态, '锁链持续时间结束');
}

function on邪狱追魂发射暗影(this: void, variable?: any): void {
  const 状态 = variable as 邪狱追魂状态 | undefined;
  if (状态 == null || 状态.已结束 || 状态.已发射弹幕 || !教派学者单位存活(状态.上下文.Boss单位)) return;
  状态.已发射弹幕 = true;
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  const count = 配置.弹幕基础数量 + 配置.每难度弹幕数量 * 读取当前难度N();
  let created = 0;
  for (let i = 0; i < count; i++) {
    if (创建教派学者暗影弹幕(状态.上下文, GetRandomReal(0, 360), 教派学者技能配置.暗影索命.终结弹幕缩放, '邪狱追魂冥法') > 0) created++;
  }
}

function 创建邪狱锁链(this: void, 状态: 邪狱追魂状态, target: any): void {
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  const 锁链: 邪狱锁链状态 = { 已结束: false, 父状态: 状态, 目标单位: target, 下次减速刷新秒: 0 };
  锁链.机制实例 = 创建固定受击次数机制单位({
    清理: 状态.上下文.清理,
    名称: '教派学者-邪狱追魂锁链',
    单位名称: '邪狱锁链',
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    模型路径: 配置.锁链模型路径,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    固定站桩: false,
    禁止普攻: true,
    缩放: 配置.锁链缩放,
    持续时间: 配置.锁链持续秒,
    受击次数: 配置.锁链受击次数,
    计数模式: '纯普攻',
    未计数伤害无效: true,
    同步生命条: true,
    变量: 锁链,
    on受击: on邪狱锁链受击,
    on击破: on邪狱锁链击破,
    on结束: on邪狱锁链机制结束,
  });
  if (锁链.机制实例 == null) {
    锁链.已结束 = true;
    状态.锁链列表.push(锁链);
    return;
  }
  锁链单位状态表[锁链.机制实例.ID] = 锁链;
  锁链.连线实例 = 创建持续单位连线({
    清理: 状态.上下文.清理,
    名称: '教派学者-邪狱追魂连线',
    起点单位: boss,
    终点单位: 锁链.机制实例.单位,
    闪电代码: 配置.锁链闪电类型,
    持续秒: 配置.锁链持续秒,
    Tick间隔毫秒: 配置.锁链跟随间隔秒 * 1000,
  });
  registerManualBuff(target, 教派学者技能配置.Buff.邪狱追魂锁链, 配置.锁链持续秒, 配置.锁链移动减速比例, {
    sourceUnit: boss,
    effectSourceName: '邪狱追魂锁链',
    effectSourceType: '技能',
  });
  刷新邪狱锁链减速(锁链);
  锁链.下次减速刷新秒 = 配置.锁链刷新减速间隔秒;
  状态.锁链列表.push(锁链);
}

function 启动邪狱追魂机制(this: void, 上下文: 教派学者运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派学者单位存活(boss) || 上下文.邪狱追魂状态 != null) {
    return false;
  }
  const 配置 = 教派学者技能配置.邪狱追魂冥法;
  const 状态: 邪狱追魂状态 = { 已结束: false, 上下文, 锁链列表: [], 已运行秒: 0, 周期回调ID: 0, 已发射弹幕: false };
  上下文.邪狱追魂状态 = 状态;
  上下文.清理.登记清理('教派学者-邪狱追魂清理', on邪狱追魂清理, 状态);
  const 移除量 = 按比例移除最大生命(boss, 配置.自损最大生命比例, true);
  EC_CreateEffect(配置.自损特效路径, GetUnitX(boss), GetUnitY(boss), 0, 0, 配置.自损特效缩放, 1, 1);
  EC_CreateEffect(配置.起始特效路径, GetUnitX(boss), GetUnitY(boss), 0, 0, 配置.起始特效缩放, 1, 配置.起始特效持续秒);
  Sound3DII_CooPlayReuse(配置.起始音效路径, GetUnitX(boss), GetUnitY(boss), 0, 教派学者技能配置.公共施法.音效裁断距离);
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < 目标列表.length; i++) {
    if (教派学者单位存活(目标列表[i])) {
      Sound3DII_CooPlayReuse(教派学者音效配置.邪狱追魂冥法.锁链捆绑, GetUnitX(目标列表[i]), GetUnitY(目标列表[i]), 0, 教派学者技能配置.公共施法.音效裁断距离);
      创建邪狱锁链(状态, 目标列表[i]);
    }
  }
  状态.周期回调ID = addPeriodicCallback(配置.锁链跟随间隔秒 * 1000, on邪狱追魂周期, 状态);
  上下文.清理.登记周期回调('教派学者-邪狱追魂周期', 状态.周期回调ID);
  const 发射回调ID = addDelayedCallback(配置.弹幕发射延迟秒 * 1000, on邪狱追魂发射暗影, 状态);
  上下文.清理.登记延迟回调('教派学者-邪狱追魂弹幕发射', 发射回调ID);
  return true;
}

function on邪狱追魂延迟启动(this: void, variable?: any): void {
  const 请求 = variable as 邪狱追魂释放请求 | undefined;
  if (请求 != null) 启动邪狱追魂机制(请求.上下文);
}

export function 释放教派学者邪狱追魂冥法(this: void, 上下文: 教派学者运行时上下文): boolean {
  if (!教派学者单位存活(上下文?.Boss单位) || 上下文.邪狱追魂状态 != null) return false;
  开始邪狱追魂施法表现(上下文);
  const 回调ID = addDelayedCallback(教派学者技能配置.公共施法.通魔施法秒 * 1000, on邪狱追魂延迟启动, { 上下文 } as 邪狱追魂释放请求);
  上下文.清理.登记延迟回调('教派学者-邪狱追魂显式释放', 回调ID);
  return true;
}

export function 注册教派学者邪狱追魂冥法(this: void): void {
  if (邪狱追魂冥法已注册) return;
  邪狱追魂冥法已注册 = true;
  注册单位技能壳监听({
    名称: '教派学者-邪狱追魂冥法',
    单位类型ID: 教派学者单位技能配置.单位ID,
    技能ID: 教派学者单位技能配置.技能壳.邪狱追魂冥法,
    获取或创建上下文: 获取或创建教派学者上下文,
    释放技能: function 教派学者邪狱追魂冥法技能壳释放(this: void, 上下文: 教派学者运行时上下文): void {
      释放教派学者邪狱追魂冥法(上下文);
    },
  });
}
