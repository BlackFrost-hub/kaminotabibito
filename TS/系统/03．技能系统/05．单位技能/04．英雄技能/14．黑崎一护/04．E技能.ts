/** @noSelfInFile */
// 黑崎一护 E：瞬步斩（A01L）。普通分支 1.5 秒范围斩击；D 连携分支 6 幻影集火单目标。
// 源 JASS 真源：技能.j（A01L 段 731-810；普通周期 Func007T 168-244；连携幻影 Func008A 254-263/冲锋周期 Func010T 349-394/Func013A 275-310/收尾 Func003T 318-347）。
// 单位壳（视野马甲/一护幻影马甲）优化为直接特效（计划第 5 节）；源“斩断弹道”筛选条件恒假（ANCIENT&&MECHANICAL 无交集），不迁移（差异审计见计划）。
// 冲突口径：连携目标选取半径按介绍 200（源枚举 240）；普通分支合计 10×10% + 终结 120% = 220%，与介绍一致。

import { 黑崎一护技能配置 } from "./00．配置";
import { 是否瞬步连携中, 关闭瞬步连携, 黑崎一护是否卍解 } from "./01．状态表";
import { 黑崎一护BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/09．黑崎一护";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕, 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
  施加减速: (this: void, source: any, target: any, reduceRatio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { Sound3DII_CooPlayPool4MultiInstanceRare } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayPool4MultiInstanceRare: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
// Blizzard.j 函数不能从 jass.common 取，统一从项目 BJ 函数库导入。
const { IsUnitAliveBJ, SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (this: void, unit: any, buffId: number, duration: number) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, show: boolean) => void;
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const R2S = jass.R2S as (this: void, value: number) => string;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha as (this: void, effect: any, alpha: number) => void;
const DzSetEffectAnimation = japi.DzSetEffectAnimation as (this: void, effect: any, animationIndex: number, flag: number) => void;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_HERO = jass.ATTACK_TYPE_HERO as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const E类型ID = stringToFourCC(配置.E.技能ID);
const 视野马甲类型ID = stringToFourCC("e007");
const 定时生命BuffID = stringToFourCC("BHwe");

// ---------------------------------------------------------------------------
// 上下文
// ---------------------------------------------------------------------------

interface E幻影 {
  X: number;
  Y: number;
  面向角度: number;
  特效: any;
  已命中: boolean;
}

interface E上下文 {
  施法者: any;
  已启动: boolean;
  视野马甲: any;
  // 普通分支
  普通回调ID: number;
  普通Tick数: number;
  // 连携分支
  目标: any;
  幻影列表: E幻影[];
  冲锋回调ID: number;
  冲锋Tick数: number;
  攻击力快照: number;
  技能实例ID?: number;
}

const E上下文表: Record<number, E上下文> = {};

function 获取或创建E上下文(this: void, unit: any): E上下文 {
  const id = GetHandleId(unit);
  let ctx = E上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      已启动: false,
      视野马甲: null,
      普通回调ID: 0,
      普通Tick数: 0,
      目标: null,
      幻影列表: [],
      冲锋回调ID: 0,
      冲锋Tick数: 0,
      攻击力快照: 0,
    };
    E上下文表[id] = ctx;
  }
  return ctx;
}

function E可释放(this: void, context: E上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

function 恢复E施法者显示(this: void, ctx: E上下文): void {
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    ShowUnit(caster, true);
    SelectUnitForPlayerSingle(caster, GetOwningPlayer(caster));
  }
  if (ctx.视野马甲 != null && ctx.视野马甲 !== 0) {
    立即移除单位并取消排泄登记(ctx.视野马甲);
    ctx.视野马甲 = null;
  }
}

function 清理E幻影(this: void, ctx: E上下文): void {
  for (let i = 0; i < ctx.幻影列表.length; i++) {
    const phantom = ctx.幻影列表[i];
    if (phantom.特效 != null && phantom.特效 !== 0) {
      // 直接销毁 Ichigo.mdl 会播放模型 Death 序列；先隐藏再销毁，表现与源马甲瞬间清除一致。
      DzSetEffectVertexAlpha(phantom.特效, 0);
      销毁点特效(phantom.特效);
      phantom.特效 = null;
    }
  }
  ctx.幻影列表 = [];
}

function 结束E普通分支(this: void, ctx: E上下文, 是否结算终结: boolean): void {
  if (ctx.普通回调ID !== 0) removePeriodicCallback(ctx.普通回调ID);
  ctx.普通回调ID = 0;
  ctx.已启动 = false;
  if (是否结算终结) {
    const caster = ctx.施法者;
    const x = GetUnitX(caster);
    const y = GetUnitY(caster);
    创建点特效({
      模型路径: 配置.E.普通.结束.特效模型,
      X: x,
      Y: y,
      Z: 0,
      面向角度: GetRandomReal(1, 360),
      缩放: 配置.E.普通.结束.特效缩放,
      持续秒: 配置.E.普通.结束.特效持续秒,
    });
    const 敌军 = 获取范围敌军(caster, x, y, 配置.E.普通.斩击半径);
    if (敌军 != null) {
      const 终结伤害 = ctx.攻击力快照 * 配置.E.普通.结束.伤害攻击力倍率;
      for (let i = 0; i < 敌军.length; i++) {
        const target = 敌军[i];
        if (target == null || target === 0) continue;
        造成单体技能伤害({
          来源: caster,
          目标: target,
          伤害: 终结伤害,
          伤害类型: DAMAGE_TYPE_NORMAL,
          attack: false,
          attackType: ATTACK_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_WHOKNOWS,
          来源类型: "单位技能",
          标签: "黑崎一护-E瞬步斩终结",
          技能ID: E类型ID,
          技能实例ID: ctx.技能实例ID,
        });
        施加眩晕(caster, target, 配置.E.普通.结束.眩晕秒, "黑崎一护-瞬步斩", "技能");
        registerManualBuff(target, 黑崎一护BuffID.瞬步斩眩晕, 配置.E.普通.结束.眩晕秒, 0);
      }
    }
    Sound3DII_CooPlayPool4MultiInstanceRare(配置.E.普通.结束.音效.路径, x, y, 0, 配置.E.普通.结束.音效.裁断距离);
  }
  恢复E施法者显示(ctx);
}

function 推进E普通斩击(this: void, variable: any): void {
  const ctx = variable as E上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束E普通分支(ctx, false);
    return;
  }

  if (ctx.普通Tick数 >= 配置.E.普通.斩击次数) {
    结束E普通分支(ctx, true);
    return;
  }
  ctx.普通Tick数 += 1;

  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  创建点特效({
    模型路径: 配置.E.普通.斩击特效.模型,
    X: x,
    Y: y,
    Z: 0,
    面向角度: GetRandomReal(1, 360),
    缩放: 配置.E.普通.斩击特效.缩放,
    持续秒: 配置.E.普通.斩击特效.持续秒,
  });
  Sound3DII_CooPlayPool4MultiInstanceRare(配置.E.普通.斩击音效.路径, x, y, 0, 配置.E.普通.斩击音效.裁断距离);

  const 敌军 = 获取范围敌军(caster, x, y, 配置.E.普通.斩击半径);
  if (敌军 == null || 敌军.length === 0) return;
  const 单次伤害 = ctx.攻击力快照 * 配置.E.普通.单次伤害攻击力倍率;
  for (let i = 0; i < 敌军.length; i++) {
    const target = 敌军[i];
    if (target == null || target === 0) continue;
    // 源：50% 概率触发攻击效果（attack 标志随机），伤害均为攻击力×10%
    const 触发攻击效果 = GetRandomInt(1, 2) === 1;
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: 单次伤害,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attack: 触发攻击效果,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "黑崎一护-E瞬步斩斩击",
      技能ID: E类型ID,
      技能实例ID: ctx.技能实例ID,
    });
    施加减速(caster, target, 配置.E.普通.减速比例, 配置.E.普通.减速持续秒, "黑崎一护-瞬步斩", "技能");
  }
}

// ---------------------------------------------------------------------------
// 连携分支：6 幻影集火
// ---------------------------------------------------------------------------

function 结算E幻影命中(this: void, ctx: E上下文, phantom: E幻影): void {
  phantom.已命中 = true;
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (target == null || target === 0 || !IsUnitAliveBJ(target)) return;

  const 当前魔法 = GetUnitState(caster, UNIT_STATE_MANA);
  const 最大魔法 = GetUnitState(caster, UNIT_STATE_MAX_MANA);
  const 魔法加成 = 最大魔法 > 0 ? 当前魔法 / 最大魔法 : 0;
  const 伤害 = ctx.攻击力快照 * 配置.E.连携.单次伤害攻击力倍率 * (1 + 魔法加成);

  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: true, // 源：触发攻击效果
    attackType: ATTACK_TYPE_HERO,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    标签: "黑崎一护-E瞬步斩幻影",
    技能ID: E类型ID,
    技能实例ID: ctx.技能实例ID,
  });

  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const 命中特效 = 黑崎一护是否卍解(caster) ? 配置.E.连携.命中特效解放后 : 配置.E.连携.命中特效解放前;
  创建点特效({ 模型路径: 命中特效.模型, X: tx, Y: ty, Z: 命中特效.高度, 面向角度: 270, 缩放: 命中特效.缩放, 持续秒: 命中特效.持续秒 });
  创建点特效({
    模型路径: 配置.E.普通.斩击特效.模型,
    X: tx,
    Y: ty,
    Z: 0,
    面向角度: GetRandomReal(1, 360),
    缩放: 配置.E.普通.斩击特效.缩放,
    持续秒: 配置.E.普通.斩击特效.持续秒,
  });
  Sound3DII_CooPlayPool4MultiInstanceRare(配置.E.普通.斩击音效.路径, tx, ty, 0, 配置.E.普通.斩击音效.裁断距离);
  const 切肉音 = GetRandomInt(1, 3);
  Sound3DII_CooPlayPool4MultiInstanceRare("Sound\\Units\\Combat\\MetalHeavySliceFlesh" + R2S(切肉音) + ".wav", tx, ty, 0, 1500);
}

function SetUnitManaDirect(this: void, unit: any, value: number): void {
  SetUnitState(unit, UNIT_STATE_MANA, value < 0 ? 0 : value);
}

function 结束E连携分支(this: void, ctx: E上下文): void {
  if (ctx.冲锋回调ID !== 0) removePeriodicCallback(ctx.冲锋回调ID);
  ctx.冲锋回调ID = 0;
  ctx.已启动 = false;

  const caster = ctx.施法者;
  if (caster != null && caster !== 0 && IsUnitAliveBJ(caster)) {
    // 源：结束后固定消耗 20% 最大魔法值
    const 最大魔法 = GetUnitState(caster, UNIT_STATE_MAX_MANA);
    SetUnitManaDirect(caster, GetUnitState(caster, UNIT_STATE_MANA) - 最大魔法 * 配置.E.连携.结束.魔法扣除最大比例);
  }
  const target = ctx.目标;
  if (target != null && target !== 0) {
    创建点特效({ 模型路径: 配置.E.连携.结束.鲜血爆炸模型, X: GetUnitX(target), Y: GetUnitY(target), Z: 0, 持续秒: 配置.E.连携.结束.鲜血爆炸持续秒 });
  }
  清理E幻影(ctx);
  ctx.目标 = null;
  恢复E施法者显示(ctx);
}

function 推进E幻影冲锋(this: void, variable: any): void {
  const ctx = variable as E上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束E连携分支(ctx);
    return;
  }

  if (ctx.冲锋Tick数 >= 配置.E.连携.最大推进次数) {
    结束E连携分支(ctx);
    return;
  }
  ctx.冲锋Tick数 += 1;

  const target = ctx.目标;
  const 目标存活 = target != null && target !== 0 && IsUnitAliveBJ(target);
  const tx = 目标存活 ? GetUnitX(target) : 0;
  const ty = 目标存活 ? GetUnitY(target) : 0;

  for (let i = 0; i < ctx.幻影列表.length; i++) {
    const phantom = ctx.幻影列表[i];
    const rad = phantom.面向角度 * bj_DEGTORAD;
    phantom.X += Cos(rad) * 配置.E.连携.每Tick距离;
    phantom.Y += Sin(rad) * 配置.E.连携.每Tick距离;
    if (phantom.特效 != null && phantom.特效 !== 0) {
      japi.DzSetEffectPos(phantom.特效, phantom.X, phantom.Y, 配置.E.连携.幻影高度);
    }
    if (!phantom.已命中 && 目标存活) {
      const dx = phantom.X - tx;
      const dy = phantom.Y - ty;
      if (SquareRoot(dx * dx + dy * dy) <= 配置.E.连携.命中判定半径) {
        结算E幻影命中(ctx, phantom);
      }
    }
  }
}

function E连携起手冲锋(this: void, variable: any): void {
  const ctx = variable as E上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  // 源：+0.2s 幻影播放 Spell 并落下 AIviTarget，随后启动 0.03s 冲锋周期
  for (let i = 0; i < ctx.幻影列表.length; i++) {
    const phantom = ctx.幻影列表[i];
    if (phantom.特效 != null && phantom.特效 !== 0) {
      DzSetEffectAnimation(phantom.特效, 配置.E.连携.幻影施法动画索引, 0);
    }
    创建点特效({ 模型路径: 配置.E.连携.起手特效.模型, X: phantom.X, Y: phantom.Y, Z: 0, 面向角度: 270, 缩放: 配置.E.连携.起手特效.缩放, 持续秒: 配置.E.连携.起手特效.持续秒 });
  }
  ctx.冲锋Tick数 = 0;
  ctx.冲锋回调ID = addPeriodicCallback(
    秒转毫秒(配置.E.连携.推进间隔秒),
    推进E幻影冲锋 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// 释放入口
// ---------------------------------------------------------------------------

function 选取E连携目标(this: void, caster: any, x: number, y: number): any {
  const 敌军 = 获取范围敌军(caster, x, y, 配置.E.连携.目标选取半径);
  let target: any = null;
  let 最近距离 = -1;
  if (敌军 != null) {
    for (let i = 0; i < 敌军.length; i++) {
      const u = 敌军[i];
      if (u == null || u === 0) continue;
      const dx = GetUnitX(u) - x;
      const dy = GetUnitY(u) - y;
      const dist = dx * dx + dy * dy;
      if (最近距离 < 0 || dist < 最近距离) {
        最近距离 = dist;
        target = u;
      }
    }
  }
  return target;
}

function 释放瞬步斩(this: void, context: E上下文, caster: any, 技能实例ID?: number): void {
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  Sound3DII_CooPlayPool4MultiInstanceRare(配置.E.音效.路径, x, y, 0, 配置.E.音效.裁断距离);
  Sound3DII_CooPlayPool4MultiInstanceRare(配置.E.金属音效.路径, x, y, 0, 配置.E.金属音效.裁断距离);

  context.施法者 = caster;
  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.攻击力快照 = 读取单位攻击力(caster);
  context.普通Tick数 = 0;
  context.冲锋Tick数 = 0;
  context.幻影列表 = [];
  context.目标 = null;

  // D 连携只在范围内存在合法目标时成立；否则消耗本次连携窗口并完整回退普通 E。
  let 连携目标: any = null;
  if (是否瞬步连携中(caster)) {
    关闭瞬步连携(caster);
    连携目标 = 选取E连携目标(caster, x, y);
  }

  // 源：隐藏本体，创建视野马甲保持视野
  ShowUnit(caster, false);
  context.视野马甲 = 创建单位并登记排泄安全(GetOwningPlayer(caster), 视野马甲类型ID, x, y, 0);
  UnitApplyTimedLife(context.视野马甲, 定时生命BuffID, 2.5);

  if (连携目标 != null && 连携目标 !== 0) {
    const target = 连携目标;
    context.目标 = target;

    // 源：起手即对目标施加 2 秒眩晕
    施加眩晕(caster, target, 配置.E.连携.起手眩晕秒, "黑崎一护-瞬步斩", "技能");
    registerManualBuff(target, 黑崎一护BuffID.瞬步斩眩晕, 配置.E.连携.起手眩晕秒, 0);

    // 6 个幻影环绕（半径 240，面向目标），直接特效表现
    const 目标X = GetUnitX(target);
    const 目标Y = GetUnitY(target);
    for (let i = 1; i <= 配置.E.连携.幻影数量; i++) {
      const deg = 60 * i;
      const rad = deg * bj_DEGTORAD;
      const px = x + Cos(rad) * 配置.E.连携.幻影半径;
      const py = y + Sin(rad) * 配置.E.连携.幻影半径;
      const faceDeg = Atan2(目标Y - py, 目标X - px) * bj_RADTODEG;
      const effect = 创建点特效({
        模型路径: 配置.E.连携.幻影模型,
        X: px,
        Y: py,
        Z: 配置.E.连携.幻影高度,
        面向角度: faceDeg,
        缩放: 配置.E.连携.幻影缩放,
        透明度: 配置.E.连携.幻影透明度,
      });
      context.幻影列表.push({ X: px, Y: py, 面向角度: faceDeg, 特效: effect, 已命中: false });
    }

    addDelayedCallback(
      秒转毫秒(配置.E.连携.冲锋延迟秒),
      E连携起手冲锋 as unknown as (this: void, variable?: any) => void,
      context,
    );
  } else {
    // 普通分支：1.5 秒范围斩击
    创建点特效({ 模型路径: "war3mapImported\\dustwaveanimate.mdl", X: x, Y: y, Z: 0, 面向角度: GetRandomReal(1, 360), 缩放: 2, 动画速度: 2.5, 持续秒: 1.2 });
    context.普通回调ID = addPeriodicCallback(
      秒转毫秒(配置.E.普通.斩击间隔秒),
      推进E普通斩击 as unknown as (this: void, variable?: any) => void,
      context,
    );
  }
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let 死亡监听已注册 = false;

function E单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (jass.GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  const ctx = E上下文表[GetHandleId(dyingUnit)];
  if (ctx == null || ctx.已启动 !== true) return;
  if (ctx.普通回调ID !== 0) removePeriodicCallback(ctx.普通回调ID);
  if (ctx.冲锋回调ID !== 0) removePeriodicCallback(ctx.冲锋回调ID);
  ctx.普通回调ID = 0;
  ctx.冲锋回调ID = 0;
  ctx.已启动 = false;
  清理E幻影(ctx);
  if (ctx.视野马甲 != null && ctx.视野马甲 !== 0) {
    立即移除单位并取消排泄登记(ctx.视野马甲);
    ctx.视野马甲 = null;
  }
}

export function 注册黑崎一护E(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-瞬步斩（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.E.技能ID,
    获取或创建上下文: 获取或创建E上下文,
    可释放: E可释放,
    释放技能: 释放瞬步斩,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 4,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(E单位死亡清理);
  }
}

注册黑崎一护E();

export {};
