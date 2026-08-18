/** @noSelfInFile */
/**
 * 06．对外接口
 *
 * 供技能 / 装备等外部模块调用的仇恨系统对外 API。
 *
 * 默认仇恨公式（见 01．仇恨计算）：仇恨值 = (实际伤害 / 目标最大生命) × 1000，
 * 即「造成目标 X% 最大生命伤害」对应的仇恨 = X × 10 点（如 30% → 300 点）。
 */

const { addThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  addThreat: (this: void, 敌人: any, 仇恨目标: any, 数值: number) => void;
};

/** 直接给「敌人」对「仇恨目标」累加指定数值的仇恨 */
export function 增加单位仇恨(敌人: any, 仇恨目标: any, 数值: number): void {
  addThreat(敌人, 仇恨目标, 数值);
}

/**
 * 按「相当于造成目标 X% 最大生命伤害」的仇恨量累加。
 * @param 相当于最大生命比例 例如 0.3 → 加 300 点仇恨
 */
export function 增加生命比例仇恨(敌人: any, 仇恨目标: any, 相当于最大生命比例: number): void {
  addThreat(敌人, 仇恨目标, Math.round(相当于最大生命比例 * 1000));
}

export {};
