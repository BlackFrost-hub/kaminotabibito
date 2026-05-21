/** @noSelfInFile */
/**
 * 通用函数 - 控制与 Buff 便捷入口
 *
 * 说明：
 * - 这是技能侧最显眼的控制 / 快速 Buff / Buff 清除入口。
 * - 这里只做技能侧便捷转导出，不迁移底层实现。
 * - 底层来源：
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
 *   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
 *   - `TS/系统/05．Buff系统/05．Buff清除函数.ts`
 * - 清除函数按 `TS/系统/05．Buff系统/01．Buff表.ts` 的 `type` 前缀工作：
 *   - `Buff:` 清增益
 *   - `Debuff:` 清负面
 *   - `Debuff:control` 清控制类负面
 *   - `Debuff:magic` 清魔法类负面
 * - `onlyPurgable=true` 时只清 `canPurge: true` 的条目。
 * - 快速 Buff 的原生魔法效果由魔兽管理；底层清除时会同步移除登记过的原生魔法效果。
 * - 下面这组“硬控制效果合集”使用固定 Buff 原始码，不再依赖 `udg_MFXG` 全局变量。
 * - 这些 Buff 命中后，通常应视为会打断蓄力、引导、持续施法。
 */

const jass = require("jass.common") as any;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilcode: number) => number;

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
  SFB_施加通用Buff,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

export {
  getBuffRuntime,
  getBuffIdsOnUnit,
  isUnitInBuffPool,
  移除单位指定Buff,
} from "../../../05．Buff系统/00．Buff系统";

export { getUnitBurn } from "../../../04．伤害系统/02．dot伤害";

export {
  施加单体护甲降低Buff,
  施加范围护甲降低Buff,
} from "../01．技能函数/19．拓展效果/01．debuff/04．护甲降低";

export {
  施加移速提升Buff,
  清除单位移速提升Buff,
} from "../01．技能函数/19．拓展效果/02．buff/04．移速提升";

export {
  施加视野变化Buff,
} from "../01．技能函数/19．拓展效果/02．buff/05．视野变化";

export {
  移除单位指定类型Buff,
  移除单位增益Buff,
  移除单位负面Buff,
  按驱散等级移除单位Buff,
  一级驱散单位Buff,
  二级驱散单位Buff,
} from "../../../05．Buff系统/05．Buff清除函数";

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
  SFB_施加通用Buff,
} from "../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";

import {
  getBuffRuntime,
  getBuffIdsOnUnit,
  isUnitInBuffPool,
  移除单位指定Buff,
} from "../../../05．Buff系统/00．Buff系统";

import {
  移除单位指定类型Buff,
  移除单位增益Buff,
  移除单位负面Buff,
  按驱散等级移除单位Buff,
  一级驱散单位Buff,
  二级驱散单位Buff,
} from "../../../05．Buff系统/05．Buff清除函数";

import {
  获取单位重伤,
  施加重伤,
  移除单位重伤,
} from "../../../04．伤害系统/03．重伤系统/01．核心功能";

export const 开始硬直 = GS_Suspend;
export const 单位是否硬直中 = GS_IsUnitSuspending;
export const 获取单位硬直剩余时间 = GS_LoadSuspend;
export const 调整单位硬直时间 = GS_UnitSuspend;

export const 初始化快速Buff系统 = SFB_Init;
export const 施加快速Buff = SFB_施加通用Buff;
export const 施加快速控制Buff = SFB_setBuff;
export const 施加快速减速Buff = SFB_setSlow;
export const 读取单位重伤 = 获取单位重伤;
export const 施加单位重伤 = 施加重伤;
export const 清除单位重伤 = 移除单位重伤;

export const 清除单位指定类型Buff = 移除单位指定类型Buff;
export const 清除单位指定Buff = 移除单位指定Buff;
export const 清除单位增益Buff = 移除单位增益Buff;
export const 清除单位负面Buff = 移除单位负面Buff;
export const 按驱散等级清除单位Buff = 按驱散等级移除单位Buff;
export const 一级驱散清除单位Buff = 一级驱散单位Buff;
export const 二级驱散清除单位Buff = 二级驱散单位Buff;
export const 获取单位Buff运行数据 = getBuffRuntime;
export const 获取单位BuffID列表 = getBuffIdsOnUnit;
export const 单位是否在Buff池中 = isUnitInBuffPool;

/** 判断单位是否拥有指定 Buff 池条目。 */
export function 单位是否拥有指定Buff(单位: any, BuffID: string): boolean {
  if (单位 == null || 单位 === 0 || BuffID == null || BuffID === "") return false;
  return getBuffRuntime(单位, BuffID) != null;
}

/** 清除单位可驱散增益 Buff（只清 Buff 表 `canPurge: true` 的 `Buff:` 条目）。 */
export function 清除单位可驱散增益Buff(单位: any): number {
  return 移除单位增益Buff(单位, true);
}

/** 清除单位可驱散负面 Buff（只清 Buff 表 `canPurge: true` 的 `Debuff:` 条目）。 */
export function 清除单位可驱散负面Buff(单位: any): number {
  return 移除单位负面Buff(单位, true);
}

/** 清除单位燃烧 Buff（会同步结束 D002 对应的 DOT）。 */
export function 清除单位燃烧Buff(单位: any): number {
  return 移除单位指定Buff(单位, "D002") ? 1 : 0;
}

/** 清除单位护甲降低 Buff（会触发 C032 的护甲回滚）。 */
export function 清除单位护甲降低Buff(单位: any): number {
  return 移除单位指定Buff(单位, "C032") ? 1 : 0;
}

/** 清除单位视野变化 Buff（会回滚所有未到期的视野变化叠加）。 */
export function 清除单位视野变化Buff(单位: any): number {
  return 移除单位指定Buff(单位, "C035") ? 1 : 0;
}

/** 清除单位控制类负面 Buff（Buff 表 type 以 `Debuff:control` 开头）。 */
export function 清除单位控制类负面Buff(单位: any, 只清可驱散: boolean = false): number {
  return 移除单位指定类型Buff(单位, "Debuff:control", 只清可驱散);
}

/** 清除单位魔法类负面 Buff（Buff 表 type 以 `Debuff:magic` 开头）。 */
export function 清除单位魔法类负面Buff(单位: any, 只清可驱散: boolean = false): number {
  return 移除单位指定类型Buff(单位, "Debuff:magic", 只清可驱散);
}

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
 * - 快速 Buff 现用控制效果：变形、睡眠、纠缠根须、飓风等也并入这里。
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
const 硬控制Buff_变形 = 1114664057; // 'Bply'
const 硬控制Buff_睡眠主效果 = 1112896364; // 'BUsl'
const 硬控制Buff_睡眠暂停 = 1112896368; // 'BUsp'
const 硬控制Buff_睡眠眩晕 = 1114993524; // 'Bust'
const 硬控制Buff_纠缠根须 = 1111844210; // 'BEer'
const 硬控制Buff_飓风主效果 = 1113815395; // 'Bcyc'
const 硬控制Buff_飓风附加 = 1113815346; // 'Bcy2'
const 软控制Buff_减速 = 1114860655; // 'Bslo'
const 软控制Buff_残废 = 1113813609; // 'Bcri'
const 软控制Buff_诅咒 = 1113813619; // 'Bcrs'
const 削弱Buff_残废 = 1113813609; // 'Bcri'
const 削弱Buff_精灵之火 = 1114005861; // 'Bfae'
const 削弱Buff_诅咒 = 1113813619; // 'Bcrs'
const 持续伤害Buff_寄生 = 1112436833; // 'BNpa'

const 硬控制Buff合集: number[] = [
  硬控制Buff_眩晕,
  硬控制Buff_破击晕眩,
  硬控制Buff_时间停止,
  硬控制Buff_沉默,
  硬控制Buff_火黑默认灵魂燃烧,
  硬控制Buff_硬直,
  硬控制Buff_冰冻喷吐,
  硬控制Buff_变形,
  硬控制Buff_睡眠主效果,
  硬控制Buff_睡眠暂停,
  硬控制Buff_睡眠眩晕,
  硬控制Buff_纠缠根须,
  硬控制Buff_飓风主效果,
  硬控制Buff_飓风附加,
];

const 软控制Buff合集: number[] = [
  软控制Buff_减速,
  软控制Buff_残废,
  软控制Buff_诅咒,
];

const 削弱Buff合集: number[] = [
  削弱Buff_残废,
  削弱Buff_精灵之火,
  削弱Buff_诅咒,
];

const 持续伤害Buff合集: number[] = [
  持续伤害Buff_寄生,
];

const 负面Buff合集: number[] = [
  ...硬控制Buff合集,
  ...软控制Buff合集,
];

const 全部负面Buff合集: number[] = [
  ...负面Buff合集,
  ...削弱Buff合集,
  ...持续伤害Buff合集,
];

function 单位拥有Buff效果(单位: any, BuffID: number): boolean {
  if (单位 == null || 单位 === 0 || BuffID == null || BuffID === 0) return false;
  return GetUnitAbilityLevel(单位, BuffID) > 0;
}

function 单位拥有任意Buff效果合集(单位: any, Buff列表: number[]): boolean {
  if (单位 == null || 单位 === 0) return false;
  let index = 0;
  while (index < Buff列表.length) {
    if (单位拥有Buff效果(单位, Buff列表[index])) return true;
    index++;
  }
  return false;
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
  return 单位拥有任意Buff效果合集(单位, 硬控制Buff合集);
}

export function 单位是否处于软控制效果合集(单位: any): boolean {
  return 单位拥有任意Buff效果合集(单位, 软控制Buff合集);
}

export function 单位是否处于削弱Buff合集(单位: any): boolean {
  return 单位拥有任意Buff效果合集(单位, 削弱Buff合集);
}

export function 单位是否处于持续伤害Buff合集(单位: any): boolean {
  return 单位拥有任意Buff效果合集(单位, 持续伤害Buff合集);
}

export function 单位是否处于负面Buff合集(单位: any): boolean {
  return 单位拥有任意Buff效果合集(单位, 负面Buff合集);
}

export function 单位是否处于全部负面Buff合集(单位: any): boolean {
  return 单位拥有任意Buff效果合集(单位, 全部负面Buff合集);
}
