/** @noSelfInFile */

const jass = require("jass.common") as any;

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animationName: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const QueueUnitAnimation = jass.QueueUnitAnimation as ((this: void, unit: any, animationName: string) => void) | undefined;

function 执行第三章电影单位动作(this: void, 参数: 剧情动作参数表): void {
  const 单位引用 = String(参数.单位引用 ?? "");
  if (单位引用 === "") return;
  const unit = 读取语义单位引用(单位引用);
  if (unit == null || unit === 0) return;

  const 动画编号 = Number(参数.动画编号);
  const 动画名 = String(参数.动画名 ?? "");
  if (参数.动画编号 != null && 动画编号 >= 0) {
    SetUnitAnimationByIndex(unit, 动画编号);
  } else if (动画名 !== "") {
    SetUnitAnimation(unit, 动画名);
  } else {
    return;
  }
  if (QueueUnitAnimation != null) QueueUnitAnimation(unit, String(参数.恢复动画名 ?? "stand"));
}

export const 第三章电影动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_播放电影单位动作": 执行第三章电影单位动作,
};
