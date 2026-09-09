/** @noSelfInFile */

export function 计算Boss脱战目标生命比例(this: void, 当前比例: number, 阶段阈值?: number): number {
  if (当前比例 >= 1) return 当前比例;
  let 目标比例: number;
  if (阶段阈值 != null && 阶段阈值 > 0 && 阶段阈值 <= 1) {
    目标比例 = 阶段阈值 * 1.35;
  } else {
    const 回复比例 = (1 - 当前比例) * 0.5;
    目标比例 = 当前比例 + (回复比例 > 0.3 ? 0.3 : 回复比例);
  }
  if (目标比例 > 1) 目标比例 = 1;
  return 目标比例 > 当前比例 ? 目标比例 : 当前比例;
}
