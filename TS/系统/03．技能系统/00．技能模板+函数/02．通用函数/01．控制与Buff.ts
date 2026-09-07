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
const UnitRemoveAbility = jass.UnitRemoveAbility as (unit: any, abilityId: number) => boolean;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 创建世界坐标进度UI, 更新世界坐标进度UI, 销毁世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI") as {
  创建世界坐标进度UI: (this: void, 参数: any) => any;
  更新世界坐标进度UI: (this: void, ui: any, 当前值: number, 立即更新?: boolean) => void;
  销毁世界坐标进度UI: (this: void, ui: any) => void;
};
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { type?: string } | undefined>;
};

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};

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
  施加单位负面效果免疫,
  施加单位控制负面效果免疫,
  施加单位魔法负面效果免疫,
  清除单位负面效果免疫,
  单位是否免疫负面效果类型,
  单位是否免疫负面效果BuffID,
} from "../../../05．Buff系统/06．负面效果免疫状态";

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
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

import {
  施加睡眠,
  清除睡眠,
  单位正在睡眠,
  注册任意单位被睡眠监听,
  注册任意单位醒来监听,
  注册任意单位睡眠被打破监听,
} from "../../../05．Buff系统/07．睡眠系统";

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

export {
  GS_Suspend,
  GS_IsUnitSuspending,
  GS_LoadSuspend,
  GS_UnitSuspend,
  SFB_Init,
  SFB_setBuff,
  SFB_setSlow,
  SFB_施加通用Buff,
  getBuffRuntime,
  getBuffIdsOnUnit,
  isUnitInBuffPool,
  移除单位指定Buff,
  施加睡眠,
  清除睡眠,
  单位正在睡眠,
  注册任意单位被睡眠监听,
  注册任意单位醒来监听,
  注册任意单位睡眠被打破监听,
  移除单位指定类型Buff,
  移除单位增益Buff,
  移除单位负面Buff,
  按驱散等级移除单位Buff,
  一级驱散单位Buff,
  二级驱散单位Buff,
};

export const 施法硬直显示BuffID = "C037";
export const 施法硬直显示Buff图标 = "ReplaceableTextures\\CommandButtons\\BTNReplay-Pause.blp";

const 施法硬直显示Buff清理表: Record<number, number | undefined> = {};
let 施法硬直显示Buff清理驱动ID = 0;

function 启动施法硬直显示Buff清理驱动(this: void): void {
  if (施法硬直显示Buff清理驱动ID !== 0) return;
  施法硬直显示Buff清理驱动ID = addPeriodicCallback(50, on施法硬直显示Buff清理Tick);
}

function 停止施法硬直显示Buff清理驱动(this: void): void {
  if (施法硬直显示Buff清理驱动ID === 0) return;
  removePeriodicCallback(施法硬直显示Buff清理驱动ID);
  施法硬直显示Buff清理驱动ID = 0;
}

function 施法硬直显示Buff清理表是否为空(this: void): boolean {
  for (const key in 施法硬直显示Buff清理表) {
    if (施法硬直显示Buff清理表[key] !== undefined) return false;
  }
  return true;
}

function on施法硬直显示Buff清理Tick(this: void): void {
  const now = getServerTime();
  for (const key in 施法硬直显示Buff清理表) {
    const hid = key as any as number;
    const 到期时间 = 施法硬直显示Buff清理表[hid] ?? 0;
    if (到期时间 > 0 && now >= 到期时间) {
      delete 施法硬直显示Buff清理表[hid];
      移除单位指定Buff(hid, 施法硬直显示BuffID);
    }
  }
  if (施法硬直显示Buff清理表是否为空()) 停止施法硬直显示Buff清理驱动();
}

function 刷新施法硬直显示Buff(this: void, 单位: any, 持续时间: number): void {
  if (单位 == null || 单位 === 0 || !(持续时间 > 0)) return;
  const hid = GetHandleId(单位) || 0;
  if (hid === 0) return;

  施法硬直显示Buff清理表[hid] = getServerTime() + 持续时间 * 1000;
  registerManualBuff(单位, 施法硬直显示BuffID, 持续时间 + 0.2, 0, {
    sourceName: "施法硬直",
    iconOverride: 施法硬直显示Buff图标,
  });
  启动施法硬直显示Buff清理驱动();
}

//=============================================================================
// 硬直读条（可选）：开始硬直 传读条参数时创建跟随单位的世界坐标倒计时条
//=============================================================================

interface 硬直读条记录 {
  UI: any;
  周期ID: number;
}

const 硬直读条表: Record<number, 硬直读条记录 | undefined> = {};

function 销毁硬直读条(this: void, 单位句柄: number): void {
  const 记录 = 硬直读条表[单位句柄];
  if (记录 == null) return;
  if (记录.周期ID !== 0) removePeriodicCallback(记录.周期ID);
  销毁世界坐标进度UI(记录.UI);
  delete 硬直读条表[单位句柄];
}

function 刷新硬直读条(this: void, 单位: any, 持续时间: number, 参数: {
  标题?: string;
  Z偏移?: number;
  UI类型?: any;
  数值后缀?: string;
}): void {
  if (单位 == null || 单位 === 0 || !(持续时间 > 0)) return;
  const 单位句柄 = GetHandleId(单位) || 0;
  if (单位句柄 === 0) return;
  销毁硬直读条(单位句柄);
  // 读条数值统一用秒（一位小数显示，如 0.8 → 0.0），不传毫秒
  const 最大秒 = 持续时间;
  let 剩余秒 = 最大秒;
  const UI = 创建世界坐标进度UI({
    X: GetUnitX(单位),
    Y: GetUnitY(单位),
    Z: 0,
    跟随单位: 单位,
    跟随Z偏移: 参数.Z偏移 ?? 220,
    最大值: 最大秒,
    当前值: 最大秒,
    标题: 参数.标题 ?? "硬直",
    数值后缀: 参数.数值后缀 ?? "",
    类型: 参数.UI类型 ?? "自然",
  });
  const 周期ID = addPeriodicCallback(50, function 硬直读条推进(this: void): void {
    剩余秒 -= 0.05;
    if (剩余秒 <= 0) {
      销毁硬直读条(单位句柄);
      return;
    }
    更新世界坐标进度UI(UI, 剩余秒);
  });
  硬直读条表[单位句柄] = { UI, 周期ID };
}

export function 开始硬直(this: void, 单位: any, 持续时间: number, 读条参数?: {
  标题?: string;
  Z偏移?: number;
  UI类型?: any;
  数值后缀?: string;
}): void {
  GS_Suspend(单位, 持续时间);
  刷新施法硬直显示Buff(单位, 持续时间);
  if (读条参数 != null) 刷新硬直读条(单位, 持续时间, 读条参数);
}

export const 单位是否硬直中 = GS_IsUnitSuspending;
export const 获取单位硬直剩余时间 = GS_LoadSuspend;

export function 调整单位硬直时间(this: void, 单位: any, 操作类型: number, 时间值: number): void {
  GS_UnitSuspend(单位, 操作类型, 时间值);
  const 剩余时间 = GS_LoadSuspend(单位);
  if (剩余时间 > 0) {
    刷新施法硬直显示Buff(单位, 剩余时间);
  } else {
    移除单位指定Buff(单位, 施法硬直显示BuffID);
  }
}

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

export function 施加黑翼守护契约Buff(this: void, 守护者: any, 受护者: any, 持续时间: number, 转移比例: number): void {
  if (守护者 == null || 守护者 === 0 || 受护者 == null || 受护者 === 0 || !(持续时间 > 0)) return;
  registerManualBuff(守护者, 常规BuffID.黑翼守护重盾_守护者契约, 持续时间, 转移比例, {
    sourceUnit: 守护者,
    effectSourceName: "黑翼守护重盾",
    effectSourceType: "装备",
  });
  registerManualBuff(受护者, 常规BuffID.黑翼守护重盾_受护者契约, 持续时间, 转移比例, {
    sourceUnit: 守护者,
    effectSourceName: "黑翼守护重盾",
    effectSourceType: "装备",
  });
}

export function 清除黑翼守护契约Buff(this: void, 守护者: any, 受护者: any): void {
  if (守护者 != null && 守护者 !== 0) 移除单位指定Buff(守护者, 常规BuffID.黑翼守护重盾_守护者契约);
  if (受护者 != null && 受护者 !== 0) 移除单位指定Buff(受护者, 常规BuffID.黑翼守护重盾_受护者契约);
}

/** 判断单位是否拥有指定 Buff 池条目。 */
export function 单位是否拥有指定Buff(单位: any, BuffID: string): boolean {
  if (单位 == null || 单位 === 0 || BuffID == null || BuffID === "") return false;
  return getBuffRuntime(单位, BuffID) != null;
}

/** 清除单位控制类负面 Buff（Buff 表 type 以 `Debuff:control` 开头）。 */
export function 清除单位控制类负面Buff(单位: any, 只清可驱散: boolean = false): number {
  return 移除单位指定类型Buff(单位, "Debuff:control", 只清可驱散);
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
const 削弱Buff_精灵之火 = 1114005861; // 'Bfae'
const 持续伤害Buff_寄生 = 1112436833; // 'BNpa'
const Buff类型字段_负面 = "debuff";
const Buff类型字段_控制 = "control";
const Buff类型字段_软控制 = "soft";
const Buff类型字段_减速 = "slow";
const Buff类型字段_持续伤害 = "dot";

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

const 减速Buff合集: number[] = [
  软控制Buff_减速,
];

const 原生持续伤害Buff合集: number[] = [
  持续伤害Buff_寄生,
];

const 原生控制Buff合集: number[] = [
  ...硬控制Buff合集,
  ...软控制Buff合集,
];

const 原生负面Buff合集: number[] = [
  ...原生控制Buff合集,
  削弱Buff_精灵之火,
  ...原生持续伤害Buff合集,
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

type Buff表类型匹配函数 = (this: void, typeName: string) => boolean;

function Buff类型拥有字段(typeName: string, 字段: string): boolean {
  const lowerType = typeName.toLowerCase();
  const lowerField = 字段.toLowerCase();
  let start = 0;
  while (start <= lowerType.length) {
    const end = lowerType.indexOf(":", start);
    const part = end >= 0 ? lowerType.substring(start, end) : lowerType.substring(start);
    if (part === lowerField) return true;
    if (end < 0) break;
    start = end + 1;
  }
  return false;
}

function Buff表类型是负面(typeName: string): boolean {
  return Buff类型拥有字段(typeName, Buff类型字段_负面);
}

function Buff表类型是控制(typeName: string): boolean {
  return Buff类型拥有字段(typeName, Buff类型字段_控制);
}

function Buff表类型是软控制(typeName: string): boolean {
  return Buff类型拥有字段(typeName, Buff类型字段_软控制) || Buff表类型是减速(typeName);
}

function Buff表类型是硬控制(typeName: string): boolean {
  return Buff表类型是控制(typeName) && !Buff表类型是软控制(typeName);
}

function Buff表类型是减速(typeName: string): boolean {
  return Buff类型拥有字段(typeName, Buff类型字段_减速);
}

function Buff表类型是控制效果(typeName: string): boolean {
  return Buff表类型是硬控制(typeName) || Buff表类型是软控制(typeName);
}

function Buff表类型是持续伤害(typeName: string): boolean {
  return Buff类型拥有字段(typeName, Buff类型字段_持续伤害);
}

function 单位拥有匹配Buff池条目(单位: any, 匹配函数: Buff表类型匹配函数): boolean {
  if (单位 == null || 单位 === 0) return false;
  const ids = getBuffIdsOnUnit(单位);
  for (let i = 0; i < ids.length; i++) {
    const meta = buffTableMod.buffs[ids[i]];
    const typeName = meta != null ? meta.type : undefined;
    if (typeof typeName !== "string") continue;
    if (匹配函数(typeName)) return true;
  }
  return false;
}

function 单位拥有组合Buff合集(单位: any, 匹配函数: Buff表类型匹配函数, 原生Buff列表: number[]): boolean {
  return 单位拥有匹配Buff池条目(单位, 匹配函数) || 单位拥有任意Buff效果合集(单位, 原生Buff列表);
}

function 清除单位匹配Buff池条目(单位: any, 匹配函数: Buff表类型匹配函数): number {
  if (单位 == null || 单位 === 0) return 0;
  const ids = getBuffIdsOnUnit(单位);
  let removed = 0;
  for (let i = 0; i < ids.length; i++) {
    const buffID = ids[i];
    const meta = buffTableMod.buffs[buffID];
    const typeName = meta != null ? meta.type : undefined;
    if (typeof typeName !== "string") continue;
    if (!匹配函数(typeName)) continue;
    if (移除单位指定Buff(单位, buffID)) removed++;
  }
  return removed;
}

function 清除单位组合Buff合集(单位: any, 匹配函数: Buff表类型匹配函数, 原生Buff列表: number[]): number {
  return 清除单位匹配Buff池条目(单位, 匹配函数) + 清除单位Buff效果合集(单位, 原生Buff列表);
}

function 清除单位Buff效果合集(单位: any, Buff列表: number[]): number {
  if (单位 == null || 单位 === 0) return 0;
  let removed = 0;
  let index = 0;
  while (index < Buff列表.length) {
    const BuffID = Buff列表[index];
    if (单位拥有Buff效果(单位, BuffID) && UnitRemoveAbility(单位, BuffID)) {
      removed++;
    }
    index++;
  }
  return removed;
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
  return 单位拥有组合Buff合集(单位, Buff表类型是硬控制, 硬控制Buff合集);
}

export function 单位是否处于软控制效果合集(单位: any): boolean {
  return 单位拥有组合Buff合集(单位, Buff表类型是软控制, 软控制Buff合集);
}

export function 单位是否处于减速效果合集(单位: any): boolean {
  return 单位拥有组合Buff合集(单位, Buff表类型是减速, 减速Buff合集);
}

/** 控制合集：硬控制 + 软控制。 */
export function 单位是否处于控制效果合集(单位: any): boolean {
  return 单位拥有组合Buff合集(单位, Buff表类型是控制效果, 原生控制Buff合集);
}

export function 单位是否处于负面Buff合集(单位: any): boolean {
  return 单位拥有组合Buff合集(单位, Buff表类型是负面, 原生负面Buff合集);
}

export function 单位是否处于持续伤害效果合集(单位: any): boolean {
  return 单位拥有组合Buff合集(单位, Buff表类型是持续伤害, 原生持续伤害Buff合集);
}

export function 清除单位硬控制Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是硬控制, 硬控制Buff合集);
}

export function 清除单位软控制Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是软控制, 软控制Buff合集);
}

export function 清除单位减速Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是减速, 减速Buff合集);
}

export function 清除单位控制Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是控制效果, 原生控制Buff合集);
}

export function 清除单位负面Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是负面, 原生负面Buff合集);
}

export function 清除单位持续伤害Buff合集(单位: any): number {
  return 清除单位组合Buff合集(单位, Buff表类型是持续伤害, 原生持续伤害Buff合集);
}
