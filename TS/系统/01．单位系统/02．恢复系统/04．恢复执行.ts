/**
 * 恢复执行模块
 *
 * 功能：周期性执行单位恢复
 */

const jass = require("jass.common") as any;
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  forEachUnitInGroup: (group: any, action: (unit: any) => void) => void;
};
const {
  calcBaseLifeRegen,
  calcBaseManaRegen,
  calcTotalLifeRegen,
  calcTotalManaRegen,
  calcBossTotalLifeRegen,
  getPercentLifeRegen,
  getPercentManaRegen,
} = require("系统.01．单位系统.02．恢复系统.01．恢复计算") as {
  calcBaseLifeRegen: (unit: any) => number;
  calcBaseManaRegen: (unit: any) => number;
  calcTotalLifeRegen: (unit: any, baseRegen: number, itemBonus: number, unitMultiplier: number) => number;
  calcTotalManaRegen: (unit: any, baseRegen: number) => number;
  calcBossTotalLifeRegen: (unit: any) => number;
  getPercentLifeRegen: (unit: any) => number;
  getPercentManaRegen: (unit: any) => number;
};
const { calcItemLifeRegenBonus } = require("系统.01．单位系统.02．恢复系统.02．装备恢复效果") as {
  calcItemLifeRegenBonus: (unit: any) => number;
};
const { getUnitLifeRegenMultiplier } = require("系统.01．单位系统.02．恢复系统.03．单位恢复特性") as {
  getUnitLifeRegenMultiplier: (unit: any) => number;
};
const {
  REGEN_THRESHOLD,
  PERCENT_REGEN_THRESHOLD,
} = require("系统.01．单位系统.02．恢复系统.00．恢复常量") as {
  REGEN_THRESHOLD: number;
  PERCENT_REGEN_THRESHOLD: number;
};

//=============================================================================
// 一、单位恢复执行
//=============================================================================

/**
 * 执行单位生命恢复
 */
function applyLifeRegen(unit: any, regen: number): void {
  if (regen <= 0) return;

  const currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE);
  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);

  // 不超过最大生命
  const lifeGap = maxLife - currentLife;
  const actualRegen = regen < lifeGap ? regen : lifeGap;
  if (actualRegen <= 0) return;

  jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife + actualRegen);
}

/**
 * 执行单位魔法恢复
 */
function applyManaRegen(unit: any, regen: number): void {
  if (regen <= 0) return;

  const currentMana = jass.GetUnitState(unit, jass.UNIT_STATE_MANA);
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);

  // 不超过最大魔法
  const manaGap = maxMana - currentMana;
  const actualRegen = regen < manaGap ? regen : manaGap;
  if (actualRegen <= 0) return;

  jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRegen);
}

//=============================================================================
// 二、玩家英雄恢复处理
//=============================================================================

/**
 * 处理玩家英雄恢复
 * 与 JASS 源代码逻辑完全一致
 */
export function processPlayerHeroRegen(unit: any): void {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return;

  // ========== 生命恢复计算 ==========
  // 1. 基础生命恢复 = 力量 × 0.32
  let baseLifeRegen = calcBaseLifeRegen(unit);

  // 2. 装备加成（如 I0BR：最大生命 × 0.12）
  const itemBonus = calcItemLifeRegenBonus(unit);
  baseLifeRegen += itemBonus;

  // 3. 单位特性倍率
  const unitMultiplier = getUnitLifeRegenMultiplier(unit);
  baseLifeRegen *= unitMultiplier;

  // 4. 读取固定生命恢复（来自装备、技能等）
  const fixedLifeRegen = YDUserDataGet("unit", unit, "生命恢复", "real") || 0;

  // 5. 计算总固定生命恢复 = 固定恢复 + 基础恢复
  const totalFixedLifeRegen = fixedLifeRegen + baseLifeRegen;

  // 6. 存储生命恢复到玩家属性（供多面板显示）
  YDUserDataSet("player", player, "生命恢复", "real", totalFixedLifeRegen);

  // 7. 读取百分比生命恢复（上限 0.06）
  const percentLifeRegen = getPercentLifeRegen(unit);

  // 8. 读取生命恢复属性增幅
  const lifeRegenAmplify = YDUserDataGet("player", player, "生命恢复属性增幅", "real") || 0;

  // 9. 计算总生命恢复 = (1 + 增幅) × (最大生命 × 百分比回复 + 生命恢复)
  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);
  const totalLifeRegen = (1 + lifeRegenAmplify) * (maxLife * percentLifeRegen + totalFixedLifeRegen);

  // ========== 魔法恢复计算 ==========
  // 1. 基础魔法恢复 = 智力 × 0.15
  const baseManaRegen = calcBaseManaRegen(unit);

  // 2. 读取固定魔法恢复（来自装备、技能等）
  const fixedManaRegen = YDUserDataGet("unit", unit, "魔法恢复", "real") || 0;

  // 3. 计算总固定魔法恢复 = 固定恢复 + 基础恢复
  const totalFixedManaRegen = fixedManaRegen + baseManaRegen;

  // 4. 存储魔法恢复到玩家属性（供多面板显示）
  YDUserDataSet("player", player, "魔法恢复", "real", totalFixedManaRegen);

  // 5. 读取百分比魔法恢复（上限 0.04）
  const percentManaRegen = getPercentManaRegen(unit);

  // 6. 计算总魔法恢复 = 1 × (最大魔法 × 百分比回复 + 魔法恢复)
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);
  const totalManaRegen = 1 * (maxMana * percentManaRegen + totalFixedManaRegen);

  // ========== 存储总恢复值（供多面板显示） ==========
  YDUserDataSet("player", player, "总生命恢复", "real", totalLifeRegen);
  YDUserDataSet("player", player, "总魔法恢复", "real", totalManaRegen);
  YDUserDataSet("player", player, "生命恢复%", "real", percentLifeRegen);
  YDUserDataSet("player", player, "魔法恢复%", "real", percentManaRegen);

  // ========== 执行恢复 ==========
  // 生命恢复阈值检查（> 0.50 或百分比 >= 0.01）
  if (totalLifeRegen > REGEN_THRESHOLD || percentLifeRegen >= PERCENT_REGEN_THRESHOLD) {
    applyLifeRegen(unit, totalLifeRegen);
  }

  // 魔法恢复阈值检查
  if (totalManaRegen > REGEN_THRESHOLD || percentManaRegen >= PERCENT_REGEN_THRESHOLD) {
    applyManaRegen(unit, totalManaRegen);
  }
}

//=============================================================================
// 三、Boss单位恢复处理
//=============================================================================

/**
 * 处理Boss单位恢复
 */
export function processBossRegen(unit: any): void {
  const totalLifeRegen = calcBossTotalLifeRegen(unit);

  if (totalLifeRegen > REGEN_THRESHOLD) {
    applyLifeRegen(unit, totalLifeRegen);
  }
}

//=============================================================================
// 四、周期性恢复主函数
//=============================================================================

/**
 * 获取玩家英雄组
 */
function getPlayerHeroGroup(): any {
  return YDUserDataGet("string", "玩家英雄", "单位组", "group");
}

/**
 * 获取动漫Boss单位组
 */
function getBossGroup(): any {
  return YDUserDataGet("string", "动漫Boss", "单位组", "group");
}

/**
 * 每秒恢复处理主函数
 */
export function onRegenTimer(): void {
  // 处理玩家英雄
  const heroGroup = getPlayerHeroGroup();
  if (heroGroup != null) {
    forEachUnitInGroup(heroGroup, (unit) => {
      if (unit != null) {
        processPlayerHeroRegen(unit);
      }
    });
  }

  // 处理Boss单位
  const bossGroup = getBossGroup();
  if (bossGroup != null) {
    forEachUnitInGroup(bossGroup, (unit) => {
      if (unit != null) {
        processBossRegen(unit);
      }
    });
  }
}

//=============================================================================
// 五、初始化（使用中心计时器）
//=============================================================================

/** 是否已注册到中心计时器 */
let _registered = false;

/**
 * 注册恢复系统到中心计时器
 */
function registerToCenterTimer(): void {
  if (_registered) return;
  _registered = true;

const { onSecond } = globalThis as unknown as {
    onSecond: (callback: () => void) => void;
  };

  // 注册每秒回调
  onSecond(onRegenTimer);
}

// 立即注册（中心计时器会在游戏开始后自动运行）
registerToCenterTimer();

export {};
