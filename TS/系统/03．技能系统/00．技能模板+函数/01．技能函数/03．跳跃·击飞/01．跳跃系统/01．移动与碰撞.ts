/** @noSelfInFile */
/**
 * 跳跃系统 - 移动与碰撞
 *
 * 包含单步移动尝试和多步推进逻辑。
 */
import {
  X_IsTerrainWalkable,
  X_IsUnitTerrainWalkable,
  X_GetAbleX,
  X_GetAbleY,
  BJ_DEGTORAD,
  MAX_SUB_STEP,
  WALKABLE_TOLERANCE,
  跳跃实例,
  跳跃映射,
  跳跃结束原因,
  在可玩区域内,
  计算坐标距离,
  计算抛物线高度,
  播放跳跃特效,
  GetUnitX,
  GetUnitY,
  GetUnitFlyHeight,
  SetUnitFlyHeight,
  SetUnitFacing,
  SetUnitX,
  SetUnitY,
  Cos,
  Sin,
} from "./00．共享";

function 尝试移动一步(
  实例: 跳跃实例,
  位移距离: number
): { 停止: boolean; 原因?: 跳跃结束原因 } {
  const 单位 = 实例.单位;
  const 当前X = GetUnitX(单位);
  const 当前Y = GetUnitY(单位);
  const 弧度 = 实例.角度 * BJ_DEGTORAD;
  const 新X = 当前X + 位移距离 * Cos(弧度);
  const 新Y = 当前Y + 位移距离 * Sin(弧度);

  if (!在可玩区域内(新X, 新Y)) {
    return { 停止: true, 原因: "阻挡" };
  }

  if (!X_IsTerrainWalkable(新X, 新Y)) {
    const 可通行X = X_GetAbleX();
    const 可通行Y = X_GetAbleY();
    const ableDist = 计算坐标距离(新X, 新Y, 可通行X, 可通行Y);
    if (ableDist > WALKABLE_TOLERANCE) {
      return { 停止: true, 原因: "阻挡" };
    }
  }

  if (!X_IsUnitTerrainWalkable(单位, 新X, 新Y)) {
    return { 停止: true, 原因: "阻挡" };
  }

  const 落点过滤 = 实例.落点过滤;
  if (typeof 落点过滤 === "function" && !落点过滤(新X, 新Y, 单位, 实例.id)) {
    return { 停止: true, 原因: "阻挡" };
  }

  if (实例.朝向跟随跳跃) {
    SetUnitFacing(单位, 实例.角度);
  }

  SetUnitX(单位, 新X);
  SetUnitY(单位, 新Y);
  实例.已移动 += 位移距离;

  const 进度 = 实例.总距离 > 0 ? (实例.已移动 / 实例.总距离) : 1;
  const 新附加高度 = 计算抛物线高度(进度, 实例.跳跃高度);
  const 当前高度 = GetUnitFlyHeight(单位);
  SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度 + 新附加高度, 0);
  实例.上次附加高度 = 新附加高度;

  if (实例.已移动 >= 实例.总距离) {
    return { 停止: true, 原因: "完成" };
  }

  return { 停止: false };
}

export function 推进一步(实例: 跳跃实例): { 停止: boolean; 原因?: 跳跃结束原因 } {
  const 起始已移动 = 实例.已移动;
  const 剩余距离 = 实例.总距离 - 实例.已移动;
  if (剩余距离 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 本tick位移 = 实例.每tick位移;
  if (本tick位移 > 剩余距离) {
    本tick位移 = 剩余距离;
  }
  if (本tick位移 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 剩余步长 = 本tick位移;
  while (剩余步长 > 0) {
    const 子步长 = 剩余步长 > MAX_SUB_STEP ? MAX_SUB_STEP : 剩余步长;
    const 结果 = 尝试移动一步(实例, 子步长);
    if (结果.停止) {
      if (实例.已移动 > 起始已移动) {
        播放跳跃特效(实例);
      }
      return 结果;
    }
    if (跳跃映射[实例.id] !== 实例) {
      return { 停止: true, 原因: "中断" };
    }
    剩余步长 -= 子步长;
  }

  if (实例.已移动 > 起始已移动) {
    播放跳跃特效(实例);
  }
  return { 停止: false };
}
