/** @noSelfInFile */
/**
 * 控制时间计算模块
 *
 * 功能：计算削减后的控制时间，应用上限
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const {
  CONTROL_REDUCTION_CAP,
  BOSS_CONTROL_LIMITS,
} = require("系统.05．Buff系统.01．控制抗性.00．控制抗性常量") as {
  CONTROL_REDUCTION_CAP: number;
  BOSS_CONTROL_LIMITS: Record<string, number>;
};
const { getHeroDuration } = require("系统.05．Buff系统.01．控制抗性.01．控制检测") as {
  getHeroDuration: (abilityId: number) => number;
};

//=============================================================================
// 一、控制抗性属性读取
//=============================================================================

/**
 * 获取单位的减少控制时间属性
 *
 * 优先级：单位属性 > 玩家属性
 */
export function getControlReduction(unit: any): number {
  // 先读取单位属性
  const unitValue = YDUserDataGet("unit", unit, "眩晕抗性", "real");
  if (unitValue > 0.01) return unitValue;

  // 再读取玩家属性
  const player = jass.GetOwningPlayer(unit);
  if (player != null) {
    const playerValue = YDUserDataGet("player", player, "眩晕抗性", "real");
    if (playerValue > 0.01) return playerValue;
  }

  return 0;
}

//=============================================================================
// 二、控制时间计算
//=============================================================================

/**
 * 应用控制时间削减上限
 */
export function applyControlReductionCap(reduction: number): number {
  return reduction < CONTROL_REDUCTION_CAP ? reduction : CONTROL_REDUCTION_CAP;
}

/**
 * 检查并应用Boss控制时间上限
 */
export function applyBossControlLimit(unit: any, duration: number): number {
  const unitTypeId = jass.GetUnitTypeId(unit);

  // 遍历Boss配置，将字符串ID转换为FourCC后比较
  for (const [idStr, limit] of Object.entries(BOSS_CONTROL_LIMITS)) {
    if (stringToFourCC(idStr) === unitTypeId && duration > limit) {
      return limit;
    }
  }

  return duration;
}

/**
 * 基于原始持续时间计算削减后的控制时长
 *
 * 供快速Buff等直接传入持续时间的场景复用。
 */
export function calcReducedControlDuration(target: any, originalDuration: number): number {
  let duration = originalDuration;

  let reduction = getControlReduction(target);
  if (reduction > 0.01) {
    reduction = applyControlReductionCap(reduction);
    duration = originalDuration * (1 - reduction);
  }

  return applyBossControlLimit(target, duration);
}

/**
 * 计算削减后的控制时间
 *
 * @param target 目标单位
 * @param abilityId 技能ID
 * @returns 实际控制时间
 */
export function calcReducedControlTime(target: any, abilityId: number): number {
  // 获取原始控制时间
  const originalDuration = getHeroDuration(abilityId);
  return calcReducedControlDuration(target, originalDuration);
}

export {};
