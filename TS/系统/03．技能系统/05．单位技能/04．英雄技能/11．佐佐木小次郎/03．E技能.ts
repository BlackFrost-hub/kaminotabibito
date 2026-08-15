/** @noSelfInFile */

/**
 * 佐佐木小次郎 - E 止水（A0GV，引导 2 秒）
 *
 * 源 JASS：`主要技能.j` 触发 zzm-Q 的 A0GV 分支。
 * - 施法开始：嘲讽 350 码内敌人攻击自己一次（attackonce），并增加敌人 30% 嘲讽值
 * - 引导期间：减伤 50%（玩家属性「伤害减少」），头顶施法进度条（e01O，+233 飞行高度）
 * - 完整施法 2 秒：恢复 50% 生命值、12 秒内增加 14% 攻击、TX25 完成特效
 * - 任何方式施法失败（引导被打断）：技能冷却改为 4 秒
 *
 * 注意：止水持续走技能自身 2 秒施法时间，因此用准备阶段（CHANNEL）监听 +
 * `单位是否正在施法` 轮询判定引导是否被打断。
 */

import { 佐佐木单位技能配置 } from "./00．配置";
import { 是佐佐木本体 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 单位是否正在施法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  单位是否正在施法: (this: void, 单位: any) => boolean;
};
const { 调整玩家属性, 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
  临时调整攻击: (this: void, 单位: any, 数值: number) => void;
};
const { 读取单位攻击力, 读取单位最大生命, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { addThreat, getThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  addThreat: (this: void, 敌人: any, 仇恨目标: any, 数值: number) => void;
  getThreat: (this: void, 敌人: any, 仇恨目标: any) => number;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};

const E技能ID数值 = stringToFourCCSafe(佐佐木单位技能配置.E技能ID);
const 施法进度条ID = stringToFourCCSafe(佐佐木单位技能配置.E.施法进度条ID);

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, whichState: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, whichState: any, value: number) => void;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, model: string, unit: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => boolean;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

/** 止水结束：解除减伤、移除进度条，并按是否完整施法结算 */
function 结束止水(this: void, 英雄: any, 施法进度条: any, 是否完整施法: boolean): void {
  const cfg = 佐佐木单位技能配置.E;

  调整玩家属性(英雄, "伤害减少", -cfg.减伤比例);
  jass.SetUnitAnimation(英雄, "stand");
  SetUnitTimeScale(英雄, 1.0);
  if (施法进度条 != null && 施法进度条 !== 0) RemoveUnit(施法进度条);

  if (!是否完整施法) {
    // 施法失败：技能短暂冷却 4 秒
    YDWESetUnitAbilityStateSafe(英雄, E技能ID数值, 1, cfg.失败冷却秒);
    return;
  }

  // 完整施法：完成特效 + 恢复 50% 生命值
  const effect = AddSpecialEffectTarget(cfg.完成特效模型, 英雄, "origin");
  if (effect != null && effect !== 0) {
    addDelayedCallback(cfg.完成特效持续秒 * 1000, () => {
      DestroyEffect(effect);
    });
  }

  const 当前生命 = GetUnitState(英雄, UNIT_STATE_LIFE);
  const 最大生命 = 读取单位最大生命(英雄);
  const 新生命 = Math.min(最大生命, 当前生命 + 最大生命 * cfg.恢复生命比例);
  SetUnitState(英雄, UNIT_STATE_LIFE, 新生命);

  // 12 秒内增加 14% 攻击（到期减回）
  const 攻击加成 = Math.floor(读取单位攻击力(英雄) * cfg.增攻比例);
  if (攻击加成 > 0) {
    临时调整攻击(英雄, 攻击加成);
    addDelayedCallback(cfg.增攻持续秒 * 1000, () => {
      if (英雄 == null || 英雄 === 0) return;
      临时调整攻击(英雄, -攻击加成);
    });
  }
}

function on佐佐木E开始(this: void, 施法单位: any, 技能ID数值: number): void {
  if (!是佐佐木本体(施法单位)) return;
  if (技能ID数值 !== E技能ID数值) return;

  const cfg = 佐佐木单位技能配置.E;
  const 施法X = GetUnitX(施法单位);
  const 施法Y = GetUnitY(施法单位);

  // 嘲讽：350 码内敌人攻击自己一次，并增加 30% 嘲讽值
  const targets = getUnitsInRange(施法X, 施法Y, cfg.嘲讽范围);
  for (let i = 0; i < targets.length; i++) {
    const enemy = targets[i];
    if (enemy == null || enemy === 0) continue;
    if (!单位存活(enemy)) continue;
    if (jass.IsUnitType(enemy, jass.UNIT_TYPE_ANCIENT as any)) continue;
    if (jass.IsUnitType(enemy, jass.UNIT_TYPE_MECHANICAL as any)) continue;
    if (jass.IsUnitType(enemy, jass.UNIT_TYPE_STRUCTURE as any)) continue;
    if (!isUnitEnemy(enemy, 施法单位)) continue;

    IssueTargetOrder(enemy, "attackonce", 施法单位);
    const 当前嘲讽 = getThreat(enemy, 施法单位);
    if (当前嘲讽 > 0) addThreat(enemy, 施法单位, 当前嘲讽 * 0.3);
  }

  // t≈30ms：进度条 + 动作 + 减伤，开始 40ms 轮询引导状态
  addDelayedCallback(30, () => {
    if (!单位存活(施法单位)) return;

    jass.SetUnitAnimationByIndex(施法单位, 14);
    const 施法进度条 = CreateUnit(jass.Player(4), 施法进度条ID, GetUnitX(施法单位), GetUnitY(施法单位), 0);
    调整玩家属性(施法单位, "伤害减少", cfg.减伤比例);
    SetUnitTimeScale(施法进度条, 0.5);
    SetUnitFlyHeight(施法进度条, GetUnitDefaultFlyHeight(施法单位) + 233, 0);

    let 已引导毫秒 = 0;
    const 轮询ID = addPeriodicCallback(40, () => {
      if (施法单位 == null || 施法单位 === 0 || !单位存活(施法单位)) {
        removePeriodicCallback(轮询ID);
        if (施法进度条 != null && 施法进度条 !== 0) RemoveUnit(施法进度条);
        调整玩家属性(施法单位, "伤害减少", -cfg.减伤比例);
        return;
      }

      已引导毫秒 += 40;
      SetUnitX(施法进度条, GetUnitX(施法单位));
      SetUnitY(施法进度条, GetUnitY(施法单位));

      if (!单位是否正在施法(施法单位)) {
        removePeriodicCallback(轮询ID);
        结束止水(施法单位, 施法进度条, false);
        return;
      }
      if (已引导毫秒 >= cfg.止水持续秒 * 1000) {
        removePeriodicCallback(轮询ID);
        结束止水(施法单位, 施法进度条, true);
      }
    });
  });
}

registerSpellChannelListener(on佐佐木E开始);

export {};
