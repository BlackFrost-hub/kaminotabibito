/**
 * 单位工具函数
 * 判断单位类型、查找单位等
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const g = require("jass.globals") as { [key: string]: any };

/**
 * 判断单位是否为英雄单位
 */
export function isHeroUnit(unit: any): boolean {
  if (!unit) return false;
  const utHero = (jass as any).UNIT_TYPE_HERO ?? (g as any).UNIT_TYPE_HERO;
  if (utHero != null && typeof (jass as any).IsUnitType === "function") {
    return (jass as any).IsUnitType(unit, utHero) === true;
  }
  if (typeof (jass as any).GetHeroLevel === "function") {
    return (jass as any).GetHeroLevel(unit) > 0;
  }
  return false;
}

/**
 * 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
 */
export function isSpecialUnit(unit: any): boolean {
  if (!unit) return true;
  if ((jass as any).UNIT_TYPE_SUMMONED != null && jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return true;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return true;
  if (typeof (jass as any).IsUnitIllusion === "function" && (jass as any).IsUnitIllusion(unit)) return true;
  return false;
}

/**
 * 查找指定玩家的英雄单位
 * @param playerId 玩家索引（0-15）
 * @returns 英雄单位，如果没有找到返回 null
 */
export function findHeroOfPlayer(playerId: number): any {
  if (typeof jass.CreateGroup !== "function" || typeof jass.GroupEnumUnitsOfPlayer !== "function") return null;
  const group = jass.CreateGroup();
  jass.GroupEnumUnitsOfPlayer(group, jass.Player(playerId), null);
  const unit = jass.FirstOfGroup(group);
  jass.DestroyGroup(group);
  if (unit && isHeroUnit(unit)) return unit;
  return null;
}

/**
 * 获取单位的攻击类型（Attack Type）
 * 单位状态0x23对应攻击类型，使用ConvertUnitState转换
 */
export function Ir_GetUnitAttackType(u: any): number {
  return (jass as any).R2I(japi.GetUnitState(u, (jass as any).ConvertUnitState(0x23)));
}

export function Ir_SetUnitAttackType(u: any, atp: number): void {
  japi.SetUnitState(u, (jass as any).ConvertUnitState(0x23), atp);
}
