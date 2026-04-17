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
  const unitValue = YDUserDataGet("unit", unit, "减少控制时间", "real");
  if (unitValue > 0.01) return unitValue;

  // 再读取玩家属性
  const player = jass.GetOwningPlayer(unit);
  if (player != null) {
    const playerValue = YDUserDataGet("player", player, "减少控制时间", "real");
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
  return Math.min(reduction, CONTROL_REDUCTION_CAP);
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
 * 计算削减后的控制时间
 *
 * @param target 目标单位
 * @param abilityId 技能ID
 * @returns 实际控制时间
 */
export function calcReducedControlTime(target: any, abilityId: number): number {
  // 获取原始控制时间
  const originalDuration = getHeroDuration(abilityId);

  // 获取控制抗性
  let reduction = getControlReduction(target);
  if (reduction <= 0.01) return originalDuration;

  // 应用上限
  reduction = applyControlReductionCap(reduction);

  // 计算削减后时间
  let duration = originalDuration * (1 - reduction);

  // 应用Boss上限
  duration = applyBossControlLimit(target, duration);

  return duration;
}

export {};
