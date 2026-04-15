/**
 * Star扩展库 - 单位属性函数
 *
 * 来源于 StarUnit.j，提供单位属性相关功能。
 *
 * 公开接口：
 *   SU_GetUnitModel(u)              - 获取单位模型文件路径
 *   SU_GetHeroParmary(u)            - 获取英雄主属性类型（0=力量,1=敏捷,2=智力）
 *   SU_AddHeroState(u, id, typ, v)  - 增加/设置英雄属性
 *   SU_GetHeroParmaryValue(u)       - 获取英雄主属性数值
 *   SU_AddHeroAllState(u, a, b, c)  - 添加英雄三项属性
 *   SU_SetHeroParmaryValue(u, typ, v) - 增加/设置/减少英雄主属性值
 *   SU_HeroISParmary(u, i)          - 判断英雄主属性类型
 */

const jass = require("jass.common") as any;
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

// 主属性类型常量
export const PRIMARY_STR = 0; // 力量
export const PRIMARY_AGI = 1; // 敏捷
export const PRIMARY_INT = 2; // 智力

/**
 * 获取单位模型文件路径
 * @param u 目标单位
 * @returns 模型文件路径（自动补全.mdl后缀）
 */
export function SU_GetUnitModel(u: any): string {
  if (u == null || u === 0) return "";

  const unitId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(u) : 0;
  let file = "";

  // 尝试从SLK读取模型路径
  if (japi != null && typeof japi.EXExecuteScript === "function") {
    const script = "(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" + unitId + "']; if _u then return _u.file or '' else return '' end end)()";
    file = japi.EXExecuteScript(script) || "";
  }

  // 检查是否有自定义模型（存储在哈希表中）
  // 注：原JASS代码检查 YDHT 中的 __model 键，这里简化处理

  // 确保有正确的后缀
  if (file.length > 0) {
    const suffix = file.slice(-4).toLowerCase();
    if (suffix !== ".mdl" && suffix !== ".mdx") {
      file += ".mdl";
    }
  }

  return file;
}

/**
 * 获取英雄主属性类型
 * @param u 目标英雄
 * @returns 主属性类型（0=力量, 1=敏捷, 2=智力, -1=无效）
 */
export function SU_GetHeroParmary(u: any): number {
  if (u == null || u === 0) return -1;

  const unitId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(u) : 0;
  if (unitId === 0) return -1;

  // 尝试从SLK读取主属性
  if (japi != null && typeof japi.EXExecuteScript === "function") {
    const script = "(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" + unitId + "']; if _u then return _u.Primary or '' else return '' end end)()";
    const primary = japi.EXExecuteScript(script) || "";

    if (primary === "STR") return PRIMARY_STR;
    if (primary === "AGI") return PRIMARY_AGI;
    if (primary === "INT") return PRIMARY_INT;
  }

  return -1;
}

/**
 * 增加/设置英雄属性
 * @param u 目标英雄
 * @param id 属性类型（0=力量, 1=敏捷, 2=智力）
 * @param typ 操作类型（0=增加, 1=设置）
 * @param value 数值
 */
export function SU_AddHeroState(u: any, id: number, typ: number, value: number): void {
  if (u == null || u === 0) return;

  const isAdd = typ === 0;

  if (id === PRIMARY_STR) {
    const current = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, false) : 0;
    if (typeof jass.SetHeroStr === "function") {
      jass.SetHeroStr(u, isAdd ? current + value : value, false);
    }
  } else if (id === PRIMARY_AGI) {
    const current = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, false) : 0;
    if (typeof jass.SetHeroAgi === "function") {
      jass.SetHeroAgi(u, isAdd ? current + value : value, false);
    }
  } else if (id === PRIMARY_INT) {
    const current = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, false) : 0;
    if (typeof jass.SetHeroInt === "function") {
      jass.SetHeroInt(u, isAdd ? current + value : value, false);
    }
  }
}

/**
 * 获取英雄主属性数值（含绿字）
 * @param u 目标英雄
 * @returns 主属性数值（-1表示无效）
 */
export function SU_GetHeroParmaryValue(u: any): number {
  if (u == null || u === 0) return -1;

  const typ = SU_GetHeroParmary(u);

  if (typ === PRIMARY_STR) {
    return typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, true) : 0;
  } else if (typ === PRIMARY_AGI) {
    return typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, true) : 0;
  } else if (typ === PRIMARY_INT) {
    return typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, true) : 0;
  }

  return -1;
}

/**
 * 添加英雄三项属性
 * @param u 目标英雄
 * @param a 力量增加值
 * @param b 智力增加值（注意：原JASS参数顺序是 a=力量, b=智力, c=敏捷）
 * @param c 敏捷增加值
 */
export function SU_AddHeroAllState(u: any, a: number, b: number, c: number): void {
  SU_AddHeroState(u, PRIMARY_STR, 0, a);   // 力量
  SU_AddHeroState(u, PRIMARY_INT, 0, b);   // 智力（注意顺序）
  SU_AddHeroState(u, PRIMARY_AGI, 0, c);   // 敏捷
}

/**
 * 增加/设置/减少英雄主属性值
 * @param u 目标英雄
 * @param typ 操作类型（0=增加, 1=设置, 2=减少）
 * @param value 数值
 */
export function SU_SetHeroParmaryValue(u: any, typ: number, value: number): void {
  if (u == null || u === 0) return;

  const primaryType = SU_GetHeroParmary(u);
  if (primaryType < 0) return;

  if (typ === 0) {
    // 增加
    SU_AddHeroState(u, primaryType, 0, value);
  } else if (typ === 1) {
    // 设置
    SU_AddHeroState(u, primaryType, 1, value);
  } else if (typ === 2) {
    // 减少
    SU_AddHeroState(u, primaryType, 1, -value);
  }
}

/**
 * 判断英雄主属性类型
 * @param u 目标英雄
 * @param i 要判断的属性类型
 * @returns 是否匹配
 */
export function SU_HeroISParmary(u: any, i: number): boolean {
  return SU_GetHeroParmary(u) === i;
}

export {};
