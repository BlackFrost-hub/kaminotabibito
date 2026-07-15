/** @noSelfInFile */

import { 祖地双灵卫单位技能配置 } from './00．配置';
import { 获取全部祖地双灵卫运行时上下文, 获取或创建祖地双灵卫运行时上下文, type 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 注册祖地双灵同誓, 更新祖地双灵同誓 } from './03．双灵同誓';
import { 注册祖地双灵卫守门轮序 } from './04．守门轮序';
import { 绑定祖地双灵卫侵蚀生命下限, 更新祖地双灵卫侵蚀阶段 } from './05．侵蚀择形';
import { 更新祖地双灵卫双钥净化 } from './07．双钥净化';
import { 绑定祖地双灵卫同息生命下限, 更新祖地双灵卫同息归寂 } from './09．同息归寂';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';

const { 注册Boss自动技能启动监听 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

let 祖地双灵卫被动已注册 = false;

function 尝试绑定双灵卫上下文(this: void, unit: any, remainingRetries: number): void {
  const context = 获取或创建祖地双灵卫运行时上下文(unit);
  if (context != null) {
    绑定祖地双灵卫侵蚀生命下限(context);
    绑定祖地双灵卫同息生命下限(context);
    return;
  }
  if (remainingRetries <= 0) return;
  addDelayedCallback(250, function 双灵卫搭档延迟绑定(this: void): void {
    尝试绑定双灵卫上下文(unit, remainingRetries - 1);
  });
}

function on祖地双灵卫Boss启动(this: void, context: any): void {
  尝试绑定双灵卫上下文(context.Boss单位, 8);
}

function 推进祖地双灵卫运行时(this: void, context: 祖地双灵卫运行时上下文, now: number): void {
  更新祖地双灵同誓(context, now);
  更新祖地双灵卫侵蚀阶段(context, now);
  更新祖地双灵卫双钥净化(context, now);
  更新祖地双灵卫同息归寂(context, now);
}

function 注册双灵卫单位监听(this: void, name: string, unitId: string): void {
  注册Boss自动技能启动监听({
    名称: name,
    单位类型ID: stringToFourCC(unitId),
    on启动: on祖地双灵卫Boss启动,
  });
}

export function 注册祖地双灵卫被动效果(this: void): void {
  if (祖地双灵卫被动已注册) return;
  祖地双灵卫被动已注册 = true;
  注册祖地双灵同誓();
  注册祖地双灵卫守门轮序();
  const units = 祖地双灵卫单位技能配置.单位;
  注册双灵卫单位监听('赤誓灵卫运行时上下文绑定', units.赤誓灵卫.单位ID);
  注册双灵卫单位监听('裂誓战躯运行时上下文绑定', units.赤誓灵卫.变异单位ID);
  注册双灵卫单位监听('苍影灵卫运行时上下文绑定', units.苍影灵卫.单位ID);
  注册双灵卫单位监听('无面祷影运行时上下文绑定', units.苍影灵卫.变异单位ID);
  创建周期机制调度器({
    名称: '祖地双灵卫-联合运行时推进',
    间隔毫秒: 200,
    取当前时间: getServerTime,
    取上下文列表: 获取全部祖地双灵卫运行时上下文,
    执行: 推进祖地双灵卫运行时,
  });
}

export const 祖地双灵卫被动效果状态 = {
  已设计: true,
  已实现: true,
  已注册: true,
  包含机制: ['四单位Boss启动绑定', '双灵同誓', '侵蚀择形', '双钥净化', '同息归寂', '公共调度器'],
} as const;

注册祖地双灵卫被动效果();
