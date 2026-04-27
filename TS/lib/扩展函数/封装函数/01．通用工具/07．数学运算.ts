/**
 * 数学运算工具函数
 * 加法/乘法叠加等通用计算
 */

const jass = require("jass.common") as any;

/**
 * 加法/乘法叠加计算
 * 正数：加法叠加（累加到 addValue）
 * 负数：乘法叠加（累乘到 multiplier）
 *
 * @param value 属性值
 * @param addValue 加法叠加引用对象
 * @param multiplier 乘法叠加引用对象
 */
export function OperatorRealMultiply(
  value: number,
  addValue: { value: number },
  multiplier: { value: number }
): void {
  if (value >= 0) {
    addValue.value += value;
  } else {
    multiplier.value *= (1 + value);
  }
}

/**
 * 抗性减伤计算（乘法叠加）
 *
 * @param resist 抗性值
 * @param multiplier 乘法叠加引用对象
 */
export function OperatorResistReduction(
  resist: number,
  multiplier: { value: number }
): void {
  multiplier.value *= (1 - resist);
}

/**
 * 创建可变数值容器
 * 用于传递引用
 */
export function createValueHolder(initialValue: number = 0): { value: number } {
  return { value: initialValue };
}

/**
 * 四舍五入到最近整数。
 */
export function round(value: number): number {
  if (value >= 0) return jass.R2I(value + 0.5);
  return -jass.R2I(-value + 0.5);
}

/**
 * 向上取整到整数。
 */
export function ceil(value: number): number {
  const truncated = jass.R2I(value);
  if (value > 0 && truncated < value) return truncated + 1;
  return truncated;
}

export function clampMin(value: number, minValue: number): number {
  return value < minValue ? minValue : value;
}

export function clampRange(value: number, minValue: number, maxValue: number): number {
  if (value < minValue) return minValue;
  if (value > maxValue) return maxValue;
  return value;
}

export function max(a: number, b: number): number {
  return a >= b ? a : b;
}

export function min(a: number, b: number): number {
  return a <= b ? a : b;
}

export {};
