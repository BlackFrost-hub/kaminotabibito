/** @noSelfInFile */

import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';

const jass = require('jass.common') as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (group: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;

export interface 地精祭祀运行时上下文 {
  Boss单位: any;
  清理: 机制清理篮子;
}

function 创建地精祭祀上下文(this: void, boss: any, 清理: 机制清理篮子): 地精祭祀运行时上下文 {
  return { Boss单位: boss, 清理 };
}

const 地精祭祀上下文工厂 = 创建单位运行时上下文工厂<地精祭祀运行时上下文>({
  名称: '地精祭祀',
  创建上下文: 创建地精祭祀上下文,
  死亡时自动清理: true,
});

export function 获取或创建地精祭祀上下文(this: void, boss: any): 地精祭祀运行时上下文 | undefined {
  return 地精祭祀上下文工厂.获取或创建(boss);
}

export function 清理地精祭祀上下文(this: void, boss: any): void {
  地精祭祀上下文工厂.清理上下文(boss);
}

export function 地精祭祀单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

/** 与旧 JASS 相同：敌对、存活、非机械/远古，且飞行高度不超过指定值。 */
export function 获取地精祭祀范围目标(this: void, boss: any, x: number, y: number, 半径: number, 最大飞行高度: number): any[] {
  const 结果: any[] = [];
  if (!地精祭祀单位存活(boss)) return 结果;
  const 敌对玩家 = GetOwningPlayer(boss);
  const 单位组 = CreateGroup();
  GroupEnumUnitsInRange(单位组, x, y, 半径, null);
  while (true) {
    const 目标 = FirstOfGroup(单位组);
    if (目标 == null || 目标 === 0) break;
    GroupRemoveUnit(单位组, 目标);
    if (
      地精祭祀单位存活(目标)
      && IsUnitEnemy(目标, 敌对玩家) === true
      && IsUnitType(目标, UNIT_TYPE_MECHANICAL) !== true
      && IsUnitType(目标, UNIT_TYPE_ANCIENT) !== true
      && GetUnitFlyHeight(目标) <= 最大飞行高度
    ) {
      结果.push(目标);
    }
  }
  DestroyGroup(单位组);
  return 结果;
}
