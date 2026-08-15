/** @noSelfInFile */

/**
 * 阿伦劳特 - R：天堂呼唤 / 裁决审判（A0D5）+ R2 裁决冲击（A0D2）
 *
 * 源 JASS：JASS\部分地图编辑器GUI的英雄jass代码\阿劳伦特\主要技能.j 的 A0D5/A0D2 分支。
 * 最终口径以技能介绍图片为准（阿劳伦特迁移计划 3.5 / 4）：
 * - 光形态天堂呼唤：祈祷约 3 秒（0.42 周期 × 7），期间友军周期恢复攻击力 × 50% 并解除不利状态；
 *   完成后 6 秒内攻击力增幅到 300%、受到魔法伤害降低 30%（B018），结束清空魔法并减速 20% / 3 秒。
 * - 暗形态裁决审判：1000 范围抽取当前生命 7%（源另附加固定 10 点强化伤害，保留），
 *   弹道回血后获得 B015 6 秒，开放 A0D2 裁决冲击；结束清空魔法并减速 20% / 3 秒。
 * - R2 裁决冲击：仅持有 B015 时可施放；血墙特效 + 直线弹幕推进，目标首次命中结算
 *   自身当前生命 × 100% + 目标已损失生命 × 20% 强化伤害、眩晕 3 秒、击退 1000（图片口径）。
 */

import { 阿伦劳特单位技能配置 } from "./00．配置";
import {
  是阿伦劳特英雄,
  是光形态,
  是暗形态,
  是有效目标,
  拥有裁决审判,
  拥有天堂呼唤,
  添加原生Buff持续,
  移除原生Buff,
  两点角度,
  两点距离,
} from "./00B．形态与状态管理";

import { 阿伦劳特BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/13．阿伦劳特";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 施加减速, 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, ratio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 临时调整攻击, 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
  调整玩家属性: (this: void, unit: any, 属性名: string, 增量: number) => void;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

const R技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.R技能ID);
const R二段技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.R二段技能ID);
const 天堂呼唤强化BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.天堂呼唤强化BuffID);
const 裁决审判强化BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.裁决审判强化BuffID);

const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const SetUnitManaPercentBJ = jass.SetUnitManaPercentBJ as (this: void, unit: any, percent: number) => void;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, timeScale: number) => void;
const EXSetEffectXY = (japi as any).EXSetEffectXY as ((this: void, effect: any, x: number, y: number) => void) | undefined;

const 角度转弧度 = Math.PI / 180;

// =============================================================================
// 运行时上下文（光/暗 R 状态、重复施放与死亡清理）
// =============================================================================

type R技能类型 = "光祈祷" | "光强化" | "暗汲取" | "暗强化" | "R2";

interface R技能上下文 {
  施法者: any;
  类型: R技能类型;
  周期回调ID: number;
  强化回调ID: number;
  已结束: boolean;
  /** 光强化期间攻击力增量（SGSS 为累加语义，用于到期精确还原） */
  光加攻值: number;
  /** 光强化期间是否已应用"技能伤害减少"属性（避免未应用时误还原） */
  光减伤已应用: boolean;
}

const R技能上下文表: Record<number, R技能上下文 | undefined> = {};

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取R技能上下文(this: void, unit: any): R技能上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  return unitId === 0 ? undefined : R技能上下文表[unitId];
}

/** 每次施放都新建独立上下文（覆盖旧引用），旧回调通过“表引用一致”判定自身已过期。 */
function 创建R技能上下文(this: void, unit: any, type: R技能类型): R技能上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const created: R技能上下文 = {
    施法者: unit,
    类型: type,
    周期回调ID: 0,
    强化回调ID: 0,
    已结束: false,
    光加攻值: 0,
    光减伤已应用: false,
  };
  R技能上下文表[unitId] = created;
  return created;
}

function 停止R技能周期(this: void, ctx: R技能上下文): void {
  if (ctx.周期回调ID !== 0) {
    removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
  }
}

/** 让单位恢复正常动作/时间缩放（源 JASS 的 PauseUnit false + SetUnitTimeScale 1.00）。 */
function 恢复施法者动作(this: void, 施法者: any): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  PauseUnit(施法者, false);
  SetUnitTimeScale(施法者, 1);
}

/** 结束减速：20% 移动/攻击速度减慢，持续 3 秒（源 JASS 结束均施加减速）。 */
function 施加结束减速(this: void, 施法者: any): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  const cfg = 阿伦劳特单位技能配置.R;
  施加减速(施法者, 施法者, cfg.结束减速比例, cfg.结束减速持续秒, "阿伦劳特-R-结束减速", "技能");
}

/**
 * 统一清理：停止周期、取消强化延迟、若仍是当前上下文则移除表引用，再执行形态结束还原。
 * 幂等（已结束直接返回），防止 6 秒到期回调与监视器 / 重复施放 / 死亡多条路径重复结算。
 */
function 清理R技能上下文(this: void, ctx: R技能上下文, 施法者: any, 结束时: (施法者: any, ctx: R技能上下文) => void): void {
  if (ctx.已结束) return;
  ctx.已结束 = true;
  停止R技能周期(ctx);
  if (ctx.强化回调ID !== 0) removeDelayedCallback(ctx.强化回调ID);
  ctx.强化回调ID = 0;
  const unitId = 取单位句柄ID(施法者);
  if (unitId !== 0 && R技能上下文表[unitId] === ctx) delete R技能上下文表[unitId];
  结束时(施法者, ctx);
}

// =============================================================================
// 光形态：天堂呼唤（A0D5 光 H00F）
// =============================================================================

interface 光祈祷上下文 {
  施法者: any;
  剩余次数: number;
  回调ID: number;
}

function 结束光形态效果(this: void, 施法者: any, ctx: R技能上下文): void {
  const cfg = 阿伦劳特单位技能配置.R;
  SetUnitManaPercentBJ(施法者, 0);
  移除原生Buff(施法者, 天堂呼唤强化BuffID);
  移除单位指定Buff(施法者, 阿伦劳特BuffID.天堂呼唤);
  // SGSS 攻击加值为累加语义：按施放时记录的增量精确还原
  if (ctx.光加攻值 > 0) 临时调整攻击(施法者, -ctx.光加攻值);
  if (ctx.光减伤已应用) 调整玩家属性(施法者, cfg.光强化魔法减伤属性名, -cfg.光强化魔法减伤);
  恢复施法者动作(施法者);
  施加结束减速(施法者);
}

function 光强化到期(this: void, 施法者: any, ctx: R技能上下文): void {
  if (ctx.已结束) return;
  清理R技能上下文(ctx, 施法者, 结束光形态效果);
}

function 光祈祷完成(this: void, 施法者: any, rctx: R技能上下文): void {
  const cfg = 阿伦劳特单位技能配置.R;
  // 祈祷期间被重新施放覆盖（新上下文已入表）：本流程作废，避免旧回调接管新状态
  if (获取R技能上下文(施法者) !== rctx) return;
  // 祈祷过程中死亡：Buff/属性尚未生效，无需还原，直接移除上下文
  if (!单位存活(施法者)) {
    delete R技能上下文表[取单位句柄ID(施法者)];
    return;
  }

  // 1. 天堂呼唤 Buff 6 秒（开放后续强化判定）
  添加原生Buff持续(施法者, 天堂呼唤强化BuffID, cfg.光强化持续秒);

  // 2. 临时攻击力增幅（攻击力 × 2.0，叠加基础攻击后总攻击力约 300%）
  const 攻击力 = 读取单位攻击力(施法者);
  const 加攻值 = 攻击力 * cfg.光强化攻击倍率;
  if (加攻值 > 0) {
    临时调整攻击(施法者, 加攻值);
    rctx.光加攻值 = 加攻值;
  }

  // 3. 玩家属性：受到魔法伤害降低 30%（用"技能伤害减少"属性表达）
  调整玩家属性(施法者, cfg.光强化魔法减伤属性名, cfg.光强化魔法减伤);
  rctx.光减伤已应用 = true;
  // 自定义 Buff：天堂呼唤强化图标显示（effectValue = 加攻值）
  registerManualBuff(施法者, 阿伦劳特BuffID.天堂呼唤, cfg.光强化持续秒, 加攻值);

  // 4. 强化期间特效（挂 chest，6 秒后自动销毁）
  createTimedUnitEffect(施法者, "chest", cfg.光强化特效, cfg.光强化持续秒);

  // 5. 解除暂停、恢复动作
  恢复施法者动作(施法者);

  // 6. 6 秒后精确还原加攻/减伤并结束；同时每 0.2 秒检测 B018 是否被移除/死亡提前结束
  rctx.类型 = "光强化";
  rctx.强化回调ID = addDelayedCallback(Math.round(cfg.光强化持续秒 * 1000), () => {
    rctx.强化回调ID = 0;
    光强化到期(施法者, rctx);
  });
  rctx.周期回调ID = addPeriodicCallback(200, () => {
    if (rctx.已结束 || rctx.周期回调ID === 0) return;
    if (施法者 == null || 施法者 === 0) return;
    if (!单位存活(施法者) || !拥有天堂呼唤(施法者)) 光强化到期(施法者, rctx);
  });
}

function 光形态R(this: void, 施法者: any): void {
  const cfg = 阿伦劳特单位技能配置.R;
  // 重复施放：先清理旧状态（含暂停/强化），再重新开始
  const 旧ctx = 获取R技能上下文(施法者);
  if (旧ctx != null && !旧ctx.已结束) 清理R技能上下文(旧ctx, 施法者, 结束光形态效果);
  const rctx = 创建R技能上下文(施法者, "光祈祷");
  if (rctx == null) return;

  // 施放：暂停施法者 → 播放动作 4 → 起手特效挂 origin 0.5 秒销毁
  PauseUnit(施法者, true);
  SetUnitAnimationByIndex(施法者, 4);
  createTimedUnitEffect(施法者, "origin", cfg.光起手特效, cfg.光起手特效持续秒);

  // 0.42 秒周期 × 7（约 3 秒祈祷）
  const 祈祷上下文: 光祈祷上下文 = {
    施法者,
    剩余次数: cfg.光祈祷次数,
    回调ID: 0,
  };
  祈祷上下文.回调ID = addPeriodicCallback(Math.round(cfg.光祈祷周期秒 * 1000), () => {
    const 祈祷 = 祈祷上下文;
    if (祈祷.剩余次数 <= 0 || !单位存活(祈祷.施法者)) {
      removePeriodicCallback(祈祷.回调ID);
      if (rctx.周期回调ID === 祈祷.回调ID) rctx.周期回调ID = 0;
      光祈祷完成(祈祷.施法者, rctx);
      return;
    }
    祈祷.剩余次数 -= 1;

    // 源 JASS：祈祷首个周期将时间缩放设为 0（完全定格动作）
    if (祈祷.剩余次数 === cfg.光祈祷次数 - 1) SetUnitTimeScale(祈祷.施法者, 0);

    const 施法者玩家 = GetOwningPlayer(祈祷.施法者);
    const 施法者X = GetUnitX(祈祷.施法者);
    const 施法者Y = GetUnitY(祈祷.施法者);
    const 攻击力 = 读取单位攻击力(祈祷.施法者);
    const 治疗量 = 攻击力 * cfg.光周期治疗倍率;

    // 枚举周围 500 范围友军（非敌人、存活、非古树/结构/机械）
    const 单位列表 = getUnitsInRange(施法者X, 施法者Y, cfg.光友军范围);
    for (let i = 0; i < 单位列表.length; i++) {
      const 友军 = 单位列表[i];
      if (!是有效目标(友军)) continue;
      if (IsUnitEnemy(友军, 施法者玩家) === true) continue;
      // 治疗 = 攻击力 × 0.5；解除不利状态
      if (治疗量 > 0) {
        doHeal({
          HealSource: 祈祷.施法者,
          HealTarget: 友军,
          HealAmount: 治疗量,
          ItemHeal: false,
          HealEffect: true,
        });
      }
      移除单位负面Buff(友军, false);
    }

    // 周期表现：ResurrectTarget.mdl（缩放 4）+ [ake]hunsebo.mdx，Z 叠加施法者飞行高度
    const 飞行高度 = GetUnitFlyHeight(祈祷.施法者);
    创建点特效({
      模型路径: cfg.光周期特效1,
      X: 施法者X,
      Y: 施法者Y,
      Z: 飞行高度,
      缩放: cfg.光周期特效1缩放,
      持续秒: cfg.光周期特效持续秒,
    });
    创建点特效({
      模型路径: cfg.光周期特效2,
      X: 施法者X,
      Y: 施法者Y,
      Z: 飞行高度,
      持续秒: cfg.光周期特效持续秒,
    });
  });
  rctx.周期回调ID = 祈祷上下文.回调ID;
}

// =============================================================================
// 暗形态：裁决审判（A0D5 暗 H00G）
// =============================================================================

interface 暗汲取弹道上下文 {
  施法者: any;
  弹道1: any;
  弹道2: any;
  当前X: number;
  当前Y: number;
  汲取值: number;
  剩余tick: number;
  回调ID: number;
}

/** 弹道命中施法者：销毁特效并恢复施法者生命 = 汲取值 */
function 结算暗汲取恢复(this: void, 施法者: any, 汲取值: number): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者) || !(汲取值 > 0)) return;
  const 当前生命 = GetUnitState(施法者, UNIT_STATE_LIFE);
  const 最大生命 = GetUnitState(施法者, UNIT_STATE_MAX_LIFE);
  SetUnitState(施法者, UNIT_STATE_LIFE, Math.min(当前生命 + 汲取值, 最大生命));
}

function 开始暗汲取弹道(this: void, 施法者: any, 目标单位: any, 汲取值: number): void {
  const cfg = 阿伦劳特单位技能配置.R;
  if (目标单位 == null || 目标单位 === 0 || !单位存活(目标单位)) return;
  const 目标X = GetUnitX(目标单位);
  const 目标Y = GetUnitY(目标单位);
  const 飞行高度 = GetUnitFlyHeight(目标单位);
  const 施法者X = GetUnitX(施法者);
  const 施法者Y = GetUnitY(施法者);
  // 目标 → 施法者 方向；死亡缠绕特效在前，鲜血特效在其后方 75 码
  const 角度 = 两点角度(目标X, 目标Y, 施法者X, 施法者Y);
  const 鲜血X = 目标X - Math.cos(角度 * 角度转弧度) * cfg.暗汲取弹道后方偏移;
  const 鲜血Y = 目标Y - Math.sin(角度 * 角度转弧度) * cfg.暗汲取弹道后方偏移;

  const 弹道1 = 创建点特效({
    模型路径: cfg.暗汲取弹道1,
    X: 目标X,
    Y: 目标Y,
    Z: 飞行高度 + cfg.暗汲取弹道Z偏移,
  });
  const 弹道2 = 创建点特效({
    模型路径: cfg.暗汲取弹道2,
    X: 鲜血X,
    Y: 鲜血Y,
    Z: 飞行高度 + cfg.暗汲取弹道Z偏移,
  });
  if (弹道1 == null || 弹道1 === 0 || 弹道2 == null || 弹道2 === 0) {
    if (弹道1 != null && 弹道1 !== 0) jass.DestroyEffect(弹道1);
    if (弹道2 != null && 弹道2 !== 0) jass.DestroyEffect(弹道2);
    return;
  }

  const 弹道上下文: 暗汲取弹道上下文 = {
    施法者,
    弹道1,
    弹道2,
    当前X: 目标X,
    当前Y: 目标Y,
    汲取值,
    剩余tick: cfg.暗汲取弹道最大tick,
    回调ID: 0,
  };
  弹道上下文.回调ID = addPeriodicCallback(20, () => {
    const ctx = 弹道上下文;
    if (ctx.剩余tick <= 0 || ctx.施法者 == null || ctx.施法者 === 0) {
      removePeriodicCallback(ctx.回调ID);
      jass.DestroyEffect(ctx.弹道1);
      jass.DestroyEffect(ctx.弹道2);
      return;
    }
    ctx.剩余tick -= 1;
    const 施法者X2 = GetUnitX(ctx.施法者);
    const 施法者Y2 = GetUnitY(ctx.施法者);
    // 到达施法者（源 IsUnitInRangeLoc 100）：恢复汲取值
    if (两点距离(ctx.当前X, ctx.当前Y, 施法者X2, 施法者Y2) <= 100) {
      removePeriodicCallback(ctx.回调ID);
      jass.DestroyEffect(ctx.弹道1);
      jass.DestroyEffect(ctx.弹道2);
      结算暗汲取恢复(ctx.施法者, ctx.汲取值);
      return;
    }
    const 新角度 = 两点角度(ctx.当前X, ctx.当前Y, 施法者X2, 施法者Y2);
    ctx.当前X += Math.cos(新角度 * 角度转弧度) * cfg.暗汲取弹道每tick距离;
    ctx.当前Y += Math.sin(新角度 * 角度转弧度) * cfg.暗汲取弹道每tick距离;
    if (EXSetEffectXY != null) {
      EXSetEffectXY(ctx.弹道1, ctx.当前X, ctx.当前Y);
      EXSetEffectXY(ctx.弹道2, ctx.当前X - Math.cos(新角度 * 角度转弧度) * cfg.暗汲取弹道后方偏移, ctx.当前Y - Math.sin(新角度 * 角度转弧度) * cfg.暗汲取弹道后方偏移);
    }
  });
}

function 结束暗形态效果(this: void, 施法者: any, _ctx: R技能上下文): void {
  SetUnitManaPercentBJ(施法者, 0);
  移除原生Buff(施法者, 裁决审判强化BuffID);
  移除单位指定Buff(施法者, 阿伦劳特BuffID.裁决审判);
  施加结束减速(施法者);
}

function 暗强化到期(this: void, 施法者: any, ctx: R技能上下文): void {
  if (ctx.已结束) return;
  清理R技能上下文(ctx, 施法者, 结束暗形态效果);
}

function 暗形态R(this: void, 施法者: any): void {
  const cfg = 阿伦劳特单位技能配置.R;
  // 重复施放：先清理旧状态（含 6 秒窗口计时与 B015）
  const 旧ctx = 获取R技能上下文(施法者);
  if (旧ctx != null && !旧ctx.已结束) 清理R技能上下文(旧ctx, 施法者, 结束暗形态效果);
  const rctx = 创建R技能上下文(施法者, "暗汲取");
  if (rctx == null) return;

  const 施法者X = GetUnitX(施法者);
  const 施法者Y = GetUnitY(施法者);
  const 施法者玩家 = GetOwningPlayer(施法者);
  const 施法者单位ID = GetUnitTypeId(施法者);
  const 单位列表 = getUnitsInRange(施法者X, 施法者Y, cfg.暗汲取范围);

  for (let i = 0; i < 单位列表.length; i++) {
    const 目标 = 单位列表[i];
    if (!是有效目标(目标)) continue;
    if (GetUnitTypeId(目标) === 施法者单位ID) continue;
    const 目标当前生命 = GetUnitState(目标, UNIT_STATE_LIFE);
    const 汲取值 = 目标当前生命 * cfg.暗汲取比例;
    if (!(汲取值 > 0)) continue;

    // 抽取当前生命 7%（SetUnitState 减生命）
    SetUnitState(目标, UNIT_STATE_LIFE, 目标当前生命 - 汲取值);

    // 固定 10 点强化伤害（源 JASS 保留；图片未提，按迁移计划 5.3 保留并记录）
    造成技能伤害({
      来源: 施法者,
      目标,
      伤害: cfg.暗汲取固定伤害,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      attack: false,
      attackType: ATTACK_TYPE_CHAOS,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: R技能ID,
      标签: "阿伦劳特-R-裁决审判",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });

    // 命中特效 CrimsonWake.mdl 2 秒（Z = 目标飞行高度 + 100，纯表现不创建单位）
    创建点特效({
      模型路径: cfg.暗汲取命中特效,
      X: GetUnitX(目标),
      Y: GetUnitY(目标),
      Z: GetUnitFlyHeight(目标) + cfg.暗汲取弹道Z偏移,
      持续秒: cfg.暗汲取命中特效持续秒,
    });

    // 弹道回血：DeathCoilMissile.mdl + BloodElementalMissile.mdl
    开始暗汲取弹道(施法者, 目标, 汲取值);
  }

  // 施放后：登记裁决审判 B015 6 秒（开放 R2）
  添加原生Buff持续(施法者, 裁决审判强化BuffID, cfg.暗强化持续秒);
  // 自定义 Buff：裁决审判强化图标显示
  registerManualBuff(施法者, 阿伦劳特BuffID.裁决审判, cfg.暗强化持续秒, 0);

  // 6 秒后精确结束；同时每 0.2 秒检测 B015 是否被移除（驱散/中断）或施法者死亡提前结束
  rctx.类型 = "暗强化";
  rctx.强化回调ID = addDelayedCallback(Math.round(cfg.暗强化持续秒 * 1000), () => {
    rctx.强化回调ID = 0;
    暗强化到期(施法者, rctx);
  });
  rctx.周期回调ID = addPeriodicCallback(200, () => {
    if (rctx.已结束 || rctx.周期回调ID === 0) return;
    if (施法者 == null || 施法者 === 0) return;
    if (!单位存活(施法者) || !拥有裁决审判(施法者)) 暗强化到期(施法者, rctx);
  });
}

// =============================================================================
// R 二段：裁决冲击（A0D2，仅持有 B015 时可施放）
// =============================================================================

function 施放裁决冲击(this: void, 施法者: any): void {
  const cfg = 阿伦劳特单位技能配置.R2;
  // 结束当前裁决审判状态（含 6 秒窗口计时、B015、结束减速）
  const 旧ctx = 获取R技能上下文(施法者);
  if (旧ctx != null && !旧ctx.已结束) 清理R技能上下文(旧ctx, 施法者, 结束暗形态效果);
  const rctx = 创建R技能上下文(施法者, "R2");
  if (rctx == null) return;

  // 1. 清空魔法，移除裁决审判 B015（结束裁决审判状态）
  SetUnitManaPercentBJ(施法者, 0);
  移除原生Buff(施法者, 裁决审判强化BuffID);

  // 2. 获取施法者位置与目标点，计算方向角
  const 施法者X = GetUnitX(施法者);
  const 施法者Y = GetUnitY(施法者);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 角度 = 两点角度(施法者X, 施法者Y, 目标X, 目标Y);
  const 飞行高度 = GetUnitFlyHeight(施法者);

  // 3. 血墙点 = 施法者前 750 码：ChaosWall（缩放 2、绕 Z 旋转 角度+90）+ Kaiserbreath（缩放 1.5、旋转角度）
  const 血墙X = 施法者X + Math.cos(角度 * 角度转弧度) * cfg.血墙点距离;
  const 血墙Y = 施法者Y + Math.sin(角度 * 角度转弧度) * cfg.血墙点距离;
  创建点特效({
    模型路径: cfg.血墙特效,
    X: 血墙X,
    Y: 血墙Y,
    Z: 飞行高度,
    缩放: cfg.血墙缩放,
    Z轴角度: 角度 + 90,
    持续秒: 1,
  });
  创建点特效({
    模型路径: cfg.冲击特效,
    X: 施法者X,
    Y: 施法者Y,
    Z: 飞行高度,
    缩放: cfg.冲击缩放,
    Z轴角度: 角度,
    持续秒: 1,
  });

  // 4. 弹幕推进：每 0.02 秒移动 50 码，最多 30 次（600 码）
  const 已命中单位ID集合: Record<number, boolean> = {};
  const 推进上下文 = {
    施法者,
    当前X: 施法者X,
    当前Y: 施法者Y,
    剩余tick: cfg.弹幕最大tick,
    回调ID: 0,
  };
  推进上下文.回调ID = addPeriodicCallback(20, () => {
    const 推进 = 推进上下文;
    if (推进.剩余tick <= 0 || 推进.施法者 == null || 推进.施法者 === 0 || !单位存活(推进.施法者)) {
      removePeriodicCallback(推进.回调ID);
      // 弹幕结束后移除 R2 上下文，避免残留引用
      if (rctx.周期回调ID === 推进.回调ID) {
        rctx.周期回调ID = 0;
        rctx.已结束 = true;
        if (获取R技能上下文(施法者) === rctx) delete R技能上下文表[取单位句柄ID(施法者)];
      }
      return;
    }
    推进.剩余tick -= 1;

    // 当前点残留特效 0.5 秒
    创建点特效({
      模型路径: cfg.路径特效,
      X: 推进.当前X,
      Y: 推进.当前Y,
      Z: 飞行高度,
      持续秒: cfg.路径特效持续秒,
    });

    // 扫描当前点 300 范围敌人（Record 去重，每个目标只进伤害组一次）
    const 敌人列表 = getUnitsInRange(推进.当前X, 推进.当前Y, cfg.路径扫描半径);
    for (let i = 0; i < 敌人列表.length; i++) {
      const 目标 = 敌人列表[i];
      if (!是有效目标(目标)) continue;
      if (IsUnitEnemy(目标, GetOwningPlayer(推进.施法者)) !== true) continue;
      const 目标ID = GetHandleId(目标);
      if (目标ID === 0 || 已命中单位ID集合[目标ID] === true) continue;
      已命中单位ID集合[目标ID] = true;

      // 伤害 = 自身当前生命 × 100% + 目标已损失生命 × 20%（图片口径）
      const 自身当前生命 = GetUnitState(推进.施法者, UNIT_STATE_LIFE);
      const 目标已损失生命 = Math.max(0, GetUnitState(目标, UNIT_STATE_MAX_LIFE) - GetUnitState(目标, UNIT_STATE_LIFE));
      const 伤害 = 自身当前生命 * cfg.自身生命倍率 + 目标已损失生命 * cfg.目标损失生命倍率;
      造成技能伤害({
        来源: 推进.施法者,
        目标,
        伤害,
        伤害类型: DAMAGE_TYPE_ENHANCED,
        attack: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: R二段技能ID,
        标签: "阿伦劳特-R2-裁决冲击",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });

      // 眩晕 3 秒 + 击退 1000（图片口径）
      施加眩晕(推进.施法者, 目标, cfg.眩晕秒, "阿伦劳特-R2-裁决冲击", "技能");
      开始击退(目标, {
        来源单位: 推进.施法者,
        距离: cfg.击退距离,
        持续时间: cfg.击退持续秒,
        检查地形: true,
        禁用碰撞: true,
      });
    }

    // 沿施法方向推进 50 码
    推进.当前X += Math.cos(角度 * 角度转弧度) * cfg.弹幕每tick距离;
    推进.当前Y += Math.sin(角度 * 角度转弧度) * cfg.弹幕每tick距离;
  });
  rctx.周期回调ID = 推进上下文.回调ID;
}

// =============================================================================
// 死亡清理
// =============================================================================

function 阿伦劳特R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!是阿伦劳特英雄(dyingUnit)) return;
  const ctx = 获取R技能上下文(dyingUnit);
  if (ctx == null || ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (ctx.类型 === "光祈祷" || ctx.类型 === "光强化") {
    // 光形态：祈祷中死亡无需还原（属性未生效）；强化期间死亡完整还原并清空魔法
    清理R技能上下文(ctx, 施法者, 结束光形态效果);
  } else {
    清理R技能上下文(ctx, 施法者, 结束暗形态效果);
  }
}

// =============================================================================
// 入口
// =============================================================================

/** R：A0D5，按形态分流（光 = 天堂呼唤，暗 = 裁决审判） */
export function on阿伦劳特R(this: void, 施法者: any, 技能ID数值: number): void {
  if (技能ID数值 !== R技能ID) return;
  if (!是阿伦劳特英雄(施法者)) return;

  if (是光形态(施法者)) {
    光形态R(施法者);
  } else if (是暗形态(施法者)) {
    暗形态R(施法者);
  }
}

/** R 二段：裁决冲击（A0D2）——暗形态 R 的 B015 提供开放窗口 */
export function on阿伦劳特R2(this: void, 施法者: any, 技能ID数值: number): void {
  if (技能ID数值 !== R二段技能ID) return;
  if (!是阿伦劳特英雄(施法者)) return;
  施放裁决冲击(施法者);
}

registerSpellEffectListener(on阿伦劳特R);
registerSpellEffectListener(on阿伦劳特R2);
registerDeathListener(阿伦劳特R单位死亡);

export {};
