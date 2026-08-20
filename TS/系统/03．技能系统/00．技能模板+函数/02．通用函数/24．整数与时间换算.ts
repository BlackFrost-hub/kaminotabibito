/** @noSelfInFile */
/**
 * 整数与时间换算
 *
 * 职责单一：为英雄技能层提供明确的取整与秒转毫秒语义，避免各英雄重复写
 * `Math.round(秒 * 1000)` 或本地公式，也避免直接引入 Lua 数学库。
 *
 * 语义说明：
 * - `jass.R2I` 是向零截断（对正数 = floor，对负数 = ceil 方向）。
 * - 本文件所有取整函数按数学定义实现（四舍五入/向下/向上），正负数均正确。
 * - 秒转毫秒统一使用四舍五入，与阿伦劳特等既有本地实现（R2I(秒*1000+0.5)）语义一致。
 */

const jass = require("jass.common") as any;
const R2I = jass.R2I as (this: void, value: number) => number;

/**
 * 四舍五入整数。
 * 正数：R2I(x + 0.5) = floor(x + 0.5)；负数：R2I(x - 0.5) = ceil(x - 0.5)。
 * 例：1.5→2，2.4→2，-1.5→-2，-1.4→-1。
 */
export function 四舍五入整数(this: void, value: number): number {
  return value >= 0 ? R2I(value + 0.5) : R2I(value - 0.5);
}

/**
 * 向下取整整数。
 * 正数：R2I = floor；负数且非整数：R2I(value) - 1。
 * 例：2.9→2，-1.5→-2，-2.0→-2。
 */
export function 向下取整整数(this: void, value: number): number {
  const 截断 = R2I(value);
  if (value >= 0) return 截断;
  return 截断 === value ? 截断 : 截断 - 1;
}

/**
 * 向上取整整数。
 * 恒等式：ceil(x) = -floor(-x)。
 * 例：2.1→3，-1.5→-1，2.0→2。
 */
export function 向上取整整数(this: void, value: number): number {
  return -向下取整整数(-value);
}

/**
 * 秒转毫秒（四舍五入）。
 * 例：0.5→500，0.033→33。
 */
export function 秒转毫秒(this: void, seconds: number): number {
  return 四舍五入整数(seconds * 1000);
}

/**
 * 秒转毫秒并保证不小于最小值（默认 0）。
 * 常用于计时器延迟，避免负数或零值导致异常调度；传入 最小值=1 可杜绝零延迟。
 */
export function 秒转正毫秒(this: void, seconds: number, 最小值: number = 0): number {
  const 毫秒 = 秒转毫秒(seconds);
  return 毫秒 < 最小值 ? 最小值 : 毫秒;
}

/**
 * 秒数转 Tick 数（按固定驱动间隔毫秒四舍五入）。
 * 仅用于"固定间隔周期回调推进的 Tick 计数"阈值判断（如每秒 10 次 → 周期毫秒=100），
 * 不得用于时间换算；调用方必须先确认周期回调间隔恒定，否则按真实驱动间隔计算。
 * 例：持续秒=8、周期毫秒=100 → 四舍五入(8*1000/100)=80 Tick。
 */
export function 秒转Tick数(this: void, 秒: number, 周期毫秒: number): number {
  return 四舍五入整数((秒 * 1000) / 周期毫秒);
}

export {};
