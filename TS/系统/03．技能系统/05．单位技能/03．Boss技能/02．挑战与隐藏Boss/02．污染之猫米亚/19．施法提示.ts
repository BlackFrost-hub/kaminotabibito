/** @noSelfInFile */

const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
};

export function 开始米亚常规施法(this: void, unit: any, 吟唱秒: number, 标题文本: string, 提示文本: string, 硬直秒?: number): void {
  开始硬直(unit, 硬直秒 ?? 吟唱秒);
  显示常规技能吟唱条({ 总时长: 吟唱秒, 颜色ID: 3, 标题文本, 提示文本 });
}
