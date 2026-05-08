/** @noSelfInFile */
/**
 * 通用函数 - 控制与 Buff 便捷入口
 *
 * 说明：
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 底层来源：
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
 * - 下面这组“硬控制效果合集”使用固定 Buff 原始码，不再依赖 `udg_MFXG` 全局变量。
 * - 这些 Buff 命中后，通常应视为会打断蓄力、引导、持续施法。
 */

const jass = require("jass.common") as any;

export {
  GS_Suspend,
  GS_IsUnitSuspending,
  GS_LoadSuspend,
  GS_UnitSuspend,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统";

export {
  SFB_Init,
  SFB_setBuff,
  SFB_setSlow,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

import {
  GS_Suspend,
  GS_IsUnitSuspending,
  GS_LoadSuspend,
  GS_UnitSuspend,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统";

import {
  SFB_Init,
  SFB_setBuff,
  SFB_setSlow,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

export const 开始硬直 = GS_Suspend;
export const 单位是否硬直中 = GS_IsUnitSuspending;
export const 获取单位硬直剩余时间 = GS_LoadSuspend;
export const 调整单位硬直时间 = GS_UnitSuspend;

export const 初始化快速Buff系统 = SFB_Init;
export const 施加快速控制Buff = SFB_setBuff;
export const 施加快速减速Buff = SFB_setSlow;

/**
 * 硬控制 / 会打断蓄力的魔法效果合集
 *
 * 对应旧 JASS：
 * - udg_MFXG[1] = 'BSTN' 眩晕
 * - udg_MFXG[2] = 'BPSE' 破击晕眩
 * - udg_MFXG[3] = 'B000' 时间停止
 * - udg_MFXG[4] = 'BNsi' 沉默
 * - udg_MFXG[5] = 'BNso' 火黑-默认灵魂燃烧
 * - udg_MFXG[7] = 'B01B' 硬直
 * - udg_MFXG[8] = 'Bfrz' 冰冻喷吐
 *
 * 说明：
 * - `Bslo` 是减速，不属于硬控制，因此不放进这里。
 * - `B002` 是旧表里的“魔法效果”占位，不作为打断合集使用。
 */
const 施法硬直Buff_魔法效果 = 1110454322; // 'B002'
const 硬控制Buff_眩晕 = 1112757326; // 'BSTN'
const 硬控制Buff_破击晕眩 = 1112560453; // 'BPSE'
const 硬控制Buff_时间停止 = 1110454320; // 'B000'
const 硬控制Buff_沉默 = 1112437609; // 'BNsi'
const 硬控制Buff_火黑默认灵魂燃烧 = 1112437615; // 'BNso'
const 硬控制Buff_硬直 = 1110454594; // 'B01B'
const 硬控制Buff_冰冻喷吐 = 1114010234; // 'Bfrz'

function 单位拥有Buff效果(单位: any, BuffID: number): boolean {
  if (单位 == null || 单位 === 0 || BuffID == null || BuffID === 0) return false;
  return jass.GetUnitAbilityLevel(单位, BuffID) > 0;
}

/**
 * 施法硬直效果
 *
 * 对应旧 JASS：
 * - udg_MFXG[0] = 'B002'
 *
 * 说明：
 * - 这个效果单独保留，不并入“硬控制效果合集”。
 * - 是否会打断蓄力/引导，由具体技能自己决定。
 */
export function 单位是否处于施法硬直效果(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return 单位拥有Buff效果(单位, 施法硬直Buff_魔法效果);
}

export function 单位是否处于硬控制效果合集(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return 单位拥有Buff效果(单位, 硬控制Buff_眩晕)
    || 单位拥有Buff效果(单位, 硬控制Buff_破击晕眩)
    || 单位拥有Buff效果(单位, 硬控制Buff_时间停止)
    || 单位拥有Buff效果(单位, 硬控制Buff_沉默)
    || 单位拥有Buff效果(单位, 硬控制Buff_火黑默认灵魂燃烧)
    || 单位拥有Buff效果(单位, 硬控制Buff_硬直)
    || 单位拥有Buff效果(单位, 硬控制Buff_冰冻喷吐);
}
