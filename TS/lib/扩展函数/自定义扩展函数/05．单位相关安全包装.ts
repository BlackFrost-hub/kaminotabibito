/** @noSelfInFile */
/**
 * 单位相关安全包装
 *
 * 说明：
 * 1. 不改老的 `00．单位相关.ts` 导出 ABI
 * 2. 专门给 TS 调用侧提供无 self 错位风险的安全入口
 */

const jass = require("jass.common") as any;
const { 登记单位排泄 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  登记单位排泄: (this: void, unit: any) => any;
};

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;

export function 创建单位并登记排泄安全(this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number): any {
  const 单位 = CreateUnit(owner, unitTypeId, x, y, facing);
  return 登记单位排泄(单位);
}

export {};
