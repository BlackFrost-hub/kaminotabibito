/** @noSelfInFile */
/**
 * 数值漂浮文字
 *
 * 目标：替代旧 JASS CombatNumbers 的 STES/YDLocal 写法。
 * - 直接 TS/Lua 调用，不走 STES。
 * - 默认跳过 0。
 * - 支持正负号、后缀、小数位。
 */

const jass = require("jass.common") as any;

const { CreateFloatTextOnUnit, CreateFloatTextAtPoint } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
  CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
};

const R2I = jass.R2I as (value: number) => number;

export interface 数值漂浮文字选项 {
  单位?: any;
  unit?: any;
  X?: number;
  Y?: number;
  x?: number;
  y?: number;

  数值: number;
  后缀?: string;
  suffix?: string;

  小数位数?: number;
  decimalPlaces?: number;
  显示正号?: boolean;
  showPlus?: boolean;
  零值隐藏?: boolean;
  hideZero?: boolean;

  size?: number;
  大小?: number;
  red?: number;
  红?: number;
  green?: number;
  绿?: number;
  blue?: number;
  蓝?: number;
  alpha?: number;
  透明度?: number;
  duration?: number;
  持续时间?: number;
  speedX?: number;
  speedY?: number;
  上飘速度?: number;
  height?: number;
  高度?: number;
}

export interface 数值漂浮文字样式 {
  size: number;
  red: number;
  green: number;
  blue: number;
  alpha: number;
  duration: number;
  speedX: number;
  speedY: number;
  height: number;
}

const 默认正数颜色红 = 100;
const 默认正数颜色绿 = 255;
const 默认正数颜色蓝 = 100;
const 默认负数颜色红 = 255;
const 默认负数颜色绿 = 80;
const 默认负数颜色蓝 = 80;
const 默认大小 = 10;
const 默认持续时间 = 1;
const 默认上飘速度 = 0.07;
const 最大小数位数 = 4;

function 数字转字符串(this: void, value: number): string {
  return tostring(value);
}

function 限制小数位数(this: void, decimalPlaces: number): number {
  if (decimalPlaces <= 0) return 0;
  if (decimalPlaces > 最大小数位数) return 最大小数位数;
  return R2I(decimalPlaces);
}

function 十的整数次方(this: void, count: number): number {
  let result = 1;
  for (let i = 0; i < count; i++) {
    result = result * 10;
  }
  return result;
}

function 绝对值(this: void, value: number): number {
  return value < 0 ? -value : value;
}

function 补齐小数位(this: void, value: number, places: number): string {
  let text = 数字转字符串(value);
  while (text.length < places) {
    text = "0" + text;
  }
  return text;
}

export function 格式化数值漂浮文字(this: void, value: number, options?: {
  后缀?: string;
  suffix?: string;
  小数位数?: number;
  decimalPlaces?: number;
  显示正号?: boolean;
  showPlus?: boolean;
}): string {
  const 后缀 = options?.后缀 ?? options?.suffix ?? "";
  const 显示正号 = options?.显示正号 ?? options?.showPlus ?? true;
  const 小数位数 = 限制小数位数(options?.小数位数 ?? options?.decimalPlaces ?? 0);
  const sign = value < 0 ? "-" : (显示正号 ? "+" : "");
  const absValue = 绝对值(value);

  if (小数位数 <= 0) {
    return sign + 数字转字符串(R2I(absValue)) + 后缀;
  }

  const scale = 十的整数次方(小数位数);
  const scaled = R2I(absValue * scale + 0.5);
  const integerPart = R2I(scaled / scale);
  const decimalPart = scaled - integerPart * scale;
  return sign + 数字转字符串(integerPart) + "." + 补齐小数位(decimalPart, 小数位数) + 后缀;
}

function 取数值漂浮文字样式(this: void, options: 数值漂浮文字选项): 数值漂浮文字样式 {
  const isNegative = options.数值 < 0;
  return {
    size: options.大小 ?? options.size ?? 默认大小,
    red: options.红 ?? options.red ?? (isNegative ? 默认负数颜色红 : 默认正数颜色红),
    green: options.绿 ?? options.green ?? (isNegative ? 默认负数颜色绿 : 默认正数颜色绿),
    blue: options.蓝 ?? options.blue ?? (isNegative ? 默认负数颜色蓝 : 默认正数颜色蓝),
    alpha: options.透明度 ?? options.alpha ?? 0,
    duration: options.持续时间 ?? options.duration ?? 默认持续时间,
    speedX: options.speedX ?? 0,
    speedY: options.上飘速度 ?? options.speedY ?? 默认上飘速度,
    height: options.高度 ?? options.height ?? 0,
  };
}

export function 显示数值漂浮文字(this: void, options: 数值漂浮文字选项): any {
  const 零值隐藏 = options.零值隐藏 ?? options.hideZero ?? true;
  if (零值隐藏 && options.数值 === 0) return null;

  const text = 格式化数值漂浮文字(options.数值, options);
  const style = 取数值漂浮文字样式(options);
  const unit = options.单位 ?? options.unit;
  if (unit != null && unit !== 0) {
    return CreateFloatTextOnUnit(unit, text, style);
  }

  const x = options.X ?? options.x ?? 0;
  const y = options.Y ?? options.y ?? 0;
  return CreateFloatTextAtPoint(x, y, text, style);
}

export function 显示单位数值漂浮文字(this: void, unit: any, value: number, options?: Omit<数值漂浮文字选项, "单位" | "unit" | "数值">): any {
  return 显示数值漂浮文字({
    ...(options ?? {}),
    单位: unit,
    数值: value,
  });
}

export function 显示坐标数值漂浮文字(this: void, x: number, y: number, value: number, options?: Omit<数值漂浮文字选项, "X" | "Y" | "x" | "y" | "数值">): any {
  return 显示数值漂浮文字({
    ...(options ?? {}),
    X: x,
    Y: y,
    数值: value,
  });
}
