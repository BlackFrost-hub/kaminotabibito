/** @noSelfInFile */

import type { 祖地双灵卫净化节点状态, 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 祖地双灵卫BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/02．挑战与隐藏Boss/05．祖地双灵卫';
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as { debugLogForce: (this: void, module: string, ...args: any[]) => void };

const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const jass = require('jass.common') as any;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const japi = require('jass.japi') as any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

function 销毁节点特效(this: void, node: 祖地双灵卫净化节点状态): void {
  if (node.特效 != null && node.特效 !== 0) DestroyEffect(node.特效);
  node.特效 = undefined;
}

function 取节点表现路径(this: void, node: 祖地双灵卫净化节点状态): string {
  const resources = 祖地双灵卫数值与表现配置.表现资源.双钥净化;
  if (node.阶段 === '破壳') return resources.节点污染外壳特效路径;
  if (node.阶段 === '校准') return resources.节点校准特效路径;
  if (node.阶段 === '已净化') return resources.节点净化完成特效路径;
  return '';
}

function 刷新节点表现(this: void, node: 祖地双灵卫净化节点状态): void {
  if (node.表现阶段 === node.阶段) return;
  销毁节点特效(node);
  node.表现阶段 = node.阶段;
  const path = 取节点表现路径(node);
  const resources = 祖地双灵卫数值与表现配置.表现资源.双钥净化;
  if (path !== '') {
    node.特效 = AddSpecialEffect(path, node.X, node.Y);
    if (node.特效 != null && node.特效 !== 0 && path === resources.节点污染外壳特效路径 && EXSetEffectSize != null) EXSetEffectSize(node.特效, 2.0);
    debugLogForce('祖地双灵卫-净化节点表现', '节点', node.序号, '阶段', node.阶段, '坐标', node.X, node.Y, '路径', path);
  }
}

function 登记节点统一清理(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.净化节点清理已登记) return;
  context.净化节点清理已登记 = true;
  context.清理.登记清理('祖地双灵卫-P3净化节点', function 清理双钥净化节点(this: void): void {
    for (let i = 0; i < context.净化节点列表.length; i++) 销毁节点特效(context.净化节点列表[i]);
  });
}

function 当前节点(this: void, context: 祖地双灵卫运行时上下文): 祖地双灵卫净化节点状态 | undefined {
  const index = context.当前净化节点序号 - 1;
  return index >= 0 && index < context.净化节点列表.length ? context.净化节点列表[index] : undefined;
}

export function 推进祖地双灵卫下一个净化节点(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.已净化节点数量 >= 祖地双灵卫数值与表现配置.P3.净化节点数量) {
    context.当前净化节点序号 = 0;
    return;
  }
  context.当前净化节点序号 = context.已净化节点数量 + 1;
  const node = 当前节点(context);
  if (node != null && node.阶段 !== '已净化') {
    node.阶段 = '破壳';
    node.校准截止Ms = 0;
    node.重试允许Ms = getServerTime() + 900;
    刷新节点表现(node);
  }
}

export function 更新祖地双灵卫双钥净化(this: void, context: 祖地双灵卫运行时上下文, now: number = getServerTime()): void {
  if (context.战斗已结束 || context.阶段 !== 'P3双蚀共鸣') return;
  登记节点统一清理(context);
  const node = 当前节点(context);
  if (node == null) return;
  if (node.阶段 === '校准' && node.校准截止Ms <= 0) node.校准截止Ms = now + 祖地双灵卫数值与表现配置.P3.校准阶段窗口秒 * 1000;
  if (node.阶段 === '校准' && now >= node.校准截止Ms) {
    node.阶段 = '破壳';
    node.校准截止Ms = 0;
    node.重试允许Ms = now + 祖地双灵卫数值与表现配置.P3.失败重试冷却秒 * 1000;
  }
  if (node.阶段 === '已净化' && node.表现阶段 !== '已净化') {
    if (context.已净化节点数量 < node.序号) context.已净化节点数量 = node.序号;
    if (context.已净化节点数量 > 祖地双灵卫数值与表现配置.P3.净化节点数量) context.已净化节点数量 = 祖地双灵卫数值与表现配置.P3.净化节点数量;
    context.P3共鸣层数 = 祖地双灵卫数值与表现配置.P3.净化节点数量 - context.已净化节点数量;
    if (context.P3共鸣层数 < 0) context.P3共鸣层数 = 0;
    context.净化易伤到Ms = now + 祖地双灵卫数值与表现配置.P3.净化后易伤秒 * 1000;
    const units = [context.赤誓灵卫单位, context.苍影灵卫单位];
    for (let i = 0; i < units.length; i++) {
      if (context.P3共鸣层数 > 0) {
        registerManualBuff(units[i], 祖地双灵卫BuffID.双蚀共鸣, 3600, 祖地双灵卫数值与表现配置.公共.P3每层共鸣减伤比例 * 100, { stack: context.P3共鸣层数, sourceName: '祖地双灵卫-双蚀共鸣' });
      } else {
        移除单位指定Buff(units[i], 祖地双灵卫BuffID.双蚀共鸣);
      }
      registerManualBuff(units[i], 祖地双灵卫BuffID.净化反冲, 祖地双灵卫数值与表现配置.P3.净化后易伤秒, 祖地双灵卫数值与表现配置.P3.净化后易伤比例 * 100, { sourceName: '祖地双灵卫-净化反冲' });
    }
    context.封门误判待触发 = true;
    播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.双钥净化, node.X, node.Y, 祖地双灵卫数值与表现配置.音效默认裁断距离);
    context.大型机制忙碌到Ms = now + 800;
  }
  刷新节点表现(node);
}

export const 双钥净化机制状态 = {
  类型: 'P3联合核心机制',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '先引导裂誓战躯踏碎节点外壳，再让无面祷影的灵魂潮穿过节点完成校准。',
  实现要求: '每次只激活一个节点，破壳与校准使用不同颜色和时间窗；失败后允许重试，不能永久锁死。',
} as const;
