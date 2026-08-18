/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 技能强制调试输出 } from "../../../00．技能模板+函数/02．通用函数/04．调试输出";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

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
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { createTimedEffect, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, height: number, durationSec: number) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
void Sound3DII_UnitPlayReuse;
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
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, speed: number) => void;
const GetUnitFlyHeight = (jass.GetUnitFlyHeight ?? ((_u: any): number => 0)) as (this: void, unit: any) => number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, flag: boolean) => void;
const AttachSoundToUnit = jass.AttachSoundToUnit as (this: void, sound: any, unit: any) => void;
const SetSoundVolume = jass.SetSoundVolume as (this: void, sound: any, volume: number) => void;
const StartSound = jass.StartSound as (this: void, sound: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

// 全局音效播放（逆回十六夜模式：jglobals 取 gg_snd 句柄，禁止猜路径）
function 播放全局音效(this: void, unit: any, soundKey: string): void {
  const soundHandle = jglobals[soundKey];
  if (soundHandle == null || soundHandle === 0) return;
  if (unit != null && unit !== 0) AttachSoundToUnit(soundHandle, unit);
  SetSoundVolume(soundHandle, 127);
  StartSound(soundHandle);
}

const 配置 = 坂井悠二技能配置.R;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const R技能ID字符串 = 配置.技能ID;
const E技能类型ID = 坂井悠二技能配置.E.技能类型ID;
const R日志模块 = "坂井悠二R排查";

interface R上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  周期回调ID: number;
  清理回调ID: number;
  神门单位: any;
  伤害攻击力快照: number;
  累计次数: number;
  飞行高度: number; // 施法时锁存（源：制裁特效 EXSetEffectZ 用施法者飞行高度）
  已切二段: boolean;
}

const 上下文表: Record<number, R上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取R上下文(this: void, unit: any): R上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建R上下文(this: void, unit: any): R上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: R上下文 = {
    施法者: unit,
    已启动: false,
    周期回调ID: 0,
    清理回调ID: 0,
    神门单位: null,
    伤害攻击力快照: 0,
    累计次数: 0,
    飞行高度: 0,
    已切二段: false,
  };
  上下文表[id] = created;
  return created;
}

function 清理R上下文(this: void, context: R上下文): void {
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.清理回调ID !== 0) {
    removeDelayedCallback(context.清理回调ID);
    context.清理回调ID = 0;
  }
  if (context.神门单位 != null && context.神门单位 !== 0) {
    RemoveUnit(context.神门单位);
    context.神门单位 = null;
  }
  // 源：一段结束时移除二段胧天震并恢复一段图标
  const caster = context.施法者;
  if (context.已切二段 && caster != null && caster !== 0 && 单位存活(caster)) {
    UnitRemoveAbility(caster, 配置.二段.技能类型ID);
    SetPlayerAbilityAvailable(GetOwningPlayer(caster), 配置.技能类型ID, true);
  }
  context.已切二段 = false;
  context.已启动 = false;
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 推进R周期伤害(this: void, context?: any): void {
  const ctx = context as R上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    技能强制调试输出(R日志模块, "周期终止：施法者无效/死亡");
    清理R上下文(ctx);
    return;
  }
  const 神门 = ctx.神门单位;
  if (神门 == null || 神门 === 0) {
    技能强制调试输出(R日志模块, "周期终止：神门单位无效");
    清理R上下文(ctx);
    return;
  }

  // 随机落点
  const 中心X = GetUnitX(神门);
  const 中心Y = GetUnitY(神门);
  const 落点半径 = 配置.周期.随机落点半径;
  const 角度 = GetRandomReal(0, 360) * (3.14159265358979 / 180);
  const 半径 = GetRandomReal(0, 落点半径);
  const 落点X = 中心X + 半径 * Math.cos(角度);
  const 落点Y = 中心Y + 半径 * Math.sin(角度);

  // 制裁特效（高度 = 施法时锁存的飞行高度，源 EXSetEffectZ）
  for (let i = 0; i < 配置.周期.制裁特效.length; i++) {
    const 特效配置 = 配置.周期.制裁特效[i];
    createTimedEffect(特效配置.模型路径, 落点X, 落点Y, ctx.飞行高度, 特效配置.持续秒);
  }

  // 落点音效（源 PlaySoundOnUnitBJ(gg_snd_StormBoltLaunch, 施法者)）
  播放全局音效(caster, 配置.周期.落点音效.全局音效键);

  // 延迟结算伤害
  addDelayedCallback(
    配置.周期.伤害延迟结算秒 * 1000,
    结算R单次伤害 as unknown as (this: void, variable?: any) => void,
    { ctx, 落点X, 落点Y },
  );

  ctx.累计次数 = ctx.累计次数 + 1;
  // 排查日志：每 4 次（约 1 秒）输出一条，避免刷屏
  if (ctx.累计次数 % 4 === 1) {
    技能强制调试输出(R日志模块, "周期伤害 tick", "累计次数", ctx.累计次数, "神门位置", 中心X, 中心Y, "落点", 落点X, 落点Y);
  }
}

function 结算R单次伤害(this: void, payload?: any): void {
  if (payload == null) return;
  const ctx = payload.ctx as R上下文;
  const 落点X = payload.落点X as number;
  const 落点Y = payload.落点Y as number;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    技能强制调试输出(R日志模块, "结算跳过：施法者无效/死亡");
    return;
  }

  const 单次伤害 = ctx.伤害攻击力快照 * 配置.周期.单次伤害攻击力倍率;
  if (单次伤害 <= 0) {
    技能强制调试输出(R日志模块, "结算跳过：伤害<=0", "快照", ctx.伤害攻击力快照, "倍率", 配置.周期.单次伤害攻击力倍率);
    return;
  }

  const 敌军列表 = 获取范围敌军(caster, 落点X, 落点Y, 配置.周期.伤害判定半径);
  技能强制调试输出(R日志模块, "结算伤害", "落点", 落点X, 落点Y, "伤害", 单次伤害, "命中数", 敌军列表.length);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: 敌军列表,
    伤害: 单次伤害,
    伤害类型: jass.DAMAGE_TYPE_MAGIC,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    标签: "坂井悠二-R-神门-制裁",
    技能ID: stringToFourCC(R技能ID字符串),
    技能实例ID: ctx.技能实例ID,
  });
}

function 释放R技能(this: void, context: R上下文, caster: any, 技能实例ID?: number): void {
  技能强制调试输出(R日志模块, "释放R入口", "施法者", caster, "实例ID", 技能实例ID, "已启动", context.已启动);
  if (context.已启动) {
    技能强制调试输出(R日志模块, "释放R被拒：已启动");
    return;
  }
  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.伤害攻击力快照 = 读取单位攻击力(caster);
  context.飞行高度 = GetUnitFlyHeight(caster); // 锁存施法者高度（制裁特效/神门高度基准）

  // 刷新 E 冷却
  YDWESetUnitAbilityStateSafe(caster, E技能类型ID, 1, 0);

  // 创建神门单位（源 'e001' 旧 ID，现物编真身为 e06S，见 00．配置）
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 神门四CC = stringToFourCC(配置.神门单位.单位ID);
  const 神门单位 = CreateUnit(GetOwningPlayer(caster), 神门四CC, 目标X, 目标Y, 0);
  context.神门单位 = 神门单位;
  技能强制调试输出(R日志模块, "创建神门", "目标点", 目标X, 目标Y, "四CC", 神门四CC, "单位ID字符串", 配置.神门单位.单位ID, "创建结果", 神门单位);
  if (神门单位 != null && 神门单位 !== 0) {
    // 源：SetUnitFlyHeight(神门, 施法者高度 + GetUnitDefaultFlyHeight(神门))；
    // 运行时创建的飞行单位 moveHeight 不自动生效，必须显式设置
    SetUnitFlyHeight(神门单位, context.飞行高度 + 配置.神门单位.飞行高度增量, 0);
  }

  // 源：等级 > 解锁等级时隐藏一段图标并添加二段胧天震（A0EC）
  if (GetHeroLevel(caster) > 配置.二段.解锁英雄等级) {
    SetPlayerAbilityAvailable(GetOwningPlayer(caster), 配置.技能类型ID, false);
    UnitAddAbility(caster, 配置.二段.技能类型ID);
    context.已切二段 = true;
    技能强制调试输出(R日志模块, "切换二段", "已添加", 配置.二段.技能ID);
  }

  // 周期伤害
  context.周期回调ID = addPeriodicCallback(
    配置.周期.周期间隔秒 * 1000,
    推进R周期伤害 as unknown as (this: void, variable?: any) => void,
    context,
  );

  // 总持续时间后清理
  context.清理回调ID = addDelayedCallback(
    配置.持续秒 * 1000,
    清理R到期 as unknown as (this: void, variable?: any) => void,
    context,
  );
  技能强制调试输出(R日志模块, "启动完成", "周期回调ID", context.周期回调ID, "清理回调ID", context.清理回调ID, "攻击力快照", context.伤害攻击力快照, "周期间隔", 配置.周期.周期间隔秒, "持续", 配置.持续秒);
}

function 清理R到期(this: void, context?: any): void {
  const ctx = context as R上下文 | undefined;
  if (ctx != null) 清理R上下文(ctx);
}

function R可释放(this: void, context: R上下文): boolean {
  const 可释放 = !context.已启动 && context.周期回调ID === 0;
  if (!可释放) {
    技能强制调试输出(R日志模块, "可释放检查被拦", "已启动", context.已启动, "周期回调ID", context.周期回调ID);
  }
  return 可释放;
}

function R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取R上下文(dyingUnit);
  if (context != null) 清理R上下文(context);
}

// 供二段（05．R2技能）查询：当前一段神门位置（无目标技能的伤害/特效中心）
export function 获取当前R神门中心(this: void, caster: any): { X: number; Y: number } | null {
  const ctx = 获取R上下文(caster);
  if (ctx == null) return null;
  const 神门 = ctx.神门单位;
  if (神门 == null || 神门 === 0 || !单位存活(神门)) return null;
  return { X: GetUnitX(神门), Y: GetUnitY(神门) };
}

export function 注册坂井悠二R(this: void): void {
  注册单位技能壳监听({
    名称: "坂井悠二-神门（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: R技能ID字符串,
    获取或创建上下文: 获取或创建R上下文,
    可释放: R可释放,
    释放技能: 释放R技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 配置.持续秒 + 1,
  });
  // 二段胧天震（A0EC）已拆分到 05．R2技能.ts 独立注册，此处不再重复
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(R单位死亡);
  }
}

注册坂井悠二R();

export const 坂井悠二R技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "一段：AOE 周期随机落点伤害；二段（胧天震）：无目标技能，以一段神门为中心 5秒 持续 AOE + 减速",
  伤害: "一段每 0.25秒 50% 攻击力（半径400落点/判定250）；二段每 0.5秒 50% 攻击力（以神门为中心半径400）+ 30%减速 0.6秒",
  持续: "一段 7秒（刷新E冷却，等级>20 切二段）；二段 5秒（无目标技能，魔耗检查 20% 最大魔法）",
} as const;
