/** @noSelfInFile */
/**
 * 单位倒计时系统 - 对外接口
 */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

import type { 单位倒计时输入参数, 规范化单位倒计时参数 } from "./01．类型";
import { 启动单位倒计时核心 } from "./02．单位倒计时核心";

function 解析单位(this: void, 参数: 单位倒计时输入参数): any {
  return 参数.单位 ?? 参数.Unit;
}

function 解析持续时间(this: void, 参数: 单位倒计时输入参数): number {
  return 参数.持续时间 ?? 参数.time ?? 0;
}

function 解析位置X(this: void, 参数: 单位倒计时输入参数, unit: any): number {
  if (参数.X != null) return 参数.X;
  if (参数.x != null) return 参数.x;
  if (unit != null && unit !== 0) return GetUnitX(unit);
  return 0;
}

function 解析位置Y(this: void, 参数: 单位倒计时输入参数, unit: any): number {
  if (参数.Y != null) return 参数.Y;
  if (参数.y != null) return 参数.y;
  if (unit != null && unit !== 0) return GetUnitY(unit);
  return 0;
}

function 解析颜色值(this: void, 中文值: number | undefined, 英文值: number | undefined, 默认值: number): number {
  return 中文值 ?? 英文值 ?? 默认值;
}

function 规范化单位倒计时参数输入(this: void, 参数: 单位倒计时输入参数): 规范化单位倒计时参数 {
  const unit = 解析单位(参数);
  return {
    单位: unit,
    持续时间: 解析持续时间(参数),
    X: 解析位置X(参数, unit),
    Y: 解析位置Y(参数, unit),
    到期效果ID: 参数.到期效果ID ?? 参数.EffectID ?? 0,
    红: 解析颜色值(参数.红, 参数.red, 255),
    绿: 解析颜色值(参数.绿, 参数.green, 0),
    蓝: 解析颜色值(参数.蓝, 参数.blue, 0),
    透明度: 解析颜色值(参数.透明度, 参数.alpha, 255),
    强化持续时间: 参数.强化持续时间 ?? 参数.PowerUPtime,
    强化生命值: 参数.强化生命值 ?? 参数.PowerUPHP,
    强化模型: 参数.强化模型 ?? 参数.PowerUPModel,
    强化单位类型: 参数.强化单位类型 ?? 参数.PowerUPunitType,
  };
}

export function 启动单位倒计时(this: void, 参数: 单位倒计时输入参数): number {
  return 启动单位倒计时核心(规范化单位倒计时参数输入(参数));
}
