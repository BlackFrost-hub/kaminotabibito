/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 教派学者技能配置, 教派学者音效配置 } from './02．数值与表现配置';

const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};
const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 教派学者单位类型ID = stringToFourCCSafe(教派学者单位技能配置.单位ID);
const 受击音效冷却毫秒 = 3000;
let 教派学者受击音效上次播放毫秒 = 0;
let 教派学者受击反应观察已注册 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function on教派学者受到最终伤害(this: void, target: any, _attacker: any, applied: number, _snapshot: any): void {
  if (!(applied > 0) || !单位存活(target) || GetUnitTypeId(target) !== 教派学者单位类型ID) return;
  const 当前毫秒 = getServerTime();
  if (当前毫秒 - 教派学者受击音效上次播放毫秒 < 受击音效冷却毫秒) return;
  教派学者受击音效上次播放毫秒 = 当前毫秒;
  播放Boss坐标音效(教派学者音效配置.受击, GetUnitX(target), GetUnitY(target), 教派学者技能配置.公共施法.音效裁断距离);
}

export function 注册教派学者受击反应观察(this: void): void {
  if (教派学者受击反应观察已注册) return;
  教派学者受击反应观察已注册 = true;
  registerAppliedFinalDamageListener(on教派学者受到最终伤害);
}
