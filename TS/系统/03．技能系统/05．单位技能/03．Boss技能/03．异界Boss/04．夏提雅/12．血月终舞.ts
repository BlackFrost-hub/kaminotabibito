/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 单位是否在扇形区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建立即执行阶段, 创建延迟阶段 } from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import { 创建原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, scale: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
const 血月终舞技能Key = '血月终舞';

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
    EXSetEffectZ(main, cfg.血月高度);
    EXSetEffectSize(main, cfg.血月缩放);
    YDWETimerDestroyEffectSafe(duration, main);
  }
  if (aux != null && aux !== 0) {
    EXSetEffectZ(aux, cfg.血月高度);
    EXSetEffectSize(aux, cfg.血月缩放);
    YDWETimerDestroyEffectSafe(duration, aux);
  }
}

function 创建终舞动画重播时点(this: void, duration: number, interval: number): number[] {
  const result: number[] = [];
  if (!(interval > 0)) return result;
  for (let elapsed = interval; elapsed < duration; elapsed += interval) result.push(elapsed);
  return result;
}

function 播放血月终舞图3特效(this: void, x: number, y: number, facing: number, duration: number): void {
  const cfg = 夏提雅数值与表现配置.P3;
  创建点特效({
    模型路径: 夏提雅数值与表现配置.表现资源.血月终舞图3特效路径,
    X: x,
    Y: y,
    持续秒: duration,
    缩放: cfg.终舞图3特效缩放,
    Z轴角度: facing,
    动画索引: 0,
  });
}

function 取血月终舞扇区伤害类型(this: void): any {
  const type = GetRandomInt(1, 3);
  if (type === 1) return DAMAGE_TYPE_SHADOW_STRIKE;
  if (type === 2) return DAMAGE_TYPE_ENHANCED;
  return DAMAGE_TYPE_NORMAL;
}

function 发射血月终舞扇区弹幕(this: void, context: 夏提雅运行时上下文, x: number, y: number, facing: number, 每扇区持续秒: number): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.P3;
  const count = cfg.扇区弹幕数量 > 0 ? cfg.扇区弹幕数量 : 1;
  const 发射间隔秒 = 每扇区持续秒 > 0 ? 每扇区持续秒 / count : cfg.扇区弹幕间隔秒;
  const halfWidth = (count - 1) * cfg.扇区弹幕横向间距 * 0.5;
  for (let i = 0; i < count; i++) {
    const 弹幕伤害类型 = 取血月终舞扇区伤害类型();
    const 发射延迟秒 = i * 发射间隔秒;
    const lateralOffset = i * cfg.扇区弹幕横向间距 - halfWidth;
    const startX = x - SinBJ(facing) * lateralOffset;
    const startY = y + CosBJ(facing) * lateralOffset;
    const 特效延迟ID = addDelayedCallback(发射延迟秒 * 1000, function 夏提雅血月终舞扇区弹幕发射表现(this: void): void {
      if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 !== 血月终舞技能Key) return;
      播放血月终舞图3特效(x, y, facing, cfg.终舞图3特效持续秒);
    });
    context.清理.登记延迟回调('夏提雅-血月终舞扇区图3-' + String(i + 1), 特效延迟ID);
    const barrage = 创建原生弹幕({
      所有者: boss,
      载体模式: '单位',
      X: startX,
      Y: startY,
      方向角: facing,
      速度: cfg.扇区弹幕速度,
      延迟发射: 发射延迟秒,
      最大距离: cfg.扇区半径,
      生命周期: cfg.扇区弹幕生命周期秒,
      命中半径: cfg.扇区弹幕命中半径,
      影响目标: '敌方',
      碰撞消失: false,
      每单位最大命中次数: 1,
      不可阻挡: true,
      禁用碰撞: true,
      显式改向后锁定方向: true,
      模型: 夏提雅数值与表现配置.表现资源.血月终舞图2弹幕特效路径,
      缩放: cfg.扇区弹幕缩放,
      攻击类型: ATTACK_TYPE_NORMAL,
      伤害类型: 弹幕伤害类型,
      武器类型: WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: 'Boss技能',
      技能标签: '夏提雅·血月终舞-扇区弹幕',
      伤害形态: 'AOE',
      目标筛选: function 夏提雅血月终舞扇区弹幕目标筛选(this: void, target: any): boolean {
        return 单位有效(target) && 单位是否在扇形区域(target, x, y, cfg.扇区半径, facing, cfg.扇区角度);
      },
      on命中: function 夏提雅血月终舞扇区弹幕命中(this: void, target: any): void {
        执行BossAOE技能伤害({
          来源: boss,
          目标: target,
          伤害公式: {
            来源攻击力比例: cfg.扇区伤害攻击力比例,
            目标最大生命比例: cfg.扇区伤害目标最大生命比例,
            总倍率: 1 / count,
          },
          attack: false,
          ranged: true,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: 弹幕伤害类型,
          weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
          标签: '夏提雅·血月终舞-扇区弹幕',
        });
      },
    });
    if (barrage.弹幕单位 != null && barrage.弹幕单位 !== 0) SetUnitAnimationByIndex(barrage.弹幕单位, 0);
  }
}

function 发射血月终舞俯冲图2(this: void, boss: any, x: number, y: number, facing: number, duration: number): void {
  const cfg = 夏提雅数值与表现配置.P3;
  const barrage = 创建原生弹幕({
    所有者: boss,
    载体模式: '单位',
    X: x,
    Y: y,
    方向角: facing,
    速度: cfg.终舞俯冲图2速度,
    最大距离: cfg.终舞冲锋长度,
    生命周期: duration,
    命中半径: 0,
    影响目标: '敌方',
    碰撞消失: false,
    不可阻挡: true,
    禁用碰撞: true,
    显式改向后锁定方向: true,
    模型: 夏提雅数值与表现配置.表现资源.血月终舞图2弹幕特效路径,
    缩放: cfg.终舞俯冲图2缩放,
  });
  if (barrage.弹幕单位 != null && barrage.弹幕单位 !== 0) SetUnitAnimationByIndex(barrage.弹幕单位, 0);
}

function 结束血月终舞(this: void, context: 夏提雅运行时上下文): void {
  关闭吟唱条('大招');
  if (context.当前大型技能 === 血月终舞技能Key) context.当前大型技能 = undefined;
}

export function 释放夏提雅血月终舞(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.阶段 !== 'P3真祖血宴' || !context.P3转阶段已处理 || context.血月终舞已释放 || context.当前大型技能 != null) return false;
  播放夏提雅台词(boss, '血月终舞');
  播放Boss坐标音效(夏提雅数值与表现配置.音效.血月终舞启动, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
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
  立即设置单位朝向(boss, finalFacing);
  const executor = 创建固定组合技能执行器<夏提雅运行时上下文>({ 名称: '夏提雅-血月终舞', 清理: context.清理, 互斥组: '夏提雅大型技能' });
  context.血月终舞已释放 = true;
  context.当前大型技能 = 血月终舞技能Key;
  context.普通机制忙碌到Ms = getServerTime() + totalDuration * 1000;
  重置夏提雅猎血连击(context);
  const stages: any[] = [
    创建立即执行阶段(function 夏提雅血月终舞启动(this: void): void {
      开始硬直(boss, sectorTotal);
      创建空中血月(centerX, centerY, activeDuration + 0.5);
      创建技能提示圈({ 类型: '方向直线', X: centerX, Y: centerY, 宽度: cfg.终舞冲锋宽度, 长度: cfg.终舞冲锋长度, 朝向: finalFacing, 持续时间: sectorTotal, 来源单位: boss });
    }, '血月与最终路径'),
  ];
  for (let i = 0; i < 4; i++) {
    const sectorFacing = finalFacing + i * 90;
    stages.push(创建立即执行阶段(function 夏提雅血月扇区预警(this: void): void {
      立即设置单位朝向(boss, sectorFacing);
      播放限时单位动画({
        单位: boss,
        动画编号: cfg.终舞引导动画编号,
        持续秒: sectorWarning,
        重播时点秒列表: 创建终舞动画重播时点(sectorWarning, cfg.终舞引导动画循环秒),
        恢复动画编号: 0,
      });
      发射血月终舞扇区弹幕(context, centerX, centerY, sectorFacing, sectorWarning);
      创建技能提示圈({ 类型: '扇形', X: centerX, Y: centerY, 半径: cfg.扇区半径, 扇形角度: cfg.扇区角度, 朝向: sectorFacing, 持续时间: sectorWarning, 来源单位: boss });
    }, `第${i + 1}扇区预警`));
    stages.push(创建延迟阶段(sectorWarning * 1000, `第${i + 1}扇区前摇`));
    stages.push(创建立即执行阶段(function 夏提雅血月扇区结算(this: void): void {
      立即设置单位朝向(boss, sectorFacing);
    }, `第${i + 1}扇区结算`));
  }
  stages.push(创建立即执行阶段(function 夏提雅血月终舞冲锋(this: void): void {
    if (context.当前大型技能 !== 血月终舞技能Key || context.阶段 !== 'P3真祖血宴') return;
    立即设置单位朝向(boss, finalFacing);
    发射血月终舞俯冲图2(boss, centerX, centerY, finalFacing, chargeDuration);
    开始冲锋(boss, {
      角度: finalFacing,
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
        播放Boss坐标音效(夏提雅数值与表现配置.音效.血月终舞, GetUnitX(hit), GetUnitY(hit), 夏提雅数值与表现配置.音效默认裁断距离);
        执行BossAOE技能伤害({
          来源: boss,
          目标: hit,
          伤害公式: { 来源攻击力比例: cfg.终舞冲锋伤害攻击力比例, 目标最大生命比例: cfg.终舞冲锋伤害目标最大生命比例 },
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_ENHANCED,
          weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
          标签: '夏提雅·血月终舞-俯冲',
        });
      },
      开始回调: function 夏提雅血月终舞冲锋动作(this: void): void {
        立即设置单位朝向(boss, finalFacing);
        SetUnitAnimationByIndex(boss, cfg.终舞冲锋动画编号);
      },
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
