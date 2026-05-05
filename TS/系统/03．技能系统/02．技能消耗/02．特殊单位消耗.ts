/**
 * 特殊单位消耗处理
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const {
  EDWARD_UNIT_CONFIG_KEY,
  SPECIAL_UNIT_COST_CONFIG,
} = require("系统.03．技能系统.02．技能消耗.00．消耗常量") as {
  EDWARD_UNIT_CONFIG_KEY: string;
  SPECIAL_UNIT_COST_CONFIG: Record<string, { type: "health_instead_mana"; description?: string }>;
};

function 提取显示名(配置键名: string): string {
  const 片段列表 = 配置键名.split("|");
  return 片段列表[0] ?? 配置键名;
}

/**
 * 获取爱德华单位。
 * 当前仍沿用前半段显示名作为缓存键，避免你尚未填写真实内部 ID 时改坏行为。
 */
export function getEdwardUnit(): any {
  return YDUserDataGet("string", 提取显示名(EDWARD_UNIT_CONFIG_KEY), "单位", "unit");
}

/**
 * 检查单位是否为爱德华。
 */
export function isEdwardUnit(unit: any): boolean {
  const edward = getEdwardUnit();
  return edward != null && unit === edward;
}

/**
 * 爱德华被动处理：扣血代替扣蓝。
 */
export function handleEdwardPassiveCost(unit: any, manaCost: number): void {
  if (!isEdwardUnit(unit)) return;

  const currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE);
  const lifeKeep = currentLife - 1;
  const deductAmount = manaCost < lifeKeep ? manaCost : lifeKeep;
  if (deductAmount > 0) {
    jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount);
  }
}

export {};
