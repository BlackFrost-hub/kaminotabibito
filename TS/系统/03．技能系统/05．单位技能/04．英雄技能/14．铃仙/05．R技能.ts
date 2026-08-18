/** @noSelfInFile */

/**
 * 铃仙（月兔） - R 丧心"丧心疮痍"（A0GL/A0GM）
 *
 * 源 JASS：`JASS/部分地图编辑器GUI的英雄jass代码/铃仙/铃仙.j`
 * ReisenR（A0GL） / ReisenR2（A0GM） 分支。
 *
 * 两阶段状态机：
 * - 阶段一（A0GL 翻滚）：沿施法方向翻滚 min(400 + 敏捷×0.8, 施法距离) 码，
 *   每 0.02 秒推进 70 码；翻滚结束恢复路径与动画倍速。施法瞬间即切换
 *   二段可用性并开启 2 秒瞄准窗口。
 * - 阶段二（A0GM 瞄准发射）：施法距离 ≤ 500 时重置冷却不发射；否则标记
 *   「二段使用」，播放音效/蓄力特效/动作，0.55 秒后沿目标方向发射 e07Q
 *   弹幕（bluesword.mdl，缩放 3，高度 115），每 0.02 秒推进 60 码。
 *   路径 140 码内敌人受 攻击力×1.5 魔法伤害；到达目标点 200 码内时结算
 *   目标 400 码范围 攻击力×3.5 魔法伤害，200 码内眩晕 1 秒（attack=true
 *   表达必定暴击）。路径伤害与范围伤害去重取高值（同一目标只受一次全额）。
 *
 * 冷却规则：2 秒瞄准窗口超时且未使用二段时，将 A0GL 冷却恢复为 8 秒；
 * 二段使用标记在 35 秒后自动清除。
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 铃仙BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/12．铃仙";
import { 播放铃仙全局音效, 播放铃仙单位绑定音效, 播放铃仙配置动作 } from "./00A．表现工具";
import { 是铃仙本体, 是有效敌对目标 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;

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
const { YDUserDataGetSafe, YDUserDataSetSafe, YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
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
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    动画速度?: number;
    持续秒?: number;
    缩放?: number;
  }) => any;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, 来源: any, 目标: any, 持续时间: number, 效果来源名称?: string, 效果来源类型?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 读取单位敏捷, 单位存活, 距离XY, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位敏捷: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

const cfg = 铃仙单位技能配置;
const R技能ID数值 = stringToFourCCSafe(cfg.R技能ID); // A0GL
const R二段技能ID数值 = stringToFourCCSafe(cfg.R二段技能ID); // A0GM
const 准心马甲ID = stringToFourCCSafe(cfg.R.准心马甲ID); // e03N
const 弹幕马甲ID = stringToFourCCSafe(cfg.R.弹幕马甲ID); // e07Q

const 技能冷却状态 = 1; // YDWE ABILITY_STATE_COOLDOWN（技能冷却状态）
const 角度转弧度 = Math.PI / 180;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, speed: number) => void;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitShareVision = jass.UnitShareVision as (this: void, unit: any, player: any, share: boolean) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const Player = jass.Player as (this: void, index: number) => any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

//=============================================================================
// 一、阶段一：翻滚（A0GL）
//=============================================================================

/**
 * 结束翻滚：停止动作、恢复路径与动画倍速。
 * 二段可用性切换与 2 秒瞄准窗口在施法瞬间已同步开启（与源 JASS 一致）。
 */
function 结束翻滚(this: void, 铃仙: any): void {
  if (铃仙 == null || 铃仙 === 0) return;
  IssueImmediateOrder(铃仙, "stop");
  SetUnitPathing(铃仙, true);
  播放铃仙配置动作(铃仙, -1, 1.0);
}

/** 翻滚推进：每 tick 沿施法方向移动 70 码，翻滚次数归零后停止 */
function 执行翻滚(this: void, 铃仙: any, 方向角: number, 翻滚次数: number): void {
  if (翻滚次数 <= 0) {
    结束翻滚(铃仙);
    return;
  }
  const 每tick距离 = cfg.R.翻滚每tick距离;
  let 剩余次数 = 翻滚次数;
  const 回调ID = addPeriodicCallback(20, () => {
    if (铃仙 == null || 铃仙 === 0) {
      removePeriodicCallback(回调ID);
      return;
    }
    // 被时停时暂停推进（源 IsUnitPausedBJ 判断）
    if (jass.IsUnitPaused(铃仙) === true) return;
    if (剩余次数 <= 0 || !单位存活(铃仙)) {
      removePeriodicCallback(回调ID);
      结束翻滚(铃仙);
      return;
    }
    // 从单位当前位置沿施法方向推进 70 码（源 GetUnitLoc + PolarProjectionBJ）
    const x = GetUnitX(铃仙) + Math.cos(方向角 * 角度转弧度) * 每tick距离;
    const y = GetUnitY(铃仙) + Math.sin(方向角 * 角度转弧度) * 每tick距离;
    SetUnitPosition(铃仙, x, y);
    剩余次数 -= 1;
  });
}

//=============================================================================
// 二、阶段一入口 + 瞄准窗口超时（Trig_L______ResenFunc005Func016T）
//=============================================================================

/**
 * 2 秒瞄准窗口超时：停止动作、恢复 A0GL 可用性；未使用二段则冷却恢复为 8 秒。
 */
function 瞄准窗口超时(this: void, 铃仙: any, 玩家: any): void {
  if (铃仙 != null && 铃仙 !== 0) IssueImmediateOrder(铃仙, "stop");
  SetPlayerAbilityAvailable(玩家, R二段技能ID数值, false);
  SetPlayerAbilityAvailable(玩家, R技能ID数值, true);
  // 未使用二段（二段使用 ≠ true）→ 将 A0GL 冷却恢复为 8 秒，便于再次尝试
  const 二段已使用 = 铃仙 != null && 铃仙 !== 0 && YDUserDataGetSafe("unit", 铃仙, "二段使用", "boolean") === true;
  if (!二段已使用 && 铃仙 != null && 铃仙 !== 0) {
    YDWESetUnitAbilityStateSafe(铃仙, R技能ID数值, 技能冷却状态, cfg.R.未发射冷却秒);
  }
}

function on铃仙R生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== R技能ID数值) return;
  if (!是铃仙本体(施法单位)) return;

  const 起始X = GetUnitX(施法单位);
  const 起始Y = GetUnitY(施法单位);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 施法距离 = 距离XY(起始X, 起始Y, 目标X, 目标Y);
  const 方向角 = 两点角度(起始X, 起始Y, 目标X, 目标Y);
  // 翻滚距离 = min(400 + 敏捷×0.8, 施法距离)，翻滚次数 = 翻滚距离 / 70
  const 翻滚距离 = Math.min(cfg.R.翻滚基础距离 + 读取单位敏捷(施法单位) * cfg.R.翻滚敏捷系数, 施法距离);
  const 翻滚次数 = Math.floor(翻滚距离 / cfg.R.翻滚每tick距离);

  const 玩家 = GetOwningPlayer(施法单位);

  // 禁用路径 + 翻滚动画倍速 2.4
  SetUnitPathing(施法单位, false);
  播放铃仙配置动作(施法单位, -1, cfg.R.翻滚动画倍速);

  // 立即同步切换二段技能可用性（源在施法瞬间完成）
  SetPlayerAbilityAvailable(玩家, R二段技能ID数值, true);
  SetPlayerAbilityAvailable(玩家, R技能ID数值, false);

  // 翻滚推进（0.02 秒周期）
  执行翻滚(施法单位, 方向角, 翻滚次数);

  // 开启 2 秒瞄准窗口
  addDelayedCallback(Math.round(cfg.R.瞄准窗口秒 * 1000), () => 瞄准窗口超时(施法单位, 玩家));
}

//=============================================================================
// 三、阶段二：瞄准发射（A0GM）
//=============================================================================

/** 弹幕路径伤害：140 码内敌对单位受 攻击力×1.5 魔法伤害（去重） */
function 处理路径伤害(this: void, 铃仙: any, 弹幕: any, 重复单位表: Record<number, boolean>): void {
  const 单位列表 = getUnitsInRange(GetUnitX(弹幕), GetUnitY(弹幕), cfg.R.弹幕命中半径);
  for (let i = 0; i < 单位列表.length; i++) {
    const 目标 = 单位列表[i];
    if (!是有效敌对目标(铃仙, 目标)) continue;
    const id = GetHandleId(目标);
    if (重复单位表[id] === true) continue;
    重复单位表[id] = true;
    造成技能伤害({
      来源: 铃仙,
      目标,
      伤害: 读取单位攻击力(铃仙) * cfg.R.路径攻击倍率,
      伤害类型: DAMAGE_TYPE_MAGIC,
      attack: true,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: R技能ID数值,
      标签: "铃仙-R-丧心疮痍-路径",
      伤害形态: "单体",
      参与技能伤害加成: true,
    });
  }
}

/** 弹幕到达目标点：目标 400 码范围 攻击力×3.5 魔法伤害；200 码内眩晕 1 秒（attack=true 表达必定暴击） */
function 结算范围伤害(
  this: void,
  铃仙: any,
  目标X: number,
  目标Y: number,
  路径伤害: number,
  范围伤害: number,
  重复单位表: Record<number, boolean>,
): void {
  const 单位列表 = getUnitsInRange(目标X, 目标Y, cfg.R.范围伤害半径);
  for (let i = 0; i < 单位列表.length; i++) {
    const 目标 = 单位列表[i];
    if (!是有效敌对目标(铃仙, 目标)) continue;
    const id = GetHandleId(目标);
    // 去重取高值：已受路径伤害 → 只补范围伤害与路径伤害的差值；否则全额范围伤害
    const 已受路径伤害 = 重复单位表[id] === true;
    const 伤害 = 已受路径伤害 ? 范围伤害 - 路径伤害 : 范围伤害;
    if (!(伤害 > 0)) continue;
    // 目标点 200 码内必定眩晕 1 秒
    if (距离XY(GetUnitX(目标), GetUnitY(目标), 目标X, 目标Y) <= cfg.R.暴击半径) {
      施加眩晕(铃仙, 目标, cfg.R.眩晕秒, 铃仙BuffID.R眩晕, "技能");
    }
    造成技能伤害({
      来源: 铃仙,
      目标,
      伤害,
      伤害类型: DAMAGE_TYPE_MAGIC,
      attack: true,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: R技能ID数值,
      标签: "铃仙-R-丧心疮痍-范围",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
  }
}

/** 发射 e07Q 弹幕并推进至目标点 200 码内（无最大距离限制） */
function 开始发射弹幕(
  this: void,
  铃仙: any,
  玩家: any,
  方向角: number,
  目标X: number,
  目标Y: number,
  准心: any,
): void {
  if (铃仙 == null || 铃仙 === 0 || !单位存活(铃仙)) {
    if (准心 != null && 准心 !== 0) RemoveUnit(准心);
    return;
  }

  const 弹幕起点X = GetUnitX(铃仙);
  const 弹幕起点Y = GetUnitY(铃仙);
  const 弹幕 = CreateUnit(玩家, 弹幕马甲ID, 弹幕起点X, 弹幕起点Y, 方向角);
  if (弹幕 == null || 弹幕 === 0) {
    if (准心 != null && 准心 !== 0) RemoveUnit(准心);
    return;
  }
  // 源 e07Q：bluesword.mdl、缩放 3、高度 115
  SetUnitScale(弹幕, cfg.R.弹幕缩放, cfg.R.弹幕缩放, cfg.R.弹幕缩放);
  SetUnitFlyHeight(弹幕, cfg.R.弹幕高度, 0);

  const 路径伤害 = 读取单位攻击力(铃仙) * cfg.R.路径攻击倍率;
  const 范围伤害 = 读取单位攻击力(铃仙) * cfg.R.范围攻击倍率;
  const 重复单位表: Record<number, boolean> = {};
  let 弹幕X = 弹幕起点X;
  let 弹幕Y = 弹幕起点Y;
  let 已完成 = false;

  const 回调ID = addPeriodicCallback(20, () => {
    if (已完成) {
      removePeriodicCallback(回调ID);
      return;
    }
    if (弹幕 == null || 弹幕 === 0 || !单位存活(弹幕)) {
      // 弹幕消失：直接清理，不做范围结算
      已完成 = true;
      removePeriodicCallback(回调ID);
      if (准心 != null && 准心 !== 0) RemoveUnit(准心);
      return;
    }
    // 1) 沿目标方向推进 60 码（源先移动再结算）
    弹幕X += Math.cos(方向角 * 角度转弧度) * cfg.R.弹幕每tick距离;
    弹幕Y += Math.sin(方向角 * 角度转弧度) * cfg.R.弹幕每tick距离;
    SetUnitPosition(弹幕, 弹幕X, 弹幕Y);
    // 2) 路径伤害检测（140 码）
    处理路径伤害(铃仙, 弹幕, 重复单位表);
    // 3) 到达目标点 200 码内 → 范围结算 + 清理
    if (距离XY(弹幕X, 弹幕Y, 目标X, 目标Y) <= cfg.R.暴击半径) {
      结算范围伤害(铃仙, 目标X, 目标Y, 路径伤害, 范围伤害, 重复单位表);
      // 目标点爆炸特效
      创建点特效({ 模型路径: cfg.R.爆炸特效1, X: 目标X, Y: 目标Y, 持续秒: cfg.R.爆炸特效持续秒 });
      创建点特效({ 模型路径: cfg.R.爆炸特效2, X: 目标X, Y: 目标Y, 持续秒: cfg.R.爆炸特效持续秒 });
      if (准心 != null && 准心 !== 0) RemoveUnit(准心);
      RemoveUnit(弹幕);
      已完成 = true;
      removePeriodicCallback(回调ID);
    }
  });
}

//=============================================================================
// 四、阶段二入口
//=============================================================================

function on铃仙R二段生效(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== R二段技能ID数值) return;
  if (!是铃仙本体(施法单位)) return;

  const 铃仙X = GetUnitX(施法单位);
  const 铃仙Y = GetUnitY(施法单位);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 距离 = 距离XY(铃仙X, 铃仙Y, 目标X, 目标Y);

  // 施法距离 ≤ 500：重置 A0GL 冷却，不发射
  if (距离 <= cfg.R.最小施法距离) {
    YDWESetUnitAbilityStateSafe(施法单位, R技能ID数值, 技能冷却状态, 0);
    return;
  }

  const 玩家 = GetOwningPlayer(施法单位);
  const 方向角 = 两点角度(铃仙X, 铃仙Y, 目标X, 目标Y);

  // 标记二段使用，35 秒后自动清除
  YDUserDataSetSafe("unit", 施法单位, "二段使用", "boolean", true);
  addDelayedCallback(35000, () => {
    YDUserDataSetSafe("unit", 施法单位, "二段使用", "boolean", false);
  });

  // 音效 + 蓄力特效（CharmTarget.mdl @1.8 倍速，1.5 秒销毁）
  // 施法音效（源 JASS：PlaySoundOnUnitBJ(gg_snd_LX_R, 100, 铃仙)）
  播放铃仙单位绑定音效(施法单位, "gg_snd_LX_R", 100);
  创建点特效({
    模型路径: cfg.R.蓄力特效模型,
    X: 铃仙X,
    Y: 铃仙Y,
    动画速度: cfg.R.蓄力特效速度,
    持续秒: cfg.R.蓄力特效持续秒,
  });

  // 动作 "spell one"，提供视野给中立敌对
  SetUnitAnimation(施法单位, "spell one");
  UnitShareVision(施法单位, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);

  // 目标点准心马甲（源 e03N）
  const 准心 = CreateUnit(玩家, 准心马甲ID, 目标X, 目标Y, 0);

  // 0.55 秒蓄力后创建弹幕并发射
  addDelayedCallback(Math.round(cfg.R.蓄力秒 * 1000), () => {
    UnitShareVision(施法单位, Player(PLAYER_NEUTRAL_AGGRESSIVE), false);
    播放铃仙配置动作(施法单位, -1, 1.0); // 恢复动画倍速
    开始发射弹幕(施法单位, 玩家, 方向角, 目标X, 目标Y, 准心);
  });
}

registerSpellEffectListener(on铃仙R生效);
registerSpellEffectListener(on铃仙R二段生效);

export {};
