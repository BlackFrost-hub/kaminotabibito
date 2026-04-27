/** @noSelfInFile */
/**
 * 伤害显示系统 - Boss战统计
 *
 * 功能：
 * 1. 记录玩家对Boss的伤害
 * 2. 记录Boss对玩家的伤害
 *
 * 依赖：
 * - YDUserDataGet/YDUserDataSet：Boss战数据存储
 */

const jass = require("jass.common") as any;

const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

// ==========================================================================================
// Boss战伤害统计
// ==========================================================================================

/**
 * 更新Boss战伤害统计
 * @param source 伤害来源
 * @param target 伤害目标
 * @param damage 伤害值
 */
export function updateBossDamageStats(this: void, source: any, target: any, damage: number): void {
  // 检查是否在Boss战中
  const bossUnit = YDUserDataGet("string", "Boss战", "单位", "unit");
  if (!bossUnit) return;

  const damageInt = jass.R2I(damage);
  const playerForce = YDUserDataGet("string", "玩家", "玩家组", "force");

  // 玩家对Boss造成伤害
  if (target === bossUnit && source) {
    const sourcePlayer = jass.GetOwningPlayer(source);
    if (sourcePlayer && jass.IsPlayerInForce(sourcePlayer, playerForce)) {
      const bossLife = jass.GetUnitState(bossUnit, jass.UNIT_STATE_LIFE);
      const actualDamage = damageInt < bossLife ? damageInt : bossLife;
      const currentDamage = YDUserDataGet("player", sourcePlayer, "造成伤害", "real") ?? 0;
      YDUserDataSet("player", sourcePlayer, "造成伤害", "real", currentDamage + actualDamage);
    }
  }

  // Boss对玩家造成伤害
  if (source === bossUnit && target) {
    const targetPlayer = jass.GetOwningPlayer(target);
    const isSummoned = jass.IsUnitType(target, jass.UNIT_TYPE_SUMMONED);

    if (!isSummoned && targetPlayer && jass.IsPlayerInForce(targetPlayer, playerForce)) {
      const bossLife = jass.GetUnitState(source, jass.UNIT_STATE_LIFE);
      const actualDamage = damageInt < bossLife ? damageInt : bossLife;
      const currentDamage = YDUserDataGet("player", targetPlayer, "承受伤害", "real") ?? 0;
      YDUserDataSet("player", targetPlayer, "承受伤害", "real", currentDamage + actualDamage);
    }
  }
}

/**
 * 检查是否在Boss战中
 */
export function isInBossBattle(this: void): boolean {
  const bossUnit = YDUserDataGet("string", "Boss战", "单位", "unit");
  return bossUnit != null;
}

/**
 * 获取Boss单位
 */
export function getBossUnit(this: void): any {
  return YDUserDataGet("string", "Boss战", "单位", "unit");
}

/**
 * 获取玩家对Boss的总伤害
 */
export function getPlayerDamageToBoss(this: void, player: any): number {
  return YDUserDataGet("player", player, "造成伤害", "real") ?? 0;
}

/**
 * 获取玩家承受Boss的总伤害
 */
export function getPlayerDamageFromBoss(this: void, player: any): number {
  return YDUserDataGet("player", player, "承受伤害", "real") ?? 0;
}
