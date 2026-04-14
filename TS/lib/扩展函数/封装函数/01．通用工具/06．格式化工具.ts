/**
 * 格式化工具函数
 * 数字格式化、字符串处理等
 */

/**
 * 格式化数字
 * 规则：≥10 取整数，<10 保留1位小数
 *
 * @param num 要格式化的数字
 * @returns 格式化后的字符串
 */
export function formatNumber(num: number): string {
  if (num >= 10) {
    return tostring(Math.floor(num));
  } else {
    return tostring(Math.floor(num * 10) / 10);
  }
}

/**
 * 格式化数字保留指定小数位
 *
 * @param num 要格式化的数字
 * @param decimals 小数位数
 * @returns 格式化后的字符串
 */
export function formatNumberDecimals(num: number, decimals: number): string {
  const multiplier = Math.pow(10, decimals);
  return tostring(Math.floor(num * multiplier) / multiplier);
}

/**
 * 格式化百分比
 *
 * @param value 百分比值（0.15 表示 15%）
 * @returns 格式化后的字符串（如 "15%"）
 */
export function formatPercent(value: number): string {
  return formatNumber(value * 100) + "%";
}

export {};
