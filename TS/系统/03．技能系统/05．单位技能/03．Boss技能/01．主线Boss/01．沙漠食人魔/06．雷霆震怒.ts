/** @noSelfInFile */

import { 施放食人魔雷霆震怒 } from '../00．食人魔公共/01．共享机制';
import { 沙漠食人魔单位技能配置 } from './00．配置';
import { 沙漠食人魔技能配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 沙漠食人魔单位类型ID = stringToFourCCSafe(沙漠食人魔单位技能配置.单位ID);
const 雷霆震怒技能ID = stringToFourCCSafe(沙漠食人魔单位技能配置.技能ID.雷霆震怒);
let 雷霆震怒已注册 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 获取沙漠食人魔技能上下文(this: void, boss: any): any | undefined {
  return 单位存活(boss) ? boss : undefined;
}

export function 释放沙漠食人魔雷霆震怒(this: void, boss: any): boolean {
  return 施放食人魔雷霆震怒(boss, 沙漠食人魔技能配置.雷霆震怒);
}

function on雷霆震怒技能壳释放(this: void, _context: any, boss: any): void {
  释放沙漠食人魔雷霆震怒(boss);
}

export function 注册沙漠食人魔雷霆震怒(this: void): void {
  if (雷霆震怒已注册) return;
  雷霆震怒已注册 = true;
  注册单位技能壳监听({
    名称: '沙漠食人魔-雷霆震怒',
    单位类型ID: 沙漠食人魔单位类型ID,
    技能ID: 雷霆震怒技能ID,
    获取或创建上下文: 获取沙漠食人魔技能上下文,
    释放技能: on雷霆震怒技能壳释放,
    技能实例持续时间秒: 6,
  });
}
