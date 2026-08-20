/** @noSelfInFile */

import { 一方通行单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力, 取单位ID } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { 开始充能, 停止充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止充能: (this: void, chargeId: number) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const cfg = 一方通行单位技能配置;
const D配置 = cfg.D;
const D技能ID = stringToFourCCSafe(cfg.D技能ID);
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;

interface 一方通行D上下文 {
  施法者: any;
  技能实例ID?: number;
  充能ID: number;
  蓄力次数: number;
  目标X: number;
  目标Y: number;
  已结算: boolean;
  蓄力持续特效: any;
}

const 上下文表: Record<number, 一方通行D上下文 | undefined> = {};

function 获取D上下文(this: void, unit: any): 一方通行D上下文 | undefined {
  const id = 取单位ID(unit);
  return id === 0 ? undefined : 上下文表[id];
}

function 获取或创建D上下文(this: void, unit: any): 一方通行D上下文 | undefined {
  const id = 取单位ID(unit);
  if (id === 0) return undefined;
  const old = 上下文表[id];
  if (old != null) return old;
  const created: 一方通行D上下文 = {
    施法者: unit,
    充能ID: 0,
    蓄力次数: 0,
    目标X: 0,
    目标Y: 0,
    已结算: false,
    蓄力持续特效: null,
  };
  上下文表[id] = created;
  return created;
}

function D目标允许(this: void, caster: any, target: any): boolean {
  return 单位存活(target)
    && IsUnitEnemy(target, GetOwningPlayer(caster))
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL);
}

function 清理D上下文(this: void, context: 一方通行D上下文): void {
  if (context.蓄力持续特效 != null && context.蓄力持续特效 !== 0) {
    销毁点特效(context.蓄力持续特效);
    context.蓄力持续特效 = null;
  }
  const id = 取单位ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 一方通行D蓄力Tick(this: void, unit: any, chargeId: number): void {
  const context = 获取D上下文(unit);
  if (context == null || context.充能ID !== chargeId || context.已结算) return;
  if (context.蓄力次数 >= D配置.最大蓄力次数) {
    停止充能(chargeId);
    return;
  }
  const maxMana = GetUnitState(unit, UNIT_STATE_MAX_MANA) || 0;
  const requested = maxMana * D配置.每次魔耗比例;
  const actual = 减少魔法值(unit, requested, false, false);
  if (!(actual < 0)) {
    停止充能(chargeId);
    return;
  }
  context.蓄力次数 += 1;
  创建点特效({
    模型路径: D配置.蓄力脉冲特效模型,
    X: GetUnitX(unit),
    Y: GetUnitY(unit),
    Z: GetUnitFlyHeight(unit) + D配置.特效Z偏移,
    缩放: D配置.蓄力脉冲特效缩放,
    持续秒: 0.2,
  });
  if (context.蓄力次数 >= D配置.最大蓄力次数) 停止充能(chargeId);
}

function D区域结算(this: void, context: 一方通行D上下文): void {
  if (context.蓄力次数 <= 0 || !单位存活(context.施法者)) return;
  const caster = context.施法者;
  const totalDamage = 读取单位攻击力(caster)
    * D配置.最大伤害攻击力倍率
    * (context.蓄力次数 / D配置.最大蓄力次数);
  if (totalDamage <= 0) return;
  const damage = totalDamage / D配置.结算次数;
  const targets = 获取范围敌军(caster, context.目标X, context.目标Y, D配置.伤害范围);
  创建点特效({
    模型路径: D配置.爆炸特效模型,
    X: context.目标X,
    Y: context.目标Y,
    Z: GetUnitFlyHeight(caster) + D配置.特效Z偏移,
    缩放: D配置.爆炸特效缩放,
    持续秒: D配置.特效持续秒,
  });
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: D技能ID,
    技能实例ID: context.技能实例ID,
    标签: "一方通行-D-等离子能量炮",
    参与技能伤害加成: true,
    每目标处理器: (target: any) => D目标允许(caster, target) ? { 伤害: damage } : undefined,
  });
}

function 一方通行D结算Tick(this: void, variable?: any): void {
  const data = variable as { context: 一方通行D上下文; 当前次数: number } | undefined;
  if (data == null) return;
  const context = data.context;
  const 当前次数 = data.当前次数;
  if (!单位存活(context.施法者)) return;
  D区域结算(context);
  if (当前次数 >= D配置.结算次数 - 1) return;
  addDelayedCallback(D配置.结算周期毫秒, 一方通行D结算Tick, { context, 当前次数: 当前次数 + 1 });
}

function 一方通行D结束(this: void, unit: any, _reason: string, chargeId: number): void {
  const context = 获取D上下文(unit);
  if (context == null || context.充能ID !== chargeId || context.已结算) return;
  context.已结算 = true;
  清理D上下文(context);
  addDelayedCallback(0, 一方通行D结算Tick, { context, 当前次数: 0 });
}

function 一方通行D开始(this: void, unit: any, chargeId: number): void {
  const context = 获取D上下文(unit);
  if (context == null) return;
  context.蓄力持续特效 = 创建点特效({
    模型路径: D配置.蓄力持续特效模型,
    X: GetUnitX(unit),
    Y: GetUnitY(unit),
    Z: GetUnitFlyHeight(unit) + D配置.特效Z偏移,
    缩放: D配置.蓄力持续特效缩放,
  });
  Sound3DII_UnitPlayReuse(D配置.施法音效路径, unit, D配置.施法音效裁断距离);
  Sound3DII_UnitPlayReuse(D配置.环境音效路径, unit, D配置.环境音效裁断距离);
}

function 释放一方通行D(this: void, context: 一方通行D上下文, caster: any, skillInstanceId?: number): void {
  if (context.充能ID !== 0) return;
  context.技能实例ID = skillInstanceId;
  context.蓄力次数 = 0;
  context.目标X = GetSpellTargetX();
  context.目标Y = GetSpellTargetY();
  context.已结算 = false;
  context.充能ID = 开始充能(caster, {
    持续时间: D配置.施法持续秒,
    强制硬直: false,
    指令中断: true,
    显示进度条特效: true,
    开始回调: 一方通行D开始,
    周期回调间隔: D配置.蓄力周期毫秒 / 1000,
    周期回调: (unit: any, chargeId: number) => 一方通行D蓄力Tick(unit, chargeId),
    结束回调: 一方通行D结束,
  });
  if (context.充能ID === 0) {
    清理D上下文(context);
  }
}

export function 注册一方通行D(this: void): void {
  注册单位技能壳监听({
    名称: "一方通行-等离子能量炮(D)",
    单位类型ID: cfg.单位类型ID,
    技能ID: cfg.D技能ID,
    获取或创建上下文: 获取或创建D上下文,
    释放技能: 释放一方通行D,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: D配置.施法持续秒 + 3,
  });
}

注册一方通行D();

export {};
