/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚运行时配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 开始米亚常规施法 } from "./19．施法提示";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { 开始跳跃 } from "../../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/01．跳跃系统/03．对外接口";
import { stringToFourCC, 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 参数: any) => any;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXEffectMatRotateY = japi.EXEffectMatRotateY as (effect: any, angle: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, angle: number) => void;
const EXEffectMatScale = japi.EXEffectMatScale as (effect: any, x: number, y: number, z: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 腐化爪击技能ID = stringToFourCC(米亚单位技能配置.腐化爪击技能);
let 米亚腐化爪击已注册 = false;

interface 米亚腐化爪击结算变量 {
  context: 米亚运行时上下文;
  target: any;
  落点X: number;
  落点Y: number;
  朝向: number;
  距离: number;
  跳跃持续秒: number;
}

const 米亚腐化爪击跳跃数据表: Record<number, 米亚腐化爪击结算变量 | undefined> = {};

function 播放爪击表现(this: void, boss: any, x: number, y: number, facing: number): void {
  const config = 米亚技能数值配置.腐化爪击;
  const slashFacingA = facing - 45;
  const slashFacingB = facing + 45;
  const angles = [slashFacingA, slashFacingB];
  for (let i = 0; i < angles.length; i++) {
    const effect = AddSpecialEffect(config.命中特效路径, x, y);
    if (effect == null || effect === 0) continue;
    EXEffectMatRotateY(effect, config.命中特效Y轴旋转角度);
    EXEffectMatRotateZ(effect, angles[i]);
    EXEffectMatScale(effect, config.命中特效缩放, config.命中特效缩放, config.命中特效缩放);
    YDWETimerDestroyEffectSafe(config.命中特效持续秒, effect);
  }
  播放爪击动作(boss);
}

function 播放爪击动作(this: void, boss: any): void {
  const config = 米亚技能数值配置.腐化爪击;
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
}

function 创建腐化爪击残留区(this: void, context: 米亚运行时上下文, x: number, y: number): void {
  const config = 米亚技能数值配置.腐化爪击;
  创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: context.Boss单位,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    提示圈: { 类型: "敌方圆形" },
    on周期: function 米亚腐化爪击残留区周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        添加米亚腐化感染(context, 区域内单位[i], config.残留每秒腐化层数, "腐化爪击残留");
      }
    },
  });
}

function 结算米亚腐化爪击(this: void, variable?: any): void {
  const data = variable as 米亚腐化爪击结算变量 | undefined;
  if (data == null) return;
  const context = data.context;
  const boss = context.Boss单位;
  const actualTarget = data.target;
  const boss有效 = 单位有效(boss);
  const 目标有效 = 单位有效(actualTarget);
  if (!boss有效) return;

  const config = 米亚技能数值配置.腐化爪击;
  SetUnitFacing(boss, data.朝向);
  const landingX = GetUnitX(boss);
  const landingY = GetUnitY(boss);
  播放爪击表现(boss, landingX, landingY, data.朝向);
  if (目标有效) {
    const 攻击力 = 读取单位攻击力(boss) || 米亚运行时配置.Boss攻击力兜底;
    const 污染标记伤害倍率 = 取米亚污染标记伤害倍率(context, actualTarget);
    const 平台超载伤害倍率 = 取米亚平台超载伤害倍率(actualTarget);
    const 伤害 = 攻击力 * config.攻击力倍率 * 污染标记伤害倍率 * 平台超载伤害倍率;
    const 伤害已提交 = 造成单体技能伤害({
      技能ID: 腐化爪击技能ID,
      来源: boss,
      目标: actualTarget,
      伤害,
      attackType: jass.ATTACK_TYPE_NORMAL,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
    });
    添加米亚腐化感染(context, actualTarget, config.残留每秒腐化层数, "腐化爪击");
  }
  创建腐化爪击残留区(context, landingX, landingY);
}

function 结算米亚腐化爪击跳跃(this: void, _unit: any, reason: any, jumpId: number): void {
  const data = 米亚腐化爪击跳跃数据表[jumpId];
  米亚腐化爪击跳跃数据表[jumpId] = undefined;
  if (data == null || reason !== "完成") {
    return;
  }
  结算米亚腐化爪击(data);
}

function 开始米亚腐化爪击跳跃(this: void, variable?: any): void {
  const data = variable as 米亚腐化爪击结算变量 | undefined;
  if (data == null) return;
  const boss = data.context.Boss单位;
  if (!单位有效(boss)) return;
  播放爪击动作(boss);
  const jumpId = 开始跳跃(boss, {
    目标X: data.落点X,
    目标Y: data.落点Y,
    距离: data.距离,
    持续时间: data.跳跃持续秒,
    跳跃高度: 米亚技能数值配置.腐化爪击.跳跃高度,
    暂停单位: true,
    朝向跟随跳跃: true,
    跳跃特效: 米亚技能数值配置.腐化爪击.跳跃特效路径,
    主单位: boss,
    主单位死亡时中断: true,
    结束回调: 结算米亚腐化爪击跳跃,
  });
  if (jumpId > 0) {
    米亚腐化爪击跳跃数据表[jumpId] = data;
  }
}

export function 释放米亚腐化爪击(this: void, context: 米亚运行时上下文, target?: any): void {
  const boss = context != null ? context.Boss单位 : null;
  const actualTarget = target;
  if (!单位有效(boss) || !单位有效(actualTarget)) {
    return;
  }
  const config = 米亚技能数值配置.腐化爪击;
  播放米亚台词(boss, "腐化爪击");
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const targetX = GetUnitX(actualTarget);
  const targetY = GetUnitY(actualTarget);
  const dx = targetX - startX;
  const dy = targetY - startY;
  const rawDistance = SquareRoot(dx * dx + dy * dy);
  if (!(rawDistance > 1)) {
    return;
  }
  const distance = rawDistance > config.跳跃最大距离 ? config.跳跃最大距离 : rawDistance;
  const ratio = distance / rawDistance;
  const landingX = startX + dx * ratio;
  const landingY = startY + dy * ratio;
  const facing = Atan2(dy, dx) * BJ_RADTODEG;
  const jumpDuration = GetRandomReal(config.跳跃最短秒, config.跳跃最长秒);
  SetUnitFacing(boss, facing);
  开始米亚常规施法(boss, config.前摇秒, "腐化爪击", `锁定目标，${config.前摇秒}秒后跃击并留下半径${config.残留半径}码爪痕（离开红色路径、落点和爪痕）`);
  SetUnitTimeScale(boss, 1);
  SetUnitAnimationByIndex(boss, config.前摇动画编号);
  创建技能提示圈({
    类型: "方向直线",
    X: startX,
    Y: startY,
    宽度: config.扑击路径宽度,
    长度: distance,
    朝向: facing,
    持续时间: config.前摇秒,
    来源单位: boss,
  });
  const delayedId = addDelayedCallback(config.前摇秒 * 1000, 开始米亚腐化爪击跳跃, {
    context,
    target: actualTarget,
    落点X: landingX,
    落点Y: landingY,
    朝向: facing,
    距离: distance,
    跳跃持续秒: jumpDuration,
  } as 米亚腐化爪击结算变量);
  context.清理.登记延迟回调("米亚-腐化爪击结算", delayedId);
}

export function 注册米亚腐化爪击(this: void): void {
  if (米亚腐化爪击已注册) return;
  米亚腐化爪击已注册 = true;
  注册单位技能壳监听({
    名称: "米亚-腐化爪击",
    单位类型ID: 米亚单位类型ID,
    技能ID: 腐化爪击技能ID,
    获取或创建上下文: 获取或创建米亚上下文,
    释放技能: function 米亚腐化爪击监听释放(this: void, _context: 米亚运行时上下文, boss: any): void {
      on米亚腐化爪击生效(boss, 腐化爪击技能ID);
    },
  });
}

function on米亚腐化爪击生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐化爪击技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 米亚单位类型ID) return;
  const context = 获取或创建米亚上下文(castingUnit);
  if (context == null) return;
  释放米亚腐化爪击(context, GetSpellTargetUnit());
}
