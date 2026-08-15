/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import {
  播放藤原妹红单位音效,
  播放藤原妹红配置动作,
  创建藤原妹红点特效,
  创建藤原妹红单位特效,
} from "./00A．表现工具";
import { 关闭藤原妹红符卡模式 } from "./04．E技能";
import { 读取单位攻击力, 单位未标记死亡 as 单位有效 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import {
  主动引爆护盾仍有效,
  创建主动引爆护盾,
  引爆主动引爆护盾,
  护盾类型,
  清理主动引爆护盾,
  type 主动引爆护盾控制器,
} from "../../../00．技能模板+函数/01．技能函数/07．护盾";

require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.05．R技能");

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { createUnitEffect, destroyUnitEffect, createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建进度条特效, 销毁进度条特效 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效") as {
  创建进度条特效: (this: void, 单位: any, 选项?: { 高度偏移?: number; 缩放?: number; 动画序号?: number; 动画速度?: number }) => any;
  销毁进度条特效: (this: void, 进度条特效: any) => void;
};
const { 开始击退, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const BJ_DEGTORAD = (jass.bj_DEGTORAD as number) || 0.017453292519943295;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const { 两点角度, 距离XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

interface 藤原妹红W运行时上下文 {
  施法者: any;
  护盾目标: any;
  护盾ID: number;
  周期回调ID: number;
  周期伤害: number;
  护盾控制器?: 主动引爆护盾控制器;
}

const 藤原妹红单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 主技能ID = stringToFourCCSafe(藤原妹红单位技能配置.主技能ID);
const 引爆技能ID = stringToFourCCSafe(藤原妹红单位技能配置.引爆技能ID);
const 藤原妹红W上下文表: Record<number, 藤原妹红W运行时上下文 | undefined> = {};
let 藤原妹红W死亡监听已注册 = false;

interface 藤原妹红符卡W运行时上下文 {
  施法者: any;
  目标: any;
  方向角: number;
  伤害: number;
  技能实例ID?: number;
  进度条特效: any;
  推进回调ID: number;
  推进计时秒: number;
  推进总计时秒: number;
  剩余位移数: number;
  位移ID列表: number[];
  活跃: boolean;
}

const 符卡W技能ID = stringToFourCCSafe(藤原妹红单位技能配置.符卡W技能ID);
const 藤原妹红符卡W上下文表: Record<number, 藤原妹红符卡W运行时上下文 | undefined> = {};
const 藤原妹红符卡W位移表: Record<number, 藤原妹红符卡W运行时上下文 | undefined> = {};
const 符卡W诊断模块 = "藤原妹红符卡W诊断";

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 读取符卡W技能等级(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetUnitAbilityLevel(unit, 符卡W技能ID);
}

export function 获取或创建藤原妹红W上下文(this: void, unit: any): 藤原妹红W运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const current = 藤原妹红W上下文表[unitId];
  if (current != null) return current;
  const created: 藤原妹红W运行时上下文 = {
    施法者: unit,
    护盾目标: undefined,
    护盾ID: 0,
    周期回调ID: 0,
    周期伤害: 0,
    护盾控制器: undefined,
  };
  藤原妹红W上下文表[unitId] = created;
  return created;
}

function 获取藤原妹红W上下文(this: void, unit: any): 藤原妹红W运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  return unitId === 0 ? undefined : 藤原妹红W上下文表[unitId];
}

function 清理藤原妹红W状态(this: void, unit: any, shieldId?: number): void {
  const context = 获取藤原妹红W上下文(unit);
  if (context == null) return;
  if (shieldId != null && context.护盾ID !== 0 && context.护盾ID !== shieldId) return;

  const 控制器 = context.护盾控制器;
  context.护盾控制器 = undefined;
  清理主动引爆护盾(控制器, "技能状态清理");
}

function 藤原妹红W护盾清理(this: void, _controller: 主动引爆护盾控制器, _reason: string): void {
  const context = 获取藤原妹红W上下文(_controller.施法者);
  destroyUnitEffect(_controller.护盾目标, 藤原妹红单位技能配置.表现资源.护盾特效键);
  if (context == null) return;
  if (context.护盾控制器 != null && context.护盾控制器 !== _controller) return;

  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  context.护盾目标 = undefined;
  context.护盾ID = 0;
  context.周期伤害 = 0;
  context.护盾控制器 = undefined;
}

function 目标允许藤原妹红W伤害(this: void, target: any): boolean {
  if (!单位有效(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

function 准备藤原妹红W周期目标伤害(this: void, target: any, _index: number): any {
  return 目标允许藤原妹红W伤害(target) ? {} : undefined;
}

function 准备藤原妹红W引爆目标伤害(this: void, target: any, _index: number): any {
  return 目标允许藤原妹红W伤害(target) ? {} : undefined;
}

function 造成藤原妹红W周期伤害(this: void, context: 藤原妹红W运行时上下文): void {
  const caster = context.施法者;
  const target = context.护盾目标;
  if (!单位有效(caster) || !单位有效(target)) return;
  const targets = 获取范围敌军(caster, GetUnitX(target), GetUnitY(target), 藤原妹红单位技能配置.周期伤害半径);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: context.周期伤害,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 主技能ID,
    每目标处理器: 准备藤原妹红W周期目标伤害,
  });
}

function 藤原妹红W周期Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红W运行时上下文 | undefined;
  if (context == null || context.护盾ID === 0) return;
  if (!单位有效(context.施法者) || !单位有效(context.护盾目标)) {
    清理藤原妹红W状态(context.施法者, context.护盾ID);
    return;
  }
  if (!主动引爆护盾仍有效(context.护盾控制器)) {
    清理藤原妹红W状态(context.施法者, context.护盾ID);
    return;
  }
  造成藤原妹红W周期伤害(context);
}

function 创建藤原妹红W护盾(this: void, context: 藤原妹红W运行时上下文, caster: any): boolean {
  if (!单位有效(caster) || GetUnitTypeId(caster) !== 藤原妹红单位类型ID) return false;
  if (context.护盾ID !== 0) return false;

  const target = GetSpellTargetUnit();
  if (!单位有效(target)) return false;
  const owner = GetOwningPlayer(caster);
  if (target !== caster && !IsUnitAlly(target, owner)) return false;
  if (!目标允许藤原妹红W伤害(target) && target !== caster) return false;

  const attack = 读取单位攻击力(caster);
  const shieldValue = attack * 藤原妹红单位技能配置.护盾值攻击力倍率;
  const periodicDamage = attack * 藤原妹红单位技能配置.周期伤害攻击力倍率;
  if (!(shieldValue > 0) || !(periodicDamage > 0)) return false;

  context.施法者 = caster;
  context.护盾目标 = target;
  context.周期伤害 = periodicDamage;
  const 控制器 = 创建主动引爆护盾({
    名称: "藤原妹红-火焰护盾",
    施法者: caster,
    护盾目标: target,
    主技能ID,
    引爆技能ID,
    护盾标签: 藤原妹红单位技能配置.护盾标签,
    护盾参数: {
      类型: 护盾类型.通用,
      数值: shieldValue,
      持续时间: 藤原妹红单位技能配置.护盾持续秒,
      来源单位: caster,
      显示护盾条: true,
      可驱散: false,
    },
    on创建前: 藤原妹红W护盾创建前,
    on清理: 藤原妹红W护盾清理,
    on引爆前: 藤原妹红W护盾引爆前,
    on引爆后: 藤原妹红W护盾引爆后,
  });
  if (控制器 == null) {
    context.护盾目标 = undefined;
    context.周期伤害 = 0;
    return false;
  }
  context.护盾控制器 = 控制器;
  context.护盾ID = 控制器.护盾ID;
  context.周期回调ID = addPeriodicCallback(
    藤原妹红单位技能配置.周期伤害间隔毫秒,
    藤原妹红W周期Tick,
    context,
  );
  return true;
}

function 藤原妹红W护盾创建前(this: void, controller: 主动引爆护盾控制器): void {
  createUnitEffect(
    controller.护盾目标,
    藤原妹红单位技能配置.表现资源.护盾特效挂点,
    藤原妹红单位技能配置.表现资源.护盾特效路径,
    undefined,
    藤原妹红单位技能配置.表现资源.护盾特效键,
  );
}

function 藤原妹红W护盾引爆前(this: void, controller: 主动引爆护盾控制器, damage: number): void {
  const caster = controller.施法者;
  const target = controller.护盾目标;
  createTimedEffect(
    藤原妹红单位技能配置.表现资源.引爆特效路径,
    GetUnitX(target),
    GetUnitY(target),
    0,
    藤原妹红单位技能配置.表现资源.引爆特效持续秒,
  );
  const targets = 获取范围敌军(caster, GetUnitX(target), GetUnitY(target), 藤原妹红单位技能配置.引爆范围);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 引爆技能ID,
    每目标处理器: 准备藤原妹红W引爆目标伤害,
  });
}

function 藤原妹红W护盾引爆后(this: void, controller: 主动引爆护盾控制器, _damage: number): void {
  清理主动引爆护盾(controller, "主动引爆");
}

function 取藤原妹红符卡W上下文(this: void, caster: any): 藤原妹红符卡W运行时上下文 | undefined {
  return 藤原妹红符卡W上下文表[取单位句柄ID(caster)];
}

function 清理藤原妹红符卡W(this: void, context: 藤原妹红符卡W运行时上下文): void {
  if (!context.活跃) return;
  context.活跃 = false;
  if (context.进度条特效 != null) {
    销毁进度条特效(context.进度条特效);
    context.进度条特效 = undefined;
  }
  if (context.推进回调ID !== 0) {
    removePeriodicCallback(context.推进回调ID);
  context.推进回调ID = 0;
  }
  for (let i = 0; i < context.位移ID列表.length; i++) {
    const displacementId = context.位移ID列表[i];
    delete 藤原妹红符卡W位移表[displacementId];
    if (displacementId !== 0) 停止位移(displacementId, "中断");
  }
  context.位移ID列表.length = 0;
  SetUnitTimeScale(context.施法者, 藤原妹红单位技能配置.动作恢复速度);
  const casterId = 取单位句柄ID(context.施法者);
  if (藤原妹红符卡W上下文表[casterId] === context) delete 藤原妹红符卡W上下文表[casterId];
}

function 藤原妹红符卡W推进Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红符卡W运行时上下文 | undefined;
  if (context == null || !context.活跃) return;
  if (!单位有效(context.施法者) || !单位有效(context.目标)) {
    清理藤原妹红符卡W(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.符卡W;
  context.推进计时秒 += cfg.推进表现间隔毫秒 * 0.001;
  context.推进总计时秒 += cfg.推进表现间隔毫秒 * 0.001;
  if (context.推进计时秒 >= cfg.推进表现时间增量秒) {
    context.推进计时秒 -= cfg.推进表现时间增量秒;
    const targetX = GetUnitX(context.目标);
    const targetY = GetUnitY(context.目标);
    const effectX = targetX + Cos(context.方向角 * BJ_DEGTORAD) * cfg.击退距离;
    const effectY = targetY + Sin(context.方向角 * BJ_DEGTORAD) * cfg.击退距离;
    let successCount = 0;
    for (let i = 0; i < cfg.命中特效.length; i++) {
      const effect = 创建藤原妹红点特效(cfg.命中特效[i], effectX, effectY, context.方向角);
      if (effect != null && effect !== 0) successCount += 1;
    }
    debugLogForce(
      符卡W诊断模块,
      "推进命中特效",
      "请求数",
      cfg.命中特效.length,
      "成功数",
      successCount,
      "X",
      effectX,
      "Y",
      effectY,
    );
  }
  if (context.推进总计时秒 < cfg.击退持续秒) return;
  removePeriodicCallback(context.推进回调ID);
  context.推进回调ID = 0;
  if (context.剩余位移数 === 0) 清理藤原妹红符卡W(context);
}

function 藤原妹红符卡W目标位移结束(this: void, target: any, reason: string, displacementId: number): void {
  const context = 藤原妹红符卡W位移表[displacementId];
  if (context == null) return;
  delete 藤原妹红符卡W位移表[displacementId];
  for (let i = 0; i < context.位移ID列表.length; i++) {
    if (context.位移ID列表[i] !== displacementId) continue;
    context.位移ID列表.splice(i, 1);
    break;
  }
  if (context.活跃 && reason === "撞墙" && 单位有效(target)) {
    造成单体技能伤害({
      来源: context.施法者,
      目标: target,
      伤害: context.伤害 * 0.5,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      来源类型: "单位技能",
      技能ID: 符卡W技能ID,
      技能实例ID: context.技能实例ID,
      标签: "藤原妹红-符卡W-撞地形追加伤害",
    });
  }
  if (context.活跃 && (reason === "撞墙" || reason === "完成") && 单位有效(target)) {
    const 收尾特效 = 藤原妹红单位技能配置.符卡W.收尾特效;
    创建藤原妹红点特效(收尾特效, GetUnitX(target), GetUnitY(target));
  }
  context.剩余位移数 -= 1;
  if (context.活跃 && context.剩余位移数 <= 0 && context.推进回调ID === 0) {
    清理藤原妹红符卡W(context);
  }
}

function 符卡W目标允许命中(this: void, caster: any, target: any): boolean {
  if (!单位有效(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return IsUnitEnemy(target, GetOwningPlayer(caster));
}

function 结算藤原妹红符卡W(this: void, context: 藤原妹红符卡W运行时上下文): void {
  if (!context.活跃 || !单位有效(context.施法者) || !单位有效(context.目标)) {
    清理藤原妹红符卡W(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.符卡W;
  const caster = context.施法者;
  const target = context.目标;
  debugLogForce(
    符卡W诊断模块,
    "进入符卡W结算",
    "施法者",
    取单位句柄ID(caster),
    "目标",
    取单位句柄ID(target),
  );
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);

  const nearTargetX = targetX - Cos(context.方向角 * BJ_DEGTORAD) * cfg.贴近目标距离;
  const nearTargetY = targetY - Sin(context.方向角 * BJ_DEGTORAD) * cfg.贴近目标距离;
  SetUnitX(caster, nearTargetX);
  SetUnitY(caster, nearTargetY);
  const casterTargetDistance = 距离XY(GetUnitX(caster), GetUnitY(caster), targetX, targetY);
  if (casterTargetDistance >= 250) {
    debugLogForce(
      符卡W诊断模块,
      "符卡W结算提前退出",
      "原因",
      "移动后仍与目标距离过远",
      "距离",
      casterTargetDistance,
    );
    清理藤原妹红符卡W(context);
    return;
  }
  播放藤原妹红单位音效(caster, cfg.结算音效键);
  播放藤原妹红配置动作(caster, cfg.命中动作编号, cfg.命中动作速度);

  const targets = 获取范围敌军(caster, GetUnitX(caster), GetUnitY(caster), cfg.搜索范围);
  let hitCount = 0;
  for (let i = 0; i < targets.length; i++) {
    const hitTarget = targets[i];
    if (!符卡W目标允许命中(caster, hitTarget)) continue;
    hitCount += 1;
    造成单体技能伤害({
      来源: caster,
      目标: hitTarget,
      伤害: context.伤害,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      来源类型: "单位技能",
      技能ID: 符卡W技能ID,
      技能实例ID: context.技能实例ID,
      标签: "藤原妹红-符卡W-初次命中",
    });
    施加眩晕(caster, hitTarget, cfg.控制秒, "藤原妹红-符卡W", "技能");
    const displacementId = 开始击退(hitTarget, {
      角度: context.方向角,
      距离: cfg.击退距离,
      持续时间: cfg.击退持续秒,
      检查地形: true,
      禁用碰撞: true,
      主单位: caster,
      主单位死亡时中断: true,
      结束回调: 藤原妹红符卡W目标位移结束,
    });
    if (displacementId > 0) {
      context.剩余位移数 += 1;
      context.位移ID列表.push(displacementId);
      藤原妹红符卡W位移表[displacementId] = context;
    }
  }
  debugLogForce(符卡W诊断模块, "符卡W命中目标统计", "枚举数", targets.length, "合法命中数", hitCount);

  context.推进回调ID = addPeriodicCallback(cfg.推进表现间隔毫秒, 藤原妹红符卡W推进Tick, context);
}

function 释放藤原妹红符卡W(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  const target = GetSpellTargetUnit();
  const casterValid = 单位有效(caster);
  const targetValid = 单位有效(target);
  debugLogForce(
    符卡W诊断模块,
    "进入符卡W入口",
    "施法者",
    取单位句柄ID(caster),
    "单位类型",
    casterValid ? GetUnitTypeId(caster) : 0,
    "符卡W技能等级",
    读取符卡W技能等级(caster),
    "目标",
    取单位句柄ID(target),
    "施法者有效",
    casterValid,
    "目标有效",
    targetValid,
  );
  if (!casterValid || !targetValid) {
    debugLogForce(符卡W诊断模块, "符卡W提前退出", "原因", !casterValid ? "施法者无效" : "目标无效");
    return;
  }
  const casterId = 取单位句柄ID(caster);
  const oldContext = 藤原妹红符卡W上下文表[casterId];
  if (oldContext != null) 清理藤原妹红符卡W(oldContext);
  关闭藤原妹红符卡模式(caster, true);
  const cfg = 藤原妹红单位技能配置.符卡W;
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  const targetWarningEffect = 创建藤原妹红单位特效(target, { 模型路径: cfg.目标预警特效, 持续秒: cfg.命中延迟秒 }, "origin");
  debugLogForce(
    符卡W诊断模块,
    "目标预警特效创建",
    "目标",
    取单位句柄ID(target),
    "路径",
    cfg.目标预警特效,
    "成功",
    targetWarningEffect != null && targetWarningEffect !== 0,
  );
  const 方向角 = 两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target));
  SetUnitFacing(caster, 方向角);
  SetUnitFacing(target, 方向角 + 180);
  开始硬直(caster, cfg.硬直秒);
  播放藤原妹红配置动作(caster, cfg.动作编号, cfg.动作速度);
  const progressEffect = 创建进度条特效(caster, {
    高度偏移: cfg.进度条高度偏移,
    动画速度: cfg.进度条动画速度,
  });
  debugLogForce(
    符卡W诊断模块,
    "施法进度条创建",
    "施法者",
    casterId,
    "成功",
    progressEffect != null && progressEffect !== 0,
    "命中延迟秒",
    cfg.命中延迟秒,
  );
  const context: 藤原妹红符卡W运行时上下文 = {
    施法者: caster,
    目标: target,
    方向角,
    伤害: 读取单位攻击力(caster) * cfg.伤害攻击力倍率,
    技能实例ID: skillInstanceId,
    进度条特效: progressEffect,
    推进回调ID: 0,
    推进计时秒: 0,
    推进总计时秒: 0,
    剩余位移数: 0,
    位移ID列表: [],
    活跃: true,
  };
  藤原妹红符卡W上下文表[casterId] = context;
  addDelayedCallback(cfg.命中延迟秒 * 1000, 结算藤原妹红符卡W, context);
  debugLogForce(
    符卡W诊断模块,
    "符卡W上下文已创建",
    "施法者",
    casterId,
    "目标",
    取单位句柄ID(target),
    "命中延迟秒",
    cfg.命中延迟秒,
    "伤害",
    context.伤害,
  );
}

function 引爆藤原妹红W护盾(this: void, context: 藤原妹红W运行时上下文, caster: any): void {
  if (!单位有效(caster)) return;
  引爆主动引爆护盾(context.护盾控制器);
}

function 藤原妹红W主技能监听(this: void, _context: 藤原妹红W运行时上下文, caster: any): void {
  const context = 获取藤原妹红W上下文(caster);
  if (context != null) 创建藤原妹红W护盾(context, caster);
}

function 藤原妹红W引爆监听(this: void, _context: 藤原妹红W运行时上下文, caster: any): void {
  const context = 获取藤原妹红W上下文(caster);
  if (context != null) 引爆藤原妹红W护盾(context, caster);
}

function 藤原妹红W单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const cardContext = 取藤原妹红符卡W上下文(dyingUnit);
  if (cardContext != null) 清理藤原妹红符卡W(cardContext);
  for (const key in 藤原妹红W上下文表) {
    const context = 藤原妹红W上下文表[Number(key)];
    if (context == null) continue;
    if (context.施法者 !== dyingUnit && context.护盾目标 !== dyingUnit) continue;
    const caster = context.施法者;
    清理藤原妹红W状态(caster, context.护盾ID);
    delete 藤原妹红W上下文表[Number(key)];
  }
}

export function 注册藤原妹红W技能(this: void): void {
  debugLogForce(
    符卡W诊断模块,
    "注册W监听",
    "单位类型ID",
    藤原妹红单位技能配置.单位类型ID,
    "符卡W技能ID",
    藤原妹红单位技能配置.符卡W技能ID,
    "符卡W数字ID",
    符卡W技能ID,
  );
  注册单位技能壳监听({
    名称: "藤原妹红-火焰护盾",
    单位类型ID: 藤原妹红单位类型ID,
    技能ID: 主技能ID,
    获取或创建上下文: 获取或创建藤原妹红W上下文,
    创建独立技能实例: false,
    释放技能: 藤原妹红W主技能监听,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-火焰护盾引爆",
    单位类型ID: 藤原妹红单位类型ID,
    技能ID: 引爆技能ID,
    获取或创建上下文: 获取或创建藤原妹红W上下文,
    创建独立技能实例: false,
    释放技能: 藤原妹红W引爆监听,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-符卡W",
    单位类型ID: 藤原妹红单位类型ID,
    技能ID: 符卡W技能ID,
    获取或创建上下文: 获取或创建藤原妹红W上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 4,
    释放技能: 释放藤原妹红符卡W,
  });
  if (!藤原妹红W死亡监听已注册) {
    藤原妹红W死亡监听已注册 = true;
    registerDeathListener(藤原妹红W单位死亡);
  }
}

注册藤原妹红W技能();

export const 藤原妹红W技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "火属性AOE技能伤害",
  护盾值: "施法者攻击力×4",
  周期伤害: "每0.5秒，施法者攻击力×0.4，半径350码",
  引爆伤害: "剩余护盾值100%，半径600码",
} as const;
