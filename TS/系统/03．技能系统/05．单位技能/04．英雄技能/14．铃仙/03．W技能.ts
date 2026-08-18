/** @noSelfInFile */

/**
 * 铃仙 - W 幻波“赤眼催眠”（A0GI）
 *
 * 源 JASS：`铃仙.j` 的 ReisenW 分支。
 * - 施法：ArcaneBurst.mdx 特效（缩放 2 / 高度 125 / 持续 2s）+ LX_W2 音效
 * - 创建 5 个分身（15% 输出 / 400% 承伤，持续秒按等级 2~4s）
 * - 中心分身（第 5 个）置于原位 1 秒后消失；其余 4 个分布 300 码圆周、面朝圆心
 * - 分身全部创建后隐藏本体
 * - 玩家选中一个分身：铃仙传送到分身位置出现，分身带消失特效后移除
 * - 分身全灭或超时（2s）未选择：铃仙原地出现
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙全局音效, 播放铃仙单位绑定音效 } from "./00A．表现工具";
import {
  是铃仙本体,
  是铃仙分身,
  注册铃仙英雄,
  加入铃仙分身,
  移除铃仙分身,
  获取铃仙分身组,
  铃仙分身数量,
  是有效敌对目标,
} from "./00B．分身与状态管理";

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 注册召唤监听 } = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心") as {
  注册召唤监听: (this: void, 回调: (被召唤单位: any, 召唤单位: any) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addSelectionListener } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener: (this: void, callback: (this: void, player: any, playerId: number, unit: any, isSelected: boolean) => void) => void;
};
const { SFB_setItemIllusion } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setItemIllusion: (this: void, sourceUnit: any, u: any, time?: number, 输出倍率?: number, 承伤倍率?: number) => boolean;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { SetUnitVertexColorBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitVertexColorBJ: (this: void, unit: any, red: number, green: number, blue: number, transparency: number) => void;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const W技能ID = stringToFourCCSafe(铃仙单位技能配置.W技能ID);

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, flag: boolean) => void;
const KillUnit = jass.KillUnit as (this: void, unit: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (this: void, modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

/** 单次 W 施法会话（key = 英雄 handle id），保证同一英雄同时只有一场 W */
interface 铃仙W会话 {
  英雄: any;
  原X: number;
  原Y: number;
  原朝向: number;
  /** 是否已经“出现”（本体恢复），只允许一次 */
  是否出现: boolean;
  /** 累计召唤角度（每分身 +90，第 5 个 ≥450 为中心分身） */
  角度: number;
  /** 超时恢复计时器 ID（0 表示未注册） */
  超时计时器ID: number;
}

const 铃仙W会话表: Record<number, 铃仙W会话 | undefined> = {};

/** 当前正在创建分身的铃仙（SFB 马甲回调中无法从召唤单位获取本体，用此变量桥接） */
let 当前W铃仙: any | null = null;
/** 获取当前正在创建分身的铃仙句柄（供召唤回调使用，对应 JASS 触发器存储的铃仙引用） */
function 获取铃仙句柄(this: void, 被召唤单位: any): number | null {
  if (当前W铃仙 != null && 当前W铃仙 !== 0) {
    return GetHandleId(当前W铃仙);
  }
  return null;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD);
}

/** 在分身位置播一次性消失特效（源 JASS：Create+Destroy 特效） */
function 播放分身消失特效(this: void, 分身: any): void {
  if (分身 == null || 分身 === 0) return;
  const x = GetUnitX(分身);
  const y = GetUnitY(分身);
  const cfg = 铃仙单位技能配置.W;
  DestroyEffect(AddSpecialEffect(cfg.分身消失特效1, x, y));
  DestroyEffect(AddSpecialEffect(cfg.分身消失特效2, x, y));
}

/** 在未结束的 W 会话的分身组里查找单位所属会话（已出现/本体已死的会话跳过） */
function 查找单位所属会话(this: void, 单位: any): 铃仙W会话 | null {
  if (单位 == null || 单位 === 0) return null;
  for (const key in 铃仙W会话表) {
    const 会话 = 铃仙W会话表[key];
    if (会话 == null || 会话.是否出现) continue;
    if (!单位存活(会话.英雄)) continue;
    const 分身组 = 获取铃仙分身组(会话.英雄);
    for (let i = 0; i < 分身组.length; i++) {
      if (分身组[i] === 单位) return 会话;
    }
  }
  return null;
}

/** 执行“铃仙出现”的表现（ShowUnit + 传送 + 朝向 + 顶点色 + Whine 特效） */
function 执行铃仙出现表现(this: void, 英雄: any, 出现X: number, 出现Y: number, 朝向?: number): void {
  if (!单位存活(英雄)) return;
  const cfg = 铃仙单位技能配置.W;
  ShowUnit(英雄, true);
  SetUnitX(英雄, 出现X);
  SetUnitY(英雄, 出现Y);
  if (朝向 != null) SetUnitFacing(英雄, 朝向);
  SetUnitVertexColorBJ(英雄, cfg.出现顶点色红, cfg.出现顶点色绿, cfg.出现顶点色蓝, 0);
  createTimedUnitEffect(英雄, "origin", cfg.出现特效模型, 1);
  // 本体已出现，结束 W 替身状态
  移除单位指定Buff(英雄, 铃仙BuffID.W替身);
}

/** 结束会话：取消超时计时器、重新选中本体、从表中移除 */
function 完成会话(this: void, 会话: 铃仙W会话): void {
  if (会话 == null) return;
  if (会话.超时计时器ID !== 0) {
    removeDelayedCallback(会话.超时计时器ID);
    会话.超时计时器ID = 0;
  }
  if (单位存活(会话.英雄)) {
    SelectUnitForPlayerSingle(会话.英雄, GetOwningPlayer(会话.英雄));
  }
  铃仙W会话表[GetHandleId(会话.英雄)] = undefined;
}

/** 铃仙出现（统一入口，仅未出现时生效） */
function 铃仙出现(this: void, 会话: 铃仙W会话, 出现X: number, 出现Y: number, 朝向?: number): void {
  if (会话 == null || 会话.是否出现) return;
  会话.是否出现 = true;
  执行铃仙出现表现(会话.英雄, 出现X, 出现Y, 朝向);
  完成会话(会话);
}

/** 铃仙原地出现（全灭 / 超时路径，本体位置未变无需传送） */
function 铃仙原地出现(this: void, 会话: 铃仙W会话): void {
  if (会话 == null) return;
  铃仙出现(会话, 会话.原X, 会话.原Y);
}

/** 选中一个分身：铃仙传送到分身位置出现，分身带消失特效后移除 */
function 铃仙分身传送出现(this: void, 会话: 铃仙W会话, 分身: any): void {
  if (会话 == null || 会话.是否出现) return;
  if (!单位存活(会话.英雄)) return;
  const 分身X = GetUnitX(分身);
  const 分身Y = GetUnitY(分身);
  const 朝向 = GetUnitFacing(分身);
  // 先置位"已出现"，防止 KillUnit 触发的死亡事件走"全灭→原地出现"
  会话.是否出现 = true;
  const 分身组 = 获取铃仙分身组(会话.英雄);
  for (let i = 0; i < 分身组.length; i++) {
    播放分身消失特效(分身组[i]);
  }
  if (单位存活(分身)) KillUnit(分身);
  执行铃仙出现表现(会话.英雄, 分身X, 分身Y, 朝向);
  完成会话(会话);
}

//=============================================================================
// 召唤监听：捕获 W 创建的 5 个分身并布置
//=============================================================================

function on铃仙分身召唤(this: void, 被召唤单位: any, 召唤单位: any): void {
  if (被召唤单位 == null || 被召唤单位 === 0) return;
  if (!是铃仙分身(被召唤单位)) return;
  // 源 JASS：仅检查被召唤单位类型（E07R），召唤单位是 SFB 马甲，非铃仙本体
  const 铃仙句柄 = 获取铃仙句柄(被召唤单位);
  if (铃仙句柄 == null) return;
  const 会话 = 铃仙W会话表[铃仙句柄];
  if (会话 == null || 会话.是否出现) {
    return;
  }
  const cfg = 铃仙单位技能配置.W;
  加入铃仙分身(会话.英雄, 被召唤单位);
  会话.角度 += 90;
  if (会话.角度 >= 450) {
    // 第 5 个（中心分身）：隐藏本体、置于原位、1 秒后消失
    ShowUnit(会话.英雄, false);
    SetUnitX(被召唤单位, 会话.原X);
    SetUnitY(被召唤单位, 会话.原Y);
    SetUnitFacing(被召唤单位, 会话.原朝向);
    addDelayedCallback(cfg.中心分身消失秒 * 1000, () => {
      if (单位存活(被召唤单位)) KillUnit(被召唤单位);
    });
  } else {
    // 其余 4 个：300 码圆周分布，面朝圆心方向
    const 分身角度 = 会话.角度;
    const 分身X = 会话.原X + cfg.分身半径 * Math.cos((分身角度 * Math.PI) / 180);
    const 分身Y = 会话.原Y + cfg.分身半径 * Math.sin((分身角度 * Math.PI) / 180);
    SetUnitX(被召唤单位, 分身X);
    SetUnitY(被召唤单位, 分身Y);
    SetUnitFacing(被召唤单位, 分身角度);
  }
}

//=============================================================================
// 死亡监听：分身死亡从组移除；全灭且未出现 → 原地出现
//=============================================================================

function on分身死亡(this: void, 死亡单位: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;
  const 会话 = 查找单位所属会话(死亡单位);
  if (会话 == null) {
    return;
  }
  移除铃仙分身(会话.英雄, 死亡单位);
  const 剩余 = 铃仙分身数量(会话.英雄);
  if (剩余 <= 0) {
    铃仙原地出现(会话);
  }
}

//=============================================================================
// 选中监听：玩家选中一个分身 → 传送出现
//=============================================================================

function on玩家选中分身(this: void, 玩家: any, playerId: number, 单位: any, 是否选中: boolean): void {
  if (!是否选中) return;
  if (!是铃仙分身(单位)) return;
  const 会话 = 查找单位所属会话(单位);
  if (会话 == null || 会话.是否出现) return;
  if (单位 === 会话.英雄) return;
  // 归属校验：只处理属于该玩家的分身
  if (GetPlayerId(GetOwningPlayer(单位)) !== playerId) return;
  铃仙分身传送出现(会话, 单位);
}

//=============================================================================
// 施法入口
//=============================================================================

function on铃仙W生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (!是铃仙本体(施法单位)) return;
  if (技能ID数值 !== W技能ID) return;
  const 英雄 = 施法单位;
  const cfg = 铃仙单位技能配置.W;
  const id = GetHandleId(英雄);
  注册铃仙英雄(英雄);

  // 防御：若存在进行中的旧会话，先恢复本体（正常因 30s 冷却不会触发）
  const 旧会话 = 铃仙W会话表[id];
  if (旧会话 != null) {
    铃仙原地出现(旧会话);
  }

  const 等级 = GetUnitAbilityLevel(英雄, W技能ID);
  const 持续秒 = cfg.分身持续秒[等级 - 1] ?? cfg.分身持续秒[0];
  const 原X = GetUnitX(英雄);
  const 原Y = GetUnitY(英雄);
  const 原朝向 = GetUnitFacing(英雄);

  // 施法音效（源 JASS：PlaySoundOnUnitBJ(gg_snd_LX_W2, 100, 铃仙)）
  播放铃仙单位绑定音效(英雄, "gg_snd_LX_W2", 100);
  创建点特效({
    模型路径: cfg.施法特效模型,
    X: 原X,
    Y: 原Y,
    Z: cfg.施法特效高度,
    缩放: cfg.施法特效缩放,
    持续秒: cfg.施法特效持续秒,
  });

  // W 对视：350 码内没有『疯狂』的敌方存活单位 +1 秒对视时间（项目暂无疯狂系统，先登记状态）
  const 周围单位 = getUnitsInRange(原X, 原Y, 350);
  for (let i = 0; i < 周围单位.length; i++) {
    const 敌方 = 周围单位[i];
    if (!是有效敌对目标(英雄, 敌方)) continue;
    registerManualBuff(敌方, 铃仙BuffID.W对视, 1, 0);
  }

  // W 替身状态：本体隐藏、5 分身期间显示状态图标
  registerManualBuff(英雄, 铃仙BuffID.W替身, 持续秒, 0);

  // 建立会话（须在创建分身之前，供召唤监听捕获）
  const 会话: 铃仙W会话 = { 英雄, 原X, 原Y, 原朝向, 是否出现: false, 角度: 0, 超时计时器ID: 0 };
  铃仙W会话表[id] = 会话;

  当前W铃仙 = 英雄;
  // 创建 5 个分身（15% 输出 / 400% 承伤）
  let 创建成功数 = 0;
  for (let i = 0; i < 5; i++) {
    const ok = SFB_setItemIllusion(英雄, 英雄, 持续秒, cfg.分身输出倍率, cfg.分身承伤倍率);
    if (!ok) {
      break;
    }
    创建成功数 += 1;
  }
  当前W铃仙 = null;

  // 超时未选择 → 原地出现
  会话.超时计时器ID = addDelayedCallback(cfg.超时恢复秒 * 1000, () => {
    const current = 铃仙W会话表[id];
    if (current == null || current !== 会话) return;
    铃仙原地出现(current);
  });
}

registerSpellEffectListener(on铃仙W生效);
注册召唤监听(on铃仙分身召唤);
registerDeathListener(on分身死亡);
addSelectionListener(on玩家选中分身);

export {};
