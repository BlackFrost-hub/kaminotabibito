/** @noSelfInFile */
// 瞬移/突进路径预计算公共工具。
// 场景：技能需要"朝目标方向瞬移，遇不可越过的地形停在地形前"时，
// 先缓步模拟路径做地形判定，得到最终可瞬移落点，再由调用方一次性瞬移。
// 纯同步数值计算：不创建单位/特效/计时器，可在任意同步分支调用。
// 迁移真源参考：坂井悠二 E 目标点分支（源 JASS 用辅助马甲 0.01s×20 tick 每步 25 码探测，
// IsTerrainPathable(WALKABILITY) 判墙；TS 改为提前算完再瞬移，行为等效）。

const jass = require("jass.common") as any;

const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;

export interface 瞬移路径结果 {
  X: number;
  Y: number;
  撞墙: boolean; // true = 被地形拦截，X/Y 为地形前最后一个可通行步进点
  实际步数: number; // 实际前进的步数（撞墙时为撞墙前已走过的步数）
}

/**
 * 沿角度缓步模拟路径，返回最终可瞬移落点。
 * @param startX 起点X
 * @param startY 起点Y
 * @param 角度 前进方向（BJ 角度制，与 两点角度 同口径）
 * @param 步长 每步前进距离
 * @param 最大步数 最多模拟步数（步长×最大步数 = 最大路径长度）
 */
export function 计算瞬移路径(
  this: void,
  startX: number,
  startY: number,
  角度: number,
  步长: number,
  最大步数: number,
): 瞬移路径结果 {
  const 弧度 = 角度 * (3.14159265358979 / 180);
  const dx = 步长 * Math.cos(弧度);
  const dy = 步长 * Math.sin(弧度);
  let 当前X = startX;
  let 当前Y = startY;
  for (let i = 1; i <= 最大步数; i++) {
    const 下一步X = 当前X + dx;
    const 下一步Y = 当前Y + dy;
    // 下一步不可通行：停在当前位置（地形前），不再前进
    if (IsTerrainPathable(下一步X, 下一步Y, PATHING_TYPE_WALKABILITY)) {
      return { X: 当前X, Y: 当前Y, 撞墙: true, 实际步数: i - 1 };
    }
    当前X = 下一步X;
    当前Y = 下一步Y;
  }
  return { X: 当前X, Y: 当前Y, 撞墙: false, 实际步数: 最大步数 };
}

/** 坐标是否可步行通行（单点快速判定） */
export function 坐标可步行通行(this: void, x: number, y: number): boolean {
  return !IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
}
