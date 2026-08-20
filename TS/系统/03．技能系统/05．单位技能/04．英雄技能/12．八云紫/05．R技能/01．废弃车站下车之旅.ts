/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import {
  八云紫单位存活,
  是八云紫,
  是八云紫合法敌人,
  获取范围内八云紫裂隙,
  创建八云紫裂隙,
  注册八云紫裂隙创建监听器,
  设置八云紫R期间D排斥豁免,
  type 八云紫裂隙记录,
} from "../07．公共与单位壳/01．裂隙系统";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 八云紫BuffID } from "../../../../../05．Buff系统/03．Buff表/02．英雄/14．八云紫";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 两点角度, 距离XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const 配置 = 八云紫单位技能配置;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_ROCK_HEAVY_BASH = jass.WEAPON_TYPE_ROCK_HEAVY_BASH as any;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const STUN_BUFF_ID = 1112757326; // 'BSTN'
const PSEUDO_STUN_BUFF_ID = 1112560453; // 'BPSE'
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (this: void, effect: any, size: number) => void;

interface 列车上下文 {
  英雄: any;
  上次X: number;
  上次Y: number;
  X: number;
  Y: number;
  方向角: number;
  方向弧度: number;
  剩余Tick: number;
  伤害: number;
  特效: any;
  周期ID: number;
  起点裂隙ID: number;
  允许触发二段: boolean;
  技能实例ID?: number;
  已结束: boolean;
}

interface R失败短冷却上下文 {
  英雄: any;
  技能ID: number;
  冷却秒: number;
  最大冷却: number;
}

interface 二段等待上下文 {
  英雄: any;
  进入裂隙: 八云紫裂隙记录;
  技能实例ID?: number;
  已结束: boolean;
}

const 二段等待表: Record<number, 二段等待上下文 | undefined> = {};

function 句柄ID(this: void, handle: any): number {
  return handle == null || handle === 0 ? 0 : jass.GetHandleId(handle);
}

function 结束列车(this: void, context: 列车上下文, 保留R期间D排斥豁免: boolean = false): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) removePeriodicCallback(context.周期ID);
  if (context.特效 != null && context.特效 !== 0) {
    // train1 销毁后会保留模型尾帧，先硬隐藏再释放句柄。
    EXSetEffectSize(context.特效, 0);
    DzSetEffectPos(context.特效, context.X, context.Y, -10000);
    销毁点特效(context.特效);
  }
  context.特效 = null;
  if (!保留R期间D排斥豁免) 设置八云紫R期间D排斥豁免(context.英雄, false);
}

function 清除二段等待(this: void, context: 二段等待上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  const heroId = 句柄ID(context.英雄);
  if (二段等待表[heroId] === context) delete 二段等待表[heroId];
  移除单位指定Buff(context.英雄, 八云紫BuffID.R二段窗口);
}

function 推动目标(this: void, target: any, directionRadians: number): void {
  const nextX = jass.GetUnitX(target) + Cos(directionRadians) * 配置.R.推动距离;
  const nextY = jass.GetUnitY(target) + Sin(directionRadians) * 配置.R.推动距离;
  if (jass.IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) === true) return;
  jass.SetUnitPosition(target, nextX, nextY);
}

function 拥有列车眩晕(this: void, target: any): boolean {
  return jass.GetUnitAbilityLevel(target, STUN_BUFF_ID) > 0
    || jass.GetUnitAbilityLevel(target, PSEUDO_STUN_BUFF_ID) > 0;
}

function 结算列车碰撞(this: void, context: 列车上下文): void {
  const targets = getEnemyUnitsInRange(context.英雄, context.X, context.Y, 配置.R.命中范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!是八云紫合法敌人(context.英雄, target)) continue;
    if (!拥有列车眩晕(target)) {
      施加眩晕(context.英雄, target, 配置.R.眩晕秒, "八云紫-R-废旧列车", "技能");
    }
    造成单体技能伤害({
      来源: context.英雄,
      目标: target,
      伤害: context.伤害,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_ROCK_HEAVY_BASH,
      来源类型: "单位技能",
      技能ID: 配置.技能.R.类型ID,
      技能实例ID: context.技能实例ID,
      标签: "八云紫-R-废旧列车碰撞",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
    if (拥有列车眩晕(target)) {
      推动目标(target, context.方向弧度);
      jass.SetUnitAnimation(target, "Death");
    }
  }
}

function 创建列车路径表现(this: void, context: 列车上下文): void {
  创建点特效({
    模型路径: 配置.R.路径特效A,
    X: context.X,
    Y: context.Y,
    持续秒: 配置.R.路径特效持续秒,
    缩放: 配置.R.路径特效A缩放,
  });
  创建点特效({
    模型路径: 配置.R.路径特效B,
    X: context.X,
    Y: context.Y,
    持续秒: 配置.R.路径特效持续秒,
    缩放: 配置.R.路径特效B缩放,
  });
}

function 创建二段列车(this: void, hero: any, gap: 八云紫裂隙记录, skillInstanceId?: number, 指定方向?: number): boolean {
  if (!八云紫单位存活(hero) || gap.已结束 || !八云紫单位存活(gap.单位)) {
    设置八云紫R期间D排斥豁免(hero, false);
    return false;
  }
  const gapX = jass.GetUnitX(gap.单位);
  const gapY = jass.GetUnitY(gap.单位);
  const direction = 指定方向 ?? 两点角度(jass.GetUnitX(hero), jass.GetUnitY(hero), gapX, gapY);
  启动列车(hero, gap, direction, false, skillInstanceId);
  return true;
}

function 二段窗口超时(this: void, variable?: any): void {
  const context = variable as 二段等待上下文 | undefined;
  if (context == null || context.已结束) return;
  清除二段等待(context);
  if (!八云紫单位存活(context.英雄)) {
    设置八云紫R期间D排斥豁免(context.英雄, false);
    return;
  }
  const heroX = jass.GetUnitX(context.英雄);
  const heroY = jass.GetUnitY(context.英雄);
  const heroFacing = jass.GetUnitFacing(context.英雄);
  const behindRadians = (heroFacing + 180) * bj_DEGTORAD;
  const targetX = heroX + Cos(behindRadians) * 配置.R.自动裂隙身后距离;
  const targetY = heroY + Sin(behindRadians) * 配置.R.自动裂隙身后距离;
  const gap = 创建八云紫裂隙(context.英雄, targetX, targetY, 配置.技能.R.类型ID, context.技能实例ID);
  if (gap == null || !创建二段列车(context.英雄, gap, context.技能实例ID, heroFacing)) {
    设置八云紫R期间D排斥豁免(context.英雄, false);
  }
}

function 开启二段窗口(this: void, hero: any, gap: 八云紫裂隙记录, skillInstanceId?: number): void {
  const heroId = 句柄ID(hero);
  const previous = 二段等待表[heroId];
  if (previous != null) 清除二段等待(previous);
  const context: 二段等待上下文 = {
    英雄: hero,
    进入裂隙: gap,
    技能实例ID: skillInstanceId,
    已结束: false,
  };
  二段等待表[heroId] = context;
  registerManualBuff(hero, 八云紫BuffID.R二段窗口, 配置.R.主动二段窗口秒, 0, {
    sourceUnit: hero,
    effectSourceName: "八云紫-R-废线二段窗口",
    effectSourceType: "技能",
  });
  addDelayedCallback(配置.R.主动二段窗口秒 * 1000, 二段窗口超时, context);
}

function 点到线段距离(this: void, px: number, py: number, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  const lengthSquared = dx * dx + dy * dy;
  if (lengthSquared <= 0.0001) return 距离XY(px, py, x1, y1);
  const rawT = ((px - x1) * dx + (py - y1) * dy) / lengthSquared;
  const t = rawT < 0 ? 0 : rawT > 1 ? 1 : rawT;
  const closestX = x1 + t * dx;
  const closestY = y1 + t * dy;
  return 距离XY(px, py, closestX, closestY);
}

function 查找列车经过的另一间隙(this: void, context: 列车上下文): 八云紫裂隙记录 | undefined {
  const stepDistance = 距离XY(context.上次X, context.上次Y, context.X, context.Y);
  const centerX = (context.上次X + context.X) * 0.5;
  const centerY = (context.上次Y + context.Y) * 0.5;
  const candidates = 获取范围内八云紫裂隙(
    centerX,
    centerY,
    配置.裂隙.扩散触发半径 + stepDistance * 0.5,
    context.英雄,
  );
  for (let i = 0; i < candidates.length; i++) {
    const gap = candidates[i];
    const gapId = 句柄ID(gap.单位);
    if (gapId === context.起点裂隙ID) continue;
    const gapX = jass.GetUnitX(gap.单位);
    const gapY = jass.GetUnitY(gap.单位);
    const distance = 点到线段距离(gapX, gapY, context.上次X, context.上次Y, context.X, context.Y);
    if (distance <= 配置.裂隙.扩散触发半径) return gap;
  }
  return undefined;
}

function 列车Tick(this: void, variable?: any): void {
  const context = variable as 列车上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!八云紫单位存活(context.英雄) || context.剩余Tick <= 0) {
    结束列车(context);
    return;
  }

  context.上次X = context.X;
  context.上次Y = context.Y;
  context.X += Cos(context.方向弧度) * 配置.R.列车每Tick距离;
  context.Y += Sin(context.方向弧度) * 配置.R.列车每Tick距离;
  context.剩余Tick -= 1;
  if (context.特效 != null && context.特效 !== 0) DzSetEffectPos(context.特效, context.X, context.Y, 0);
  创建列车路径表现(context);
  结算列车碰撞(context);

  if (context.允许触发二段) {
    const gap = 查找列车经过的另一间隙(context);
    if (gap != null) {
      结束列车(context, true);
      开启二段窗口(context.英雄, gap, context.技能实例ID);
      return;
    }
  }
  if (context.剩余Tick <= 0) 结束列车(context);
}

function 启动列车(
  this: void,
  hero: any,
  startGap: 八云紫裂隙记录,
  direction: number,
  canTriggerSecond: boolean,
  skillInstanceId?: number,
): void {
  const x = jass.GetUnitX(startGap.单位);
  const y = jass.GetUnitY(startGap.单位);
  设置八云紫R期间D排斥豁免(hero, true);
  const effect = 创建点特效({
    模型路径: 配置.R.列车模型,
    X: x,
    Y: y,
    面向角度: direction,
    缩放: 配置.R.列车缩放,
    红: 配置.R.列车颜色[0],
    绿: 配置.R.列车颜色[1],
    蓝: 配置.R.列车颜色[2],
    透明度: 配置.R.列车颜色[3],
  });
  创建点特效({
    模型路径: 配置.E.出现特效,
    X: x,
    Y: y,
    持续秒: 1.5,
    缩放: 2,
  });
  const context: 列车上下文 = {
    英雄: hero,
    上次X: x,
    上次Y: y,
    X: x,
    Y: y,
    方向角: direction,
    方向弧度: direction * bj_DEGTORAD,
    剩余Tick: 配置.R.列车Tick数,
    伤害: 读取单位攻击力(hero) * 配置.R.伤害攻击力比例,
    特效: effect,
    周期ID: 0,
    起点裂隙ID: 句柄ID(startGap.单位),
    允许触发二段: canTriggerSecond,
    技能实例ID: skillInstanceId,
    已结束: false,
  };
  context.周期ID = addPeriodicCallback(配置.R.列车Tick毫秒, 列车Tick, context);
}

function 选择目标裂隙(this: void, hero: any, targetX: number, targetY: number): 八云紫裂隙记录 | undefined {
  const gaps = 获取范围内八云紫裂隙(targetX, targetY, 配置.R.裂隙选择范围, hero);
  let selected: 八云紫裂隙记录 | undefined;
  let selectedDistance = 配置.R.裂隙选择范围 + 1;
  for (let i = 0; i < gaps.length; i++) {
    const distance = 距离XY(targetX, targetY, jass.GetUnitX(gaps[i].单位), jass.GetUnitY(gaps[i].单位));
    if (distance < selectedDistance) {
      selected = gaps[i];
      selectedDistance = distance;
    }
  }
  return selected;
}

function 延迟覆盖R失败短冷却(this: void, variable?: any): void {
  const context = variable as R失败短冷却上下文 | undefined;
  if (context == null || !八云紫单位存活(context.英雄)) return;
  const maximum = 技能_获取技能最大冷却时间(context.英雄, context.技能ID) || context.最大冷却 || context.冷却秒;
  技能_设置技能冷却时间(context.英雄, context.技能ID, context.冷却秒, maximum);
}

function 设置R失败短冷却(this: void, hero: any): void {
  const 技能ID = 配置.技能.R.类型ID;
  const 冷却秒 = 配置.R.无合法裂隙失败冷却秒;
  const 最大冷却 = 技能_获取技能最大冷却时间(hero, 技能ID) || 80;
  技能_设置技能冷却时间(hero, 技能ID, 冷却秒, 最大冷却);
  const context: R失败短冷却上下文 = { 英雄: hero, 技能ID, 冷却秒, 最大冷却 };
  addDelayedCallback(10, 延迟覆盖R失败短冷却, context);
}

function 获取R监听上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 释放R(this: void, _entry: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const targetX = jass.GetSpellTargetX();
  const targetY = jass.GetSpellTargetY();
  const gap = 选择目标裂隙(hero, targetX, targetY);
  if (gap == null) {
    jass.DisplayTimedTextToPlayer(jass.GetOwningPlayer(hero), 0, 0, 3, "目标位置附近没有可用的『间隙』。 ");
    设置R失败短冷却(hero);
    return;
  }
  let direction = 两点角度(jass.GetUnitX(gap.单位), jass.GetUnitY(gap.单位), targetX, targetY);
  if (距离XY(jass.GetUnitX(gap.单位), jass.GetUnitY(gap.单位), targetX, targetY) <= 1) direction = jass.GetUnitFacing(hero);
  启动列车(hero, gap, direction, true, skillInstanceId);
}

function 监听主动二段裂隙(
  this: void,
  hero: any,
  gap: 八云紫裂隙记录,
  skillId: number,
  _skillInstanceId?: number,
): void {
  if (skillId !== 配置.技能.D.类型ID) return;
  const context = 二段等待表[句柄ID(hero)];
  if (context == null || context.已结束) {
    return;
  }
  清除二段等待(context);
  if (!创建二段列车(hero, gap, context.技能实例ID)) 设置八云紫R期间D排斥豁免(hero, false);
}

注册单位技能壳监听({
  名称: "八云紫-废弃车站下车之旅（R）",
  单位类型ID: 配置.单位.英雄类型ID,
  技能ID: 配置.技能.R.类型ID,
  获取或创建上下文: 获取R监听上下文,
  释放技能: 释放R,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 8,
});
注册八云紫裂隙创建监听器(监听主动二段裂隙);

export {};
