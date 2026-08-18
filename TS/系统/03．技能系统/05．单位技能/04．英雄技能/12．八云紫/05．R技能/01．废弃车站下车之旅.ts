/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import {
  八云紫单位存活,
  是八云紫,
  是八云紫合法敌人,
  查找八云紫裂隙,
  获取范围内八云紫裂隙,
  创建八云紫裂隙,
  注册八云紫裂隙创建监听器,
  type 八云紫裂隙记录,
} from "../07．公共与单位壳/01．裂隙系统";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 八云紫诊断日志, 八云紫诊断句柄 } from "../00B．诊断";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
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

function 结束列车(this: void, context: 列车上下文): void {
  if (context.已结束) return;
  八云紫诊断日志("R", "结束列车", "英雄", 八云紫诊断句柄(context.英雄), "X", context.X, "Y", context.Y, "剩余Tick", context.剩余Tick, "允许二段", context.允许触发二段);
  context.已结束 = true;
  if (context.周期ID !== 0) removePeriodicCallback(context.周期ID);
  if (context.特效 != null && context.特效 !== 0) {
    // train1 销毁后会保留模型尾帧，先硬隐藏再释放句柄。
    EXSetEffectSize(context.特效, 0);
    DzSetEffectPos(context.特效, context.X, context.Y, -10000);
    销毁点特效(context.特效);
  }
  context.特效 = null;
}

function 清除二段等待(this: void, context: 二段等待上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  const heroId = 句柄ID(context.英雄);
  if (二段等待表[heroId] === context) delete 二段等待表[heroId];
  八云紫诊断日志("R", "清除二段等待", "英雄", heroId, "进入裂隙", 八云紫诊断句柄(context.进入裂隙.单位));
}

function 推动目标(this: void, target: any, directionRadians: number): void {
  const nextX = jass.GetUnitX(target) + Math.cos(directionRadians) * 配置.R.推动距离;
  const nextY = jass.GetUnitY(target) + Math.sin(directionRadians) * 配置.R.推动距离;
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

function 创建二段列车(this: void, hero: any, gap: 八云紫裂隙记录, skillInstanceId?: number): void {
  if (!八云紫单位存活(hero) || gap.已结束 || !八云紫单位存活(gap.单位)) return;
  const gapX = jass.GetUnitX(gap.单位);
  const gapY = jass.GetUnitY(gap.单位);
  const direction = 两点角度(jass.GetUnitX(hero), jass.GetUnitY(hero), gapX, gapY);
  启动列车(hero, gap, direction, false, skillInstanceId);
}

function 二段窗口超时(this: void, variable?: any): void {
  const context = variable as 二段等待上下文 | undefined;
  if (context == null || context.已结束) return;
  八云紫诊断日志("R", "二段窗口超时", "英雄", 八云紫诊断句柄(context.英雄), "进入裂隙", 八云紫诊断句柄(context.进入裂隙.单位));
  清除二段等待(context);
  if (!八云紫单位存活(context.英雄)) return;
  const heroX = jass.GetUnitX(context.英雄);
  const heroY = jass.GetUnitY(context.英雄);
  const behindRadians = (jass.GetUnitFacing(context.英雄) + 180) * Math.PI / 180;
  const targetX = heroX + Math.cos(behindRadians) * 配置.R.自动裂隙身后距离;
  const targetY = heroY + Math.sin(behindRadians) * 配置.R.自动裂隙身后距离;
  const gap = 创建八云紫裂隙(context.英雄, targetX, targetY, 配置.技能.R.类型ID, context.技能实例ID);
  八云紫诊断日志("R", "超时自动创建身后间隙", "请求X", targetX, "请求Y", targetY, "间隙", gap != null ? 八云紫诊断句柄(gap.单位) : 0);
  if (gap != null) 创建二段列车(context.英雄, gap, context.技能实例ID);
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
  八云紫诊断日志("R", "开启二段窗口", "英雄", heroId, "进入裂隙", 八云紫诊断句柄(gap.单位), "窗口秒", 配置.R.主动二段窗口秒);
  addDelayedCallback(配置.R.主动二段窗口秒 * 1000, 二段窗口超时, context);
}

function 列车Tick(this: void, variable?: any): void {
  const context = variable as 列车上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!八云紫单位存活(context.英雄) || context.剩余Tick <= 0) {
    结束列车(context);
    return;
  }

  context.X += Math.cos(context.方向弧度) * 配置.R.列车每Tick距离;
  context.Y += Math.sin(context.方向弧度) * 配置.R.列车每Tick距离;
  context.剩余Tick -= 1;
  if (context.剩余Tick === 配置.R.列车Tick数 - 1 || context.剩余Tick % 10 === 0) {
    八云紫诊断日志("R", "列车Tick", "英雄", 八云紫诊断句柄(context.英雄), "X", context.X, "Y", context.Y, "剩余Tick", context.剩余Tick, "特效有效", context.特效 != null && context.特效 !== 0);
  }
  if (context.特效 != null && context.特效 !== 0) DzSetEffectPos(context.特效, context.X, context.Y, 0);
  创建列车路径表现(context);
  结算列车碰撞(context);

  if (context.允许触发二段) {
    const gap = 查找八云紫裂隙(context.X, context.Y, 配置.裂隙.扩散触发半径, context.英雄);
    if (gap != null && 句柄ID(gap.单位) !== context.起点裂隙ID) {
      八云紫诊断日志("R", "列车进入另一间隙", "列车X", context.X, "列车Y", context.Y, "起点裂隙", context.起点裂隙ID, "命中裂隙", 八云紫诊断句柄(gap.单位));
      结束列车(context);
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
    X: x,
    Y: y,
    方向角: direction,
    方向弧度: direction * Math.PI / 180,
    剩余Tick: 配置.R.列车Tick数,
    伤害: 读取单位攻击力(hero) * 配置.R.伤害攻击力比例,
    特效: effect,
    周期ID: 0,
    起点裂隙ID: 句柄ID(startGap.单位),
    允许触发二段: canTriggerSecond,
    技能实例ID: skillInstanceId,
    已结束: false,
  };
  八云紫诊断日志("R", "启动列车", "英雄", 八云紫诊断句柄(hero), "起点裂隙", 八云紫诊断句柄(startGap.单位), "起点X", x, "起点Y", y, "方向角", direction, "允许二段", canTriggerSecond, "伤害", context.伤害, "特效有效", effect != null && effect !== 0, "Tick数", 配置.R.列车Tick数);
  context.周期ID = addPeriodicCallback(配置.R.列车Tick毫秒, 列车Tick, context);
}

function 选择目标裂隙(this: void, hero: any, targetX: number, targetY: number): 八云紫裂隙记录 | undefined {
  const gaps = 获取范围内八云紫裂隙(targetX, targetY, 配置.R.裂隙选择范围, hero);
  八云紫诊断日志("R", "搜索目标裂隙", "英雄", 八云紫诊断句柄(hero), "目标X", targetX, "目标Y", targetY, "搜索范围", 配置.R.裂隙选择范围, "候选数", gaps.length);
  let selected: 八云紫裂隙记录 | undefined;
  let selectedDistance = 配置.R.裂隙选择范围 + 1;
  for (let i = 0; i < gaps.length; i++) {
    const distance = 距离XY(targetX, targetY, jass.GetUnitX(gaps[i].单位), jass.GetUnitY(gaps[i].单位));
    八云紫诊断日志("R", "目标裂隙候选", "间隙", 八云紫诊断句柄(gaps[i].单位), "X", jass.GetUnitX(gaps[i].单位), "Y", jass.GetUnitY(gaps[i].单位), "距离", distance, "长期", gaps[i].长期);
    if (distance < selectedDistance) {
      selected = gaps[i];
      selectedDistance = distance;
    }
  }
  return selected;
}

function 获取R监听上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 释放R(this: void, _entry: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const targetX = jass.GetSpellTargetX();
  const targetY = jass.GetSpellTargetY();
  const gap = 选择目标裂隙(hero, targetX, targetY);
  八云紫诊断日志("R", "收到R施法", "英雄", 八云紫诊断句柄(hero), "英雄X", jass.GetUnitX(hero), "英雄Y", jass.GetUnitY(hero), "目标X", targetX, "目标Y", targetY, "选中间隙", gap != null ? 八云紫诊断句柄(gap.单位) : 0, "技能实例ID", skillInstanceId ?? 0);
  if (gap == null) {
    八云紫诊断日志("R", "R入口失败", "原因", "目标点400范围没有同玩家已登记间隙");
    jass.DisplayTimedTextToPlayer(jass.GetOwningPlayer(hero), 0, 0, 3, "目标位置附近没有可用的『间隙』。 ");
    const maximum = 技能_获取技能最大冷却时间(hero, 配置.技能.R.类型ID) || 80;
    技能_设置技能冷却时间(hero, 配置.技能.R.类型ID, 配置.R.无合法裂隙失败冷却秒, maximum);
    return;
  }
  let direction = 两点角度(jass.GetUnitX(gap.单位), jass.GetUnitY(gap.单位), targetX, targetY);
  if (距离XY(jass.GetUnitX(gap.单位), jass.GetUnitY(gap.单位), targetX, targetY) <= 1) direction = jass.GetUnitFacing(hero);
  八云紫诊断日志("R", "R入口成功", "间隙", 八云紫诊断句柄(gap.单位), "列车方向", direction);
  启动列车(hero, gap, direction, true, skillInstanceId);
}

function 监听主动二段裂隙(
  this: void,
  hero: any,
  gap: 八云紫裂隙记录,
  skillId: number,
  _skillInstanceId?: number,
): void {
  八云紫诊断日志("R", "收到裂隙创建监听", "英雄", 八云紫诊断句柄(hero), "间隙", 八云紫诊断句柄(gap.单位), "来源技能ID", skillId, "要求D技能ID", 配置.技能.D.类型ID, "存在二段窗口", 二段等待表[句柄ID(hero)] != null);
  if (skillId !== 配置.技能.D.类型ID) return;
  const context = 二段等待表[句柄ID(hero)];
  if (context == null || context.已结束) {
    八云紫诊断日志("R", "主动二段未触发", "原因", context == null ? "没有二段窗口" : "二段窗口已结束");
    return;
  }
  清除二段等待(context);
  创建二段列车(hero, gap, context.技能实例ID);
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
