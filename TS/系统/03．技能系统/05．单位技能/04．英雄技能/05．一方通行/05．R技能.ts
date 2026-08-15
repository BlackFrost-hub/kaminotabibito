/** @noSelfInFile */

import { 一方通行单位技能配置 } from "./00．配置";
import { 一方通行BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/07．一方通行";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位最大生命 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, name?: string, type?: "装备" | "技能", displayBuffID?: string) => void;
};
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, target: any, buffID: string) => any;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getObjectPropertyRealSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number, property: string) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const cfg = 一方通行单位技能配置;
const R配置 = cfg.R;
const R技能ID = stringToFourCCSafe(cfg.R技能ID);
const 单位类型ID = stringToFourCCSafe(cfg.单位类型ID);
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const AddLightning = jass.AddLightning as (this: void, code: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const DestroyLightning = jass.DestroyLightning as (this: void, lightning: any) => void;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

interface 一方通行R上下文 {
  施法者: any;
  目标: any;
  技能实例ID?: number;
  目标X: number;
  目标Y: number;
  总伤害: number;
  当前次数: number;
  周期回调ID: number;
  已启动: boolean;
  施法者暂停来源: string;
  目标暂停来源: string;
}

const 上下文表: Record<number, 一方通行R上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 获取R上下文(this: void, unit: any): 一方通行R上下文 | undefined {
  const id = 取单位ID(unit);
  return id === 0 ? undefined : 上下文表[id];
}

function 获取或创建R上下文(this: void, unit: any): 一方通行R上下文 | undefined {
  const id = 取单位ID(unit);
  if (id === 0) return undefined;
  const old = 上下文表[id];
  if (old != null) return old;
  const created: 一方通行R上下文 = {
    施法者: unit,
    目标: null,
    目标X: 0,
    目标Y: 0,
    总伤害: 0,
    当前次数: 0,
    周期回调ID: 0,
    已启动: false,
    施法者暂停来源: `一方通行-R-施法者:${id}`,
    目标暂停来源: `一方通行-R-目标:${id}`,
  };
  上下文表[id] = created;
  return created;
}

function R目标允许(this: void, caster: any, target: any): boolean {
  return 单位存活(target)
    && target !== caster
    && IsUnitEnemy(target, GetOwningPlayer(caster))
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE);
}

function 目标模型缩放(this: void, target: any): number {
  const value = getObjectPropertyRealSafe(2, GetUnitTypeId(target), "modelScale");
  return value > 0 ? value : 1;
}

function 创建R目标特效(this: void, target: any, modelPath: string, duration: number): void {
  if (!单位存活(target)) return;
  创建点特效({
    模型路径: modelPath,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    Z: GetUnitFlyHeight(target),
    缩放: 目标模型缩放(target),
    持续秒: duration,
  });
}

function 创建R闪电(this: void, caster: any, target: any): void {
  const lightning = AddLightning(R配置.闪电特效模型, false, GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target));
  if (lightning != null && lightning !== 0) {
    addDelayedCallback(100, () => DestroyLightning(lightning));
  }
}

function 清理R上下文(this: void, context: 一方通行R上下文, 施加后续虚弱: boolean): void {
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.施法者 != null && context.施法者 !== 0) {
    移除单位暂停(context.施法者, context.施法者暂停来源);
    SetUnitTimeScale(context.施法者, 1);
    if (单位存活(context.施法者)) SetUnitAnimationByIndex(context.施法者, 0);
  }
  if (context.目标 != null && context.目标 !== 0) {
    移除单位暂停(context.目标, context.目标暂停来源);
    SetUnitTimeScale(context.目标, 1);
  }
  if (施加后续虚弱 && R目标允许(context.施法者, context.目标)) {
    SFB_setSlow(
      context.施法者,
      context.目标,
      R配置.后续减速比例,
      R配置.后续减速比例,
      R配置.后续虚弱持续秒,
      "一方通行-血液逆流",
      "技能",
      一方通行BuffID.血液逆流虚弱,
    );
    创建R目标特效(context.目标, R配置.目标血液特效2模型, 0.5);
    创建R目标特效(context.目标, R配置.目标血液特效3模型, 0.5);
  }
  const id = 取单位ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
  context.已启动 = false;
}

function 一方通行R周期Tick(this: void, variable?: any): void {
  const context = variable as 一方通行R上下文 | undefined;
  if (context == null || !context.已启动) return;
  if (!R目标允许(context.施法者, context.目标) || context.当前次数 >= R配置.伤害次数) {
    清理R上下文(context, R目标允许(context.施法者, context.目标));
    return;
  }
  SetUnitX(context.目标, context.目标X);
  SetUnitY(context.目标, context.目标Y);
  context.当前次数 += 1;
  创建R闪电(context.施法者, context.目标);
  造成单体技能伤害({
    来源: context.施法者,
    目标: context.目标,
    伤害: context.总伤害 / R配置.伤害次数,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能ID,
    技能实例ID: context.技能实例ID,
    标签: "一方通行-R-血液逆流",
    参与技能伤害加成: true,
  });
  创建R目标特效(context.目标, R配置.目标血液特效模型, 0.5);
  if (context.当前次数 === 10) SetUnitAnimationByIndex(context.施法者, 0);
  if (context.当前次数 === 20) SetUnitAnimationByIndex(context.施法者, 1);
  if (context.当前次数 === 25) {
    SetUnitAnimation(context.目标, "death");
    SetUnitTimeScale(context.目标, 1.8);
  }
  if (context.当前次数 >= R配置.伤害次数) {
    清理R上下文(context, true);
  }
}

function 释放一方通行R(this: void, context: 一方通行R上下文, caster: any, skillInstanceId?: number): void {
  if (context.已启动) return;
  const target = GetSpellTargetUnit();
  if (!R目标允许(caster, target)) return;
  const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE) || 0;
  const life = GetUnitState(target, UNIT_STATE_LIFE) || 0;
  context.技能实例ID = skillInstanceId;
  context.目标 = target;
  context.目标X = GetUnitX(target);
  context.目标Y = GetUnitY(target);
  context.总伤害 = Math.max(0, maxLife - life) * R配置.目标已损失生命总倍率;
  context.当前次数 = 0;
  context.已启动 = true;
  const maxMana = GetUnitState(caster, jass.UNIT_STATE_MAX_MANA) || 0;
  减少魔法值(caster, maxMana * R配置.百分比魔耗比例, false, false);
  添加单位暂停(caster, context.施法者暂停来源);
  添加单位暂停(target, context.目标暂停来源);
  SetUnitAnimationByIndex(caster, 0);
  Sound3DII_UnitPlayReuse(R配置.施法音效路径, caster, R配置.施法音效裁断距离);
  context.周期回调ID = addPeriodicCallback(R配置.伤害周期毫秒, 一方通行R周期Tick, context);
}

function 一方通行R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const casterId = 取单位ID(dyingUnit);
  const ownContext = 上下文表[casterId];
  if (ownContext != null) {
    清理R上下文(ownContext, false);
    return;
  }
  for (const key in 上下文表) {
    const context = 上下文表[Number(key)];
    if (context != null && context.目标 === dyingUnit) {
      清理R上下文(context, false);
      return;
    }
  }
}

function 一方通行R伤害修正(this: void, context: any): number {
  if (context == null || context.attacker == null || context.attacker === 0) return context?.currentDamage ?? 0;
  if (getBuffRuntime(context.attacker, 一方通行BuffID.血液逆流虚弱) == null) return context.currentDamage;
  return context.currentDamage * (1 - R配置.后续造成伤害降低比例);
}

export function 注册一方通行R(this: void): void {
  注册单位技能壳监听({
    名称: "一方通行-血液逆流(R)",
    单位类型ID: cfg.单位类型ID,
    技能ID: cfg.R技能ID,
    获取或创建上下文: 获取或创建R上下文,
    释放技能: 释放一方通行R,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 7,
  });
  registerDamageModifier(一方通行R伤害修正, 70);
  registerDeathListener(一方通行R单位死亡);
}

注册一方通行R();

export {};
