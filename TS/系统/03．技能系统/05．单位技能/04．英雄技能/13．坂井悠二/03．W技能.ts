/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 创建点特效, 创建单位坐标跟随特效, 销毁单位坐标跟随特效, 设置特效颜色 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  设置特效颜色: (this: void, effect: any, red: number, green: number, blue: number, alpha?: number) => void;
};
// 源 PlaySoundOnUnitBJ(gg_snd_ReviveUndead, 100, 目标)：照源用 jglobals 全局音效句柄 + BJ 封装播放
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitModelScale = (jass.GetUnitModelScale ?? ((_u: any): number => 1)) as (this: void, unit: any) => number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 坂井悠二技能配置.W;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const W技能ID字符串 = 配置.技能ID;

interface W上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  阶段回调ID: number;
  伤害攻击力快照: number;
  目标: any;
  当前阶段: number;
}

const 上下文表: Record<number, W上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取W上下文(this: void, unit: any): W上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建W上下文(this: void, unit: any): W上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: W上下文 = {
    施法者: unit,
    已启动: false,
    阶段回调ID: 0,
    伤害攻击力快照: 0,
    目标: null,
    当前阶段: 0,
  };
  上下文表[id] = created;
  return created;
}

function 清理W上下文(this: void, context: W上下文): void {
  if (context.阶段回调ID !== 0) {
    removeDelayedCallback(context.阶段回调ID);
    context.阶段回调ID = 0;
  }
  context.已启动 = false;
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 推进W三段特效(this: void, context?: any): void {
  const ctx = context as W上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理W上下文(ctx);
    return;
  }
  if (target == null || target === 0 || !单位存活(target)) {
    清理W上下文(ctx);
    return;
  }

  const stageIndex = ctx.当前阶段;
  if (stageIndex >= 配置.三段特效.length) {
    清理W上下文(ctx);
    return;
  }

  const 特效配置 = 配置.三段特效[stageIndex];
  createTimedUnitEffect(target, "origin", 特效配置.模型路径, 特效配置.持续秒);

  ctx.当前阶段 = stageIndex + 1;
  if (ctx.当前阶段 < 配置.三段特效.length) {
    ctx.阶段回调ID = addDelayedCallback(
      特效配置.持续秒 * 1000,
      推进W三段特效 as unknown as (this: void, variable?: any) => void,
      ctx,
    );
  } else {
    清理W上下文(ctx);
  }
}

function 释放W技能(this: void, context: W上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  const target = GetSpellTargetUnit();
  if (target == null || target === 0) return;
  if (!单位存活(target)) return;

  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.伤害攻击力快照 = 读取单位攻击力(caster);
  context.目标 = target;
  context.当前阶段 = 0;

  // 1. 立即眩晕 2秒（按用户决策 B：立即眩晕+立即伤害）
  施加眩晕(caster, target, 配置.眩晕秒, 坂井悠二BuffID.W眩晕, "技能");

  // 2. 立即结算伤害
  const 伤害 = context.伤害攻击力快照 * 配置.伤害攻击力倍率;
  if (伤害 > 0 && 单位存活(target)) {
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: 伤害,
      伤害类型: jass.DAMAGE_TYPE_MAGIC,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "坂井悠二-W-银之监牢",
      技能ID: stringToFourCC(W技能ID字符串),
      技能实例ID: context.技能实例ID,
    });
  }

  // 3. 播放音效（同步表现）：源 PlaySoundOnUnitBJ(gg_snd_ReviveUndead, 100, 目标)
  const w音效句柄 = (jglobals as any)[配置.音效.全局音效键];
  if (w音效句柄 != null) PlaySoundOnUnitBJ(w音效句柄, 100, target);

  // 4. 壳优化为控制特效：目标模型缩放×2（可选）
  if (配置.壳优化为控制特效.启用) {
    const 缩放倍率 = 配置.壳优化为控制特效.缩放倍率;
    const 当前缩放 = GetUnitModelScale(target);
    void 当前缩放;
    void 缩放倍率;
    // 缩放表现暂由物编/特效控制，TS 侧不修改 modelScale 以免与其他技能冲突
  }

  // 5. 推进三段特效（每段 1秒）
  context.阶段回调ID = addDelayedCallback(
    0,
    推进W三段特效 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function W可释放(this: void, context: W上下文): boolean {
  return !context.已启动 && context.阶段回调ID === 0;
}

function W单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取W上下文(dyingUnit);
  if (context != null) 清理W上下文(context);
}

export function 注册坂井悠二W(this: void): void {
  注册单位技能壳监听({
    名称: "坂井悠二-银之监牢（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: W技能ID字符串,
    获取或创建上下文: 获取或创建W上下文,
    可释放: W可释放,
    释放技能: 释放W技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 4,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(W单位死亡);
  }
}

注册坂井悠二W();

export const 坂井悠二W技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "单体暗属性技能伤害",
  伤害: "立即 350% 攻击力 + 2秒眩晕",
  表现: "三段直接特效各 1秒 + 3D 音效",
} as const;

// 本地复用：createTimedUnitEffect 与 创建点特效 保持同步
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
