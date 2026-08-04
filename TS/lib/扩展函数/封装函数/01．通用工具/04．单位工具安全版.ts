/** @noSelfInFile */

const jass = require("jass.common") as any;

const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;

type 单位组遍历回调 = (this: void, unit: any) => void;

const 单位组遍历回调栈: 单位组遍历回调[] = [];

function on安全遍历单位组(this: void): void {
  const 回调 = 单位组遍历回调栈[单位组遍历回调栈.length - 1];
  if (typeof 回调 !== "function") return;
  const 单位 = GetEnumUnit();
  if (单位 == null || 单位 === 0) return;
  回调(单位);
}

/**
 * `@noSelfInFile` 兼容的单位组遍历。
 * 使用具名 JASS `ForGroup` 回调，不修改原单位组，支持同步嵌套遍历。
 */
export function forEachUnitInGroupSafe(this: void, 单位组: any, 回调: 单位组遍历回调): void {
  if (单位组 == null || 单位组 === 0 || typeof 回调 !== "function") return;
  单位组遍历回调栈.push(回调);
  ForGroup(单位组, on安全遍历单位组);
  单位组遍历回调栈.pop();
}

export {};
