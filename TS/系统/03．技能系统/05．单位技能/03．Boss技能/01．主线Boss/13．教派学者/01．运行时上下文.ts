/** @noSelfInFile */

import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';
import { 教派学者单位技能配置 } from './00．配置';

const jass = require('jass.common') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export interface 教派学者机制状态 {
  已结束?: boolean;
  [key: string]: any;
}

export interface 教派学者运行时上下文 {
  Boss单位: any;
  清理: 机制清理篮子;
  暗影弹幕ID表: Record<number, true | undefined>;
  深渊之牢状态?: 教派学者机制状态;
  冥神魔门状态?: 教派学者机制状态;
  冥之念欲状态?: 教派学者机制状态;
  邪狱追魂状态?: 教派学者机制状态;
  魔门反噬生效: boolean;
  魔门反噬原魔抗: number;
  魔门反噬结束回调ID: number;
}

function on清理教派学者运行时状态(this: void, variable?: any): void {
  const 上下文 = variable as 教派学者运行时上下文 | undefined;
  if (上下文 == null) return;
  上下文.暗影弹幕ID表 = {};
  上下文.深渊之牢状态 = undefined;
  上下文.冥神魔门状态 = undefined;
  上下文.冥之念欲状态 = undefined;
  上下文.邪狱追魂状态 = undefined;
}

function 创建教派学者上下文(this: void, boss: any, 清理: 机制清理篮子): 教派学者运行时上下文 {
  const 上下文: 教派学者运行时上下文 = {
    Boss单位: boss,
    清理,
    暗影弹幕ID表: {},
    深渊之牢状态: undefined,
    冥神魔门状态: undefined,
    冥之念欲状态: undefined,
    邪狱追魂状态: undefined,
    魔门反噬生效: false,
    魔门反噬原魔抗: 0,
    魔门反噬结束回调ID: 0,
  };
  清理.登记清理('教派学者运行时状态', on清理教派学者运行时状态, 上下文);
  return 上下文;
}

const 教派学者上下文工厂 = 创建单位运行时上下文工厂<教派学者运行时上下文>({
  名称: '教派学者',
  主动技能提示: 教派学者单位技能配置.主动技能提示,
  创建上下文: 创建教派学者上下文,
  死亡时自动清理: true,
});

export function 获取或创建教派学者上下文(this: void, boss: any): 教派学者运行时上下文 | undefined {
  return 教派学者上下文工厂.获取或创建(boss);
}

export function 获取教派学者上下文(this: void, boss: any): 教派学者运行时上下文 | undefined {
  return 教派学者上下文工厂.获取(boss);
}

export function 获取全部教派学者上下文(this: void): 教派学者运行时上下文[] {
  return 教派学者上下文工厂.获取全部();
}

export function 清理教派学者上下文(this: void, boss: any): void {
  教派学者上下文工厂.清理上下文(boss);
}

export function 教派学者单位存活(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && IsUnitType(unit, UNIT_TYPE_DEAD) !== true
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}
