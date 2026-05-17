/** @noSelfInFile */
/**
 * 吟唱条系统 - 数字格式化
 */

const jass = require("jass.common") as any;

const R2I = jass.R2I as (value: number) => number;

export function 取整小数(this: void, n: number): number {
  return R2I(n);
}

export function 四舍五入到一位小数(this: void, n: number): number {
  return R2I(n * 10 + 0.5);
}

export function 格式化一位小数(this: void, n: number): string {
  const 十倍值 = 四舍五入到一位小数(n);
  const 整数部分 = R2I(十倍值 / 10);
  let 小数部分 = (十倍值 - 整数部分 * 10).toString();
  if (小数部分.length <= 0) {
    小数部分 = "0";
  }
  return 整数部分.toString() + "." + 小数部分;
}

export function 格式化已过秒(this: void, 已过时间: number): string {
  return 格式化一位小数(已过时间);
}

export function 格式化剩余秒(this: void, 总时长: number, 已过时间: number): string {
  const 剩余 = 总时长 - 已过时间;
  if (剩余 < 0) return "0.0";
  return 格式化一位小数(剩余);
}
