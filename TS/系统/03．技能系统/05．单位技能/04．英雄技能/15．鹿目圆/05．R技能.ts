/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import {
  是鹿目圆圆神,
  获取圆神剩余秒,
  结束鹿目圆圆神,
  设置鹿目圆圆环之理施法状态,
} from "./01．状态与被动";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始硬直, 施加单位控制负面效果免疫 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加单位控制负面效果免疫: (this: void, unit: any, duration: number, syncNative?: boolean) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, target: any, onlyPurgable?: boolean) => number;
};
const { 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 消耗单位全部当前魔法 } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  消耗单位全部当前魔法: (this: void, unit: any) => number;
};
const { 确保单位可设置飞行高度 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享") as {
  确保单位可设置飞行高度: (this: void, unit: any) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { 读取单位攻击力, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
// GetRandomDirectionDeg 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx as (this: void, unit: any, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const GetRandomReal = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const bj_DEGTORAD = (jass.bj_DEGTORAD ?? 0.017453292519943295) as number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const 配置 = 鹿目圆单位技能配置;

/** 播放地图预载全局音效（源 PlaySoundAtPointBJ gg_snd_*） */
function 播放R全局音效(this: void, soundKey: string): void {
  if (soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  jass.StartSound(sound);
}

interface R入口上下文 {
  施法者: any;
  目标X: number;
  目标Y: number;
  方向: number;
  距离: number;
  剩余圆神秒: number;
  攻击力快照: number;
}

interface R运行上下文 extends R入口上下文 {
  所有者: any;
  技能实例ID?: number;
  主箭: any;
  副箭: any;
  已移动距离: number;
  已结算Tick: number;
  /** 源 Func009Func002T 的 0.10s 延迟回调 */
  起手延迟ID: number;
  /** 上升阶段周期（源 Func001T：0.02s×90 上升 +7） */
  上升周期ID: number;
  上升次数: number;
  /** 圆神下降阶段周期（源 Func001Func006T：0.02s×22 下降 -28） */
  下降周期ID: number;
  下降次数: number;
  /** 双箭飞行周期（源 Func001Func001Func001Func008T：每 0.02s 移动 30） */
  弹道周期ID: number;
  /** 脉冲周期（源 Func001Func001Func001Func008Func001Func005T：0.1s×30） */
  脉冲周期ID: number;
  已结束: boolean;
}

function 移除单位壳(this: void, unit: any): void {
  if (unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0) RemoveUnit(unit);
}

function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 获取R入口(this: void, caster: any): R入口上下文 | undefined {
  if (!是鹿目圆圆神(caster)) return undefined;
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const distance = 两点距离(startX, startY, targetX, targetY);
  // 源：距离不足 500 时进入失败分支（提示 + 技能冷却重置），因此这里始终返回上下文
  return {
    施法者: caster,
    目标X: targetX,
    目标Y: targetY,
    方向: 两点角度(startX, startY, targetX, targetY),
    距离: distance,
    剩余圆神秒: 获取圆神剩余秒(caster),
    攻击力快照: 读取单位攻击力(caster),
  };
}

function 清理R(this: void, context: R运行上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.起手延迟ID !== 0) {
    removeDelayedCallback(context.起手延迟ID);
    context.起手延迟ID = 0;
  }
  if (context.上升周期ID !== 0) {
    removePeriodicCallback(context.上升周期ID);
    context.上升周期ID = 0;
  }
  if (context.下降周期ID !== 0) {
    removePeriodicCallback(context.下降周期ID);
    context.下降周期ID = 0;
  }
  if (context.弹道周期ID !== 0) {
    removePeriodicCallback(context.弹道周期ID);
    context.弹道周期ID = 0;
  }
  if (context.脉冲周期ID !== 0) {
    removePeriodicCallback(context.脉冲周期ID);
    context.脉冲周期ID = 0;
  }
  移除单位壳(context.主箭);
  移除单位壳(context.副箭);
  context.主箭 = null;
  context.副箭 = null;
  移除单位指定Buff(context.施法者, 鹿目圆BuffID.圆环之理);
  设置鹿目圆圆环之理施法状态(context.施法者, false);
  结束独立技能伤害实例(context.技能实例ID);
}

function 清理R脉冲箭(this: void, variable?: any): void {
  const data = variable as { unit: any } | undefined;
  if (data != null) 移除单位壳(data.unit);
}

function 创建R脉冲箭(this: void, context: R运行上下文): void {
  const angle = GetRandomDirectionDeg();
  const radius = GetRandomReal(50, 650);
  const radians = angle * bj_DEGTORAD;
  const x = context.目标X + radius * Cos(radians);
  const y = context.目标Y + radius * Sin(radians);
  // 源 Func005T：圆环之理矢=e01T 在随机创建点出现，并叠加 dtpink 特效 1.50s，动画索引 3
  const arrow = 创建单位并登记排泄安全(
    context.所有者,
    配置.单位壳.R脉冲箭,
    x,
    y,
    angle,
  );
  if (arrow == null || arrow === 0) {
    return;
  }
  SetUnitAnimationByIndex(arrow, 配置.R.脉冲箭动画索引);
  addDelayedCallback(配置.R.脉冲特效持续秒 * 1000, 清理R脉冲箭, { unit: arrow });
  创建点特效({
    模型路径: 配置.R.脉冲特效,
    X: x,
    Y: y,
    Z: 0,
    面向角度: angle,
    缩放: 1.0,
    持续秒: 配置.R.脉冲特效持续秒,
  });
}

function 是R基础有效目标(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && GetUnitTypeId(unit) !== 0
    && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是R敌方目标(this: void, unit: any, owner: any): boolean {
  return 是R基础有效目标(unit)
    && IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true
    && GetUnitFlyHeight(unit) <= 配置.R.敌方最大飞行高度
    && IsUnitEnemy(unit, owner) === true;
}

function 是R友方目标(this: void, unit: any, owner: any): boolean {
  return 是R基础有效目标(unit)
    && IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true
    && (IsUnitAlly(unit, owner) === true || IsUnitOwnedByPlayer(unit, owner) === true);
}

function 获取单位句柄ID列表(this: void, units: any[]): string {
  const ids: string[] = [];
  for (let i = 0; i < units.length; i++) ids.push(String(GetHandleId(units[i])));
  return ids.join(",");
}

function 结算R单次脉冲(this: void, context: R运行上下文): void {
  // 源 Func005T：每 tick StopSoundBJ + PlaySoundAtPointBJ(gg_snd_FrostArrowLaunch1)
  播放R全局音效(配置.R.脉冲音效键);
  创建R脉冲箭(context);
  const units = getUnitsInRange(context.目标X, context.目标Y, 配置.R.范围);
  const enemies: any[] = [];
  const allies: any[] = [];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (是R敌方目标(unit, context.所有者)) enemies.push(unit);
    else if (是R友方目标(unit, context.所有者)) allies.push(unit);
  }

  const multiplier = 1 + context.剩余圆神秒 / 20;
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: enemies,
    伤害: 0,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.R.类型ID,
    技能实例ID: context.技能实例ID,
    标签: "鹿目圆-R-圆环之理",
    参与技能伤害加成: true,
    每目标处理器: R敌方每目标处理,
    变量: { context, multiplier },
  });

  // 源 Func015A：友军每 tick 回满生命/魔法并驱散负面（UnitRemoveBuffsEx + 移除 MFXG）
  for (let i = 0; i < allies.length; i++) {
    const ally = allies[i];
    移除单位负面Buff(ally, false);
    doHeal({
      HealSource: context.施法者,
      HealTarget: ally,
      HealAmount: GetUnitStateJapi(ally, UNIT_STATE_MAX_LIFE),
      HealManaAmount: GetUnitStateJapi(ally, UNIT_STATE_MAX_MANA),
      ItemHeal: false,
      HealEffect: false,
      HealShowText: false,
      ManaEffect: false,
      ManaShowText: false,
    });
  }
}

function R敌方每目标处理(this: void, target: any, _index: number, variable?: any): any {
  const data = variable as { context: R运行上下文; multiplier: number } | undefined;
  if (data == null || !是R敌方目标(target, data.context.所有者)) return undefined;
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(target, UNIT_STATE_LIFE);
  const missingLife = maxLife > life ? maxLife - life : 0;
  const totalDamage = (
    data.context.攻击力快照 * 配置.R.攻击力比例
    + missingLife * 配置.R.已损失生命比例
  ) * data.multiplier;
  return { 伤害: totalDamage / 配置.R.Tick次数 };
}

function R结算Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.已结算Tick >= 配置.R.Tick次数) {
    清理R(context);
    return;
  }
  context.已结算Tick += 1;
  结算R单次脉冲(context);
  if (context.已结算Tick >= 配置.R.Tick次数) 清理R(context);
}

/** 源 Func001T：圆神上升循环，每 0.01s +7，90 次后停止并等待 1s 创建双箭 */
function R上升Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.上升次数 >= 配置.R.上升Tick次数) {
    removePeriodicCallback(context.上升周期ID);
    context.上升周期ID = 0;
    addDelayedCallback(配置.R.创建箭延迟毫秒, R创建双箭, context);
    return;
  }
  context.上升次数 += 1;
  SetUnitFlyHeight(context.施法者, GetUnitFlyHeight(context.施法者) + 配置.R.上升每Tick高度, 0);
}

/** 源 Func001Func001Func001T：上升完成 1s 后创建圆环之理特效(e01V)+圆环之理箭(e01U)，并启动箭飞行与圆神下降 */
function R创建双箭(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  const caster = context.施法者;
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const owner = context.所有者;
  const mainArrow = 创建单位并登记排泄安全(owner, 配置.单位壳.R主箭, startX, startY, context.方向);
  const subArrow = 创建单位并登记排泄安全(owner, 配置.单位壳.R副箭, startX, startY, context.方向);
  if (mainArrow == null || mainArrow === 0 || subArrow == null || subArrow === 0) {
    移除单位壳(mainArrow);
    移除单位壳(subArrow);
    清理R(context);
    return;
  }
  context.主箭 = mainArrow;
  context.副箭 = subArrow;
  context.已移动距离 = 0;

  SetUnitFacing(mainArrow, context.方向);
  SetUnitFlyHeight(mainArrow, 配置.R.主箭高度, 0);
  SetUnitScale(mainArrow, 配置.R.主箭缩放, 配置.R.主箭缩放, 配置.R.主箭缩放);
  SetUnitFacing(subArrow, context.方向);
  SetUnitFlyHeight(subArrow, 配置.R.副箭高度, 0);
  SetUnitScale(subArrow, 配置.R.副箭缩放, 配置.R.副箭缩放, 配置.R.副箭缩放);

  // 源 Func001Func001Func001T：同时启动 箭飞行(0.02s) 与 圆神下降(0.02s)
  context.弹道周期ID = addPeriodicCallback(配置.R.箭间隔毫秒, R弹道Tick, context);
  context.下降周期ID = addPeriodicCallback(配置.R.箭间隔毫秒, R下降Tick, context);
}

/** 源 Func001Func006T：箭飞行期间圆神每 0.02s 下降 -28，22 次后恢复默认高度。 */
function R下降Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.下降次数 >= 配置.R.下降Tick次数) {
    removePeriodicCallback(context.下降周期ID);
    context.下降周期ID = 0;
    SetUnitFlyHeight(context.施法者, GetUnitDefaultFlyHeight(context.施法者), 0);
    UnitRemoveBuffsEx(context.施法者, false, true, false, false, false, false, true);
    PauseUnit(context.施法者, false);
    return;
  }
  context.下降次数 += 1;
  SetUnitFlyHeight(context.施法者, GetUnitFlyHeight(context.施法者) - 配置.R.下降每Tick高度, 0);
}

function R弹道Tick(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.已移动距离 >= context.距离) {
    removePeriodicCallback(context.弹道周期ID);
    context.弹道周期ID = 0;
    移除单位壳(context.主箭);
    移除单位壳(context.副箭);
    context.主箭 = null;
    context.副箭 = null;
    // 源 Func001Func001Func001Func008T 到达分支：EC_CreateEffect MagicExplosion 缩放2.5 持续6.00
    创建点特效({
      模型路径: 配置.R.命中特效,
      X: context.目标X,
      Y: context.目标Y,
      Z: 0,
      面向角度: 270,
      缩放: 配置.R.命中特效缩放,
      持续秒: 6,
    });
    context.已结算Tick = 0;
    context.脉冲周期ID = addPeriodicCallback(配置.R.Tick间隔毫秒, R结算Tick, context);
    return;
  }

  const move = context.距离 - context.已移动距离 < 配置.R.箭步长
    ? context.距离 - context.已移动距离
    : 配置.R.箭步长;
  context.已移动距离 += move;
  const radians = context.方向 * bj_DEGTORAD;
  const x = GetUnitX(context.主箭) + move * Cos(radians);
  const y = GetUnitY(context.主箭) + move * Sin(radians);
  SetUnitX(context.主箭, x);
  SetUnitY(context.主箭, y);
  SetUnitX(context.副箭, x);
  SetUnitY(context.副箭, y);
}

/** 源 Func009Func002T：施法后 0.10s 清空魔法、启用飞行并开始升空。 */
function R开始处理(this: void, variable?: any): void {
  const context = variable as R运行上下文 | undefined;
  if (context == null || context.已结束) return;
  context.起手延迟ID = 0;
  消耗单位全部当前魔法(context.施法者);
  确保单位可设置飞行高度(context.施法者);
  context.上升周期ID = addPeriodicCallback(配置.R.上升间隔毫秒, R上升Tick, context);
}

function 释放R(this: void, entry: R入口上下文, caster: any, 技能实例ID?: number): void {
  // 源 A021：施法距离 < 500 → ResetUnitAnimation + 提示 + A021 加回移除重置冷却
  if (entry.距离 < 配置.R.最低施法距离) {
    SetUnitAnimation(caster, "stand");
    jass.DisplayTimedTextToPlayer(GetOwningPlayer(caster), 0, 0, 20, 配置.R.失败提示语);
    const maximum = 技能_获取技能最大冷却时间(caster, 配置.技能.R.类型ID) || 480;
    技能_设置技能冷却时间(caster, 配置.技能.R.类型ID, 0.01, maximum);
    结束独立技能伤害实例(技能实例ID);
    return;
  }

  const owner = GetOwningPlayer(caster);

  // 先锁定技能栏，再结束圆神；否则结束函数会把 A0FR/A01W 恢复到可见状态。
  设置鹿目圆圆环之理施法状态(caster, true);
  // 源 A021：成功施放后立即结束圆神；R 的独立上下文继续完成后续弹道和结算。
  结束鹿目圆圆神(caster, "施放圆环之理");
  const maximum = 技能_获取技能最大冷却时间(caster, 配置.技能.R.类型ID) || 配置.R.冷却秒;
  技能_设置技能冷却时间(caster, 配置.技能.R.类型ID, 配置.R.冷却秒, maximum);

  开始硬直(caster, 配置.R.起手硬直秒);
  SetUnitAnimation(caster, "spell");
  施加单位控制负面效果免疫(caster, 配置.R.施法控制免疫秒, true);
  registerManualBuff(caster, 鹿目圆BuffID.圆环之理, 配置.R.持续秒 + 配置.R.清蓝延迟毫秒 / 1000, 0, {
    sourceUnit: caster,
    stack: 1,
  });

  const context: R运行上下文 = {
    ...entry,
    所有者: owner,
    技能实例ID,
    主箭: null,
    副箭: null,
    已移动距离: 0,
    已结算Tick: 0,
    起手延迟ID: 0,
    上升周期ID: 0,
    上升次数: 0,
    下降周期ID: 0,
    下降次数: 0,
    弹道周期ID: 0,
    脉冲周期ID: 0,
    已结束: false,
  };
  // 源 Func002T → Func001T：0.10s 后开始上升循环（每 0.01s +7，共 90 次）
  context.起手延迟ID = addDelayedCallback(配置.R.清蓝延迟毫秒, R开始处理, context);
}

注册单位技能壳监听({
  名称: "鹿目圆-圆环之理",
  单位类型ID: 配置.单位.圆神类型ID,
  技能ID: 配置.技能.R.类型ID,
  获取或创建上下文: 获取R入口,
  释放技能: 释放R,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 12,
});

export {};
