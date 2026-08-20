/** @noSelfInFile */
// Saber R：誓约胜利之剑（A0DF）蓄力 + 发射准备 + 光炮。
// 源 JASS 真源：主要技能.j 1855-2106/2403-2443。
// 单位壳 e063/e064/e066 迁移为直接特效（计划第 10 节）；光炮为路径 AOE、每目标仅一次。
// 60% 百分比魔耗由统一魔耗系统经物编字段结算，技能文件不重复扣蓝（时点差异记录在计划17.4）。
// 阿瓦隆分支：保留源的发射准备与动画时点，只跳过普通 4 秒蓄力。

import { Saber技能配置 } from "./00．配置";
import { Saber是否阿瓦隆 } from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";


const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, addPeriodicCallback, removeDelayedCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
// 源 PlaySoundOnUnitBJ(gg_snd_SaberExcalibur) / StopSoundBJ：照源用 jglobals 全局音效句柄 + BJ 封装播放
const { PlaySoundOnUnitBJ, StopSoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
  StopSoundBJ: (this: void, soundHandle: any, fadeOut: boolean) => void;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
// GetRandomDirectionDeg 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

const japi = require("jass.japi") as any;

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = Saber技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const R类型ID = stringToFourCC(配置.R.技能ID);

// ---------------------------------------------------------------------------
// R 上下文
// ---------------------------------------------------------------------------

interface 聚集粒子 {
  X: number;
  Y: number;
  高度: number;
  特效: any;
}

interface R上下文 {
  caster: any;
  技能实例ID?: number;
  已启动: boolean;
  伤害快照: number;
  Saber点X: number;
  Saber点Y: number;
  方向角度: number;
  飞行高度快照: number;
  阿瓦隆快照: boolean;
  蓄力回调ID: number;
  蓄力Tick数: number;
  聚集列表: 聚集粒子[];
  聚集回调ID: number;
  准备回调ID: number;
  能量回调ID: number;
  光炮回调ID: number;
  光炮Tick数: number;
  命中组: Record<number, boolean>;
}

const R上下文表: Record<number, R上下文> = {};

function 获取或创建R上下文(this: void, caster: any): R上下文 {
  const id = GetHandleId(caster);
  let record = R上下文表[id];
  if (record == null) {
    record = {
      caster,
      已启动: false,
      伤害快照: 0,
      Saber点X: 0,
      Saber点Y: 0,
      方向角度: 0,
      飞行高度快照: 0,
      阿瓦隆快照: false,
      蓄力回调ID: 0,
      蓄力Tick数: 0,
      聚集列表: [],
      聚集回调ID: 0,
      准备回调ID: 0,
      能量回调ID: 0,
      光炮回调ID: 0,
      光炮Tick数: 0,
      命中组: {},
    };
    R上下文表[id] = record;
  }
  return record;
}

function 销毁R聚集表现(this: void, ctx: R上下文): void {
  if (ctx.聚集回调ID !== 0) {
    removePeriodicCallback(ctx.聚集回调ID);
    ctx.聚集回调ID = 0;
  }
  for (const p of ctx.聚集列表) {
    if (p.特效 != null && p.特效 !== 0) 销毁点特效(p.特效);
  }
  ctx.聚集列表 = [];
}

function 清理R全部(this: void, ctx: R上下文): void {
  const caster = ctx.caster;
  if (ctx.蓄力回调ID !== 0) removePeriodicCallback(ctx.蓄力回调ID);
  if (ctx.准备回调ID !== 0) removeDelayedCallback(ctx.准备回调ID);
  if (ctx.能量回调ID !== 0) removeDelayedCallback(ctx.能量回调ID);
  if (ctx.光炮回调ID !== 0) removePeriodicCallback(ctx.光炮回调ID);
  ctx.蓄力回调ID = 0;
  ctx.准备回调ID = 0;
  ctx.能量回调ID = 0;
  ctx.光炮回调ID = 0;
  销毁R聚集表现(ctx);
  if (caster != null && caster !== 0) {
    移除单位暂停(caster, 配置.暂停来源.R蓄力);
  }
  ctx.已启动 = false;
}

function R可释放(this: void, context: R上下文, _caster: any): boolean {
  return !context.已启动;
}

// ---------------------------------------------------------------------------
// 蓄力阶段
// ---------------------------------------------------------------------------

// 源：蓄力结束后 ForGroupBJ(聚集单位组) 对每个粒子 IssuePointOrder("move", Saber位置)
// + SetUnitTimeScale(50)，全部粒子高速汇聚回 Saber；TS 用周期回调推进直接特效模拟
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;

function 推进R聚集回收(this: void, variable?: any): void {
  const ctx = variable as R上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;
  if (ctx.聚集列表.length === 0 || caster == null || caster === 0) {
    销毁R聚集表现(ctx);
    return;
  }

  const cfg = 配置.R.蓄力结束.聚集回收;
  const 目标X = GetUnitX(caster);
  const 目标Y = GetUnitY(caster);
  const 目标高度 = GetUnitFlyHeight(caster);
  const 剩余: 聚集粒子[] = [];
  for (const p of ctx.聚集列表) {
    const dx = 目标X - p.X;
    const dy = 目标Y - p.Y;
    const 距离 = SquareRoot(dx * dx + dy * dy);
    if (距离 <= cfg.到达距离) {
      if (p.特效 != null && p.特效 !== 0) 销毁点特效(p.特效);
      continue;
    }
    const 步长 = 距离 < cfg.每次移动距离 ? 距离 : cfg.每次移动距离;
    p.X += dx / 距离 * 步长;
    p.Y += dy / 距离 * 步长;
    // 高度同步收拢到 Saber 飞行高度，汇聚视觉不悬空
    const 高差 = 目标高度 - p.高度;
    const 限幅高差 = 高差 > cfg.每次高度变化 ? cfg.每次高度变化 : 高差 < -cfg.每次高度变化 ? -cfg.每次高度变化 : 高差;
    p.高度 += 限幅高差;
    if (p.特效 != null && p.特效 !== 0) {
      DzSetEffectPos(p.特效, p.X, p.Y, p.高度);
    }
    剩余.push(p);
  }
  ctx.聚集列表 = 剩余;
  if (ctx.聚集列表.length === 0 && ctx.聚集回调ID !== 0) {
    removePeriodicCallback(ctx.聚集回调ID);
    ctx.聚集回调ID = 0;
  }
}

function 启动R聚集回收(this: void, ctx: R上下文): void {
  if (ctx.聚集列表.length === 0) return;
  if (ctx.聚集回调ID !== 0) removePeriodicCallback(ctx.聚集回调ID);
  ctx.聚集回调ID = addPeriodicCallback(
    秒转毫秒(配置.R.蓄力结束.聚集回收.Tick间隔秒),
    推进R聚集回收 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function R蓄力结束(this: void, ctx: R上下文): void {
  const caster = ctx.caster;
  if (ctx.蓄力回调ID !== 0) removePeriodicCallback(ctx.蓄力回调ID);
  ctx.蓄力回调ID = 0;

  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理R全部(ctx);
    return;
  }

  if (ctx.阿瓦隆快照) {
    // 阿瓦隆：跳过普通蓄力，直接播放发射音效（源 PlaySoundOnUnitBJ(gg_snd_SaberExcalibur)）
    const r阿瓦隆音效句柄 = (jglobals as any)[配置.R.蓄力.音效.全局音效键];
    if (r阿瓦隆音效句柄 != null) PlaySoundOnUnitBJ(r阿瓦隆音效句柄, 100, caster);
    销毁R聚集表现(ctx);
  } else {
    // 普通蓄力结束：聚集法阵 + 粒子高速汇聚回 Saber（源 IssuePointOrder move + TimeScale 50）
    创建点特效({
      模型路径: 配置.R.蓄力结束.法阵特效.模型路径,
      X: ctx.Saber点X,
      Y: ctx.Saber点Y,
      面向角度: ctx.方向角度 + 配置.R.蓄力结束.法阵特效.朝向偏移,
      缩放: 配置.R.蓄力结束.法阵特效.缩放,
      持续秒: 配置.R.蓄力结束.法阵特效.持续秒,
    });
    启动R聚集回收(ctx);
  }

  SetUnitAnimationByIndex(caster, 配置.R.蓄力结束.动作索引);
  ctx.准备回调ID = addDelayedCallback(
    秒转毫秒(配置.R.蓄力结束.发射准备延迟秒),
    R发射准备 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 推进R蓄力(this: void, variable?: any): void {
  const ctx = variable as R上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;

  if (caster == null || caster === 0 || !单位存活(caster) || ctx.阿瓦隆快照 || ctx.蓄力Tick数 >= 配置.R.蓄力.最大Tick数) {
    R蓄力结束(ctx);
    return;
  }

  ctx.蓄力Tick数 += 1;
  if (ctx.蓄力Tick数 === 配置.R.蓄力.音效Tick) {
    // 源第 78 周期 PlaySoundOnUnitBJ(gg_snd_SaberExcalibur)
    const r蓄力音效句柄 = (jglobals as any)[配置.R.蓄力.音效.全局音效键];
    if (r蓄力音效句柄 != null) PlaySoundOnUnitBJ(r蓄力音效句柄, 100, caster);
  }

  const cfg = 配置.R.蓄力.聚集粒子;
  // 每周期创建 3 个聚集粒子（随机半径 0-720、随机方向）
  for (let i = 0; i < cfg.每Tick数量; i++) {
    const 半径 = GetRandomReal(0, cfg.随机半径上限);
    const 角度 = GetRandomDirectionDeg() * bj_DEGTORAD;
    const X = ctx.Saber点X + 半径 * Cos(角度);
    const Y = ctx.Saber点Y + 半径 * Sin(角度);
    ctx.聚集列表.push({
      X,
      Y,
      高度: ctx.飞行高度快照,
      特效: 创建点特效({
        模型路径: cfg.模型路径,
        X,
        Y,
        Z: ctx.飞行高度快照,
        持续秒: -1,
      }),
    });
  }

  // 全体粒子升降：前 75 周期 +18，之后 -30；达到 600 移除
  const 剩余: 聚集粒子[] = [];
  for (const p of ctx.聚集列表) {
    if (p.高度 >= cfg.移除高度) {
      if (p.特效 != null && p.特效 !== 0) 销毁点特效(p.特效);
      continue;
    }
    p.高度 += ctx.蓄力Tick数 >= cfg.上升段Tick数 ? cfg.下降每次高度 : cfg.上升每次高度;
    if (p.高度 < 0) p.高度 = 0;
    if (p.特效 != null && p.特效 !== 0) {
      DzSetEffectPos(p.特效, p.X, p.Y, p.高度);
    }
    剩余.push(p);
  }
  ctx.聚集列表 = 剩余;
}

// ---------------------------------------------------------------------------
// 发射准备与光炮
// ---------------------------------------------------------------------------

function R创建能量表现(this: void, ctx: R上下文, 角度: number): void {
  const 面向弧度 = (角度 + 180) * bj_DEGTORAD;
  const 点1X = ctx.Saber点X + 配置.R.发射.能量A.后方偏移 * Cos(面向弧度);
  const 点1Y = ctx.Saber点Y + 配置.R.发射.能量A.后方偏移 * Sin(面向弧度);
  const 点2X = ctx.Saber点X + 配置.R.发射.能量B.后方偏移 * Cos(面向弧度);
  const 点2Y = ctx.Saber点Y + 配置.R.发射.能量B.后方偏移 * Sin(面向弧度);
  创建点特效({
    模型路径: 配置.R.发射.能量A.模型路径,
    X: 点1X,
    Y: 点1Y,
    Z: 配置.R.发射.能量A.飞行高度,
    面向角度: 角度 + 配置.R.发射.能量A.朝向偏移,
    缩放: 配置.R.发射.能量A.缩放,
    动画速度: 配置.R.发射.能量A.动画速度,
    持续秒: 配置.R.光炮.间隔秒 * 配置.R.光炮.最大Tick数 + 1,
  });
  创建点特效({
    模型路径: 配置.R.发射.能量B.模型路径,
    X: 点2X,
    Y: 点2Y,
    面向角度: 角度 + 配置.R.发射.能量B.朝向偏移,
    缩放: 配置.R.发射.能量B.缩放,
    动画速度: 配置.R.发射.能量B.动画速度,
    蓝: 配置.R.发射.能量B.蓝,
    持续秒: 配置.R.光炮.间隔秒 * 配置.R.光炮.最大Tick数 + 1,
  });
}

function 推进R光炮(this: void, variable?: any): void {
  const ctx = variable as R上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;

  const 收尾 = (): void => {
    if (ctx.光炮回调ID !== 0) removePeriodicCallback(ctx.光炮回调ID);
    ctx.光炮回调ID = 0;
    ctx.已启动 = false;
  };

  if (caster == null || caster === 0 || !单位存活(caster)) {
    收尾();
    return;
  }

  ctx.光炮Tick数 += 1;
  if (ctx.光炮Tick数 > 配置.R.光炮.最大Tick数) {
    收尾();
    return;
  }

  // 源：第 10/20 周期重新创建能量表现
  for (const tick of 配置.R.发射.能量重现Tick) {
    if (ctx.光炮Tick数 === tick) {
      R创建能量表现(ctx, GetUnitFacing(caster));
    }
  }

  // 伤害点沿方向推进：50×循环数，半径 350，每目标仅一次
  const 弧度 = ctx.方向角度 * bj_DEGTORAD;
  const 点X = ctx.Saber点X + 配置.R.光炮.每Tick距离 * ctx.光炮Tick数 * Cos(弧度);
  const 点Y = ctx.Saber点Y + 配置.R.光炮.每Tick距离 * ctx.光炮Tick数 * Sin(弧度);
  if (配置.R.光炮.每Tick距离 * ctx.光炮Tick数 > 配置.R.光炮.最大距离) {
    收尾();
    return;
  }

  const 敌军列表 = 获取范围敌军(caster, 点X, 点Y, 配置.R.光炮.伤害半径);
  const 新目标: any[] = [];
  for (const target of 敌军列表) {
    if (target == null || target === 0) continue;
    if (ctx.命中组[GetHandleId(target)] === true) continue;
    ctx.命中组[GetHandleId(target)] = true;
    新目标.push(target);
  }
  if (新目标.length > 0) {
    const 倍率 = ctx.阿瓦隆快照 ? 配置.R.光炮.阿瓦隆伤害攻击力倍率 : 配置.R.光炮.伤害攻击力倍率;
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 新目标,
      伤害: ctx.伤害快照 * 倍率,
      伤害类型: DAMAGE_TYPE_DIVINE,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: ctx.阿瓦隆快照 ? "Saber-R-光炮-阿瓦隆" : "Saber-R-光炮",
      技能ID: R类型ID,
      技能实例ID: ctx.技能实例ID,
    });
  }
}

function R能量与光炮启动(this: void, variable?: any): void {
  const ctx = variable as R上下文 | undefined;
  if (ctx == null) return;
  ctx.能量回调ID = 0;
  const caster = ctx.caster;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    ctx.已启动 = false;
    return;
  }

  // 源：发射准备时重新读取 Saber 当前面向作为光炮方向
  const 角度 = GetUnitFacing(caster);
  R创建能量表现(ctx, 角度);
  移除单位暂停(caster, 配置.暂停来源.R蓄力);

  ctx.光炮Tick数 = 0;
  ctx.命中组 = {};
  ctx.光炮回调ID = addPeriodicCallback(
    秒转毫秒(配置.R.光炮.间隔秒),
    推进R光炮 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function R发射准备(this: void, variable?: any): void {
  const ctx = variable as R上下文 | undefined;
  if (ctx == null) return;
  ctx.准备回调ID = 0;
  销毁R聚集表现(ctx); // 发射准备时点强制收尾，未汇聚完的粒子一并回收
  const caster = ctx.caster;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    ctx.已启动 = false;
    return;
  }

  // 光束先于伤害出现
  创建点特效({
    模型路径: 配置.R.发射.光束.模型路径,
    X: ctx.Saber点X,
    Y: ctx.Saber点Y,
    面向角度: ctx.方向角度 + 配置.R.发射.光束.朝向偏移,
    缩放: 配置.R.发射.光束.缩放,
    持续秒: 配置.R.发射.光束.持续秒,
  });

  ctx.能量回调ID = addDelayedCallback(
    秒转毫秒(配置.R.发射.能量准备延迟秒),
    R能量与光炮启动 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// 施法入口
// ---------------------------------------------------------------------------

function 释放R技能(this: void, context: R上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) {
    return;
  }
  context.已启动 = true;
  context.caster = caster;
  context.技能实例ID = 技能实例ID;
  context.伤害快照 = 读取单位攻击力(caster);
  context.Saber点X = GetUnitX(caster);
  context.Saber点Y = GetUnitY(caster);
  context.方向角度 = 两点角度(context.Saber点X, context.Saber点Y, GetSpellTargetX(), GetSpellTargetY());
  context.飞行高度快照 = GetUnitFlyHeight(caster);
  context.阿瓦隆快照 = Saber是否阿瓦隆(caster);
  context.蓄力Tick数 = 0;
  context.光炮Tick数 = 0;
  context.命中组 = {};
  context.聚集列表 = [];

  // 起手：暂停 + 动作索引 1
  添加单位暂停(caster, 配置.暂停来源.R蓄力);
  SetUnitAnimationByIndex(caster, 配置.R.起手.动作索引);

  context.蓄力回调ID = addPeriodicCallback(
    秒转毫秒(配置.R.蓄力.间隔秒),
    推进R蓄力 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let R死亡监听已注册 = false;

function R单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  const ctx = R上下文表[GetHandleId(dyingUnit)];
  if (ctx == null || !ctx.已启动) return;
  // 源：施法者死亡时 StopSoundBJ(gg_snd_SaberExcalibur, true) 淡出停播
  const excalibur句柄 = (jglobals as any)[配置.R.蓄力.音效.全局音效键];
  if (excalibur句柄 != null) StopSoundBJ(excalibur句柄, true);
  清理R全部(ctx);
}

export function 注册SaberR(this: void): void {
  注册单位技能壳监听({
    名称: "Saber-誓约胜利之剑（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.R.技能ID,
    获取或创建上下文: 获取或创建R上下文,
    可释放: R可释放,
    释放技能: 释放R技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 12,
  });
  if (!R死亡监听已注册) {
    R死亡监听已注册 = true;
    registerDeathListener(R单位死亡清理);
  }
}

注册SaberR();

export {};
