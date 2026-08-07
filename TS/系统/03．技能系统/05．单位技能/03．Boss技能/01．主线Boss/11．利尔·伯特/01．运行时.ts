/** @noSelfInFile */

import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';

const jass = require('jass.common') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export type 利尔检查阶段 = '检查中' | '失败等待惩罚' | '已结束';

export interface 利尔检查状态 {
  上下文: 利尔伯特运行时上下文;
  目标单位: any;
  装备: any;
  阶段: 利尔检查阶段;
  累计最终伤害: number;
  正常结束回调ID: number;
  失败惩罚回调ID: number;
}

export interface 利尔伯特运行时上下文 {
  Boss单位: any;
  清理: 机制清理篮子;
  正义审判递归锁: boolean;
  检查状态?: 利尔检查状态;
}

function 创建利尔伯特上下文(this: void, boss: any, 清理: 机制清理篮子): 利尔伯特运行时上下文 {
  return {
    Boss单位: boss,
    清理,
    正义审判递归锁: false,
    检查状态: undefined,
  };
}

const 利尔伯特上下文工厂 = 创建单位运行时上下文工厂<利尔伯特运行时上下文>({
  名称: '利尔·伯特',
  创建上下文: 创建利尔伯特上下文,
  死亡时自动清理: true,
});

export function 获取或创建利尔伯特上下文(this: void, boss: any): 利尔伯特运行时上下文 | undefined {
  return 利尔伯特上下文工厂.获取或创建(boss);
}

export function 获取利尔伯特上下文(this: void, boss: any): 利尔伯特运行时上下文 | undefined {
  return 利尔伯特上下文工厂.获取(boss);
}

export function 获取全部利尔伯特上下文(this: void): 利尔伯特运行时上下文[] {
  return 利尔伯特上下文工厂.获取全部();
}

export function 清理利尔伯特上下文(this: void, boss: any): void {
  利尔伯特上下文工厂.清理上下文(boss);
}

export function 利尔伯特单位存活(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && IsUnitType(unit, UNIT_TYPE_DEAD) !== true
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

