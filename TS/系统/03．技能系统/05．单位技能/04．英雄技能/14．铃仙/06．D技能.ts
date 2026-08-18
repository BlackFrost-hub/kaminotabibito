/** @noSelfInFile */

/**
 * 铃仙（月兔） - D 幻胧月睨（A0GJ）
 *
 * 源 JASS：`JASS/部分地图编辑器GUI的英雄jass代码/铃仙/铃仙.j` ReisenD 分支
 * （Trig_L______ResenFunc006Func016T / Func017Func005T 等）。
 *
 * 逻辑：
 * - 立即：Q 冷却减少 4 秒、W 冷却减少 8 秒；全图玩家英雄免疫伤害 1 秒。
 * - 播放音效 gg_snd_LX_D_24343 + gg_snd_LX_D；屏幕滤镜约 1.1 秒
 *   （源 CinematicFilterGenericBJ，迁移简化为 DisplayCineFilter）。
 * - 每 1 秒发射 1 波、共 5 波；每波 15 发 e07N 弹幕，角度 = N × 24°（N = 1..15）。
 * - 每 0.03 秒推进所有弹幕，每 tick 前移 30 码；每 tick 检测弹幕周围 127 码内敌人：
 *   首次命中 = 攻击力×1 魔法伤害，重复命中 = 攻击力×1 × 10%，命中后移除该弹幕。
 * - 5 波射完后延迟 1 秒清理所有弹幕；施法者死亡或弹幕全部消失时提前结束循环。
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙全局音效, 播放铃仙单位绑定音效 } from "./00A．表现工具";
import { 是铃仙本体, 是有效敌对目标, 全图英雄免疫伤害 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { YDWESetUnitAbilityStateSafe, YDWEGetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
  YDWEGetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: {
    来源: any;
    目标: any;
    伤害: number;
    伤害类型: any;
    attack?: boolean;
    ranged?: boolean;
    attackType?: any;
    weaponType?: any;
    来源类型?: string;
    技能ID?: number;
    标签?: string;
    伤害形态?: "单体" | "AOE" | "未知";
    参与技能伤害加成?: boolean;
  }) => boolean;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};

const cfg = 铃仙单位技能配置;
const D技能ID数值 = stringToFourCCSafe(cfg.D技能ID); // A0GJ
const Q技能ID数值 = stringToFourCCSafe(cfg.Q技能ID); // A0GK
const W技能ID数值 = stringToFourCCSafe(cfg.W技能ID); // A0GI
const 弹幕马甲ID = stringToFourCCSafe(cfg.D.弹幕马甲ID); // e07N

const 技能冷却状态 = 1; // YDWE ABILITY_STATE_COOLDOWN（技能冷却状态）
const 角度转弧度 = Math.PI / 180;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
// 源 e07N 默认模型为 LightArrow.mdl，按 D 弹幕规格替换为 Bullet.mdl
const DzSetUnitModel = (japi as any).DzSetUnitModel as ((this: void, unit: any, model: string) => void) | undefined;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, model: string, target: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const DisplayCineFilter = jass.DisplayCineFilter as (this: void, show: boolean) => void;
const { CinematicFilterGenericBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicFilterGenericBJ: (this: void, duration: number, bmode: any, tex: string, red0: number, green0: number, blue0: number, trans0: number, red1: number, green1: number, blue1: number, trans1: number) => void;
};
const BLEND_MODE_BLEND = jass.BLEND_MODE_BLEND as number;

//=============================================================================
// 一、D 弹幕上下文（每次施法独立）
//=============================================================================

interface D弹幕上下文 {
  施法者: any;
  /** 弹幕推进周期回调 ID（0.03 秒） */
  推进回调ID: number;
  /** 已发射波数（共 5 波） */
  波次数: number;
  /** 当前波次存活的弹幕列表 */
  弹幕列表: any[];
  /** 当前波次已命中单位去重表（每波重置） */
  重复命中表: Record<number, boolean>;
  已结束: boolean;
}

/** 结束 D：移除推进回调、清理所有剩余弹幕（英雄死亡 / 弹幕全消 / 5 波后清理） */
function 结束D弹幕(this: void, ctx: D弹幕上下文): void {
  if (ctx.已结束) return;
  ctx.已结束 = true;
  if (ctx.推进回调ID !== 0) {
    removePeriodicCallback(ctx.推进回调ID);
    ctx.推进回调ID = 0;
  }
  for (let i = 0; i < ctx.弹幕列表.length; i++) {
    const 弹幕 = ctx.弹幕列表[i];
    if (弹幕 != null && 弹幕 !== 0) RemoveUnit(弹幕);
  }
  ctx.弹幕列表 = [];
  ctx.重复命中表 = {};
  // D 波次结束：移除状态 Buff
  移除单位指定Buff(ctx.施法者, 铃仙BuffID.D波次);
}

/** 发射一波：15 发弹幕，角度 = N × 24°（N = 1..15），设置朝向角度 */
function 发射D一波(this: void, ctx: D弹幕上下文): void {
  const 施法者 = ctx.施法者;
  const 玩家 = GetOwningPlayer(施法者);
  const 中心X = GetUnitX(施法者);
  const 中心Y = GetUnitY(施法者);
  let 创建数 = 0;
  for (let N = 1; N <= cfg.D.每波弹幕数; N++) {
    const 角度 = N * cfg.D.弹幕角度间隔;
    const 弹幕 = CreateUnit(玩家, 弹幕马甲ID, 中心X, 中心Y, 角度);
    if (弹幕 == null || 弹幕 === 0) continue;
    if (DzSetUnitModel != null) DzSetUnitModel(弹幕, cfg.D.弹幕模型);
    ctx.弹幕列表.push(弹幕);
    创建数 += 1;
  }
}

/** 链式发射 5 波，每波间隔 1 秒 */
function 发射D下一波(this: void, ctx: D弹幕上下文): void {
  if (ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    结束D弹幕(ctx);
    return;
  }
  ctx.波次数 += 1;
  ctx.重复命中表 = {}; // 每波重置去重

  // 每 tick 头顶 Whine 特效 + 震波特效 + 音效（源 JASS ResenFunc006Func016T）
  DestroyEffect(AddSpecialEffectTarget("war3mapImported\\Whine.mdx", 施法者, "overhead"));
  DestroyEffect(AddSpecialEffectTarget("war3mapImported\\Shockwave_Darkness.mdx", 施法者, "origin"));
  播放铃仙单位绑定音效(施法者, "gg_snd_tan2", 100);

  发射D一波(ctx);
  if (ctx.波次数 >= cfg.D.持续秒) {
    // 5 波射完，延迟 1 秒清理
    addDelayedCallback(Math.round(cfg.D.清理延迟秒 * 1000), () => 结束D弹幕(ctx));
    return;
  }
  addDelayedCallback(Math.round(cfg.D.波次间隔秒 * 1000), () => 发射D下一波(ctx));
}

/** 弹幕推进：每 0.03 秒前移 30 码并检测 127 码内敌人（首次全额 / 重复 10%） */
function 推进D弹幕(this: void, ctx: D弹幕上下文): void {
  if (ctx.已结束) return;
  const 施法者 = ctx.施法者;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    结束D弹幕(ctx);
    return;
  }

  const 列表 = ctx.弹幕列表;
  for (let i = 列表.length - 1; i >= 0; i--) {
    const 弹幕 = 列表[i];
    if (弹幕 == null || 弹幕 === 0 || !单位存活(弹幕)) {
      列表.splice(i, 1);
      continue;
    }
    // 沿朝向前移 30 码
    const 朝向 = GetUnitFacing(弹幕);
    const 新X = GetUnitX(弹幕) + Math.cos(朝向 * 角度转弧度) * cfg.D.弹幕每tick距离;
    const 新Y = GetUnitY(弹幕) + Math.sin(朝向 * 角度转弧度) * cfg.D.弹幕每tick距离;
    SetUnitPosition(弹幕, 新X, 新Y);

    // 检测 127 码内敌人
    const 单位列表 = getUnitsInRange(新X, 新Y, cfg.D.弹幕命中半径);
    let 已命中 = false;
    for (let j = 0; j < 单位列表.length; j++) {
      const 目标 = 单位列表[j];
      if (!是有效敌对目标(施法者, 目标)) continue;
      const id = GetHandleId(目标);
      const 重复命中 = ctx.重复命中表[id] === true;
      ctx.重复命中表[id] = true;
      const 伤害 = 读取单位攻击力(施法者) * cfg.D.攻击力倍率 * (重复命中 ? cfg.D.重复命中比例 : 1);
      if (!(伤害 > 0)) continue;
      造成技能伤害({
        来源: 施法者,
        目标,
        伤害,
        伤害类型: DAMAGE_TYPE_MAGIC,
        attack: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: D技能ID数值,
        标签: "铃仙-D-幻胧月睨",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
      已命中 = true;
    }
    // 命中后移除该弹幕
    if (已命中) {
      RemoveUnit(弹幕);
      列表.splice(i, 1);
    }
  }

  // 弹幕全部消失且 5 波已射完 → 提前结束循环
  if (列表.length <= 0 && ctx.波次数 >= cfg.D.持续秒) {
    结束D弹幕(ctx);
  }
}

//=============================================================================
// 二、施法入口
//=============================================================================

function 启动D弹幕(this: void, 施法者: any): void {
  const ctx: D弹幕上下文 = {
    施法者,
    推进回调ID: 0,
    波次数: 0,
    弹幕列表: [],
    重复命中表: {},
    已结束: false,
  };
  // 弹幕推进回调（0.03 秒）
  ctx.推进回调ID = addPeriodicCallback(Math.round(cfg.D.弹幕tick秒 * 1000), () => 推进D弹幕(ctx));
  // 发射第一波（后续波次链式间隔 1 秒）
  发射D下一波(ctx);
}

function on铃仙D生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== D技能ID数值) return;
  if (!是铃仙本体(施法单位)) return;

  // 立即：减少 Q 冷却 4 秒、W 冷却 8 秒
  const q冷却 = YDWEGetUnitAbilityStateSafe(施法单位, Q技能ID数值, 技能冷却状态);
  YDWESetUnitAbilityStateSafe(施法单位, Q技能ID数值, 技能冷却状态, Math.max(0, q冷却 - cfg.D.Q冷却减少));
  const w冷却 = YDWEGetUnitAbilityStateSafe(施法单位, W技能ID数值, 技能冷却状态);
  YDWESetUnitAbilityStateSafe(施法单位, W技能ID数值, 技能冷却状态, Math.max(0, w冷却 - cfg.D.W冷却减少));

  // 全图玩家英雄免疫伤害 1 秒
  全图英雄免疫伤害(cfg.D.免伤秒);

  // 音效
  播放铃仙全局音效("gg_snd_LX_D_24343");
  播放铃仙全局音效("gg_snd_LX_D");

  // 屏幕滤镜（源 JASS CinematicFilterGenericBJ）
  CinematicFilterGenericBJ(1.10, BLEND_MODE_BLEND, "222.blp", 100, 100, 100.00, 0.00, 0, 0, 0, 0);
  addDelayedCallback(1100, () => DisplayCineFilter(false));

  // D 波次状态：持续弹幕期间显示状态图标
  registerManualBuff(施法单位, 铃仙BuffID.D波次, cfg.D.持续秒, 0);

  // 开始波次弹幕
  启动D弹幕(施法单位);
}

registerSpellEffectListener(on铃仙D生效);

export {};
