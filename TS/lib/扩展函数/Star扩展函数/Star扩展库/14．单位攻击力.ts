/**
 * Star扩展库 - 单位攻击力函数
 *
 * 来源于 StarUnit.j，提供单位攻击力相关功能。
 *
 * 公开接口：
 *   SU_GetUnitWhiteAtk(u, a)  - 获取英雄/单位白字攻击力
 */

const jass = require("jass.common") as any;

// 单位状态常量（原生JASS未暴露的）
const UNIT_STATE_ATTACK1_BASE = 0x12;  // 攻击1基础伤害
const UNIT_STATE_ATTACK1_BONUS = 0x10; // 攻击1加成
const UNIT_STATE_ATTACK1_COUNT = 0x11; // 攻击1数量（骰子数）

/**
 * 获取英雄主属性数值（白字）
 * @param u 目标英雄
 * @returns 主属性白字数值
 */
function getHeroPrimaryGreenValue(u: any): number {
  // 获取主属性类型
  let primaryType = -1;
  let japi: any = null;
  try {
    japi = require("jass.japi") as any;
  } catch (_e) {
    japi = null;
  }

  const unitId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(u) : 0;

  if (japi != null && typeof japi.EXExecuteScript === "function") {
    const script = "(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" + unitId + "']; if _u then return _u.Primary or '' else return '' end end)()";
    const primary = japi.EXExecuteScript(script) || "";

    if (primary === "STR") primaryType = 0;
    else if (primary === "AGI") primaryType = 1;
    else if (primary === "INT") primaryType = 2;
  }

  if (primaryType === 0) {
    const total = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, true) : 0;
    const green = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, false) : 0;
    return total - green;
  } else if (primaryType === 1) {
    const total = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, true) : 0;
    const green = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, false) : 0;
    return total - green;
  } else if (primaryType === 2) {
    const total = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, true) : 0;
    const green = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, false) : 0;
    return total - green;
  }

  return 0;
}

/**
 * 获取英雄/单位白字攻击力
 *
 * 计算公式：
 * 白字攻击 = 攻击基础伤害 + 攻击加成 * (骰子数 + 1) / 2 - 主属性绿字 * a
 *
 * @param u 目标单位
 * @param a 主属性系数（通常为1，用于扣除主属性加成的攻击力）
 * @returns 白字攻击力
 */
export function SU_GetUnitWhiteAtk(u: any, a: number): number {
  if (u == null || u === 0) return 0;

  // 获取主属性绿字
  const primaryGreen = getHeroPrimaryGreenValue(u);

  // 获取攻击力状态
  const baseDmg = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE))
    : 0;
  const bonusDmg = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS))
    : 0;
  const diceCount = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_COUNT))
    : 0;

  // 计算白字攻击力
  // 公式：基础 + 加成 * (骰子数 + 1) / 2 - 主属性绿字 * a
  const whiteAtk = baseDmg + bonusDmg * (diceCount + 1) / 2 - a * primaryGreen;

  return whiteAtk;
}

export {};
