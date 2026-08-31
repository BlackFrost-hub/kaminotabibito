/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - 被动：术式节点与连接 / 演算普攻 / 公共状态容器（A1+A2）
 *
 * A1：
 * - 每名塞莉亚独立维护最多 2 个节点与至多 1 条有效连接。
 * - 节点字段：唯一序号、类型、坐标、来源技能、到期时间、特效句柄。
 * - 不同类型且距离合法的两节点自动形成一条连接；同一节点对仅一条，
 *   连接记录带 可读取 状态（原子消费）；旧连接先失效再更新，避免同帧双连接。
 * - 新节点超限先安全销毁最旧节点及其连接，再加入新节点；
 *   节点不是单位：不阻挡、不可攻击、不改变寻路。
 * - 总清理幂等：死亡 / 场景清理 / 主动清理共用；两个塞莉亚的数据互不串号。
 *
 * A2：
 * - 仅监听塞莉亚真实普攻（isNormalAttack 且非技能包装伤害），不递归触发。
 * - Q/W/E 成功施法各累积一次强化窗口（有上限）；命中节点或连接附近合法敌人时
 *   追加一次演算伤害并消费窗口；命中连接附近时延长该连接并触发 Q 冷却回馈（内部冷却）。
 * - 无节点/无连接时基础普攻不受影响。
 */

import {
  塞莉亚克莱尔技能配置,
  塞莉亚克莱尔节点配置,
  塞莉亚克莱尔演算普攻配置,
  塞莉亚克莱尔表现配置,
  塞莉亚克莱尔连接表现,
  塞莉亚克莱尔E配置,
} from "./00．配置";
import { 塞莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/24．塞莉亚·克莱尔";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const AddLightningEx = jass.AddLightningEx as (this: void, codeName: string, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => any;
const DestroyLightning = jass.DestroyLightning as (this: void, whichLightning: any) => boolean;
const SetLightningColor = jass.SetLightningColor as (this: void, l: any, r: number, g: number, b: number, a: number) => void;
/** 特效坐标迁移暂无项目封装；按局部别名约定直接绑定 japi（仅 D 节点移动使用）。 */
const EXSetEffectXY = (japi as any).EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const {
  取单位ID,
  单位存活,
  距离平方XY,
  点到线段距离平方,
  读取单位攻击力,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  点到线段距离平方: (this: void, px: number, py: number, ax: number, ay: number, bx: number, by: number) => number;
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { 销毁世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI") as {
  销毁世界坐标进度UI: (this: void, ui: any) => void;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
  技能_获取技能最大冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const Q技能类型ID = jass.FourCC(塞莉亚克莱尔技能配置.Q.技能ID) as number;

//=============================================================================
// 类型
//=============================================================================

export type 塞莉亚节点类型 = "棱晶" | "结界" | "锚定";

export interface 塞莉亚节点 {
  序号: number;
  类型: 塞莉亚节点类型;
  X: number;
  Y: number;
  来源实例ID?: number;
  /** 到期时间（getGameTime 毫秒） */
  到期时间: number;
  /** 常驻特效句柄（持续秒 -1，由节点实例单次销毁） */
  特效句柄: any;
}

export interface 塞莉亚连接信息 {
  A序号: number;
  B序号: number;
  A类型: 塞莉亚节点类型;
  B类型: 塞莉亚节点类型;
  /** 是否仍可被读取（R 消费锁；Q/W/E 只读使用不翻转） */
  可读取: boolean;
}

interface 塞莉亚连接 extends 塞莉亚连接信息 {
  闪电句柄: any;
}

export type 塞莉亚清理原因 = "英雄死亡" | "技能清理" | "地图清理" | "主动清理";

interface 塞莉亚英雄状态 {
  节点列表: 塞莉亚节点[];
  连接: 塞莉亚连接 | null;
  强化次数: number;
  回馈下次可用时间: number;
  /** R 蓄力快照期：D 一律拒绝改动节点数据 */
  R锁定: boolean;
  /** D 转写事务进行中（同帧重入保护） */
  转写中: boolean;
  技能清理表: Record<string, ((this: void) => void) | undefined>;
  进度UI列表: any[];
  已清理: boolean;
}

//=============================================================================
// 状态表与死亡监听
//=============================================================================

const 塞莉亚状态表: Record<number, 塞莉亚英雄状态 | undefined> = {};
let 下一全局节点序号 = 1;
let 死亡监听已注册 = false;
/**
 * E 区域成员标记（目标句柄 → 覆盖区域数）。
 * 计数制：同一目标可能同时处于多名塞莉亚的阵内，进入 +1、离开 −1，归零摘除。
 * 由 05 区域周期维护，02/A3 只读查询。
 */
const E区域目标表: Record<number, number | undefined> = {};

function 取或建状态(this: void, 英雄: any): 塞莉亚英雄状态 {
  const id = 取单位ID(英雄);
  let 状态 = 塞莉亚状态表[id];
  if (状态 == null) {
    状态 = {
      节点列表: [],
      连接: null,
      强化次数: 0,
      回馈下次可用时间: 0,
      R锁定: false,
      转写中: false,
      技能清理表: {},
      进度UI列表: [],
      已清理: false,
    };
    塞莉亚状态表[id] = 状态;
  }
  return 状态;
}

function 查找状态(this: void, 英雄: any): 塞莉亚英雄状态 | undefined {
  return 塞莉亚状态表[取单位ID(英雄)];
}

/** 判断单位是否为塞莉亚·克莱尔 */
export function 是塞莉亚克莱尔(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return GetUnitTypeId(unit) === jass.FourCC(英雄单位类型ID);
}

//=============================================================================
// 连接底层（原生双点连线：牵引/跳链同源）
//=============================================================================

function 建立连接线(this: void, 连接: 塞莉亚连接, A: 塞莉亚节点, B: 塞莉亚节点): void {
  const z = 塞莉亚克莱尔节点配置.连接Z高度;
  const 句柄 = AddLightningEx(塞莉亚克莱尔连接表现.效果代码, false, A.X, A.Y, z, B.X, B.Y, z);
  if (句柄 != null && 句柄 !== 0) {
    SetLightningColor(
      句柄,
      塞莉亚克莱尔连接表现.RGB.红 / 255,
      塞莉亚克莱尔连接表现.RGB.绿 / 255,
      塞莉亚克莱尔连接表现.RGB.蓝 / 255,
      塞莉亚克莱尔连接表现.RGB.透明度 / 255,
    );
  }
  连接.闪电句柄 = 句柄;
}

/** 关闭当前连接：可读取位先失效，再销毁连线。 */
function 关闭连接(状态: 塞莉亚英雄状态): void {
  const 连接 = 状态.连接;
  if (连接 == null) return;
  连接.可读取 = false;
  if (连接.闪电句柄 != null && 连接.闪电句柄 !== 0) {
    DestroyLightning(连接.闪电句柄);
    连接.闪电句柄 = null;
  }
  状态.连接 = null;
}

/** 在新节点与其余异型存活节点之间尝试建立唯一连接（距离须合法）。 */
function 尝试建立连接(状态: 塞莉亚英雄状态, 新节点: 塞莉亚节点): void {
  if (状态.连接 != null) return;
  const 其他 = 取其他存活节点(状态, 新节点);
  if (其他 == null) return;
  const maxDistSq = 塞莉亚克莱尔节点配置.连接距离 * 塞莉亚克莱尔节点配置.连接距离;
  if (距离平方XY(新节点.X, 新节点.Y, 其他.X, 其他.Y) > maxDistSq) return;
  const 连接: 塞莉亚连接 = {
    A序号: 新节点.序号,
    B序号: 其他.序号,
    A类型: 新节点.类型,
    B类型: 其他.类型,
    可读取: true,
    闪电句柄: null,
  };
  建立连接线(连接, 新节点, 其他);
  状态.连接 = 连接;
}

function 取其他存活节点(状态: 塞莉亚英雄状态, 自身: 塞莉亚节点): 塞莉亚节点 | null {
  const now = getGameTime();
  for (let i = 0; i < 状态.节点列表.length; i++) {
    const 节点 = 状态.节点列表[i];
    if (节点.序号 === 自身.序号) continue;
    if (节点.类型 === 自身.类型) continue; // 同型不成连
    if (now >= 节点.到期时间) continue;
    return 节点;
  }
  return null;
}

function 取内部节点(状态: 塞莉亚英雄状态, 序号: number): 塞莉亚节点 | null {
  for (let i = 0; i < 状态.节点列表.length; i++) {
    if (状态.节点列表[i].序号 === 序号) return 状态.节点列表[i];
  }
  return null;
}

//=============================================================================
// 节点生命周期
//=============================================================================

/** 内部销毁：仅操作状态对象（供周期清扫使用，无需英雄句柄）。 */
function 销毁内部节点(状态: 塞莉亚英雄状态, 序号: number): boolean {
  let 目标索引 = -1;
  for (let i = 0; i < 状态.节点列表.length; i++) {
    if (状态.节点列表[i].序号 === 序号) {
      目标索引 = i;
      break;
    }
  }
  if (目标索引 < 0) return false;
  const 连接 = 状态.连接;
  if (连接 != null && (连接.A序号 === 序号 || 连接.B序号 === 序号)) {
    关闭连接(状态); // 旧连接先失效
  }
  const 节点 = 状态.节点列表.splice(目标索引, 1)[0];
  销毁点特效(节点.特效句柄);
  return true;
}

/** 安全销毁单个节点：其所在连接先失效关闭，再销毁特效与引用。 */
export function 销毁塞莉亚节点按序号(this: void, 英雄: any, 序号: number): boolean {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return false;
  return 销毁内部节点(状态, 序号);
}

function 清理过期节点(状态: 塞莉亚英雄状态): void {
  const now = getGameTime();
  let i = 0;
  while (i < 状态.节点列表.length) {
    if (now >= 状态.节点列表[i].到期时间) {
      销毁内部节点(状态, 状态.节点列表[i].序号);
    } else {
      i += 1;
    }
  }
}

/**
 * 全体过期清扫（周期驱动）：玩家不操作时节点也会按 存续毫秒 自动消失，
 * 连接线随节点销毁一并关闭，不再依赖后续查询惰性清理。
 */
function on塞莉亚节点清扫(this: void): void {
  for (const id in 塞莉亚状态表) {
    const 状态 = 塞莉亚状态表[id];
    if (状态 == null || 状态.已清理) continue;
    清理过期节点(状态);
  }
}

/**
 * 在真实坐标创建节点；超上限时安全替换最旧节点及其连接，再加入新节点，
 * 最后尝试与其余异型存活节点建立连接。
 */
export function 创建塞莉亚节点(
  this: void,
  英雄: any,
  类型: 塞莉亚节点类型,
  X: number,
  Y: number,
  来源实例ID?: number,
  /** 存续毫秒覆盖（D 的临时短寿命节点使用）；缺省取 节点配置.存续毫秒 */
  存续毫秒?: number,
): 塞莉亚节点 | null {
  if (英雄 == null || 英雄 === 0 || !单位存活(英雄)) return null;
  const 状态 = 取或建状态(英雄);
  if (状态.已清理) return null;

  清理过期节点(状态);

  while (状态.节点列表.length >= 塞莉亚克莱尔节点配置.上限) {
    销毁内部节点(状态, 状态.节点列表[0].序号);
  }

  // 公式节点表现：按节点类型取 一用途一完整对象（模型路径/缩放/高度/持续秒/RGB 全配置驱动；RGB 按类型青蓝/白蓝/紫蓝）
  const 节点表现 = 类型 === "棱晶"
    ? 塞莉亚克莱尔表现配置.公式节点棱晶
    : 类型 === "结界"
      ? 塞莉亚克莱尔表现配置.公式节点结界
      : 塞莉亚克莱尔表现配置.公式节点锚定;
  const 特效句柄 = 创建点特效({
    模型路径: 节点表现.模型路径,
    RGB: 节点表现.RGB,
    X,
    Y,
    Z: 节点表现.高度,
    缩放: 节点表现.缩放,
    持续秒: 节点表现.持续秒,
  });
  if (特效句柄 == null || 特效句柄 === 0) return null;

  const 节点: 塞莉亚节点 = {
    序号: 下一全局节点序号++,
    类型,
    X,
    Y,
    来源实例ID,
    到期时间: getGameTime() + (存续毫秒 != null && 存续毫秒 > 0 ? 存续毫秒 : 塞莉亚克莱尔节点配置.存续毫秒),
    特效句柄,
  };
  状态.节点列表.push(节点);
  尝试建立连接(状态, 节点);
  return 节点;
}

/** 查询存活节点副本（惰性剔除过期）。 */
export function 查询塞莉亚节点(this: void, 英雄: any): 塞莉亚节点[] {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return [];
  清理过期节点(状态);
  const 结果: 塞莉亚节点[] = [];
  for (let i = 0; i < 状态.节点列表.length; i++) 结果.push(状态.节点列表[i]);
  return 结果;
}

export function 取塞莉亚节点按序号(this: void, 英雄: any, 序号: number): 塞莉亚节点 | null {
  const 列表 = 查询塞莉亚节点(英雄);
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i].序号 === 序号) return 列表[i];
  }
  return null;
}

/** 读取当前有效连接的只读快照（两端节点必须仍在有效期内）。 */
export function 查询塞莉亚有效连接(this: void, 英雄: any): 塞莉亚连接信息 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.连接 == null) return null;
  清理过期节点(状态);
  const 连接 = 状态.连接;
  if (连接 == null) return null;
  const A = 取内部节点(状态, 连接.A序号);
  const B = 取内部节点(状态, 连接.B序号);
  if (A == null || B == null) return null;
  return { A序号: A.序号, B序号: B.序号, A类型: A.类型, B类型: B.类型, 可读取: 连接.可读取 };
}

/**
 * 原子消费连接：只有一次调用能把 可读取 从 true 翻转为 false 并关闭连线。
 * R 分支入口必须走这里，防止多个异步回调重复消费同一条连接。
 */
export function 消费塞莉亚连接(this: void, 英雄: any): 塞莉亚连接信息 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.连接 == null || !状态.连接.可读取) return null;
  const 快照 = 查询塞莉亚有效连接(英雄);
  if (快照 == null) return null;
  状态.连接.可读取 = false; // 原子翻转
  关闭连接(状态);
  return 快照;
}

/**
 * D 术式转写事务：校验 → R 锁检查 → 关闭旧连接 → 更新坐标与特效 → 重算连接 → 解锁。
 * 任一步失败恢复原状或安全收口，不留半条连接。
 */
export function 转写塞莉亚节点事务(
  this: void,
  英雄: any,
  节点序号: number,
  新X: number,
  新Y: number,
): boolean {
  const 状态 = 取或建状态(英雄);
  if (状态.已清理 || 状态.R锁定 || 状态.转写中) return false;
  清理过期节点(状态);
  const 节点 = 取内部节点(状态, 节点序号);
  if (节点 == null) return false;

  状态.转写中 = true;
  // ① 旧连接先失效（含连线销毁）
  关闭连接(状态);
  // ② 原地迁移同一节点特效（不改存续期，不复制保护/伤害语义）
  节点.X = 新X;
  节点.Y = 新Y;
  if (EXSetEffectXY != null) EXSetEffectXY(节点.特效句柄, 新X, 新Y);
  // ③ 重算连接
  尝试建立连接(状态, 节点);
  // ④ 解锁
  状态.转写中 = false;
  return true;
}

//=============================================================================
// R 锁定（R 蓄力期间 D 不得改写本次 R 数据）
//=============================================================================

export function 锁定塞莉亚R(this: void, 英雄: any): boolean {
  const 状态 = 取或建状态(英雄);
  if (状态.R锁定) return false;
  状态.R锁定 = true;
  return true;
}

export function 解除塞莉亚R锁定(this: void, 英雄: any): void {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return;
  状态.R锁定 = false;
}

export function 是否塞莉亚R锁定中(this: void, 英雄: any): boolean {
  const 状态 = 查找状态(英雄);
  return 状态 != null && 状态.R锁定;
}

//=============================================================================
// A2：强化窗口 / E 区域标记
//=============================================================================

/** Q/W/E 施法真正成功后调用：累积一次演算窗口（受上限约束）并同步 Buff。 */
export function 授予塞莉亚演算窗口(this: void, 英雄: any): void {
  const 状态 = 取或建状态(英雄);
  if (状态.已清理) return;
  if (状态.强化次数 >= 塞莉亚克莱尔演算普攻配置.强化上限) return;
  状态.强化次数 += 1;
  registerManualBuff(英雄, 塞莉亚BuffID.演算魔弹, 8, 状态.强化次数, { stack: 状态.强化次数 });
}

function 消耗塞莉亚演算窗口(this: void, 英雄: any, 状态: 塞莉亚英雄状态): void {
  if (状态.强化次数 <= 0) return;
  状态.强化次数 -= 1;
  if (状态.强化次数 <= 0) {
    状态.强化次数 = 0;
    移除单位指定Buff(英雄, 塞莉亚BuffID.演算魔弹);
  } else {
    registerManualBuff(英雄, 塞莉亚BuffID.演算魔弹, 8, 状态.强化次数, { stack: 状态.强化次数 });
  }
}

/** E 区域进入/离开维护（05 调用）；成员死亡由统一死亡入口递减。 */
export function 标记目标在塞莉亚E区域(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0) return;
  const id = 取单位ID(目标);
  E区域目标表[id] = (E区域目标表[id] ?? 0) + 1;
}
export function 取消标记目标在塞莉亚E区域(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0) return;
  const id = 取单位ID(目标);
  const 计数 = E区域目标表[id];
  if (计数 == null) return;
  if (计数 <= 1) delete E区域目标表[id];
  else E区域目标表[id] = 计数 - 1;
}
export function 目标在塞莉亚E区域(this: void, 目标: any): boolean {
  if (目标 == null || 目标 === 0) return false;
  return (E区域目标表[取单位ID(目标)] ?? 0) > 0;
}

//=============================================================================
// A2：演算普攻监听
//=============================================================================

const 阵内解析上次时间: Record<number, number | undefined> = {};

function 造成塞莉亚演算伤害(this: void, 施法者: any, 目标: any, 伤害值: number, 标签: string): boolean {
  return 造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    标签,
    伤害形态: "单体",
    参与技能伤害加成: false,
  });
}

function 处理塞莉亚演算普攻(this: void, target: any, attacker: any, snapshot: any, 状态: 塞莉亚英雄状态): void {
  if (target == null || target === 0) return;
  if (!单位存活(target)) return;
  if (snapshot?.isNormalAttack !== true) return;
  if (snapshot?.isWrappedSkillDamage === true) return;
  if (snapshot?.originalAttacker != null && snapshot.originalAttacker !== attacker) return;
  if (状态.已清理 || 状态.强化次数 <= 0) return;
  清理过期节点(状态);
  if (状态.节点列表.length <= 0) return;

  const px = GetUnitX(target);
  const py = GetUnitY(target);
  const 判定平方 = 塞莉亚克莱尔演算普攻配置.判定半径 * 塞莉亚克莱尔演算普攻配置.判定半径;

  let 近节点 = false;
  for (let i = 0; i < 状态.节点列表.length; i++) {
    if (距离平方XY(px, py, 状态.节点列表[i].X, 状态.节点列表[i].Y) <= 判定平方) {
      近节点 = true;
      break;
    }
  }
  let 近连接 = false;
  const 连接 = 状态.连接;
  if (!近节点 && 连接 != null) {
    const A = 取内部节点(状态, 连接.A序号);
    const B = 取内部节点(状态, 连接.B序号);
    if (A != null && B != null) {
      近连接 = 点到线段距离平方(px, py, A.X, A.Y, B.X, B.Y) <= 判定平方;
    }
  }
  if (!近节点 && !近连接) return;

  // 分支真正进入：结算后消费窗口
  const 攻击力 = 读取单位攻击力(attacker);
  const 追加伤害 = 攻击力 * 塞莉亚克莱尔演算普攻配置.追加伤害攻击力倍率;
  造成塞莉亚演算伤害(attacker, target, 追加伤害, "塞莉亚-演算完成");

  if (近连接 && 状态.连接 != null) {
    const 两端最晚上界 = 两端到期上界(状态);
    const 新A = 取内部节点(状态, 状态.连接.A序号);
    const 新B = 取内部节点(状态, 状态.连接.B序号);
    if (新A != null && 新A.到期时间 + 塞莉亚克莱尔演算普攻配置.连接延长毫秒 <= 两端最晚上界) {
      新A.到期时间 += 塞莉亚克莱尔演算普攻配置.连接延长毫秒;
    }
    if (新B != null && 新B.到期时间 + 塞莉亚克莱尔演算普攻配置.连接延长毫秒 <= 两端最晚上界) {
      新B.到期时间 += 塞莉亚克莱尔演算普攻配置.连接延长毫秒;
    }
    回馈Q冷却(attacker, 状态);
  }

  // E 联动：命中锚定区域内目标附加一发低伤解析魔弹（每目标内部冷却）
  if (目标在塞莉亚E区域(target)) {
    const tid = 取单位ID(target);
    const now = getGameTime();
    const 上次 = 阵内解析上次时间[tid] ?? 0;
    if (now - 上次 >= 塞莉亚克莱尔E配置.阵内解析内部冷却毫秒) {
      阵内解析上次时间[tid] = now;
      造成塞莉亚演算伤害(attacker, target, 攻击力 * 塞莉亚克莱尔E配置.阵内追加解析倍率, "塞莉亚-阵内解析");
    }
  }

  消耗塞莉亚演算窗口(attacker, 状态);
}

function 两端到期上界(状态: 塞莉亚英雄状态): number {
  // 连接延长不得超过两端任一节点的自然存续上限：以创建时的 存续毫秒 为基准，
  // 这里取两节点中较晚到期者作为延长后的共同上界（避免一侧单独续命成幽灵线）。
  let 最大 = 0;
  for (let i = 0; i < 状态.节点列表.length; i++) {
    if (状态.节点列表[i].到期时间 > 最大) 最大 = 状态.节点列表[i].到期时间;
  }
  return 最大 + 塞莉亚克莱尔节点配置.存续毫秒 / 2;
}

function 回馈Q冷却(this: void, 英雄: any, 状态: 塞莉亚英雄状态): void {
  const now = getGameTime();
  if (now < 状态.回馈下次可用时间) return;
  状态.回馈下次可用时间 = now + 塞莉亚克莱尔演算普攻配置.回馈内部冷却毫秒;
  const 当前 = platformAbilityApi.技能_获取技能当前冷却时间(英雄, Q技能类型ID);
  if (当前 <= 0) return;
  const 缩减 = 当前 - 塞莉亚克莱尔演算普攻配置.冷却缩减秒;
  const 最大冷却 = platformAbilityApi.技能_获取技能最大冷却时间(英雄, Q技能类型ID);
  platformAbilityAction.技能_设置技能冷却时间(英雄, Q技能类型ID, 缩减 > 0 ? 缩减 : 0, 最大冷却);
}

//=============================================================================
// 清理表 / 进度 UI 登记
//=============================================================================

export function 登记塞莉亚技能清理(
  this: void,
  英雄: any,
  标签: string,
  清理: (this: void) => void,
): (this: void) => void {
  const 状态 = 取或建状态(英雄);
  状态.技能清理表[标签] = 清理;
  return function 注销塞莉亚技能清理(this: void): void {
    const 当前 = 塞莉亚状态表[取单位ID(英雄)];
    if (当前 != null && 当前.技能清理表[标签] === 清理) delete 当前.技能清理表[标签];
  };
}

export function 登记塞莉亚进度UI(this: void, 英雄: any, ui: any): void {
  if (ui == null || ui === 0) return;
  const 状态 = 取或建状态(英雄);
  for (let i = 0; i < 状态.进度UI列表.length; i++) {
    if (状态.进度UI列表[i] === ui) return;
  }
  状态.进度UI列表.push(ui);
}

export function 销毁塞莉亚进度UI(this: void, 英雄: any, ui: any): void {
  if (ui == null || ui === 0) return;
  销毁世界坐标进度UI(ui);
  const 状态 = 查找状态(英雄);
  if (状态 == null) return;
  for (let i = 0; i < 状态.进度UI列表.length; i++) {
    if (状态.进度UI列表[i] === ui) {
      状态.进度UI列表.splice(i, 1);
      return;
    }
  }
}

function 清理全部进度UI(状态: 塞莉亚英雄状态): void {
  while (状态.进度UI列表.length > 0) {
    const ui = 状态.进度UI列表[0];
    状态.进度UI列表.splice(0, 1);
    销毁世界坐标进度UI(ui);
  }
}

function 执行全部技能清理(状态: 塞莉亚英雄状态): void {
  for (const 标签 in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[标签];
    if (清理 != null) 清理();
  }
  for (const 标签 in 状态.技能清理表) delete 状态.技能清理表[标签];
}

//=============================================================================
// 统一回收（幂等）
//=============================================================================

/**
 * 复位单个状态数据。英雄可为 null（地图清理场景无句柄反查能力，
 * TSTL 不提供 id→unit 反查）：此时跳过依赖存活判定的 Buff 移除。
 */
function 复位状态数据(this: void, 英雄: any, 状态: 塞莉亚英雄状态): void {
  执行全部技能清理(状态);
  关闭连接(状态);
  while (状态.节点列表.length > 0) {
    const 节点 = 状态.节点列表[0];
    状态.节点列表.splice(0, 1);
    销毁点特效(节点.特效句柄);
  }
  状态.强化次数 = 0;
  状态.R锁定 = false;
  状态.转写中 = false;
  清理全部进度UI(状态);
  if (英雄 != null && 单位存活(英雄)) {
    移除单位指定Buff(英雄, 塞莉亚BuffID.演算魔弹);
    移除单位指定Buff(英雄, 塞莉亚BuffID.解析结界);
    移除单位指定Buff(英雄, 塞莉亚BuffID.高阶术式蓄力);
  }
}

export function 清理塞莉亚状态(this: void, 英雄: any, 原因: 塞莉亚清理原因 = "主动清理"): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const id = 取单位ID(英雄);
  const 状态 = 塞莉亚状态表[id];
  if (状态 == null) return false;
  if (状态.已清理) return true;
  状态.已清理 = true;
  void 原因;
  复位状态数据(英雄, 状态);
  delete 塞莉亚状态表[id];
  return true;
}

export function 清理全部塞莉亚状态(this: void, 原因: 塞莉亚清理原因 = "地图清理"): number {
  let 数量 = 0;
  const ids: number[] = [];
  for (const id in 塞莉亚状态表) ids.push(Number(id));
  for (let i = 0; i < ids.length; i++) {
    const 状态 = 塞莉亚状态表[ids[i]];
    if (状态 == null || 状态.已清理) continue;
    状态.已清理 = true;
    void 原因;
    复位状态数据(null, 状态);
    delete 塞莉亚状态表[ids[i]];
    数量++;
  }
  return 数量;
}

/** 仅供测试/调试：登记中的塞莉亚数量、节点总数与活跃连接数。 */
export function 获取塞莉亚状态统计(this: void): { 英雄数: number; 节点总数: number; 连接数: number } {
  let 英雄数 = 0;
  let 节点总数 = 0;
  let 连接数 = 0;
  for (const id in 塞莉亚状态表) {
    const 状态 = 塞莉亚状态表[id];
    if (状态 != null) {
      英雄数++;
      节点总数 += 状态.节点列表.length;
      if (状态.连接 != null) 连接数++;
    }
  }
  return { 英雄数, 节点总数, 连接数 };
}

function 确保死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 塞莉亚死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    // 1) 作为英雄本体
    清理塞莉亚状态(dyingUnit, "英雄死亡");
    // 2) 作为 E 区域成员：直接整行摘除（跨区域计数一并清零，各阵周期会自行对账）
    const diedId = 取单位ID(dyingUnit);
    delete E区域目标表[diedId];
    delete 阵内解析上次时间[diedId];
  });
}

let 普攻联动已注册 = false;
let 清扫周期已注册 = false;

/** 注册被动入口（幂等）：死亡清理 + 演算普攻监听。 */
export function 注册塞莉亚被动效果(this: void): void {
  确保死亡监听();
  if (!清扫周期已注册) {
    清扫周期已注册 = true;
    addPeriodicCallback(1000, on塞莉亚节点清扫);
  }
  if (普攻联动已注册) return;
  普攻联动已注册 = true;
  registerAppliedFinalDamageListener(function 塞莉亚演算普攻入口(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
    if (attacker == null || attacker === 0) return;
    const 状态 = 塞莉亚状态表[取单位ID(attacker)];
    if (状态 == null) return;
    处理塞莉亚演算普攻(target, attacker, snapshot, 状态);
  });
}

export {};
