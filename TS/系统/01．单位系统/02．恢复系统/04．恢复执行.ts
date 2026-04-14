/**
 * 恢复执行模块
 *
 * 功能：周期性执行单位恢复
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const {
  calcBaseLifeRegen,
  calcBaseManaRegen,
  calcTotalLifeRegen,
  calcTotalManaRegen,
  calcBossTotalLifeRegen,
  getPercentLifeRegen,
} = require("系统.01．单位系统.02．恢复系统.01．恢复计算") as {
  calcBaseLifeRegen: (unit: any) => number;
  calcBaseManaRegen: (unit: any) => number;
  calcTotalLifeRegen: (unit: any, baseRegen: number, itemBonus: number, unitMultiplier: number) => number;
  calcTotalManaRegen: (unit: any, baseRegen: number) => number;
  calcBossTotalLifeRegen: (unit: any) => number;
  getPercentLifeRegen: (unit: any) => number;
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
  const actualRegen = Math.min(regen, maxLife - currentLife);
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
  const actualRegen = Math.min(regen, maxMana - currentMana);
  if (actualRegen <= 0) return;

  jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRegen);
}

//=============================================================================
// 二、玩家英雄恢复处理
//=============================================================================

/**
 * 处理玩家英雄恢复
 */
export function processPlayerHeroRegen(unit: any): void {
  // 1. 基础恢复
  const baseLifeRegen = calcBaseLifeRegen(unit);
  const baseManaRegen = calcBaseManaRegen(unit);

  // 2. 装备加成
  const itemBonus = calcItemLifeRegenBonus(unit);

  // 3. 单位特性
  const unitMultiplier = getUnitLifeRegenMultiplier(unit);

  // 4. 计算总恢复
  const totalLifeRegen = calcTotalLifeRegen(unit, baseLifeRegen, itemBonus, unitMultiplier);
  const totalManaRegen = calcTotalManaRegen(unit, baseManaRegen);

  // 5. 缓存到玩家属性
  const player = jass.GetOwningPlayer(unit);
  if (player != null) {
    // YDUserDataSet 会在其他地方处理
  }

  // 6. 执行恢复（检查阈值）
  const percentLifeRegen = getPercentLifeRegen(unit);
  if (totalLifeRegen > REGEN_THRESHOLD || percentLifeRegen >= PERCENT_REGEN_THRESHOLD) {
    applyLifeRegen(unit, totalLifeRegen);
  }

  // 魔法恢复阈值检查
  if (totalManaRegen > REGEN_THRESHOLD) {
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
    jass.ForGroup(heroGroup, () => {
      const unit = jass.GetEnumUnit();
      if (unit != null) {
        processPlayerHeroRegen(unit);
      }
    });
  }

  // 处理Boss单位
  const bossGroup = getBossGroup();
  if (bossGroup != null) {
    jass.ForGroup(bossGroup, () => {
      const unit = jass.GetEnumUnit();
      if (unit != null) {
        processBossRegen(unit);
      }
    });
  }
}

export {};
