/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, reduceRatio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, height: number, durationSec: number) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => boolean;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

const 配置 = 坂井悠二技能配置.R.二段;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const R二段技能ID字符串 = 配置.技能ID;

interface R2上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  周期回调ID: number;
  冲击回调ID: number;
  清理回调ID: number;
  伤害攻击力快照: number;
  冲击累计次数: number;
}

const 上下文表: Record<number, R2上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取R2上下文(this: void, unit: any): R2上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建R2上下文(this: void, unit: any): R2上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: R2上下文 = {
    施法者: unit,
    已启动: false,
    周期回调ID: 0,
    冲击回调ID: 0,
    清理回调ID: 0,
    伤害攻击力快照: 0,
    冲击累计次数: 0,
  };
  上下文表[id] = created;
  return created;
}

function 清理R2上下文(this: void, context: R2上下文): void {
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.冲击回调ID !== 0) {
    removePeriodicCallback(context.冲击回调ID);
    context.冲击回调ID = 0;
  }
  if (context.清理回调ID !== 0) {
    removeDelayedCallback(context.清理回调ID);
    context.清理回调ID = 0;
  }
  context.已启动 = false;
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function R2命中减速处理(this: void, target: any, _索引: number, _成功: boolean, 变量?: any): void {
  if (target == null || target === 0) return;
  const caster = 变量 as any;
  if (caster == null || caster === 0) return;
  施加减速(caster, target, 配置.减速比例, 配置.减速控制秒, 坂井悠二BuffID.R2减速, "技能");
}

function 推进R2周期(this: void, context?: any): void {
  const ctx = context as R2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理R2上下文(ctx);
    return;
  }

  const 范围 = 配置.范围;
  const 单次伤害 = ctx.伤害攻击力快照 * 配置.单次伤害攻击力倍率;
  if (单次伤害 > 0) {
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 获取范围敌军(caster, GetUnitX(caster), GetUnitY(caster), 范围),
      伤害: 单次伤害,
      伤害类型: jass.DAMAGE_TYPE_MAGIC,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "坂井悠二-R2-胧天震-周期",
      技能ID: stringToFourCC(R二段技能ID字符串),
      技能实例ID: ctx.技能实例ID,
      变量: caster,
      每目标结算后处理器: R2命中减速处理,
    });
  }
}

function 推进R2冲击特效(this: void, context?: any): void {
  const ctx = context as R2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理R2上下文(ctx);
    return;
  }

  // 每秒 5 个冲击，本回调周期 = 0.2秒（1/5），每次一个冲击
  const 中心X = GetUnitX(caster);
  const 中心Y = GetUnitY(caster);
  const 角度 = GetRandomReal(0, 360) * (3.14159265358979 / 180);
  const 半径 = GetRandomReal(配置.冲击.随机半径最小, 配置.冲击.随机半径最大);
  const 落点X = 中心X + 半径 * Math.cos(角度);
  const 落点Y = 中心Y + 半径 * Math.sin(角度);

  createTimedEffect(配置.冲击.冲击特效.模型路径, 落点X, 落点Y, 0, 配置.冲击.冲击特效.持续秒);
  createTimedEffect(配置.冲击.冲击震荡特效.模型路径, 落点X, 落点Y, 0, 配置.冲击.冲击震荡特效.持续秒);
  createTimedEffect(配置.冲击.地形特效.模型路径, 落点X, 落点Y, 0, 配置.冲击.地形特效.持续秒);

  ctx.冲击累计次数 = ctx.冲击累计次数 + 1;
}

function 释放R2技能(this: void, context: R2上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;

  // 等级检查
  const 等级 = GetHeroLevel(caster);
  if (等级 < 配置.解锁英雄等级) return;

  // 魔法值检查：20% 最大魔法 + 300
  const 当前魔法 = GetUnitState(caster, UNIT_STATE_MANA);
  const 消耗 = GetUnitState(caster, UNIT_STATE_MAX_MANA) * 配置.魔耗检查.最大魔法比例 + 配置.魔耗检查.固定加值;
  if (当前魔法 < 消耗) return; // 不足时不消耗也不触发（物编会自动消耗，这里仅作安全门）

  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.伤害攻击力快照 = 读取单位攻击力(caster);
  context.冲击累计次数 = 0;

  // 区域特效
  createTimedEffect(配置.区域特效.模型路径, GetUnitX(caster), GetUnitY(caster), 0, 配置.区域特效.持续秒);

  // 音效
  Sound3DII_UnitPlayReuse(配置.音效.路径, caster, 配置.音效.裁断距离);

  // 周期伤害 0.5秒/次
  context.周期回调ID = addPeriodicCallback(
    配置.周期间隔秒 * 1000,
    推进R2周期 as unknown as (this: void, variable?: any) => void,
    context,
  );

  // 冲击特效 0.2秒/次（每秒 5个，持续 5秒）
  context.冲击回调ID = addPeriodicCallback(
    (配置.持续秒 / (配置.冲击.每秒数量 * 配置.持续秒)) * 1000,
    推进R2冲击特效 as unknown as (this: void, variable?: any) => void,
    context,
  );

  // 到期清理
  context.清理回调ID = addDelayedCallback(
    配置.持续秒 * 1000,
    清理R2到期 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function 清理R2到期(this: void, context?: any): void {
  const ctx = context as R2上下文 | undefined;
  if (ctx != null) 清理R2上下文(ctx);
}

function R2可释放(this: void, context: R2上下文): boolean {
  return !context.已启动 && context.周期回调ID === 0;
}

function R2单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取R2上下文(dyingUnit);
  if (context != null) 清理R2上下文(context);
}

export function 注册坂井悠二R2(this: void): void {
  注册单位技能壳监听({
    名称: "坂井悠二-胧天震（R二段）",
    单位类型ID: 英雄单位类型ID,
    技能ID: R二段技能ID字符串,
    获取或创建上下文: 获取或创建R2上下文,
    可释放: R2可释放,
    释放技能: 释放R2技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 配置.持续秒 + 1,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(R2单位死亡);
  }
}

注册坂井悠二R2();

export const 坂井悠二R2技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "AOE 周期伤害 + 减速",
  伤害: "每 0.5秒 50% 攻击力，持续 5秒，30% 减速 0.6秒",
  解锁条件: "英雄等级 ≥ 20，魔法值 ≥ 20% max + 300",
} as const;
