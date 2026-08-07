/** @noSelfInFile */

import { 施放食人魔雷霆震怒 } from '../00．食人魔公共/01．共享机制';
import { 杀戮食人魔单位技能配置 } from './00．配置';
import { 获取或创建杀戮食人魔上下文, type 杀戮食人魔运行时上下文 } from './01．运行时上下文';
import { 杀戮食人魔技能配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as { stringToFourCCSafe: (this: void, text: string) => number };
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const 杀戮食人魔单位类型ID = stringToFourCCSafe(杀戮食人魔单位技能配置.单位ID);
const 雷霆震怒技能ID = stringToFourCCSafe(杀戮食人魔单位技能配置.技能ID.雷霆震怒);
let 雷霆震怒已注册 = false;

function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? GetHandleId(handle) : 0;
}

export function 释放杀戮食人魔雷霆震怒(this: void, context: 杀戮食人魔运行时上下文): boolean {
  const 是否开始 = 施放食人魔雷霆震怒(context.Boss单位, 杀戮食人魔技能配置.雷霆震怒);
  debugLogForce('杀戮食人魔-雷霆震怒', '释放请求', 'bossHid=', 取句柄ID(context.Boss单位), 'started=', 是否开始);
  return 是否开始;
}

function on雷霆震怒技能壳释放(this: void, context: 杀戮食人魔运行时上下文): void {
  const 是否开始 = 释放杀戮食人魔雷霆震怒(context);
  debugLogForce('杀戮食人魔-雷霆震怒', '技能壳释放', 'bossHid=', 取句柄ID(context.Boss单位), 'started=', 是否开始);
}

export function 注册杀戮食人魔雷霆震怒(this: void): void {
  if (雷霆震怒已注册) {
    debugLogForce('杀戮食人魔-雷霆震怒', '重复注册请求已忽略');
    return;
  }
  雷霆震怒已注册 = true;
  注册单位技能壳监听({ 名称: '杀戮食人魔-雷霆震怒', 单位类型ID: 杀戮食人魔单位类型ID, 技能ID: 雷霆震怒技能ID, 获取或创建上下文: 获取或创建杀戮食人魔上下文, 释放技能: on雷霆震怒技能壳释放, 技能实例持续时间秒: 6 });
  debugLogForce('杀戮食人魔-雷霆震怒', '技能壳注册完成', 'skillId=', 雷霆震怒技能ID, 'unitTypeId=', 杀戮食人魔单位类型ID);
}
