/** @noSelfInFile */
/**
 * 芙莉莲被动（B1：A1 隐匿/解析/花田状态与统一清理 + A2 演算普攻）
 *
 * 按英雄句柄隔离：魔力隐匿计时、一个重点解析目标、最多两种不同解析、解析完成、
 * 待强化普攻窗口、花田判定接口（D 模块注入）与活动技能清理器。
 * 相同解析类型只刷新不叠层；新重点目标清理旧目标解析/Buff/标记；
 * 解析完成只允许下一次合法 Q/R 原子消费一次；总清理幂等。
 */

import {
  芙莉莲技能配置,
  芙莉莲Buff配置,
  芙莉莲被动配置,
  芙莉莲表现配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 创建点特效, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  /** 挂载特效（scale + height 驱动；替代 createUnitEffect 无高度入口的短板） */
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number, RGB?: any) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, appliedDamage: number, snapshot: any) => void) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 单位存活, 取单位ID } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  取单位ID: (this: void, unit: any) => number;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
  技能_获取技能最大冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const Q技能ID = stringToFourCCSafe(芙莉莲技能配置.Q.技能ID);
const W技能ID = stringToFourCCSafe(芙莉莲技能配置.W.技能ID);
const 隐匿BuffID = 芙莉莲Buff配置.魔力隐匿;
const 解析中BuffID = 芙莉莲Buff配置.解析中;
const 解析完成BuffID = 芙莉莲Buff配置.解析完成;
const 演算BuffID = 芙莉莲Buff配置.演算魔弹;
const 被动配置 = 芙莉莲被动配置;

const GetHandleId = jass.GetHandleId as (this: void, h: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

//=============================================================================
// A1：状态容器（按英雄句柄隔离；两名芙莉莲不共享目标或花田）
//=============================================================================

export type 解析类型 = "攻击" | "防御" | "位置";

export interface 芙莉莲英雄状态 {
  /** 状态所属芙莉莲句柄（死亡清理/特效键反查用） */
  芙莉莲: any;
  /** 隐匿：静默期满为 true；施法/普攻/受打断解除 */
  隐匿: boolean;
  /** 上次活动时刻（施法/普攻；静默计时基准） */
  最后活动时间: number;
  /** 唯一重点解析目标 */
  重点目标: any;
  /** 三类解析的到期时间戳（0 = 无） */
  解析到期: { 攻击: number; 防御: number; 位置: number };
  /** 解析完成（两种不同解析后置位；Q/R 命中原子消费一次后清除全部） */
  解析完成: boolean;
  /** 待强化普攻（演算魔弹）到期时间戳 */
  演算普攻到期: number;
  /** 技能清理器（Q/W/E/R/D 登记；死亡/统一清理时执行） */
  技能清理表: Record<string, () => void>;
}

const 英雄状态表: Record<number, 芙莉莲英雄状态 | undefined> = {};

/** 花田判定接口（D 模块注入；默认无花田） */
export const 花田判定接口: {
  在花田内: (this: void, 英雄: any) => boolean;
  在花田内静止: (this: void, 英雄: any) => boolean;
} = {
  在花田内: function 默认无花田(this: void, _英雄: any): boolean {
    return false;
  },
  在花田内静止: function 默认无静止(this: void, _英雄: any): boolean {
    return false;
  },
};

export function 是芙莉莲(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && jass.GetUnitTypeId(unit) === 英雄单位类型ID;
}

function 取英雄状态(this: void, 英雄: any): 芙莉莲英雄状态 {
  const id = GetHandleId(英雄);
  let 状态 = 英雄状态表[id];
  if (状态 == null) {
    状态 = {
      芙莉莲: 英雄,
      隐匿: false,
      最后活动时间: getGameTime(),
      重点目标: null,
      解析到期: { 攻击: 0, 防御: 0, 位置: 0 },
      解析完成: false,
      演算普攻到期: 0,
      技能清理表: {},
    };
    英雄状态表[id] = 状态;
  }
  return 状态;
}

//=============================================================================
// 技能清理登记（Q/W/E/R/D 模块调用；死亡/统一清理统一执行，幂等）
//=============================================================================

export function 登记芙莉莲清理(this: void, 英雄: any, 名称: string, 清理: () => void): void {
  if (英雄 == null || 英雄 === 0) return;
  取英雄状态(英雄).技能清理表[名称] = 清理;
}

//=============================================================================
// 魔力隐匿
//=============================================================================

/** 施法/普攻活动：解除隐匿并重置静默计时（Q/W/E/R/D 释放与普攻监听调用） */
export function 记录芙莉莲活动(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  if (状态.隐匿) {
    debugLogForce("芙莉莲-被动", "Buff", "操作", "移除", "目标", 英雄, "BuffID", 隐匿BuffID);
    状态.隐匿 = false;
    移除单位指定Buff(英雄, 隐匿BuffID);
  }
  状态.最后活动时间 = getGameTime();
  // 重新安排静默期满回调（解除后重新计时）
  启动隐匿计时(英雄);
}

/** 重新安排隐匿计时（D 花田静止检测变化时调用；按当前静止倍率重算静默期满，幂等） */
export function 重新安排隐匿计时(this: void, 英雄: any): void {
  启动隐匿计时(英雄);
}

/** Q/R 释放时快照隐匿状态（快照后由 记录芙莉莲活动 解除；本函数不改变状态） */
export function 快照隐匿(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && 状态.隐匿;
}

// 隐匿检测采用"活动时安排一次性延迟回调"：静默期满且期间无新活动 → 进入隐匿；
// 花田内静止时静默需求时间按恢复倍率缩短（倍率在安排时点判定一次）。

const 隐匿计时回调表: Record<number, number | undefined> = {};

/** 活动/解除后安排"静默期满进入隐匿"的一次性回调（旧回调先取消） */
function 启动隐匿计时(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = GetHandleId(英雄);
  const 旧ID = 隐匿计时回调表[id];
  if (旧ID != null) removeDelayedCallbackSafe(旧ID);
  const 状态 = 取英雄状态(英雄);
  // 花田内静止时恢复倍率由 D 模块通过 花田判定接口 提供；此处按当前位置判定一次
  const 静止倍率 = 花田判定接口.在花田内静止(英雄) ? 被动配置.花田隐匿恢复倍率 : 1;
  const 需要毫秒 = (被动配置.隐匿静默秒 / (静止倍率 > 0 ? 静止倍率 : 1)) * 1000;
  const 回调ID = addDelayedCallbackSafe(需要毫秒, function 进入隐匿(this: void): void {
    隐匿计时回调表[id] = undefined;
    const s = 英雄状态表[id];
    if (s == null || s.隐匿) return;
    if (!单位存活(英雄)) return;
    // 期间无新活动（最后活动时间未变）才进入隐匿
    if (getGameTime() - s.最后活动时间 < 被动配置.隐匿静默秒 / (静止倍率 > 0 ? 静止倍率 : 1) - 0.05) return;
    debugLogForce("芙莉莲-被动", "状态", "进入隐匿", "英雄", 英雄);
    s.隐匿 = true;
    debugLogForce("芙莉莲-被动", "Buff", "操作", "施加", "目标", 英雄, "BuffID", 隐匿BuffID);
    registerManualBuff(英雄, 隐匿BuffID, 9999, 1, { stack: 1 });
  });
  隐匿计时回调表[id] = 回调ID;
  void 状态;
}

// 延迟回调安全封装（避免直接依赖两个计时器导出名）
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
function addDelayedCallbackSafe(this: void, delayMs: number, callback: (this: void) => void): number {
  return addDelayedCallback(delayMs, callback);
}
function removeDelayedCallbackSafe(this: void, id: number): void {
  removeDelayedCallback(id);
}

//=============================================================================
// 长期解析
//=============================================================================

/** 解析标记特效键（挂重点目标；目标切换/清理销毁） */
function 解析标记键(this: void, 芙莉莲: any): string {
  return "芙莉莲解析标记-" + GetHandleId(芙莉莲);
}

/** 清理指定芙莉莲的重点目标解析（标记/Buff/完成状态；不触碰技能清理器） */
function 清理重点目标解析(this: void, 芙莉莲: any, 状态: 芙莉莲英雄状态): void {
  if (状态.重点目标 != null && 状态.重点目标 !== 0) {
    debugLogForce("芙莉莲-被动", "特效", "类型", "销毁", "路径", 芙莉莲表现配置.解析标记.模型路径);
    销毁单位坐标跟随特效(状态.重点目标, 解析标记键(芙莉莲));
    debugLogForce("芙莉莲-被动", "Buff", "操作", "移除", "目标", 状态.重点目标, "BuffID", 解析中BuffID);
    移除单位指定Buff(状态.重点目标, 解析中BuffID);
    debugLogForce("芙莉莲-被动", "Buff", "操作", "移除", "目标", 状态.重点目标, "BuffID", 解析完成BuffID);
    移除单位指定Buff(状态.重点目标, 解析完成BuffID);
  }
  状态.重点目标 = null;
  状态.解析到期 = { 攻击: 0, 防御: 0, 位置: 0 };
  状态.解析完成 = false;
}

/**
 * 施加解析：新重点目标先清理旧目标（解析/Buff/标记）；相同类型只刷新；
 * 两种不同解析记录后进入解析完成（Buff + 完成特效一次）。
 */
export function 施加解析(this: void, 芙莉莲: any, 目标: any, 类型: 解析类型): void {
  if (芙莉莲 == null || 芙莉莲 === 0) return;
  if (目标 == null || 目标 === 0 || !单位存活(目标)) return;
  const 状态 = 取英雄状态(芙莉莲);
  // 重点目标唯一：切换时完整清理旧目标
  if (状态.重点目标 != null && 状态.重点目标 !== 0 && 状态.重点目标 !== 目标) {
    清理重点目标解析(芙莉莲, 状态);
  }
  状态.重点目标 = 目标;
  const 到期 = getGameTime() + 被动配置.解析持续秒;
  const 现在 = getGameTime();
  // 单目标最多维护两种解析（制作规划）：已有两种未到期解析且新类型未持有 → 忽略本次施加（刷新已持有类型仍允许）
  const 已有类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  if (已有类型数 >= 2 && !(状态.解析到期[类型] > 现在)) return;
  状态.解析到期[类型] = 到期;
  // 相同类型刷新；不同类型累加（最多两种不同即完成）；已过期解析不计入（惰性）
  const 有效类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  // 解析完成状态同步为惰性判定（两种未到期解析即完成；到期自动失效）
  状态.解析完成 = 有效类型数 >= 2;
  if (状态.解析完成) {
    debugLogForce("芙莉莲-被动", "Buff", "操作", "施加", "目标", 目标, "BuffID", 解析完成BuffID);
    registerManualBuff(目标, 解析完成BuffID, 被动配置.解析持续秒, 1, { stack: 1 });
    // 解析完成特效一次（复用 CeliaFormulaLockCore；参数配置驱动）
    debugLogForce("芙莉莲-被动", "特效", "类型", "创建", "路径", 芙莉莲表现配置.解析完成.模型路径);
    创建点特效({
      模型路径: 芙莉莲表现配置.解析完成.模型路径,
      RGB: 芙莉莲表现配置.解析完成.RGB,
          X: GetUnitX(目标),
      Y: GetUnitY(目标),
      Z: 芙莉莲表现配置.解析完成.高度,
      缩放: 芙莉莲表现配置.解析完成.缩放,
      持续秒: 芙莉莲表现配置.解析完成.持续秒,
    });
  } else {
    // 解析中标记 Buff（刷新；解析完成时不叠加中标记）
    if (有效类型数 >= 1) {
      debugLogForce("芙莉莲-被动", "Buff", "操作", "施加", "目标", 目标, "BuffID", 解析中BuffID);
      registerManualBuff(目标, 解析中BuffID, 被动配置.解析持续秒, 有效类型数, { stack: 有效类型数 });
    }
  }
  // 解析标记特效（常驻句柄，键管理；已存在时同键覆盖；缩放/高度 经 创建单位坐标跟随特效 配置驱动）
  if (有效类型数 >= 1) {
    debugLogForce("芙莉莲-被动", "特效", "类型", "创建", "路径", 芙莉莲表现配置.解析标记.模型路径);
    const 标记 = 创建单位坐标跟随特效(
      目标,
      芙莉莲表现配置.解析标记.模型路径,
      解析标记键(芙莉莲),
      芙莉莲表现配置.解析标记.缩放,
      芙莉莲表现配置.解析标记.高度,
      undefined,
      芙莉莲表现配置.解析标记.动画索引,
      芙莉莲表现配置.解析标记.面向角度,
      芙莉莲表现配置.解析标记.RGB,
    );
    void 标记;
  }
}

/** 取当前重点解析目标（R 的 t0 解析快照用；无则 null） */
export function 取芙莉莲重点目标(this: void, 芙莉莲: any): any {
  if (芙莉莲 == null || 芙莉莲 === 0) return null;
  const 状态 = 英雄状态表[GetHandleId(芙莉莲)];
  if (状态 == null || 状态.重点目标 == null || 状态.重点目标 === 0) return null;
  if (!单位存活(状态.重点目标)) return null;
  // 无任何有效解析（未到期）时不作为重点目标
  const 现在 = getGameTime();
  const 有效类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  if (有效类型数 <= 0) return null;
  return 状态.重点目标;
}

/** 目标是否持有指定解析（重点目标匹配且未到期） */
export function 有解析(this: void, 芙莉莲: any, 目标: any, 类型: 解析类型): boolean {
  if (芙莉莲 == null || 目标 == null || 目标 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(芙莉莲)];
  if (状态 == null || 状态.重点目标 == null || 状态.重点目标 !== 目标) return false;
  return 状态.解析到期[类型] > getGameTime();
}

/** 目标是否解析完成（重点目标匹配 + 两种未到期解析；惰性，到期自动失效） */
export function 目标解析完成(this: void, 芙莉莲: any, 目标: any): boolean {
  if (芙莉莲 == null || 目标 == null || 目标 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(芙莉莲)];
  if (状态 == null || 状态.重点目标 !== 目标) return false;
  const 现在 = getGameTime();
  const 有效类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  return 有效类型数 >= 2;
}

/**
 * 原子消费解析完成（仅合法 Q/R 调用）：目标匹配且完成 → 清除该目标全部解析与完成状态。
 * 返回 true = 消费成功（调用方执行破防/穿透强化）。
 */
export function 尝试消费解析完成(this: void, 芙莉莲: any, 目标: any): boolean {
  if (芙莉莲 == null || 目标 == null || 目标 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(芙莉莲)];
  if (状态 == null || 状态.重点目标 !== 目标) return false;
  const 现在 = getGameTime();
  const 有效类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  if (有效类型数 < 2) return false;
  清理重点目标解析(芙莉莲, 状态);
  return true;
}

//=============================================================================
// A2：演算普攻（Q/W/E 成功提供；真实普攻命中解析目标追加收益）
//=============================================================================

/** Q/W/E 真正成功后提供一次待强化普攻（演算魔弹窗口） */
export function 提供演算普攻(this: void, 芙莉莲: any): void {
  if (芙莉莲 == null || 芙莉莲 === 0) return;
  const 状态 = 取英雄状态(芙莉莲);
  状态.演算普攻到期 = getGameTime() + 被动配置.演算普攻窗口秒;
  debugLogForce("芙莉莲-被动", "Buff", "操作", "施加", "目标", 芙莉莲, "BuffID", 演算BuffID);
  registerManualBuff(芙莉莲, 演算BuffID, 被动配置.演算普攻窗口秒, 1, { stack: 1 });
}

/** 减少指定技能当前冷却（演算魔弹命中反馈） */
function 减少技能冷却(this: void, 英雄: any, 技能代码: number, 减少秒: number): void {
  const 当前 = platformAbilityApi.技能_获取技能当前冷却时间(英雄, 技能代码);
  if (当前 <= 0) return;
  const 剩余 = 当前 - 减少秒;
  const 新冷却 = 剩余 > 0 ? 剩余 : 0;
  const 最大冷却 = platformAbilityApi.技能_获取技能最大冷却时间(英雄, 技能代码);
  platformAbilityAction.技能_设置技能冷却时间(英雄, 技能代码, 新冷却, 最大冷却);
}

function 处理芙莉莲普攻(this: void, target: any, attacker: any, appliedDamage: number, snapshot: any): void {
  // 只处理芙莉莲真实普通攻击（技能伤害/包装伤害不递归触发）
  if (!是芙莉莲(attacker)) return;
  if (snapshot == null) return;
  if (snapshot.isNormalAttack !== true) return;
  if (snapshot.isWrappedSkillDamage === true) return;
  if (snapshot.originalAttacker != null && snapshot.originalAttacker !== attacker) return;
  // 普攻也是隐匿活动（记录芙莉莲活动 内部会重新安排隐匿计时）
  记录芙莉莲活动(attacker);
  // 演算魔弹：窗口有效 + 命中重点目标（有解析）才追加
  const 状态 = 英雄状态表[GetHandleId(attacker)];
  if (状态 == null || 状态.演算普攻到期 <= getGameTime()) return;
  if (状态.重点目标 == null || 状态.重点目标 !== target) return;
  const 现在 = getGameTime();
  const 有效类型数 =
    (状态.解析到期.攻击 > 现在 ? 1 : 0) +
    (状态.解析到期.防御 > 现在 ? 1 : 0) +
    (状态.解析到期.位置 > 现在 ? 1 : 0);
  if (有效类型数 <= 0) return;
  // 消费窗口（一次）
  状态.演算普攻到期 = 0;
  移除单位指定Buff(attacker, 演算BuffID);
  // 追加小伤害（归属芙莉莲；两种未到期解析（解析完成）用更高倍率，但不清除解析完成——只有 Q/R 能消费）
  const 倍率 = 有效类型数 >= 2 ? 被动配置.演算完成目标倍率 : 被动配置.演算伤害倍率;
  造成技能伤害({
    来源: attacker,
    目标: target,
    伤害: appliedDamage * 倍率,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 英雄单位类型ID,
    标签: "芙莉莲-演算魔弹",
    伤害形态: "单体",
    参与技能伤害加成: false,
  });
  // 冷却反馈：Q/W 各减少少量冷却
  减少技能冷却(attacker, Q技能ID, 被动配置.演算冷却缩减秒);
  减少技能冷却(attacker, W技能ID, 被动配置.演算冷却缩减秒);
}

//=============================================================================
// 统一清理（幂等；覆盖死亡、复活重置、重复初始化与场景清理）
//=============================================================================

export function 清理芙莉莲状态(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = GetHandleId(英雄);
  const 状态 = 英雄状态表[id];
  if (状态 == null) return;
  // 隐匿计时回调
  const 计时ID = 隐匿计时回调表[id];
  if (计时ID != null) removeDelayedCallback(计时ID);
  隐匿计时回调表[id] = undefined;
  // 重点目标解析
  清理重点目标解析(英雄, 状态);
  // 自身 Buff
  移除单位指定Buff(英雄, 隐匿BuffID);
  移除单位指定Buff(英雄, 演算BuffID);
  // 技能清理器
  for (const key in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[key];
    if (清理 != null) 清理();
  }
  delete 英雄状态表[id];
}

//=============================================================================
// 注册入口（幂等；index 调用）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲被动(this: void): void {
  debugLogForce("芙莉莲-被动", "注册", "名称", "注册芙莉莲被动");
  if (已注册) return;
  已注册 = true;
  // 死亡清理：芙莉莲死亡清自身状态；目标死亡清对应解析
  registerDeathListener(function 芙莉莲死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    if (是芙莉莲(dyingUnit)) {
      清理芙莉莲状态(dyingUnit);
      return;
    }
    // 目标死亡：所有以其为重点目标的芙莉莲清理解析（芙莉莲参数用状态保存的句柄，保证特效键正确）
    for (const id in 英雄状态表) {
      const 状态 = 英雄状态表[id];
      if (状态 == null || 状态.重点目标 == null) continue;
      if (状态.重点目标 === dyingUnit || 取单位ID(状态.重点目标) === 取单位ID(dyingUnit)) {
        if (状态.芙莉莲 != null) 清理重点目标解析(状态.芙莉莲, 状态);
      }
    }
  });
  // 英雄注册：立即进入静默计时起点
  registerPlayerHeroListener(function 芙莉莲英雄注册(this: void, _player: any, hero: any): void {
    if (是芙莉莲(hero)) {
      取英雄状态(hero);
      启动隐匿计时(hero);
    }
  });
  registerAppliedFinalDamageListener(处理芙莉莲普攻);
}

export const 芙莉莲被动模块 = {
  英雄ID: 芙莉莲技能配置.单位类型ID,
  注册: 注册芙莉莲被动,
} as const;
