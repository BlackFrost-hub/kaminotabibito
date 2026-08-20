/** @noSelfInFile */
// Saber W：风王铁锤（A0DE）双入口 + E 联动。
// 源 JASS 真源：主要技能.j（地面 1686-1776/1553-1614/1487-1551；E地面 1645-1677；敌人 1777-1824/1385-1485；E敌人冲击 1310-1359）。
// 单位壳 e061/e062/e065 迁移为直接特效 + 路径上下文（计划第 10 节），伤害走统一封装。
// 冲突口径：地面减速 99%/2 秒、E地面硬直 2 秒以技能说明为准；源末尾改写 A0DB 冷却为遗留错误，不迁移（计划17.3）。

import { Saber技能配置 } from "./00．配置";
import { SaberBuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/08．Saber";
import { Saber是否E开启, 消耗SaberE } from "./04．E技能";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";


const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 开始闪烁 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.06．闪烁") as {
  开始闪烁: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成批量AOE技能伤害: (this: void, params: any) => number;
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
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { getCooldownReduction } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  getCooldownReduction: (this: void, unit: any) => number;
};
const { setAbilityCooldown } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  setAbilityCooldown: (this: void, unit: any, abilityId: number, level: number, cooldown: number) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
// 源 PlaySoundOnUnitBJ(gg_snd_BansheeMissileLaunch2 / gg_snd_Saber_EW1 / gg_snd_CorrosiveBreathMissileLaunch1)：照源用 jglobals 全局音效句柄
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  销毁点特效: (this: void, effect: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetLoc = jass.GetSpellTargetLoc as (this: void) => any;
const GetLocationX = jass.GetLocationX as (this: void, loc: any) => number;
const GetLocationY = jass.GetLocationY as (this: void, loc: any) => number;
const RemoveLocation = jass.RemoveLocation as (this: void, loc: any) => void;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const IsUnitInRange = jass.IsUnitInRange as (this: void, a: any, b: any, range: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const WEAPON_TYPE_METAL_MEDIUM_SLICE = jass.WEAPON_TYPE_METAL_MEDIUM_SLICE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = Saber技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const W类型ID = stringToFourCC(配置.W.技能ID);

// ---------------------------------------------------------------------------
// W 地面分支（无 E）：传送 + 6 路龙卷风
// ---------------------------------------------------------------------------

interface 龙卷风路径 {
  X: number;
  Y: number;
  角度: number;
  特效: any;
}

interface W地面上下文 {
  caster: any;
  技能实例ID?: number;
  伤害快照: number;
  龙卷风列表: 龙卷风路径[];
  命中组: Record<number, boolean>;
  周期回调ID: number;
  Tick数: number;
}

function 清理龙卷风表现(this: void, ctx: W地面上下文): void {
  for (const path of ctx.龙卷风列表) {
    if (path.特效 != null && path.特效 !== 0) 销毁点特效(path.特效);
    path.特效 = null;
  }
  ctx.龙卷风列表 = [];
}

function 推进W龙卷风(this: void, variable?: any): void {
  const ctx = variable as W地面上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;

  const 收尾 = (): void => {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    清理龙卷风表现(ctx);
  };

  if (caster == null || caster === 0 || !单位存活(caster)) {
    收尾();
    return;
  }

  ctx.Tick数 += 1;
  if (ctx.Tick数 > 配置.W.地面分支.龙卷风.最大Tick数) {
    收尾();
    return;
  }

  const cfg = 配置.W.地面分支.龙卷风;
  for (const path of ctx.龙卷风列表) {
    const 弧度 = path.角度 * bj_DEGTORAD;
    path.X += cfg.每Tick距离 * Cos(弧度);
    path.Y += cfg.每Tick距离 * Sin(弧度);
    if (path.特效 != null && path.特效 !== 0) {
      DzSetEffectPos(path.特效, path.X, path.Y, cfg.飞行高度);
    }

    // 新目标：伤害 + 登记；已命中目标：按远离 Saber 方向击退
    const 敌军列表 = 获取范围敌军(caster, path.X, path.Y, cfg.伤害半径);
    const 新目标: any[] = [];
    for (const target of 敌军列表) {
      if (target == null || target === 0) continue;
      if (ctx.命中组[GetHandleId(target)] === true) {
        开始击退(target, {
          来源单位: caster,
          距离: cfg.重复组击退距离,
          持续时间: 0.05,
          检查地形: true,
          暂停单位: false,
          禁用碰撞: false,
        });
        continue;
      }
      ctx.命中组[GetHandleId(target)] = true;
      新目标.push(target);
    }
    if (新目标.length > 0) {
      造成批量AOE技能伤害({
        来源: caster,
        目标列表: 新目标,
        伤害: ctx.伤害快照 * cfg.伤害攻击力倍率,
        伤害类型: DAMAGE_TYPE_MIND,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_METAL_MEDIUM_SLICE,
        来源类型: "单位技能",
        标签: "Saber-W-地面龙卷风",
        技能ID: W类型ID,
        技能实例ID: ctx.技能实例ID,
        每目标结算后处理器: (target: any, _索引: number, 成功: boolean): void => {
          if (!成功 || target == null || target === 0) return;
          // 说明口径：减速 99% 持续 2 秒（源为 id=0 硬直 1.5 秒，审计差异见计划17.2）
          施加减速(caster, target, cfg.控制.减速比例, cfg.控制.减速秒, SaberBuffID.风王减速, "技能");
          registerManualBuff(target, SaberBuffID.风王减速, cfg.控制.减速秒, cfg.控制.减速比例, { 来源: caster, 标签: "Saber-W-地面龙卷风" });
        },
      });
    }
  }
}

function W地面启动龙卷风(this: void, variable?: any): void {
  const ctx = variable as W地面上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;
  if (caster == null || caster === 0 || !单位存活(caster)) return;

  const w龙卷风音效句柄 = (jglobals as any)[配置.W.地面分支.龙卷风.音效.全局音效键];
    if (w龙卷风音效句柄 != null) PlaySoundOnUnitBJ(w龙卷风音效句柄, 100, caster);
  SetUnitTimeScale(caster, 1.0);

  const cfg = 配置.W.地面分支.龙卷风;
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  for (let i = 1; i <= cfg.数量; i++) {
    const 角度 = cfg.出生朝向步进度 * i;
    ctx.龙卷风列表.push({
      X: x,
      Y: y,
      角度,
      特效: 创建点特效({
        模型路径: cfg.模型路径,
        X: x,
        Y: y,
        Z: cfg.飞行高度,
        面向角度: 角度,
        缩放: cfg.模型缩放,
        持续秒: cfg.推进间隔秒 * cfg.最大Tick数 + 1,
      }),
    });
  }
  ctx.Tick数 = 0;
  ctx.周期回调ID = addPeriodicCallback(
    秒转毫秒(cfg.推进间隔秒),
    推进W龙卷风 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

const W地面上下文表: Record<number, W地面上下文> = {};

/**
 * 读取 W 对地面施放的目标点：A0DE 是单位目标技能（targs=ground,enemies），点击地面时
 * GetSpellTargetUnit 为 null、GetSpellTargetX/Y 恒返 0,0，必须用 GetSpellTargetLoc 取点。
 * Lua 运行时无效 location 可能非 null，优先直接取坐标再释放；取到 (0,0) 时回落 X/Y。
 */
function 读取W地面目标点(this: void): { X: number; Y: number } {
  const loc = GetSpellTargetLoc();
  if (loc != null && loc !== 0) {
    const X = GetLocationX(loc);
    const Y = GetLocationY(loc);
    RemoveLocation(loc);
    if (X !== 0 || Y !== 0) return { X, Y };
  }
  const fx = GetSpellTargetX();
  const fy = GetSpellTargetY();
  return { X: fx, Y: fy };
}

function 释放W地面分支(this: void, caster: any, 目标X: number, 目标Y: number, 技能实例ID?: number): void {
  const cfg = 配置.W.地面分支;

  // 地面分支冷却：基础 7 秒，缩减上限 30%（源 YDWESetUnitAbilityDataReal 105=7，迁移为同步冷却接口）
  let 缩减 = getCooldownReduction(caster);
  if (缩减 > cfg.冷却缩减上限) 缩减 = cfg.冷却缩减上限;
  const 等级 = GetUnitAbilityLevel(caster, W类型ID);
  setAbilityCooldown(caster, W类型ID, 等级, cfg.冷却秒);
  技能_设置技能冷却时间(caster, W类型ID, cfg.冷却秒 - cfg.冷却秒 * 缩减, cfg.冷却秒);

  // 传送：最多 300 码（目标点为施法事件入口锁存值）
  const dx = 目标X - GetUnitX(caster);
  const dy = 目标Y - GetUnitY(caster);
  const 距离 = SquareRoot(dx * dx + dy * dy);
  const 实际距离 = 距离 > cfg.传送最大距离 ? cfg.传送最大距离 : 距离;
  const 方向 = 两点角度(GetUnitX(caster), GetUnitY(caster), 目标X, 目标Y);
  const 弧度 = 方向 * bj_DEGTORAD;
  const 落点X = GetUnitX(caster) + 实际距离 * Cos(弧度);
  const 落点Y = GetUnitY(caster) + 实际距离 * Sin(弧度);
  开始闪烁(caster, { 目标X: 落点X, 目标Y: 落点Y, 持续时间: 0, 闪烁期间暂停单位: false });

  // 落点气势特效 + 动作
  创建点特效({
    模型路径: cfg.气势特效.模型路径,
    X: 落点X,
    Y: 落点Y,
    动画速度: cfg.气势特效.动画速度,
    持续秒: cfg.气势特效.持续秒,
  });
  SetUnitAnimationByIndex(caster, cfg.动作索引);
  SetUnitTimeScale(caster, cfg.时间流速);

  const ctx: W地面上下文 = {
    caster,
    技能实例ID,
    伤害快照: 读取单位攻击力(caster),
    龙卷风列表: [],
    命中组: {},
    周期回调ID: 0,
    Tick数: 0,
  };
  W地面上下文表[GetHandleId(caster)] = ctx;
  addDelayedCallback(
    秒转毫秒(cfg.龙卷风.启动延迟秒),
    W地面启动龙卷风 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// W 地面分支（E 开启）：直线 12 段风王冲击
// ---------------------------------------------------------------------------

interface 闪避率记录项 {
  unit: any;
  原值: number;
}

interface WE地面上下文 {
  caster: any;
  技能实例ID?: number;
  伤害快照: number;
  方向角度: number;
  起点X: number;
  起点Y: number;
  重复组: Record<number, boolean>;
  闪避率记录: 闪避率记录项[];
  周期回调ID: number;
  Tick数: number;
}

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

function WE地面恢复闪避率(this: void, ctx: WE地面上下文): void {
  for (const item of ctx.闪避率记录) {
    if (item.unit == null || item.unit === 0 || !单位存活(item.unit)) continue;
    YDUserDataSetSafe("unit", item.unit, "闪避率", "real", item.原值);
  }
  ctx.闪避率记录 = [];
}

function 推进WE地面冲击(this: void, variable?: any): void {
  const ctx = variable as WE地面上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;

  const 收尾 = (): void => {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    WE地面恢复闪避率(ctx);
    移除单位暂停(caster, 配置.暂停来源.W地面E联动);
  };

  if (caster == null || caster === 0 || !单位存活(caster)) {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    return;
  }

  ctx.Tick数 += 1;
  if (ctx.Tick数 > 配置.W.E联动地面分支.路径.Tick数) {
    收尾();
    return;
  }

  const cfg = 配置.W.E联动地面分支;
  const 弧度 = ctx.方向角度 * bj_DEGTORAD;
  const 点X = ctx.起点X + cfg.路径.每Tick距离 * ctx.Tick数 * Cos(弧度);
  const 点Y = ctx.起点Y + cfg.路径.每Tick距离 * ctx.Tick数 * Sin(弧度);

  // e061 风王冲击表现（物编缩放 1.5 × 运行时 5）
  // 物编 e061 烘焙 Y 轴旋转 -90，源用 CreateUnit facing=角度+90 补偿；
  // 特效无物编数据，用 Y轴角度 -90 复现物编旋转，朝向沿用源 角度+90。
  创建点特效({
    模型路径: cfg.表现特效.模型路径,
    X: 点X,
    Y: 点Y,
    Z: cfg.表现特效.飞行高度,
    面向角度: ctx.方向角度 + cfg.表现特效.朝向偏移,
    Y轴角度: -90,
    缩放: cfg.表现特效.缩放,
    持续秒: cfg.表现特效.持续秒,
  });

  // 首次进入：硬直并登记；重复组：每周期伤害 + 沿路径击退
  const 敌军列表 = 获取范围敌军(caster, 点X, 点Y, cfg.路径.伤害半径);
  const 新目标: any[] = [];
  for (const target of 敌军列表) {
    if (target == null || target === 0) continue;
    if (ctx.重复组[GetHandleId(target)] === true) {
      开始击退(target, {
        角度: ctx.方向角度,
        距离: cfg.持续击退距离,
        持续时间: cfg.路径.Tick间隔秒,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: false,
      });
      continue;
    }
    ctx.重复组[GetHandleId(target)] = true;
    // 说明：无法闪避（源对英雄/恶魔记录并清零闪避率）
    if (IsUnitType(target, UNIT_TYPE_HERO)) {
      const 当前闪避 = Number(YDUserDataGetSafe("unit", target, "闪避率", "real")) || 0;
      ctx.闪避率记录.push({ unit: target, 原值: 当前闪避 });
      YDUserDataSetSafe("unit", target, "闪避率", "real", 0);
    }
    新目标.push(target);
  }
  // 源：首次进入只施加控制并登记，不造成伤害
  for (const target of 新目标) {
    施加眩晕(caster, target, cfg.首次控制秒, SaberBuffID.风王冲击硬直, "技能");
    registerManualBuff(target, SaberBuffID.风王冲击硬直, cfg.首次控制秒, 0, { 来源: caster, 标签: "Saber-W-E联动地面" });
  }

  // 重复组持续伤害（源：每周期攻击力×0.5，12 周期合计×6 = 说明 600%）
  const 重复目标: any[] = [];
  const 全部敌军 = 获取范围敌军(caster, 点X, 点Y, cfg.路径.伤害半径 + cfg.路径.每Tick距离);
  for (const target of 全部敌军) {
    if (target == null || target === 0) continue;
    if (ctx.重复组[GetHandleId(target)] !== true) continue;
    重复目标.push(target);
  }
  if (重复目标.length > 0) {
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 重复目标,
      伤害: ctx.伤害快照 * cfg.持续伤害攻击力倍率,
      伤害类型: DAMAGE_TYPE_PLANT,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_MEDIUM_SLICE,
      来源类型: "单位技能",
      标签: "Saber-W-E联动地面-持续",
      技能ID: W类型ID,
      技能实例ID: ctx.技能实例ID,
    });
  }
}

function 释放WE地面分支(this: void, caster: any, 目标X: number, 目标Y: number, 技能实例ID?: number): void {
  const cfg = 配置.W.E联动地面分支;

  添加单位暂停(caster, 配置.暂停来源.W地面E联动);
  const wE联动音效句柄 = (jglobals as any)[cfg.音效.全局音效键];
  if (wE联动音效句柄 != null) PlaySoundOnUnitBJ(wE联动音效句柄, 100, caster);
  // 目标点为施法事件入口锁存值（分支链路里重读 GetSpellTargetLoc 已失效）
  const 方向 = 两点角度(GetUnitX(caster), GetUnitY(caster), 目标X, 目标Y);
  // 消耗并结束魔力放出（源：移除 S009）
  消耗SaberE(caster);
  SetUnitAnimationByIndex(caster, cfg.动作索引);

  // 出生点表现：物编 e061 烘焙 Y 轴旋转 -90，用 Y轴角度 -90 复现；朝向沿用源 角度+90（见推进处注释）。
  创建点特效({
    模型路径: cfg.表现特效.模型路径,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z: cfg.表现特效.飞行高度,
    面向角度: 方向 + cfg.表现特效.朝向偏移,
    Y轴角度: -90,
    缩放: cfg.表现特效.缩放,
    持续秒: cfg.表现特效.持续秒,
  });

  const ctx: WE地面上下文 = {
    caster,
    技能实例ID,
    伤害快照: 读取单位攻击力(caster),
    方向角度: 方向,
    起点X: GetUnitX(caster),
    起点Y: GetUnitY(caster),
    重复组: {},
    闪避率记录: [],
    周期回调ID: 0,
    Tick数: 0,
  };
  ctx.周期回调ID = addPeriodicCallback(
    秒转毫秒(cfg.路径.Tick间隔秒),
    推进WE地面冲击 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// W 敌人分支（含 E 联动冲击波）
// ---------------------------------------------------------------------------

interface W敌人上下文 {
  caster: any;
  目标: any;
  技能实例ID?: number;
  伤害快照: number;
  冲锋角度: number;
  捕捉成功: boolean;
  周期回调ID: number;
  Tick数: number;
  E开启快照: boolean;
}

interface 冲击波上下文 {
  caster: any;
  技能实例ID?: number;
  伤害快照: number;
  X: number;
  Y: number;
  角度: number;
  特效: any;
  命中组: Record<number, boolean>;
  周期回调ID: number;
  Tick数: number;
}

function 推进W冲击波(this: void, variable?: any): void {
  const ctx = variable as 冲击波上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;
  const cfg = 配置.W.敌人分支.E联动冲击波;

  const 收尾 = (): void => {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    if (ctx.特效 != null && ctx.特效 !== 0) 销毁点特效(ctx.特效);
    ctx.特效 = null;
  };

  if (caster == null || caster === 0 || !单位存活(caster)) {
    收尾();
    return;
  }

  ctx.Tick数 += 1;
  if (ctx.Tick数 > cfg.最大Tick数) {
    收尾();
    return;
  }

  const 弧度 = ctx.角度 * bj_DEGTORAD;
  ctx.X += cfg.每Tick距离 * Cos(弧度);
  ctx.Y += cfg.每Tick距离 * Sin(弧度);
  if (ctx.特效 != null && ctx.特效 !== 0) {
    DzSetEffectPos(ctx.特效, ctx.X, ctx.Y, cfg.飞行高度);
  }

  const 敌军列表 = 获取范围敌军(caster, ctx.X, ctx.Y, cfg.伤害半径);
  const 新目标: any[] = [];
  for (const target of 敌军列表) {
    if (target == null || target === 0) continue;
    if (ctx.命中组[GetHandleId(target)] === true) {
      开始击退(target, {
        角度: ctx.角度,
        距离: cfg.重复组击退距离,
        持续时间: cfg.推进间隔秒,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: false,
      });
      continue;
    }
    ctx.命中组[GetHandleId(target)] = true;
    新目标.push(target);
  }
  if (新目标.length > 0) {
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 新目标,
      伤害: ctx.伤害快照 * cfg.伤害攻击力倍率,
      伤害类型: DAMAGE_TYPE_PLANT,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "Saber-W-E联动冲击波",
      技能ID: W类型ID,
      技能实例ID: ctx.技能实例ID,
    });
  }
}

function 启动W冲击波(this: void, ctx: W敌人上下文): void {
  const caster = ctx.caster;
  const cfg = 配置.W.敌人分支.E联动冲击波;
  const w冲击波音效句柄 = (jglobals as any)[cfg.音效.全局音效键];
  if (w冲击波音效句柄 != null) PlaySoundOnUnitBJ(w冲击波音效句柄, 100, caster);
  const 波上下文: 冲击波上下文 = {
    caster,
    技能实例ID: ctx.技能实例ID,
    伤害快照: ctx.伤害快照,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    角度: ctx.冲锋角度,
    特效: 创建点特效({
      模型路径: cfg.模型路径,
      X: GetUnitX(caster),
      Y: GetUnitY(caster),
      Z: cfg.飞行高度,
      面向角度: ctx.冲锋角度,
      X轴角度: -90, // e062 物编 maxRoll=-90 的等效
      缩放: cfg.缩放,
      持续秒: cfg.推进间隔秒 * cfg.最大Tick数 + 1,
    }),
    命中组: {},
    周期回调ID: 0,
    Tick数: 0,
  };
  波上下文.周期回调ID = addPeriodicCallback(
    秒转毫秒(cfg.推进间隔秒),
    推进W冲击波 as unknown as (this: void, variable?: any) => void,
    波上下文,
  );
}

function W目标硬直表现恢复(this: void, variable?: any): void {
  const target = variable as any;
  if (target == null || target === 0 || !单位存活(target)) return;
  SetUnitAnimation(target, "stand");
  SetUnitTimeScale(target, 1.0);
}

function 推进W敌人追击(this: void, variable?: any): void {
  const ctx = variable as W敌人上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.caster;
  const target = ctx.目标;

  const 收尾 = (): void => {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    SetUnitPathing(caster, true);
    if (ctx.捕捉成功 && 单位存活(caster) && target != null && target !== 0 && 单位存活(target)) {
      // 捕捉成功：解除暂停、面向目标、主伤害单体、控制与击退
      移除单位暂停(caster, 配置.暂停来源.W敌人追击);
      SetUnitFacing(caster, 两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target)));
      造成单体技能伤害({
        来源: caster,
        目标: target,
        伤害: ctx.伤害快照 * 配置.W.敌人分支.主伤害攻击力倍率,
        伤害类型: DAMAGE_TYPE_NORMAL,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
        来源类型: "单位技能",
        标签: "Saber-W-敌人捕捉",
        技能ID: W类型ID,
        技能实例ID: ctx.技能实例ID,
      });
      createTimedUnitEffect(target, 配置.W.敌人分支.命中特效.挂点, 配置.W.敌人分支.命中特效.模型路径, 配置.W.敌人分支.命中特效.持续秒);
      施加眩晕(caster, target, 配置.W.敌人分支.主控制秒, SaberBuffID.风王硬直, "技能");
      registerManualBuff(target, SaberBuffID.风王硬直, 配置.W.敌人分支.主控制秒, 0, { 来源: caster, 标签: "Saber-W-敌人捕捉" });
      // 源：目标 Death 动作 + 时间流速冻结（周期置 0 保持死亡姿势）
      SetUnitAnimation(target, "death");
      SetUnitTimeScale(target, 0);
      addDelayedCallback(
        秒转毫秒(配置.W.敌人分支.主控制秒),
        W目标硬直表现恢复 as unknown as (this: void, variable?: any) => void,
        target,
      );
      开始击退(target, {
        来源单位: caster,
        距离: 配置.W.敌人分支.目标击退距离,
        持续时间: 0.15,
        检查地形: true,
        暂停单位: false,
        禁用碰撞: true,
      });
      if (ctx.E开启快照) {
        启动W冲击波(ctx);
      }
    } else {
      // 未捕捉：只恢复 Saber 状态
      SetUnitTimeScale(caster, 1.0);
      移除单位暂停(caster, 配置.暂停来源.W敌人追击);
    }
  };

  if (caster == null || caster === 0 || !单位存活(caster)) {
    if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
    ctx.周期回调ID = 0;
    if (caster != null && caster !== 0) {
      SetUnitPathing(caster, true);
      移除单位暂停(caster, 配置.暂停来源.W敌人追击);
    }
    return;
  }

  ctx.Tick数 += 1;
  if (target == null || target === 0 || !单位存活(target)) {
    收尾();
    return;
  }
  if (IsUnitInRange(caster, target, 配置.W.敌人分支.追击.捕捉半径)) {
    ctx.捕捉成功 = true;
    收尾();
    return;
  }
  if (ctx.Tick数 >= 配置.W.敌人分支.追击.最大Tick数) {
    收尾();
    return;
  }

  const 弧度 = ctx.冲锋角度 * bj_DEGTORAD;
  const 移动X = GetUnitX(caster) + 配置.W.敌人分支.追击.每Tick距离 * Cos(弧度);
  const 移动Y = GetUnitY(caster) + 配置.W.敌人分支.追击.每Tick距离 * Sin(弧度);
  if (IsTerrainPathable(移动X, 移动Y, PATHING_TYPE_WALKABILITY)) {
    收尾();
    return;
  }
  SetUnitX(caster, 移动X);
  SetUnitY(caster, 移动Y);
  SetUnitFacing(caster, ctx.冲锋角度);
}

function 释放W敌人分支(this: void, caster: any, target: any, 技能实例ID?: number): void {
  const ctx: W敌人上下文 = {
    caster,
    目标: target,
    技能实例ID,
    伤害快照: 读取单位攻击力(caster),
    冲锋角度: 两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target)),
    捕捉成功: false,
    周期回调ID: 0,
    Tick数: 0,
    E开启快照: Saber是否E开启(caster),
  };
  添加单位暂停(caster, 配置.暂停来源.W敌人追击);
  SetUnitAnimationByIndex(caster, 配置.W.敌人分支.动作索引);
  SetUnitTimeScale(caster, 配置.W.敌人分支.时间流速);
  SetUnitPathing(caster, false);
  ctx.周期回调ID = addPeriodicCallback(
    秒转毫秒(配置.W.敌人分支.追击.间隔秒),
    推进W敌人追击 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

// ---------------------------------------------------------------------------
// 入口与注册
// ---------------------------------------------------------------------------

interface W上下文 {
  施法者: any;
}

const W上下文表: Record<number, W上下文> = {};

function 获取或创建W上下文(this: void, caster: any): W上下文 {
  const id = GetHandleId(caster);
  let record = W上下文表[id];
  if (record == null) {
    record = { 施法者: caster };
    W上下文表[id] = record;
  }
  return record;
}

function 释放W技能(this: void, _context: W上下文, caster: any, 技能实例ID?: number): void {
  if (!单位存活(caster)) return;
  // 施法事件入口立即锁存目标点：GetSpellTargetLoc 只在施法事件内有效，
  // 下层分支链路里重读会拿到无效值（方向指向 0,0 的根源）
  const 锁存目标点 = 读取W地面目标点();
  const target = GetSpellTargetUnit();
  if (target != null && target !== 0 && 单位存活(target)) {
    释放W敌人分支(caster, target, 技能实例ID);
  } else if (Saber是否E开启(caster)) {
    释放WE地面分支(caster, 锁存目标点.X, 锁存目标点.Y, 技能实例ID);
  } else {
    释放W地面分支(caster, 锁存目标点.X, 锁存目标点.Y, 技能实例ID);
  }
}

let W死亡监听已注册 = false;

function W单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  移除单位暂停(dyingUnit, 配置.暂停来源.W敌人追击);
  移除单位暂停(dyingUnit, 配置.暂停来源.W地面E联动);
  SetUnitPathing(dyingUnit, true);
  const 地面 = W地面上下文表[GetHandleId(dyingUnit)];
  if (地面 != null && 地面.周期回调ID !== 0) {
    removePeriodicCallback(地面.周期回调ID);
    地面.周期回调ID = 0;
    清理龙卷风表现(地面);
  }
}

export function 注册SaberW(this: void): void {
  注册单位技能壳监听({
    名称: "Saber-风王铁锤（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.W.技能ID,
    获取或创建上下文: 获取或创建W上下文,
    释放技能: 释放W技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
  if (!W死亡监听已注册) {
    W死亡监听已注册 = true;
    registerDeathListener(W单位死亡清理);
  }
}

注册SaberW();

export {};
