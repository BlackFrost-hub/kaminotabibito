/** @noSelfInFile */
/**
 * 伊蕾娜 - 被动：旅途见闻 / 强化普攻 / 公共状态容器（A1+A2）
 *
 * A1：
 * - 每名伊蕾娜独立维护最多 上限(3) 条见闻；记录类型/序号/到期时间。
 * - 同类型重复记录刷新该条持续时间；超上限淘汰最旧（序号最小）。
 * - 容器同时持有：待强化普攻、当前 D 变式（含 R 锁定槽）、E 扫帚路线、W 结界指针、
 *   技能清理表与世界坐标进度 UI 列表。
 * - 统一清理入口幂等：死亡监听 / 打断（技能清理表）/ 地图清理共用；
 *   清理时移除见闻与变式 Buff、注销清理表、销毁进度 UI。
 *
 * A2：
 * - 监听伊蕾娜真实普攻的应用后最终伤害（isNormalAttack 且非技能包装伤害）。
 * - 每次最多消费一条见闻：按见闻类型发射强化魔弹（风行穿透 / 镜界减速+护盾回响 / 远行短追踪或路线直射）。
 * - 强化命中减少 Q/W/E 冷却，带内部冷却；没有见闻时保持原生普攻，不产生额外爆炸。
 */

import {
  伊蕾娜技能配置,
  伊蕾娜见闻配置,
  伊蕾娜变式配置,
  伊蕾娜普攻联动配置,
  伊蕾娜表现配置,
  伊蕾娜E配置,
} from "./00．配置";
import { 伊蕾娜BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/23．伊蕾娜";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 取单位ID, 单位存活, 两点角度, 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, attackSlow: number, moveSlow: number, time: number, effectSourceName?: string, effectSourceType?: string, displayBuffID?: string) => void;
};
const { 充能单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  充能单位标签护盾: (this: void, 单位: any, 标签: string, 数值: number, 最大值: number, 参数?: any) => number;
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

const 英雄单位类型ID = jass.FourCC(伊蕾娜技能配置.单位类型ID) as number;
const Q技能类型ID = jass.FourCC(伊蕾娜技能配置.Q.技能ID) as number;
const W技能类型ID = jass.FourCC(伊蕾娜技能配置.W.技能ID) as number;
const E技能类型ID = jass.FourCC(伊蕾娜技能配置.E.技能ID) as number;

//=============================================================================
// 类型
//=============================================================================

export type 伊蕾娜见闻类型 = "风行" | "镜界" | "远行";

export interface 伊蕾娜见闻 {
  /** 全局递增序号（淘汰最旧的判定基准） */
  序号: number;
  类型: 伊蕾娜见闻类型;
  /** 到期时间（getGameTime 毫秒） */
  到期时间: number;
  /** 记录时的技能实例 ID（可追溯，不参与判定） */
  来源实例ID?: number;
}

export type 伊蕾娜变式类型 = "迅行" | "镜界" | "灰烬";

export interface 伊蕾娜扫帚路线 {
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  方向角: number;
  /** 到期时间（getGameTime 毫秒）；短寿命，供 Q/R 读取 */
  到期时间: number;
}

export type 伊蕾娜清理原因 = "英雄死亡" | "技能清理" | "地图清理" | "主动清理";

interface 伊蕾娜英雄状态 {
  见闻列表: 伊蕾娜见闻[];
  当前变式: 伊蕾娜变式类型 | null;
  /** 变式未消费的到期时间（毫秒），超时自动归零 */
  变式到期时间: number;
  /** R 蓄力期间锁定：D 不能改写本次 R 的变式快照 */
  R锁定变式: 伊蕾娜变式类型 | null;
  E路线: 伊蕾娜扫帚路线 | null;
  /** W 结界运行数据（结构由 04．W技能.ts 定义并管理生命周期） */
  W结界: any;
  技能清理表: Record<string, ((this: void) => void) | undefined>;
  进度UI列表: any[];
  /** 冷却回馈内部冷却的下次可用时刻（毫秒） */
  回馈下次可用时间: number;
  已清理: boolean;
}

//=============================================================================
// 状态表与死亡监听
//=============================================================================

const 伊蕾娜状态表: Record<number, 伊蕾娜英雄状态 | undefined> = {};
let 下一全局见闻序号 = 1;
let 死亡监听已注册 = false;

function 取句柄(this: void, 英雄: any): number {
  return 取单位ID(英雄);
}

function 取或建状态(this: void, 英雄: any): 伊蕾娜英雄状态 {
  const id = 取句柄(英雄);
  let 状态 = 伊蕾娜状态表[id];
  if (状态 == null) {
    状态 = {
      见闻列表: [],
      当前变式: null,
      变式到期时间: 0,
      R锁定变式: null,
      E路线: null,
      W结界: null,
      技能清理表: {},
      进度UI列表: [],
      回馈下次可用时间: 0,
      已清理: false,
    };
    伊蕾娜状态表[id] = 状态;
  }
  return 状态;
}

function 查找状态(this: void, 英雄: any): 伊蕾娜英雄状态 | undefined {
  return 伊蕾娜状态表[取句柄(英雄)];
}

//=============================================================================
// 判定
//=============================================================================

/** 判断单位是否为伊蕾娜 */
export function 是伊蕾娜(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return GetUnitTypeId(unit) === 英雄单位类型ID;
}

//=============================================================================
// Buff 展示同步（层数=数量；时长=最短剩余寿命）
//=============================================================================

function 取最短剩余秒(this: void, 列表: 伊蕾娜见闻[]): number {
  const now = getGameTime();
  let 最短 = 0;
  for (let i = 0; i < 列表.length; i++) {
    const 剩余 = 列表[i].到期时间 - now;
    if (i === 0 || 剩余 < 最短) 最短 = 剩余;
  }
  return 最短 > 0 ? 最短 / 1000 : 0.1;
}

/** 依据见闻列表刷新“旅途见闻”与“魔法弹强化”两层 Buff（层内数量=层数）。 */
function 刷新见闻Buff(this: void, 英雄: any, 状态: 伊蕾娜英雄状态): void {
  const 数量 = 状态.见闻列表.length;
  if (数量 <= 0) {
    移除单位指定Buff(英雄, 伊蕾娜BuffID.旅途见闻);
    移除单位指定Buff(英雄, 伊蕾娜BuffID.魔法弹强化);
    return;
  }
  const 时长秒 = 取最短剩余秒(状态.见闻列表);
  registerManualBuff(英雄, 伊蕾娜BuffID.旅途见闻, 时长秒, 数量, { stack: 数量 });
  registerManualBuff(英雄, 伊蕾娜BuffID.魔法弹强化, 时长秒, 数量, { stack: 数量 });
}

/** 就地剔除过期见闻（惰性过期；返回是否发生变化）。 */
function 惰性剔除过期见闻(this: void, 状态: 伊蕾娜英雄状态): boolean {
  const now = getGameTime();
  let 有变化 = false;
  let i = 0;
  while (i < 状态.见闻列表.length) {
    if (状态.见闻列表[i].到期时间 <= now) {
      状态.见闻列表.splice(i, 1);
      有变化 = true;
    } else {
      i += 1;
    }
  }
  return 有变化;
}

//=============================================================================
// A1：见闻读写
//=============================================================================

/**
 * 记录一条见闻（Q/W/E 成功释放后调用）。
 * 同类型刷新持续时间；超过上限淘汰最旧。返回本次生效的记录。
 */
export function 记录伊蕾娜见闻(
  this: void,
  英雄: any,
  类型: 伊蕾娜见闻类型,
  来源实例ID?: number,
): 伊蕾娜见闻 | null {
  if (英雄 == null || 英雄 === 0 || !单位存活(英雄)) return null;
  const 状态 = 查找状态(英雄) ?? 取或建状态(英雄);
  if (状态.已清理) return null;

  const now = getGameTime();
  // 同类型：刷新最新一条的同型记录，不无限叠层
  for (let i = 状态.见闻列表.length - 1; i >= 0; i--) {
    if (状态.见闻列表[i].类型 === 类型) {
      const 记录 = 状态.见闻列表.splice(i, 1)[0];
      记录.到期时间 = now + 伊蕾娜见闻配置.持续毫秒;
      记录.来源实例ID = 来源实例ID;
      状态.见闻列表.push(记录);
      刷新见闻Buff(英雄, 状态);
      return 记录;
    }
  }

  const 记录: 伊蕾娜见闻 = {
    序号: 下一全局见闻序号++,
    类型,
    到期时间: now + 伊蕾娜见闻配置.持续毫秒,
    来源实例ID,
  };
  状态.见闻列表.push(记录);
  // 超上限：淘汰最旧（序号最小者位于队首）
  while (状态.见闻列表.length > 伊蕾娜见闻配置.上限) {
    状态.见闻列表.shift();
  }
  刷新见闻Buff(英雄, 状态);
  return 记录;
}

/** 查询当前有效见闻（创建顺序副本；惰性剔除过期项并同步 Buff）。 */
export function 查询伊蕾娜见闻(this: void, 英雄: any): 伊蕾娜见闻[] {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return [];
  if (惰性剔除过期见闻(状态)) 刷新见闻Buff(英雄, 状态);
  const 结果: 伊蕾娜见闻[] = [];
  for (let i = 0; i < 状态.见闻列表.length; i++) 结果.push(状态.见闻列表[i]);
  return 结果;
}

function 取消费源索引(this: void, 状态: 伊蕾娜英雄状态): number {
  if (状态.见闻列表.length <= 0) return -1;
  const 顺序 = 伊蕾娜见闻配置.消费顺序 as string;
  if (顺序 === "最新优先") return 状态.见闻列表.length - 1;
  return 0;
}

/** 预览下一次将消费的见闻（不移除；用于先按类型分支再确认消费）。 */
export function 预览伊蕾娜消费见闻(this: void, 英雄: any): 伊蕾娜见闻 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  if (惰性剔除过期见闻(状态)) 刷新见闻Buff(英雄, 状态);
  const 索引 = 取消费源索引(状态);
  if (索引 < 0) return null;
  return 状态.见闻列表[索引];
}

/**
 * 确认消费指定序号的见闻（仅在分支真正进入后调用；校验失败不得白扣）。
 * 成功返回被消费记录；序号已失效返回 null 且不做任何修改。
 */
export function 消费伊蕾娜见闻按序号(this: void, 英雄: any, 序号: number): 伊蕾娜见闻 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  for (let i = 0; i < 状态.见闻列表.length; i++) {
    if (状态.见闻列表[i].序号 !== 序号) continue;
    const 记录 = 状态.见闻列表.splice(i, 1)[0];
    刷新见闻Buff(英雄, 状态);
    return 记录;
  }
  return null;
}

//=============================================================================
// A1/D：变式状态
//=============================================================================

function 同步变式Buff(this: void, 英雄: any, 状态: 伊蕾娜英雄状态): void {
  if (状态.当前变式 == null) {
    移除单位指定Buff(英雄, 伊蕾娜BuffID.魔法变式);
    return;
  }
  const 剩余秒 = (状态.变式到期时间 - getGameTime()) / 1000;
  registerManualBuff(英雄, 伊蕾娜BuffID.魔法变式, 剩余秒 > 0 ? 剩余秒 : 0.1, 0);
}

/** 设置当前变式（D 切换调用；覆盖旧变式，不叠加多套）。 */
export function 设置伊蕾娜变式(this: void, 英雄: any, 变式: 伊蕾娜变式类型): boolean {
  const 状态 = 查找状态(英雄) ?? 取或建状态(英雄);
  if (状态.已清理) return false;
  if (状态.R锁定变式 != null) return false; // R 蓄力期间锁定，D 不能改写本次 R
  状态.当前变式 = 变式;
  状态.变式到期时间 = getGameTime() + 伊蕾娜变式配置.保持秒 * 1000;
  同步变式Buff(英雄, 状态);
  return true;
}

/** 读取当前变式（惰性校验保持期；R 锁定期间对普通技能不可见，R 用 获取伊蕾娜R锁定变式 读取）。 */
export function 获取伊蕾娜变式(this: void, 英雄: any): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  if (状态.R锁定变式 != null) return null;
  if (状态.当前变式 == null) return null;
  if (getGameTime() >= 状态.变式到期时间) {
    状态.当前变式 = null;
    状态.变式到期时间 = 0;
    同步变式Buff(英雄, 状态);
    return null;
  }
  return 状态.当前变式;
}

/** 仅 R 技能使用：读取蓄力开始时锁定的变式快照。 */
export function 获取伊蕾娜R锁定变式(this: void, 英雄: any): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  return 状态.R锁定变式;
}

/** R 开始蓄力时锁定当前变式快照（后续 D 切换被拒；中断时解除锁定还原）。 */
export function 锁定伊蕾娜R变式(this: void, 英雄: any): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄) ?? 取或建状态(英雄);
  if (状态.R锁定变式 != null) return 状态.R锁定变式;
  const 当前 = 获取伊蕾娜变式(英雄);
  if (当前 == null) return null;
  状态.R锁定变式 = 当前;
  // 锁定即从可切换池摘除，避免 R 过程中 D 再次改写
  状态.当前变式 = null;
  状态.变式到期时间 = 0;
  同步变式Buff(英雄, 状态);
  return 状态.R锁定变式;
}

/** 解除 R 锁定并把变式还原为锁定值（R 中断/失败时调用，不得白扣）。 */
export function 还原伊蕾娜R锁定变式(this: void, 英雄: any): void {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.R锁定变式 == null) return;
  状态.当前变式 = 状态.R锁定变式;
  状态.变式到期时间 = getGameTime() + 伊蕾娜变式配置.保持秒 * 1000;
  状态.R锁定变式 = null;
  同步变式Buff(英雄, 状态);
}

/** 消费变式（分支真正进入成功后调用）。返回被消费的变式；无变式返回 null。 */
export function 消费伊蕾娜变式(this: void, 英雄: any): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  // R 锁定中的变式只能由 R 自己在完成路径消费
  if (状态.R锁定变式 != null) return null;
  const 当前 = 获取伊蕾娜变式(英雄);
  if (当前 == null) return null;
  状态.当前变式 = null;
  状态.变式到期时间 = 0;
  同步变式Buff(英雄, 状态);
  return 当前;
}

/**
 * 按受益矩阵消费变式：迅行→Q/E；镜界→W；灰烬→Q/E/R。
 * 不受益时不消耗（保留给后续技能）；分支未真正进入不得调用本函数。
 * R 蓄力期间变式处于锁定快照，其他技能一律读不到、也不可消耗。
 */
export function 消费伊蕾娜变式用于(
  this: void,
  英雄: any,
  技能键: "Q" | "W" | "E" | "R",
): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.R锁定变式 != null) return null;
  const 当前 = 状态.当前变式;
  if (当前 == null) return null;
  let 受益 = false;
  if (当前 === "迅行") 受益 = 技能键 === "Q" || 技能键 === "E";
  else if (当前 === "镜界") 受益 = 技能键 === "W";
  else 受益 = true; // 灰烬：Q/E/R 全部受益
  if (!受益) return null;
  return 消费伊蕾娜变式(英雄);
}

/** 仅 R 使用：消费锁定的变式快照（R 充能完成且变式分支真正进入后调用）。 */
export function 消费伊蕾娜R锁定变式(this: void, 英雄: any): 伊蕾娜变式类型 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.R锁定变式 == null) return null;
  const 锁定 = 状态.R锁定变式;
  状态.R锁定变式 = null;
  return 锁定;
}

//=============================================================================
// A1/E：扫帚路线
//=============================================================================

/** 记录 E 的扫帚路线（到达终点时调用；短寿命，超时自动失效）。 */
export function 记录伊蕾娜扫帚路线(
  this: void,
  英雄: any,
  起点X: number,
  起点Y: number,
  终点X: number,
  终点Y: number,
  方向角: number,
): 伊蕾娜扫帚路线 | null {
  const 状态 = 查找状态(英雄) ?? 取或建状态(英雄);
  if (状态.已清理) return null;
  const 路线: 伊蕾娜扫帚路线 = {
    起点X,
    起点Y,
    终点X,
    终点Y,
    方向角,
    到期时间: getGameTime() + 伊蕾娜E配置.路线寿命秒 * 1000,
  };
  状态.E路线 = 路线;
  return 路线;
}

/** 读取当前存活的扫帚路线（惰性过期）。 */
export function 读取伊蕾娜扫帚路线(this: void, 英雄: any): 伊蕾娜扫帚路线 | null {
  const 状态 = 查找状态(英雄);
  if (状态 == null || 状态.E路线 == null) return null;
  if (getGameTime() >= 状态.E路线.到期时间) {
    状态.E路线 = null;
    return null;
  }
  return 状态.E路线;
}

/** 清除扫帚路线（场景清理/显式失效）。 */
export function 清除伊蕾娜扫帚路线(this: void, 英雄: any): void {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return;
  状态.E路线 = null;
}

//=============================================================================
// A1/W：结界运行数据槽（结构由 04．W技能.ts 定义，这里只做统一存取与清理）
//=============================================================================

/** 存入当前 W 结界运行数据（重复施放时由 W 自行先关旧再存新）。 */
export function 存伊蕾娜W结界(this: void, 英雄: any, 数据: any): void {
  const 状态 = 查找状态(英雄) ?? 取或建状态(英雄);
  if (状态.已清理) return;
  状态.W结界 = 数据;
}

export function 取伊蕾娜W结界(this: void, 英雄: any): any {
  const 状态 = 查找状态(英雄);
  if (状态 == null) return null;
  return 状态.W结界;
}

//=============================================================================
// A1：技能清理表 / 进度 UI 登记（技能实例侧登记，统一回收执行）
//=============================================================================

/** 登记技能清理回调，返回注销函数（幂等）。 */
export function 登记伊蕾娜技能清理(
  this: void,
  英雄: any,
  标签: string,
  清理: (this: void) => void,
): (this: void) => void {
  const 状态 = 取或建状态(英雄);
  状态.技能清理表[标签] = 清理;
  return function 注销伊蕾娜技能清理(this: void): void {
    const 当前 = 伊蕾娜状态表[取句柄(英雄)];
    if (当前 != null && 当前.技能清理表[标签] === 清理) delete 当前.技能清理表[标签];
  };
}

function 执行全部技能清理(this: void, 状态: 伊蕾娜英雄状态): void {
  for (const 标签 in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[标签];
    if (清理 != null) 清理();
  }
  for (const 标签 in 状态.技能清理表) delete 状态.技能清理表[标签];
}

/** 登记世界坐标进度 UI 句柄（随英雄状态统一销毁；重复登记去重）。 */
export function 登记伊蕾娜进度UI(this: void, 英雄: any, ui: any): void {
  if (ui == null || ui === 0) return;
  const 状态 = 取或建状态(英雄);
  for (let i = 0; i < 状态.进度UI列表.length; i++) {
    if (状态.进度UI列表[i] === ui) return;
  }
  状态.进度UI列表.push(ui);
}

/** 立即销毁指定进度 UI 并摘除登记。 */
export function 销毁伊蕾娜进度UI(this: void, 英雄: any, ui: any): void {
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

function 清理全部进度UI(this: void, 状态: 伊蕾娜英雄状态): void {
  while (状态.进度UI列表.length > 0) {
    const ui = 状态.进度UI列表[0];
    状态.进度UI列表.splice(0, 1);
    销毁世界坐标进度UI(ui);
  }
}

//=============================================================================
// A1：统一回收（幂等）
//=============================================================================

/**
 * 统一回收入口：死亡 / 打断 / 地图清理 / 主动清理 共用。
 * 清理顺序：技能清理表（各技能自清弹道/护盾/特效）→ 见闻与变式 Buff →
 * 路线/W 结界指针 → 进度 UI → 摘除状态表项。
 */
export function 清理伊蕾娜状态(this: void, 英雄: any, 原因: 伊蕾娜清理原因 = "主动清理"): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const id = 取句柄(英雄);
  const 状态 = 伊蕾娜状态表[id];
  if (状态 == null) return false;
  if (状态.已清理) return true;
  状态.已清理 = true;
  void 原因;

  执行全部技能清理(状态);
  状态.见闻列表 = [];
  状态.当前变式 = null;
  状态.变式到期时间 = 0;
  状态.R锁定变式 = null;
  状态.E路线 = null;
  状态.W结界 = null;
  清理全部进度UI(状态);

  if (单位存活(英雄)) {
    移除单位指定Buff(英雄, 伊蕾娜BuffID.旅途见闻);
    移除单位指定Buff(英雄, 伊蕾娜BuffID.魔法弹强化);
    移除单位指定Buff(英雄, 伊蕾娜BuffID.魔法变式);
  }
  delete 伊蕾娜状态表[id];
  return true;
}

/** 地图 / 场景清理：清理所有伊蕾娜状态（句柄反查不可用，直接遍历表）。返回清理数量。 */
export function 清理全部伊蕾娜状态(this: void, 原因: 伊蕾娜清理原因 = "地图清理"): number {
  let 数量 = 0;
  const ids: number[] = [];
  for (const id in 伊蕾娜状态表) ids.push(Number(id));
  for (let i = 0; i < ids.length; i++) {
    const 状态 = 伊蕾娜状态表[ids[i]];
    if (状态 == null || 状态.已清理) continue;
    状态.已清理 = true;
    void 原因;
    执行全部技能清理(状态);
    状态.见闻列表 = [];
    状态.当前变式 = null;
    状态.变式到期时间 = 0;
    状态.R锁定变式 = null;
    状态.E路线 = null;
    状态.W结界 = null;
    清理全部进度UI(状态);
    delete 伊蕾娜状态表[ids[i]];
    数量++;
  }
  return 数量;
}

/** 仅供测试/调试：登记中的伊蕾娜数量与见闻总数。 */
export function 获取伊蕾娜状态统计(this: void): { 英雄数: number; 见闻总数: number } {
  let 英雄数 = 0;
  let 见闻总数 = 0;
  for (const id in 伊蕾娜状态表) {
    const 状态 = 伊蕾娜状态表[id];
    if (状态 != null) {
      英雄数++;
      见闻总数 += 状态.见闻列表.length;
    }
  }
  return { 英雄数, 见闻总数 };
}

//=============================================================================
// A2：强化普攻（消耗一条见闻；Q/W/E 冷却回馈带内部冷却）
//=============================================================================

/** 强制披挂强度上限保护：负数防御归零 */
function 不小于零(this: void, v: number): number {
  return v > 0 ? v : 0;
}

function 发射风行穿透弹(this: void, 英雄: any, 目标X: number, 目标Y: number): void {
  const 方向角 = 两点角度(GetUnitX(英雄), GetUnitY(英雄), 目标X, 目标Y);
  发射弹道({
    名称: "伊蕾娜-风行魔弹",
    所有者: 英雄,
    发射X: GetUnitX(英雄),
    发射Y: GetUnitY(英雄),
    发射方向角: 方向角,
    速度: 伊蕾娜普攻联动配置.弹道速度,
    轨迹: { 类型: "直线", 距离: 伊蕾娜普攻联动配置.风行穿透距离 },
    命中半径: 伊蕾娜普攻联动配置.命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    最大总命中次数: 伊蕾娜普攻联动配置.风行最大命中数,
    伤害值: 读取单位攻击力(英雄) * 伊蕾娜普攻联动配置.伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能标签: "伊蕾娜-魔法弹强化",
    伤害形态: "AOE",
    参与技能伤害加成: false,
    模型: 伊蕾娜表现配置.Q联动弹道.模型路径,
    缩放: 伊蕾娜表现配置.Q联动弹道.缩放,
    飞行高度: 伊蕾娜表现配置.Q联动弹道.高度,
    生命周期: 伊蕾娜普攻联动配置.风行穿透距离 / 伊蕾娜普攻联动配置.弹道速度 + 0.5,
  });
}

function 发射远行魔弹(this: void, 英雄: any, 目标: any): void {
  const 路线 = 读取伊蕾娜扫帚路线(英雄);
  const 发射参数: any = {
    名称: "伊蕾娜-远行魔弹",
    所有者: 英雄,
    发射X: GetUnitX(英雄),
    发射Y: GetUnitY(英雄),
    速度: 伊蕾娜普攻联动配置.弹道速度,
    命中半径: 伊蕾娜普攻联动配置.命中半径,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(英雄) * 伊蕾娜普攻联动配置.伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能标签: "伊蕾娜-魔法弹强化",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 伊蕾娜表现配置.Q联动弹道.模型路径,
    缩放: 伊蕾娜表现配置.Q联动弹道.缩放,
    飞行高度: 伊蕾娜表现配置.Q联动弹道.高度,
    生命周期: 伊蕾娜普攻联动配置.远行最大距离 / 伊蕾娜普攻联动配置.弹道速度 + 0.5,
  };
  if (路线 != null) {
    // 沿最近一次扫帚路线方向直射
    发射参数.发射方向角 = 路线.方向角;
    发射参数.轨迹 = { 类型: "直线", 距离: 伊蕾娜普攻联动配置.远行最大距离 };
  } else {
    // 短追踪：追踪目标片刻后保持方向直飞
    发射参数.发射方向角 = 两点角度(GetUnitX(英雄), GetUnitY(英雄), GetUnitX(目标), GetUnitY(目标));
    发射参数.轨迹 = {
      类型: "追踪",
      目标,
      追踪转向速度: 伊蕾娜普攻联动配置.远行追踪转向速度,
      追踪保持秒: 伊蕾娜普攻联动配置.远行追踪保持秒,
    };
  }
  发射弹道(发射参数);
}

function 施加镜界回应(this: void, 英雄: any, 目标: any): void {
  SFB_setSlow(
    英雄,
    目标,
    0,
    伊蕾娜普攻联动配置.镜界减速比例,
    伊蕾娜普攻联动配置.镜界减速秒,
    "伊蕾娜-魔法弹强化",
    "技能",
  );
  const 护盾数值 = 读取单位攻击力(英雄) * 伊蕾娜普攻联动配置.回响护盾攻击力倍率;
  充能单位标签护盾(英雄, "伊蕾娜-保护回响", 护盾数值, 护盾数值, {
    类型: 0,
    持续时间: 伊蕾娜普攻联动配置.回响护盾秒,
    来源单位: 英雄,
    显示护盾条: false,
  });
}

/** 强化命中回馈：减少 Q/W/E 剩余冷却（带内部冷却）。 */
function 回馈QWE冷却(this: void, 英雄: any, 状态: 伊蕾娜英雄状态): void {
  const now = getGameTime();
  if (now < 状态.回馈下次可用时间) return;
  状态.回馈下次可用时间 = now + 伊蕾娜普攻联动配置.冷却回馈内部冷却毫秒;

  const 技能表: { id: number; 当前: number }[] = [
    { id: Q技能类型ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, Q技能类型ID) },
    { id: W技能类型ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, W技能类型ID) },
    { id: E技能类型ID, 当前: platformAbilityApi.技能_获取技能当前冷却时间(英雄, E技能类型ID) },
  ];
  for (let i = 0; i < 技能表.length; i++) {
    if (技能表[i].当前 <= 0) continue;
    const 剩余 = 不小于零(技能表[i].当前 - 伊蕾娜普攻联动配置.冷却缩减秒);
    const 最大冷却 = platformAbilityApi.技能_获取技能最大冷却时间(英雄, 技能表[i].id);
    platformAbilityAction.技能_设置技能冷却时间(英雄, 技能表[i].id, 剩余, 最大冷却);
  }
}

function 处理伊蕾娜强化普攻(this: void, target: any, attacker: any, _applied: number, snapshot: any): void {
  if (target == null || target === 0) return;
  if (attacker == null || attacker === 0 || !是伊蕾娜(attacker)) return;
  // 仅真实普攻触发；技能伤害包装不反向触发
  if (snapshot?.isNormalAttack !== true) return;
  if (snapshot?.isWrappedSkillDamage === true) return;
  if (snapshot?.originalAttacker != null && snapshot.originalAttacker !== attacker) return;
  if (!单位存活(target)) return;

  const 状态 = 查找状态(attacker);
  if (状态 == null || 状态.已清理) return;
  if (惰性剔除过期见闻(状态)) 刷新见闻Buff(attacker, 状态);
  const 下一条 = 预览伊蕾娜消费见闻(attacker);
  if (下一条 == null) return;

  // 先让分支真正进入（发射对应的强化魔弹），再确认消费，失败不白扣
  if (下一条.类型 === "风行") {
    发射风行穿透弹(attacker, GetUnitX(target), GetUnitY(target));
  } else if (下一条.类型 === "镜界") {
    施加镜界回应(attacker, target);
  } else {
    发射远行魔弹(attacker, target);
  }
  const 已消费 = 消费伊蕾娜见闻按序号(attacker, 下一条.序号);
  void 已消费;

  回馈QWE冷却(attacker, 状态);
}

function 确保死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 伊蕾娜死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    if (伊蕾娜状态表[取单位ID(dyingUnit)] == null) return;
    清理伊蕾娜状态(dyingUnit, "英雄死亡");
  });
}

let 普攻联动已注册 = false;

/** 注册被动入口（幂等）：死亡清理监听 + 强化普攻伤害监听。 */
export function 注册伊蕾娜被动效果(this: void): void {
  确保死亡监听();
  if (普攻联动已注册) return;
  普攻联动已注册 = true;
  registerAppliedFinalDamageListener(处理伊蕾娜强化普攻);
}

export {};
