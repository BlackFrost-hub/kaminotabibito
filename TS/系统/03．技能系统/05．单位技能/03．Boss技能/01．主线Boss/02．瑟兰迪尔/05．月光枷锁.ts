/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 获取或创建瑟兰迪尔上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 瑟兰迪尔单位技能配置 } from "./00．配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位句柄存在, 单位存活 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 播放限时单位动画 } from "../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建追踪插值轨迹: (this: void, 目标单位: any, 到达距离?: number) => any;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数: number | { 持续时间: number }) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: {
    sourceName?: string;
    iconOverride?: string;
    effectModelOverride?: string;
  }) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 创建瑟兰迪尔月光碎片 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.14．月光碎片") as {
  创建瑟兰迪尔月光碎片: (this: void, x: number, y: number) => any;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const R2I = jass.R2I as (value: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const UnitRemoveAbility = jass.UnitRemoveAbility as (unit: any, abilityId: number) => boolean;

const 瑟兰迪尔单位类型ID = stringToFourCC(瑟兰迪尔单位技能配置.单位ID);
const 月光枷锁技能ID = stringToFourCC(瑟兰迪尔数值与表现配置.月光枷锁.技能槽位);
let 月光枷锁已注册 = false;
const BJ_RADTODEG = 57.29577951308232;
const 月光枷锁根须BuffID = "C017";
const 月光枷锁原生根须Buff = 1111844210; // 'BEer'

interface 月光枷锁绑定记录 {
  来源单位: any;
  目标单位: any;
  已承受打断伤害: number;
}

const 月光枷锁绑定表: Record<number, 月光枷锁绑定记录 | undefined> = {};

function 播放月光枷锁施法动作(this: void, caster: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  开始硬直(caster, config.施法硬直秒);
  显示常规技能吟唱条({
    总时长: config.施法硬直秒,
    颜色ID: config.吟唱条颜色ID,
    标题文本: config.吟唱条标题文本,
    提示文本: config.吟唱条提示文本,
  });
  播放限时单位动画({
    单位: caster,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    持续秒: config.施法硬直秒,
    重播时点秒列表: [config.动画重播延迟Ms / 1000],
    恢复动画编号: config.恢复动画编号,
    恢复动画速度: config.恢复动画速度,
  });
}

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 发射月光枷锁弹幕(this: void, caster: any, target: any, context?: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  const targetId = GetHandleId(target);
  let 已命中 = false;

  function 月光枷锁弹幕目标筛选(this: void, 目标单位: any): boolean {
    return 单位有效(目标单位) && GetHandleId(目标单位) === targetId;
  }

  function 月光枷锁弹幕命中(this: void, 命中单位: any): void {
    if (已命中) return;
    已命中 = true;
    结算瑟兰迪尔月光枷锁命中(caster, 命中单位, context);
  }

  function 月光枷锁弹幕到达目标点(this: void): void {
    if (已命中 || !单位有效(target)) return;
    已命中 = true;
    结算瑟兰迪尔月光枷锁命中(caster, target, context);
  }

  创建原生弹幕({
    所有者: caster,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    方向角: GetUnitFacing(caster),
    指定目标: target,
    速度: config.飞行速度,
    轨迹采样器: 创建追踪插值轨迹(target, config.命中半径),
    命中半径: config.命中半径,
    生命周期: 3,
    最大距离: config.最大飞行距离,
    碰撞消失: true,
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    模型: config.飞行特效,
    附着特效模型: config.飞行特效,
    飞行高度: 80,
    影响目标: "全部",
    目标筛选: 月光枷锁弹幕目标筛选,
    on命中: 月光枷锁弹幕命中,
    on命中单位: 月光枷锁弹幕命中,
    on到达目标点: 月光枷锁弹幕到达目标点,
  });
}

function 播放月光枷锁命中特效(this: void, target: any): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  createTimedUnitEffect(target, "origin", config.命中特效, config.定身秒);
}

function 结算月光枷锁Tick伤害(this: void, caster: any, target: any, tickIndex: number, 记录: 月光枷锁绑定记录): void {
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  const targetId = GetHandleId(target);
  addDelayedCallback(R2I(config.Tick间隔秒 * tickIndex * 1000), function 月光枷锁Tick伤害回调(this: void): void {
    if (!单位有效(caster) || !单位有效(target)) return;
    if (月光枷锁绑定表[targetId] !== 记录) return;
    执行Boss单体技能伤害({
      技能ID: 月光枷锁技能ID,
      来源: caster,
      目标: target,
      伤害公式: {
        来源攻击力比例: config.Tick伤害Boss攻击力比例,
        目标最大生命比例: config.Tick伤害目标最大生命比例,
        总倍率: config.Tick伤害总倍率,
      },
      attack: false,
      ranged: false,
      attackType: jass.ATTACK_TYPE_NORMAL,
      伤害类型: jass.DAMAGE_TYPE_PLANT,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    });
  });
}

function 清理月光枷锁绑定记录(this: void, targetId: number, 记录: 月光枷锁绑定记录, 清理控制: boolean): boolean {
  if (月光枷锁绑定表[targetId] !== 记录) return false;
  delete 月光枷锁绑定表[targetId];
  if (清理控制) 清理月光枷锁控制(记录.目标单位);
  return true;
}

function 创建月光枷锁绑定记录(this: void, caster: any, target: any, context?: 瑟兰迪尔运行时上下文): 月光枷锁绑定记录 | undefined {
  if (!单位有效(caster) || !单位有效(target)) return undefined;
  if (context != null && context.清理.已清理()) return undefined;
  const targetId = GetHandleId(target);
  const 旧记录 = 月光枷锁绑定表[targetId];
  if (旧记录 != null) 清理月光枷锁绑定记录(targetId, 旧记录, true);
  const 记录: 月光枷锁绑定记录 = {
    来源单位: caster,
    目标单位: target,
    已承受打断伤害: 0,
  };
  月光枷锁绑定表[targetId] = 记录;
  if (context != null) {
    context.清理.登记清理("月光枷锁绑定", function 清理瑟兰迪尔月光枷锁绑定(this: void): void {
      清理月光枷锁绑定记录(targetId, 记录, true);
    });
  }
  return 记录;
}

function 打断月光枷锁并掉落碎片(this: void, target: any): boolean {
  if (!单位有效(target)) return false;
  const targetId = GetHandleId(target);
  const 记录 = 月光枷锁绑定表[targetId];
  if (记录 == null) return false;

  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  清理月光枷锁绑定记录(targetId, 记录, true);
  addDelayedCallback(0, function 延后一帧清理月光枷锁控制(this: void): void {
    清理月光枷锁控制(target);
  });
  addDelayedCallback(120, function 延迟清理月光枷锁控制(this: void): void {
    清理月光枷锁控制(target);
  });
  创建瑟兰迪尔月光碎片(GetUnitX(target), GetUnitY(target));
  return true;
}

function 清理月光枷锁控制(this: void, target: any): void {
  if (!单位句柄存在(target)) return;
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  移除单位指定Buff(target, config.BuffID);
  移除单位指定Buff(target, 月光枷锁根须BuffID);
  UnitRemoveAbility(target, 月光枷锁原生根须Buff);
}

function on月光枷锁承受伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (applied <= 0 || !单位有效(target) || !单位有效(attacker)) return;
  const targetId = GetHandleId(target);
  const 记录 = 月光枷锁绑定表[targetId];
  if (记录 == null) return;
  if (attacker === 记录.来源单位) return;

  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  记录.已承受打断伤害 += applied;
  if (记录.已承受打断伤害 >= config.打断所需伤害) {
    打断月光枷锁并掉落碎片(target);
  }
}

export function 释放瑟兰迪尔月光枷锁(this: void, _context: 瑟兰迪尔运行时上下文, _target: any): void {
  释放瑟兰迪尔月光枷锁效果(_context.Boss单位, _target, _context);
}

export function 释放瑟兰迪尔月光枷锁效果(this: void, caster: any, target: any, context?: 瑟兰迪尔运行时上下文): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  播放瑟兰迪尔台词(caster, "月光枷锁");
  让单位面向目标(caster, target);
  播放月光枷锁施法动作(caster);
  addDelayedCallback(R2I(config.施法硬直秒 * 1000), function 瑟兰迪尔月光枷锁吟唱完成发射(this: void): void {
    关闭吟唱条("常规技能");
    if (!单位有效(caster) || !单位有效(target)) return;
    让单位面向目标(caster, target);
    SetUnitTimeScale(caster, config.恢复动画速度);
    SetUnitAnimationByIndex(caster, config.恢复动画编号);
    发射月光枷锁弹幕(caster, target, context);
  });
}

function 结算瑟兰迪尔月光枷锁命中(this: void, caster: any, target: any, context?: 瑟兰迪尔运行时上下文): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const config = 瑟兰迪尔数值与表现配置.月光枷锁;
  const 记录 = 创建月光枷锁绑定记录(caster, target, context);
  if (记录 == null) return;
  const targetId = GetHandleId(target);
  Sound3DII_CooPlayReuse(config.命中音效, GetUnitX(target), GetUnitY(target), 0, config.命中音效裁断距离);
  播放月光枷锁命中特效(target);
  施加扩展控制(caster, target, "roots", { 持续时间: config.定身秒 });
  registerManualBuff(target, config.BuffID, config.定身秒, 0, {
    sourceName: GetUnitName(caster),
    iconOverride: "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
    effectModelOverride: config.命中特效,
  });
  for (let i = 1; i <= config.定身秒; i++) {
    结算月光枷锁Tick伤害(caster, target, i, 记录);
  }
  addDelayedCallback(R2I(config.定身秒 * 1000) + 1, function 月光枷锁自然到期清理(this: void): void {
    清理月光枷锁绑定记录(targetId, 记录, true);
  });
}

export function 立即打断瑟兰迪尔月光枷锁(this: void, caster: any, target: any): boolean {
  if (!单位有效(caster) || !单位有效(target)) return false;
  if (月光枷锁绑定表[GetHandleId(target)] == null) {
    结算瑟兰迪尔月光枷锁命中(caster, target);
  }
  return 打断月光枷锁并掉落碎片(target);
}

function on瑟兰迪尔月光枷锁生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 月光枷锁技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 瑟兰迪尔单位类型ID) return;
  const target = GetSpellTargetUnit();
  const context = 获取或创建瑟兰迪尔上下文(castingUnit);
  if (context == null) return;
  释放瑟兰迪尔月光枷锁效果(castingUnit, target, context);
}

export function 注册瑟兰迪尔月光枷锁(this: void): void {
  if (月光枷锁已注册) return;
  月光枷锁已注册 = true;
  注册单位技能壳监听({
    名称: "瑟兰迪尔月光枷锁",
    单位类型ID: 瑟兰迪尔单位类型ID,
    技能ID: 月光枷锁技能ID,
    获取或创建上下文: 获取或创建瑟兰迪尔上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 瑟兰迪尔运行时上下文, boss: any): void {
      on瑟兰迪尔月光枷锁生效(boss, 月光枷锁技能ID);
    },
  });
  registerAppliedFinalDamageListener(on月光枷锁承受伤害);
}
