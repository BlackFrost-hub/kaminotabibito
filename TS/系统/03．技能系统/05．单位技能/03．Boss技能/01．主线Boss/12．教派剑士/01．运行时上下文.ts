/** @noSelfInFile */

import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';

const { removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  removeDelayedCallback: (this: void, callbackId: number) => void;
};

const jass = require('jass.common') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export interface 教派剑士机制状态 {
  已结束?: boolean;
  [key: string]: any;
}

export interface 教派剑士运行时上下文 {
  Boss单位: any;
  清理: 机制清理篮子;
  黑魔法侵蚀递归锁: boolean;
  黑洞强化普攻就绪: boolean;
  黑洞强化普攻清除回调ID: number;
  旋风状态?: 教派剑士机制状态;
  黑洞状态?: 教派剑士机制状态;
  魔祭状态?: 教派剑士机制状态;
  分身状态?: 教派剑士机制状态;
}

function on清理教派剑士运行时状态(this: void, variable?: any): void {
  const 上下文 = variable as 教派剑士运行时上下文 | undefined;
  if (上下文 == null) return;
  if (上下文.黑洞强化普攻清除回调ID !== 0) removeDelayedCallback(上下文.黑洞强化普攻清除回调ID);
  上下文.黑魔法侵蚀递归锁 = false;
  上下文.黑洞强化普攻就绪 = false;
  上下文.黑洞强化普攻清除回调ID = 0;
  上下文.旋风状态 = undefined;
  上下文.黑洞状态 = undefined;
  上下文.魔祭状态 = undefined;
  上下文.分身状态 = undefined;
}

function 创建教派剑士上下文(this: void, boss: any, 清理: 机制清理篮子): 教派剑士运行时上下文 {
  const 上下文: 教派剑士运行时上下文 = {
    Boss单位: boss,
    清理,
    黑魔法侵蚀递归锁: false,
    黑洞强化普攻就绪: false,
    黑洞强化普攻清除回调ID: 0,
    旋风状态: undefined,
    黑洞状态: undefined,
    魔祭状态: undefined,
    分身状态: undefined,
  };
  清理.登记清理('教派剑士运行时状态', on清理教派剑士运行时状态, 上下文);
  return 上下文;
}

const 教派剑士上下文工厂 = 创建单位运行时上下文工厂<教派剑士运行时上下文>({
  名称: '教派剑士',
  创建上下文: 创建教派剑士上下文,
  死亡时自动清理: true,
});

export function 获取或创建教派剑士上下文(this: void, boss: any): 教派剑士运行时上下文 | undefined {
  return 教派剑士上下文工厂.获取或创建(boss);
}

export function 获取教派剑士上下文(this: void, boss: any): 教派剑士运行时上下文 | undefined {
  return 教派剑士上下文工厂.获取(boss);
}

export function 获取全部教派剑士上下文(this: void): 教派剑士运行时上下文[] {
  return 教派剑士上下文工厂.获取全部();
}

export function 清理教派剑士上下文(this: void, boss: any): void {
  教派剑士上下文工厂.清理上下文(boss);
}

export function 教派剑士单位存活(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && IsUnitType(unit, UNIT_TYPE_DEAD) !== true
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}
