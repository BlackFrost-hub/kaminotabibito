/** @noSelfInFile */

/**
 * 佐佐木小次郎 - 分身与状态管理
 *
 * 职责：
 * - 初始隐藏 Q/W 二段技能（A0GT/A0GR，玩家级可用性开关，模块加载时设置）
 * - 分身创建：复用 SFB_setItemIllusion（幻象物品技能），动态写入输出 10% / 承伤 400%
 * - 分身落地处理：召唤事件中心捕获幻象 → 去碰撞、入场暂停、动作 9 @1.2 倍速、按需传送与结算
 * - 瞬移冷却（单位级状态 + QWERD 被动冷却显示，创建分身时立即刷新）
 * - 「瞬移后」标记（右键换位后 1 秒内 Q 附加剑气）
 * - 普攻计数（7 次普通攻击在敌人身后创建分身，不含技能普攻）
 * - 扇形技能伤害结算（Q / W 共用）
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 播放佐佐木坐标音效, 播放佐佐木配置动作 } from "./00A．表现工具";
import { 佐佐木小次郎BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/11．佐佐木小次郎";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { SFB_setItemIllusion } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setItemIllusion: (this: void, sourceUnit: any, u: any, time?: number, 输出倍率?: number, 承伤倍率?: number) => boolean;
};
const { 注册召唤监听 } = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心") as {
  注册召唤监听: (this: void, 回调: (被召唤单位: any, 召唤单位: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, 来源: string) => boolean;
  移除单位暂停: (this: void, unit: any, 来源: string) => boolean;
};
const { X_SetUnitMovableSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_SetUnitMovableSafe: (this: void, unit: any, movable: boolean) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活, 两点角度, 角度差绝对值, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  角度差绝对值: (this: void, a: number, b: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 注册普攻攻击效果监听 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.21．攻击效果.02．攻击效果监听") as {
  注册普攻攻击效果监听: (this: void, 参数: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 登记被动技能冷却 } = require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示") as {
  登记被动技能冷却: (this: void, unit: any, abilityId: number, cooldownSec: number) => void;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 佐佐木单位类型ID = stringToFourCCSafe(佐佐木单位技能配置.单位类型ID);
const Q二段技能ID = stringToFourCCSafe(佐佐木单位技能配置.Q二段技能ID);
const W二段技能ID = stringToFourCCSafe(佐佐木单位技能配置.W二段技能ID);
const D被动技能ID = stringToFourCCSafe(佐佐木单位技能配置.D被动技能ID);
/** 幻象原生 Buff（分身判定标志） */
const 幻象BuffID = stringToFourCCSafe("BIil");

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const IsUnitIllusion = jass.IsUnitIllusion as (this: void, unit: any) => boolean;

//=============================================================================
// 一、初始隐藏 Q/W 二段技能（玩家级可用性，模块加载时对所有玩家生效）
//=============================================================================

for (let playerId = 0; playerId <= 15; playerId++) {
  SetPlayerAbilityAvailable(jass.Player(playerId), Q二段技能ID, false);
  SetPlayerAbilityAvailable(jass.Player(playerId), W二段技能ID, false);
}

//=============================================================================
// 二、通用工具
//=============================================================================

function 是有效伤害目标(this: void, 施法者: any, target: any): boolean {
  if (target == null || target === 0 || target === 施法者) return false;
  if (!单位存活(target)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_ANCIENT as any)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL as any)) return false;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_STRUCTURE as any)) return false;
  if (!isUnitEnemy(target, 施法者)) return false;
  return true;
}

/**
 * 扇形技能伤害结算（Q / W 共用）
 * 以（中心X, 中心Y）为圆心、半径 radius、面向 faceAngle ± 半角 的扇形内敌人结算一次技能伤害。
 */
export function 佐佐木扇形伤害(
  this: void,
  施法者: any,
  中心X: number,
  中心Y: number,
  面向角度: number,
  半径: number,
  半角: number,
  攻击倍率: number,
  技能ID: number,
  标签: string,
  命中特效模型: string,
  命中特效缩放: number,
  硬直秒: number,
): void {
  const 伤害值 = 读取单位攻击力(施法者) * 攻击倍率;
  const targets = getUnitsInRange(中心X, 中心Y, 半径);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!是有效伤害目标(施法者, target)) continue;
    const 指向目标角度 = 两点角度(中心X, 中心Y, GetUnitX(target), GetUnitY(target));
    if (角度差绝对值(指向目标角度, 面向角度) > 半角) continue;

    if (硬直秒 > 0) {
      const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
        SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
      };
      SFB_施加通用Buff(施法者, target, 21, 硬直秒);
    }
    if (命中特效模型 !== "") {
      创建点特效({
        模型路径: 命中特效模型,
        X: GetUnitX(target),
        Y: GetUnitY(target),
        面向角度: 面向角度,
        缩放: 命中特效缩放,
        持续秒: 1,
      });
    }
    造成技能伤害({
      来源: 施法者,
      目标: target,
      伤害: 伤害值,
      伤害类型: DAMAGE_TYPE_NORMAL,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID,
      标签,
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
  }
}

//=============================================================================
// 三、瞬移冷却（内部状态 + QWERD 显示）与「瞬移后」标记
//=============================================================================

interface 瞬移冷却记录 {
  英雄: any;
  冷却中: boolean;
  计时器ID: number;
}

const 瞬移冷却表: Record<number, 瞬移冷却记录 | undefined> = {};
const 分身入场暂停来源 = "佐佐木分身入场";

/** 是否是佐佐木小次郎本体 */
export function 是佐佐木本体(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 佐佐木单位类型ID;
}

//=============================================================================
// 三A、玩家 → 佐佐木本体注册表（右键换位时由指令单位所属玩家反查本体）
//=============================================================================

const 佐佐木英雄表: Record<number, any> = {};
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;

export function 注册佐佐木英雄(this: void, 英雄: any): void {
  if (!是佐佐木本体(英雄)) return;
  佐佐木英雄表[GetPlayerId(GetOwningPlayer(英雄))] = 英雄;
}

export function 获取玩家佐佐木英雄(this: void, player: any): any {
  if (player == null || player === 0) return null;
  const hero = 佐佐木英雄表[GetPlayerId(player)];
  if (hero == null || hero === 0 || !单位存活(hero)) return null;
  return hero;
}

/** 右键换位后 1 秒内为 true（Q 附加剑气窗口） */
const 瞬移后表: Record<number, boolean | undefined> = {};

export function 获取瞬移后标记(this: void, 英雄: any): boolean {
  return 瞬移后表[GetHandleId(英雄)] === true;
}

export function 消耗瞬移后标记(this: void, 英雄: any): boolean {
  const id = GetHandleId(英雄);
  if (瞬移后表[id] !== true) return false;
  瞬移后表[id] = false;
  return true;
}

export function 设置瞬移后标记(this: void, 英雄: any): void {
  const id = GetHandleId(英雄);
  瞬移后表[id] = true;
  registerManualBuff(英雄, 佐佐木小次郎BuffID.无心视野, 佐佐木单位技能配置.D.瞬移后窗口秒, 0);
  addDelayedCallback(佐佐木单位技能配置.D.瞬移后窗口秒 * 1000, () => {
    瞬移后表[id] = false;
    移除单位指定Buff(英雄, 佐佐木小次郎BuffID.无心视野);
  });
}

/** 瞬移是否就绪（冷却结束或被分身创建刷新） */
export function 瞬移是否就绪(this: void, 英雄: any): boolean {
  const record = 瞬移冷却表[GetHandleId(英雄)];
  return record == null || record.冷却中 !== true;
}

/** 结束内部瞬移冷却，并清除 D 被动图标上的模拟冷却显示。 */
function 结束瞬移冷却(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = GetHandleId(英雄);
  const record = 瞬移冷却表[id];
  if (record != null) {
    record.冷却中 = false;
    record.计时器ID = 0;
  }
  登记被动技能冷却(英雄, D被动技能ID, 0);
}

/** 启用 3 秒内部瞬移冷却，并在常驻 A0GW 被动图标上显示倒计时。 */
export function 启用瞬移冷却(this: void, 英雄: any): void {
  const id = GetHandleId(英雄);
  let record = 瞬移冷却表[id];
  if (record == null || record.英雄 !== 英雄) {
    record = { 英雄, 冷却中: false, 计时器ID: 0 };
    瞬移冷却表[id] = record;
  }
  if (record.计时器ID !== 0) removeDelayedCallback(record.计时器ID);

  record.冷却中 = true;
  登记被动技能冷却(英雄, D被动技能ID, 佐佐木单位技能配置.D.瞬移冷却秒);
  record.计时器ID = addDelayedCallback(佐佐木单位技能配置.D.瞬移冷却秒 * 1000, () => {
    const current = 瞬移冷却表[id];
    if (current == null) return;
    current.计时器ID = 0;
    结束瞬移冷却(current.英雄);
    瞬移冷却表[id] = undefined;
  });
}

/**
 * 刷新瞬移就绪（Q/W 施法与创建分身时调用）：
 * 保留源 JASS 的立即刷新语义，但只清内部状态和 QWERD 模拟冷却。
 */
export function 刷新瞬移就绪(this: void, 英雄: any): void {
  const id = GetHandleId(英雄);
  const record = 瞬移冷却表[id];
  if (record != null && record.计时器ID !== 0) {
    removeDelayedCallback(record.计时器ID);
    record.计时器ID = 0;
  }
  if (record != null) record.冷却中 = false;
  登记被动技能冷却(英雄, D被动技能ID, 0);
}

//=============================================================================
// 四、分身创建与召唤落地处理
//=============================================================================

interface 分身待落地记录 {
  英雄: any;
  落点X: number;
  落点Y: number;
  朝向: number;
  /** "W落地"：传送到原位并结算扇形伤害；"原地"：留在创建处；"身后"：传送到敌人身后 */
  行为: "W落地" | "原地" | "身后";
  技能ID: number;
}

const 分身待落地表: Record<number, 分身待落地记录 | undefined> = {};

/** 当前正在创建分身的佐佐木本体（SFB 幻象召唤事件的召唤单位是全局马甲，无法从召唤单位反推本体） */
let 当前创建分身的英雄: any = null;

function 分身入场处理(this: void, 分身: any, 记录: 分身待落地记录): void {
  // 所有佐佐木分身都锁定转向窗口；直接 SetUnitX/SetUnitY 仍可用于技能位移。
  X_SetUnitMovableSafe(分身, false);
  // 去碰撞（几乎不可移动 + 不阻挡）
  if (typeof japi.EXSetUnitCollisionType === "function") {
    japi.EXSetUnitCollisionType(false, 分身, 1);
  }
  添加单位暂停(分身, 分身入场暂停来源);

  // 统一传送到落点（SFB 幻象默认创建在全局马甲位置，并非本体位置，必须手动定位到起点/落点）。
  // Q「原地」= 起点、W「W落地」= 原点、普攻「身后」= 敌人身后；先让分身出现在起点，本体随后才位移。
  SetUnitX(分身, 记录.落点X);
  SetUnitY(分身, 记录.落点Y);
  播放佐佐木配置动作(分身, 9, 1.2);

  if (记录.行为 === "W落地") {
    const cfg = 佐佐木单位技能配置.W;
    佐佐木扇形伤害(
      记录.英雄,
      GetUnitX(分身),
      GetUnitY(分身),
      记录.朝向,
      cfg.命中范围,
      cfg.扇形半角,
      cfg.攻击力倍率,
      记录.技能ID,
      "佐佐木小次郎-后撤斩",
      cfg.命中特效模型,
      cfg.命中特效缩放,
      0,
    );
    const { 播放佐佐木单位音效 } = require("./00A．表现工具") as {
      播放佐佐木单位音效: (this: void, unit: any, path: string, cutoff: number) => void;
    };
    播放佐佐木单位音效(分身, cfg.分身命中音效路径, cfg.分身命中音效裁断);
  }

  addDelayedCallback(1000, () => {
    if (分身 == null || 分身 === 0) return;
    jass.SetUnitTimeScale(分身, 1.0);
    移除单位暂停(分身, 分身入场暂停来源);
  });
}

function on佐佐木分身召唤(this: void, 被召唤单位: any, 召唤单位: any): void {
  if (被召唤单位 == null || 被召唤单位 === 0) return;
  const 是幻象 = IsUnitIllusion(被召唤单位);
  const 类型匹配 = GetUnitTypeId(被召唤单位) === 佐佐木单位类型ID;
  if (!是幻象) return;
  if (!类型匹配) return;
  const 英雄 = 当前创建分身的英雄;
  if (英雄 == null || 英雄 === 0) return;
  if (!是佐佐木本体(英雄)) return;

  const id = GetHandleId(英雄);
  const 记录 = 分身待落地表[id];
  if (记录 == null) return;
  分身待落地表[id] = undefined;
  分身入场处理(被召唤单位, 记录);
}

注册召唤监听(on佐佐木分身召唤);

/**
 * 创建佐佐木分身（输出 10% 攻击 / 承伤 400%，持续 3 秒）
 * 行为决定分身落点与是否结算落地伤害。
 */
export function 创建佐佐木分身(
  this: void,
  英雄: any,
  落点X: number,
  落点Y: number,
  朝向: number,
  行为: "W落地" | "原地" | "身后",
  技能ID: number,
): boolean {
  const cfg = 佐佐木单位技能配置.D;
  注册佐佐木英雄(英雄);
  const id = GetHandleId(英雄);
  分身待落地表[id] = { 英雄, 落点X, 落点Y, 朝向, 行为, 技能ID };

  // 记录当前创建分身的本体，供召唤事件回调反查（SFB 召唤单位是全局马甲）
  当前创建分身的英雄 = 英雄;
  const ok = SFB_setItemIllusion(英雄, 英雄, cfg.分身持续秒, cfg.分身输出倍率, cfg.分身承伤倍率);
  当前创建分身的英雄 = null;
  if (!ok) {
    分身待落地表[id] = undefined;
    return false;
  }

  // 兜底：1.5 秒后仍未捕获召唤则清空待落地记录，避免污染下一次创建
  addDelayedCallback(1500, () => {
    if (分身待落地表[id] != null) 分身待落地表[id] = undefined;
  });

  // 每次主动技能创建分身时立即刷新瞬移冷却
  刷新瞬移就绪(英雄);
  播放佐佐木坐标音效(佐佐木单位技能配置.Q.创建分身音效路径, GetUnitX(英雄), GetUnitY(英雄), 佐佐木单位技能配置.Q.创建分身音效裁断);
  return true;
}

/** 分身判定：目标是否为佐佐木的可换位分身（幻象 Buff + 同类型 + 存活） */
export function 是佐佐木分身(this: void, 英雄: any, 目标: any): boolean {
  if (目标 == null || 目标 === 0 || 目标 === 英雄) return false;
  if (!单位存活(目标)) return false;
  if (!IsUnitIllusion(目标)) return false;
  if (GetUnitTypeId(目标) !== 佐佐木单位类型ID) return false;
  const { 单位拥有原生Buff } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
    单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  };
  return 单位拥有原生Buff(目标, 幻象BuffID);
}

//=============================================================================
// 五、普攻计数（7 次普通攻击在敌人身后创建分身，不含技能普攻）
//=============================================================================

const 普攻计数表: Record<number, number | undefined> = {};

function on佐佐木普攻命中(this: void, ctx: any): void {
  const source = ctx?.source;
  if (!是佐佐木本体(source)) return;
  if (!单位存活(source)) return;
  const target = ctx?.target;
  if (target == null || target === 0) return;

  const id = GetHandleId(source);
  注册佐佐木英雄(source);
  const count = (普攻计数表[id] ?? 0) + 1;
  if (count < 佐佐木单位技能配置.D.普攻创建分身次数) {
    普攻计数表[id] = count;
    return;
  }
  普攻计数表[id] = 0;

  // 在敌人身后创建分身
  const cfg = 佐佐木单位技能配置.D;
  const 指向角度 = 两点角度(GetUnitX(source), GetUnitY(source), GetUnitX(target), GetUnitY(target));
  const 身后X = 极坐标X(GetUnitX(target), 指向角度, cfg.普攻分身后方距离);
  const 身后Y = 极坐标Y(GetUnitY(target), 指向角度, cfg.普攻分身后方距离);
  创建佐佐木分身(source, 身后X, 身后Y, 指向角度, "身后", D被动技能ID);
}

注册普攻攻击效果监听({
  名称: "佐佐木小次郎-普攻计数",
  条件: (ctx: any) => 是佐佐木本体(ctx?.source),
  命中后: on佐佐木普攻命中,
});

export {};
