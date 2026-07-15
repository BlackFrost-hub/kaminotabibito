/** @noSelfInFile */

import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 单位是否在扇形区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建立即执行阶段, 创建延迟阶段 } from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, scale: number) => void) | undefined;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
const 血月终舞技能Key = '血月终舞';

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取P3节奏倍率(this: void, context: 夏提雅运行时上下文): number {
  return 1 / (1 + context.血宴层数 * 夏提雅数值与表现配置.P3.血宴每层技能节奏提高);
}

function 移动到场地中心(this: void, boss: any): void {
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  if (rect != null && rect !== 0) 执行战斗自身传送到坐标(boss, GetRectCenterX(rect), GetRectCenterY(rect));
}

function 创建空中血月(this: void, x: number, y: number, duration: number): void {
  const cfg = 夏提雅数值与表现配置.P3;
  const main = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血月终舞特效路径, x, y);
  const aux = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血月终舞辅助特效路径, x, y);
  if (main != null && main !== 0) {
    if (typeof EXSetEffectZ === 'function') EXSetEffectZ(main, cfg.血月高度);
    if (typeof EXSetEffectSize === 'function') EXSetEffectSize(main, cfg.血月缩放);
    YDWETimerDestroyEffectSafe(duration, main);
  }
  if (aux != null && aux !== 0) {
    if (typeof EXSetEffectZ === 'function') EXSetEffectZ(aux, cfg.血月高度);
    if (typeof EXSetEffectSize === 'function') EXSetEffectSize(aux, cfg.血月缩放);
    YDWETimerDestroyEffectSafe(duration, aux);
  }
}

function 结算血月扇区(this: void, context: 夏提雅运行时上下文, x: number, y: number, facing: number): void {
  const cfg = 夏提雅数值与表现配置.P3;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位是否在扇形区域(target, x, y, cfg.扇区半径, facing, cfg.扇区角度)) continue;
    const damage = 计算组合技能伤害(context.Boss单位, target, {
      来源攻击力比例: cfg.扇区伤害攻击力比例,
      目标最大生命比例: cfg.扇区伤害目标最大生命比例,
    });
    造成AOE技能伤害({ 来源: context.Boss单位, 目标: target, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: '夏提雅·血月终舞-扇区' });
  }
}

function 结束血月终舞(this: void, context: 夏提雅运行时上下文): void {
  关闭吟唱条('大招');
  if (context.当前大型技能 === 血月终舞技能Key) context.当前大型技能 = undefined;
}

export function 释放夏提雅血月终舞(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.阶段 !== 'P3真祖血宴' || !context.P3转阶段已处理 || context.血月终舞已释放 || context.当前大型技能 != null) return false;
  const cfg = 夏提雅数值与表现配置.P3;
  移动到场地中心(boss);
  const centerX = GetUnitX(boss);
  const centerY = GetUnitY(boss);
  const finalFacing = Atan2(GetUnitY(target) - centerY, GetUnitX(target) - centerX) * RAD_TO_DEG;
  const endX = centerX + CosBJ(finalFacing) * cfg.终舞冲锋长度;
  const endY = centerY + SinBJ(finalFacing) * cfg.终舞冲锋长度;
  const pace = 取P3节奏倍率(context);
  const sectorWarning = cfg.扇区预警秒 * pace;
  const sectorTotal = sectorWarning * 4;
  const chargeDuration = cfg.终舞冲锋秒 * pace;
  const recovery = GetRandomReal(cfg.血月终舞回落最小秒, cfg.血月终舞回落最大秒);
  const activeDuration = sectorTotal + chargeDuration;
  const totalDuration = activeDuration + recovery;
  const executor = 创建固定组合技能执行器<夏提雅运行时上下文>({ 名称: '夏提雅-血月终舞', 清理: context.清理, 互斥组: '夏提雅大型技能' });
  context.血月终舞已释放 = true;
  context.当前大型技能 = 血月终舞技能Key;
  context.普通机制忙碌到Ms = getServerTime() + totalDuration * 1000;
  重置夏提雅猎血连击(context);
  const stages: any[] = [
    创建立即执行阶段(function 夏提雅血月终舞启动(this: void): void {
      创建空中血月(centerX, centerY, activeDuration + 0.5);
      创建技能提示圈({ 类型: '方向直线', X: centerX, Y: centerY, 宽度: cfg.终舞冲锋宽度, 长度: cfg.终舞冲锋长度, 朝向: finalFacing, 持续时间: sectorTotal, 来源单位: boss });
      SetUnitAnimationByIndex(boss, cfg.终舞引导动画编号);
    }, '血月与最终路径'),
  ];
  for (let i = 0; i < 4; i++) {
    const sectorFacing = finalFacing + i * 90;
    stages.push(创建立即执行阶段(function 夏提雅血月扇区预警(this: void): void {
      创建技能提示圈({ 类型: '扇形', X: centerX, Y: centerY, 半径: cfg.扇区半径, 朝向: sectorFacing, 持续时间: sectorWarning, 来源单位: boss });
    }, `第${i + 1}扇区预警`));
    stages.push(创建延迟阶段(sectorWarning * 1000, `第${i + 1}扇区前摇`));
    stages.push(创建立即执行阶段(function 夏提雅血月扇区结算(this: void): void {
      结算血月扇区(context, centerX, centerY, sectorFacing);
    }, `第${i + 1}扇区结算`));
  }
  stages.push(创建立即执行阶段(function 夏提雅血月终舞冲锋(this: void): void {
    if (context.当前大型技能 !== 血月终舞技能Key || context.阶段 !== 'P3真祖血宴') return;
    开始冲锋(boss, {
      目标X: endX,
      目标Y: endY,
      距离: cfg.终舞冲锋长度,
      持续时间: chargeDuration,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      位移特效: 夏提雅数值与表现配置.表现资源.滴管长枪拖尾特效路径,
      命中半径: cfg.终舞冲锋宽度 * 0.5,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 夏提雅血月终舞冲锋命中(this: void, _source: any, hit: any): void {
        const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.终舞冲锋伤害攻击力比例, 目标最大生命比例: cfg.终舞冲锋伤害目标最大生命比例 });
        造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: '夏提雅·血月终舞-俯冲' });
      },
      开始回调: function 夏提雅血月终舞冲锋动作(this: void): void { SetUnitAnimationByIndex(boss, cfg.终舞冲锋动画编号); },
    });
  }, '最终俯冲'));
  stages.push(创建延迟阶段(chargeDuration * 1000, '最终俯冲'));
  stages.push(创建延迟阶段(recovery * 1000, '真祖回落期'));
  显示大招吟唱条({ 通道: '大招', 总时长: activeDuration, 颜色ID: 2, 标题文本: '血月终舞', 提示文本: '依次避开血月扇区与提前锁定的最终冲锋路径' });
  const executionId = executor.开始({
    key: 血月终舞技能Key,
    单位: boss,
    上下文: context,
    最大持续毫秒: (totalDuration + 1) * 1000,
    阶段列表: stages,
    结束回调: function 夏提雅血月终舞结束(this: void): void { 结束血月终舞(context); },
  });
  if (executionId === 0) {
    结束血月终舞(context);
    return false;
  }
  return true;
}

export const 血月终舞技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '血月映照四个扇区依次结算，最后按提前锁定方向完成长枪俯冲。',
} as const;
