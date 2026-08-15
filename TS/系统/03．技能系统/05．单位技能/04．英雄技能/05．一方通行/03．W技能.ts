/** @noSelfInFile */

import { 一方通行单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始击退, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 开始原地击飞 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统") as {
  开始原地击飞: (this: void, unit: any, params: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 施加减速, 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, ratio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
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
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const cfg = 一方通行单位技能配置;
const W配置 = cfg.W;
const 单位类型ID = stringToFourCCSafe(cfg.单位类型ID);
const W技能ID = stringToFourCCSafe(cfg.W技能ID);
const W二段技能ID = stringToFourCCSafe(cfg.W二段技能ID);
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT ?? jass.DAMAGE_TYPE_MAGIC;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const ResetUnitAnimation = jass.ResetUnitAnimation as (this: void, unit: any) => void;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const CreateDestructable = jass.CreateDestructable as (this: void, objectId: number, x: number, y: number, facing: number, scale: number, variation: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, destructable: any) => void;
const GetRandomReal = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进") as {
  沿角度步进直到地形阻挡: (this: void, params: any) => { 最终X: number; 最终Y: number; 实际步数: number; 是否提前停止: boolean };
};

interface 一方通行W上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  二段窗口中: boolean;
  方向角: number;
  目标X: number;
  目标Y: number;
  窗口回调ID: number;
  位移ID: number;
  二段回调ID: number;
  二段次数: number;
  已命中单位: Record<number, true | undefined>;
  暂停来源: string;
  碰撞已发生: boolean;
}

const 上下文表: Record<number, 一方通行W上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 获取W上下文(this: void, unit: any): 一方通行W上下文 | undefined {
  const id = 取单位ID(unit);
  return id === 0 ? undefined : 上下文表[id];
}

function 获取或创建W上下文(this: void, unit: any): 一方通行W上下文 | undefined {
  const id = 取单位ID(unit);
  if (id === 0) return undefined;
  const old = 上下文表[id];
  if (old != null) return old;
  const created: 一方通行W上下文 = {
    施法者: unit,
    已启动: false,
    二段窗口中: false,
    方向角: 0,
    目标X: 0,
    目标Y: 0,
    窗口回调ID: 0,
    位移ID: 0,
    二段回调ID: 0,
    二段次数: 0,
    已命中单位: {},
    暂停来源: `一方通行-W:${id}`,
    碰撞已发生: false,
  };
  上下文表[id] = created;
  return created;
}

function 删除W辅助状态(this: void, caster: any): void {
  jass.UnitRemoveAbility(caster, W二段技能ID);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), W技能ID, true);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), W二段技能ID, false);
}

function 清理W上下文(this: void, context: 一方通行W上下文): void {
  if (context.窗口回调ID !== 0) {
    removeDelayedCallback(context.窗口回调ID);
    context.窗口回调ID = 0;
  }
  if (context.位移ID !== 0) {
    停止位移(context.位移ID, "中断");
    context.位移ID = 0;
  }
  if (context.二段回调ID !== 0) {
    removePeriodicCallback(context.二段回调ID);
    context.二段回调ID = 0;
  }
  if (context.施法者 != null && context.施法者 !== 0) {
    移除单位暂停(context.施法者, context.暂停来源);
    删除W辅助状态(context.施法者);
    ResetUnitAnimation(context.施法者);
  }
  context.已启动 = false;
  context.二段窗口中 = false;
  const id = 取单位ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function W目标允许(this: void, caster: any, target: any): boolean {
  return 单位存活(target)
    && target !== caster
    && IsUnitEnemy(target, GetOwningPlayer(caster))
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE);
}

function W造成单体伤害(this: void, caster: any, target: any, damage: number, skillInstanceId?: number): void {
  if (!W目标允许(caster, target) || damage <= 0) return;
  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_PLANT,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID: skillInstanceId,
    标签: "一方通行-W-矢量操作",
    参与技能伤害加成: true,
  });
}

function W造成AOE伤害(this: void, caster: any, x: number, y: number, radius: number, damage: number, skillInstanceId?: number): void {
  const targets = 获取范围敌军(caster, x, y, radius);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_PLANT,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID: skillInstanceId,
    标签: "一方通行-W-范围矢量冲击",
    参与技能伤害加成: true,
    每目标处理器: (target: any) => W目标允许(caster, target) ? { 伤害: damage } : undefined,
  });
}

function 一方通行W单位目标结算(this: void, context: 一方通行W上下文, target: any): void {
  const caster = context.施法者;
  const damage = 读取单位攻击力(caster) * W配置.目标伤害攻击力倍率;
  W造成单体伤害(caster, target, damage, context.技能实例ID);
  if (context.碰撞已发生 && 单位存活(target)) {
    创建点特效({
      模型路径: W配置.碰撞特效模型,
      X: GetUnitX(target),
      Y: GetUnitY(target),
      Z: GetUnitFlyHeight(target),
      持续秒: 1,
    });
    W造成AOE伤害(
      caster,
      GetUnitX(target),
      GetUnitY(target),
      W配置.碰撞范围,
      读取单位攻击力(caster) * W配置.碰撞伤害攻击力倍率,
      context.技能实例ID,
    );
    施加眩晕(caster, target, W配置.目标眩晕秒, "一方通行-W-碰撞眩晕", "技能");
  }
}

function 一方通行W单位目标(this: void, context: 一方通行W上下文, target: any): void {
  const caster = context.施法者;
  context.已启动 = true;
  context.碰撞已发生 = false;
  Sound3DII_UnitPlayReuse(W配置.施法音效路径, caster, W配置.施法音效裁断距离);
  if (W目标允许(caster, target)) {
    施加减速(caster, target, W配置.目标减速比例, W配置.目标减速秒, "一方通行-W-目标减速", "技能");
  }
  context.位移ID = 开始击退(target, {
    来源单位: caster,
    距离: W配置.目标击退距离,
    持续时间: W配置.目标击退持续秒,
    检查地形: true,
    暂停单位: false,
    命中半径: W配置.目标碰撞半径,
    只命中敌人: true,
    命中后结束: true,
    命中回调: () => { context.碰撞已发生 = true; },
    撞墙回调: () => { context.碰撞已发生 = true; },
    结束回调: () => {
      context.位移ID = 0;
      一方通行W单位目标结算(context, target);
      清理W上下文(context);
    },
  });
  if (context.位移ID === 0) {
    一方通行W单位目标结算(context, target);
    清理W上下文(context);
  }
}

function 一方通行W地面单击(this: void, context: 一方通行W上下文): void {
  const caster = context.施法者;
  context.已启动 = true;
  Sound3DII_UnitPlayReuse(W配置.施法音效路径, caster, W配置.施法音效裁断距离);
  创建点特效({ 模型路径: W配置.单击雷霆特效模型, X: GetUnitX(caster), Y: GetUnitY(caster), Z: GetUnitFlyHeight(caster), 持续秒: 1 });
  创建点特效({ 模型路径: W配置.单击沙尘特效模型, X: GetUnitX(caster), Y: GetUnitY(caster), Z: GetUnitFlyHeight(caster), 缩放: 1.4, 持续秒: 1 });
  const targets = 获取范围敌军(caster, GetUnitX(caster), GetUnitY(caster), W配置.地面单击范围);
  const damage = 读取单位攻击力(caster) * W配置.地面单击伤害攻击力倍率;
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_PLANT,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID: context.技能实例ID,
    标签: "一方通行-W-地面单击",
    参与技能伤害加成: true,
    每目标处理器: (target: any) => W目标允许(caster, target) ? {
      伤害: damage,
      伤害类型: DAMAGE_TYPE_PLANT,
    } : undefined,
    每目标结算后处理器: (target: any) => {
      if (W目标允许(caster, target)) {
        开始原地击飞(target, {
          持续时间: W配置.地面击飞持续秒,
          最小高度: 25,
          最大高度: 25,
          持续特效模型: W配置.二段践踏特效模型,
          持续特效间隔: 0.2,
          暂停单位: true,
          主单位: caster,
        });
      }
    },
  });
  清理W上下文(context);
}

function 创建一方通行W地形(this: void, x: number, y: number): void {
  const destructable = CreateDestructable(stringToFourCCSafe(W配置.地形破坏物ID), x, y, GetRandomReal(0, 360), 1, 0);
  创建点特效({ 模型路径: W配置.二段践踏特效模型, X: x, Y: y, 持续秒: 1 });
  创建点特效({ 模型路径: W配置.单击雷霆特效模型, X: x, Y: y, 持续秒: 1 });
  if (destructable != null && destructable !== 0) {
    addDelayedCallback(5000, () => RemoveDestructable(destructable));
  }
}

function 一方通行W二段Tick(this: void, variable?: any): void {
  const context = variable as 一方通行W上下文 | undefined;
  if (context == null || !context.已启动 || !单位存活(context.施法者)) {
    if (context != null) 清理W上下文(context);
    return;
  }
  if (context.二段次数 >= W配置.二段循环次数) {
    清理W上下文(context);
    return;
  }
  const caster = context.施法者;
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const next = 沿角度步进直到地形阻挡({ 起点X: x, 起点Y: y, 角度度: context.方向角, 单步距离: W配置.二段每次移动距离, 步数: 1 });
  if (next.实际步数 <= 0) {
    清理W上下文(context);
    return;
  }
  jass.SetUnitX(caster, next.最终X);
  jass.SetUnitY(caster, next.最终Y);
  SetUnitFacing(caster, context.方向角);
  context.二段次数 += 1;
  if (context.二段次数 === 13 || context.二段次数 === 26 || context.二段次数 === 39) {
    创建一方通行W地形(next.最终X, next.最终Y);
  }
  const targets = 获取范围敌军(caster, next.最终X, next.最终Y, W配置.二段范围);
  const damage = 读取单位攻击力(caster) * W配置.二段伤害攻击力倍率;
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_PLANT,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID: context.技能实例ID,
    标签: "一方通行-W-地面双击",
    参与技能伤害加成: true,
    每目标处理器: (target: any) => {
      const id = 取单位ID(target);
      if (context.已命中单位[id] || !W目标允许(caster, target)) return undefined;
      context.已命中单位[id] = true;
      return { 伤害: damage };
    },
    每目标结算后处理器: (target: any) => {
      if (W目标允许(caster, target)) 施加减速(caster, target, W配置.二段减速比例, W配置.二段减速秒, "一方通行-W-双击减速", "技能");
    },
  });
}

function 一方通行W二段(this: void, context: 一方通行W上下文, caster: any): void {
  if (!context.二段窗口中 || context.已启动) return;
  if (context.窗口回调ID !== 0) {
    removeDelayedCallback(context.窗口回调ID);
    context.窗口回调ID = 0;
  }
  context.二段窗口中 = false;
  context.已启动 = true;
  context.二段次数 = 0;
  context.已命中单位 = {};
  const maxMana = jass.GetUnitState(caster, jass.UNIT_STATE_MAX_MANA) || 0;
  减少魔法值(caster, maxMana * W配置.二段追加魔耗比例, false, false);
  移除单位暂停(caster, context.暂停来源);
  添加单位暂停(caster, context.暂停来源);
  SetUnitAnimationByIndex(caster, 10);
  Sound3DII_UnitPlayReuse(W配置.施法音效路径, caster, W配置.施法音效裁断距离);
  删除W辅助状态(caster);
  context.二段回调ID = addPeriodicCallback(W配置.二段周期毫秒, 一方通行W二段Tick, context);
}

function 一方通行W单击窗口结束(this: void, variable?: any): void {
  const context = variable as 一方通行W上下文 | undefined;
  if (context == null || !context.二段窗口中 || context.已启动) return;
  context.窗口回调ID = 0;
  context.二段窗口中 = false;
  删除W辅助状态(context.施法者);
  一方通行W地面单击(context);
}

function 释放一方通行W(this: void, context: 一方通行W上下文, caster: any, skillInstanceId?: number): void {
  if (context.已启动 || context.二段窗口中) return;
  context.技能实例ID = skillInstanceId;
  const target = GetSpellTargetUnit();
  if (target != null && target !== 0) {
    if (W目标允许(caster, target)) 一方通行W单位目标(context, target);
    else 清理W上下文(context);
    return;
  }

  context.二段窗口中 = true;
  context.方向角 = 两点角度(GetUnitX(caster), GetUnitY(caster), GetSpellTargetX(), GetSpellTargetY());
  context.目标X = GetSpellTargetX();
  context.目标Y = GetSpellTargetY();
  添加单位暂停(caster, context.暂停来源);
  SetUnitAnimationByIndex(caster, 10);
  jass.UnitAddAbility(caster, W二段技能ID);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), W技能ID, false);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), W二段技能ID, true);
  context.窗口回调ID = addDelayedCallback(W配置.二段窗口秒 * 1000, 一方通行W单击窗口结束, context);
}

function 释放一方通行W二段(this: void, context: 一方通行W上下文, caster: any): void {
  一方通行W二段(context, caster);
}

function 一方通行W单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取W上下文(dyingUnit);
  if (context != null) 清理W上下文(context);
}

export function 注册一方通行W(this: void): void {
  注册单位技能壳监听({
    名称: "一方通行-矢量操作(W)",
    单位类型ID: cfg.单位类型ID,
    技能ID: cfg.W技能ID,
    获取或创建上下文: 获取或创建W上下文,
    释放技能: 释放一方通行W,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
  注册单位技能壳监听({
    名称: "一方通行-矢量操作二段(W)",
    单位类型ID: cfg.单位类型ID,
    技能ID: cfg.W二段技能ID,
    获取或创建上下文: 获取或创建W上下文,
    释放技能: 释放一方通行W二段,
    创建独立技能实例: false,
  });
  registerDeathListener(一方通行W单位死亡);
}

注册一方通行W();

export {};
