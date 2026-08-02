/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 创建原生弹幕, 创建直线定点轨迹 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { EC_GetPointZ } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_GetPointZ: (this: void, x: number, y: number) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXSetEffectXY = japi.EXSetEffectXY as (effect: any, x: number, y: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, angle: number) => void;
const EXEffectMatScale = japi.EXEffectMatScale as (effect: any, x: number, y: number, z: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
const 亡冥英斩技能Key = '亡冥英斩';

function 造成亡冥英斩伤害(this: void, source: any, target: any, attackRatio: number, lifeRatio: number, tag: string): void {
  执行BossAOE技能伤害({
    来源: source,
    目标: target,
    伤害公式: { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    标签: tag,
  });
}

function 结束亡冥英斩(this: void, context: 亚伦柯斯运行时上下文): void {
  if (context.当前大型技能 === 亡冥英斩技能Key) context.当前大型技能 = undefined;
}

function 销毁归魂回斩弹幕(this: void, 弹幕: any): void {
  if (弹幕 != null && 弹幕.销毁 != null) 弹幕.销毁('手动销毁');
}

function 亚伦柯斯归魂目标允许(this: void, boss: any, target: any): boolean {
  if (!单位有效(target)) return false;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    if (heroes[i] === target) return true;
  }
  return false;
}

function 安排P3归魂回斩(this: void, context: 亚伦柯斯运行时上下文, startX: number, startY: number, endX: number, endY: number, distance: number, reverseFacing: number): void {
  const boss = context.Boss单位;
  const cfg = 亚伦柯斯正式设计配置.亡冥英斩;
  创建技能提示圈({ 类型: '方向直线', X: endX, Y: endY, 宽度: cfg.路径宽度, 长度: distance, 朝向: reverseFacing, 持续时间: cfg.P3归魂延迟秒, 来源单位: boss });
  const traceX = (startX + endX) * 0.5;
  const traceY = (startY + endY) * 0.5;
  const trace = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.归魂剑痕特效路径, traceX, traceY);
  if (trace != null && trace !== 0) {
    EXSetEffectXY(trace, traceX, traceY);
    EXSetEffectZ(trace, EC_GetPointZ(traceX, traceY));
    EXEffectMatRotateZ(trace, reverseFacing + cfg.P3剑痕朝向修正角度);
    EXEffectMatScale(trace, distance / cfg.P3剑痕模型基准长度, cfg.路径宽度 / cfg.P3剑痕模型基准宽度, 1);
    context.清理.登记限时特效('亚伦柯斯-归魂剑痕', trace, (cfg.P3归魂延迟秒 + cfg.P3归魂推进秒 + 0.1) * 1000);
  }
  const delayedId = addDelayedCallback(cfg.P3归魂延迟秒 * 1000, function 亚伦柯斯归魂回斩结算(this: void): void {
    if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约') {
      结束亡冥英斩(context);
      return;
    }
    播放限时单位动画({ 单位: boss, 动画编号: cfg.P3归魂动画编号, 持续秒: 1, 恢复动画编号: 1 });
    播放Boss坐标音效(亚伦柯斯正式设计配置.音效.归魂剑痕, endX, endY, 亚伦柯斯正式设计配置.音效默认裁断距离);
    const 弹幕 = 创建原生弹幕({
      所有者: boss,
      载体模式: '特效',
      X: endX,
      Y: endY,
      方向角: reverseFacing,
      速度: distance / cfg.P3归魂推进秒,
      生命周期: cfg.P3归魂推进秒,
      最大距离: distance,
      轨迹采样器: 创建直线定点轨迹(endX, endY, startX, startY),
      命中半径: cfg.路径宽度 * 0.5,
      影响目标: '敌方',
      每单位最大命中次数: 1,
      碰撞消失: false,
      禁用碰撞: true,
      附加特效1: {
        模型: 亚伦柯斯正式设计配置.表现资源.归魂剑痕特效路径,
        跟随主弹幕参数: true,
        缩放X: distance / cfg.P3剑痕模型基准长度,
        缩放Y: cfg.路径宽度 / cfg.P3剑痕模型基准宽度,
        缩放Z: 1,
        朝向角偏移: cfg.P3剑痕朝向修正角度,
      },
      目标筛选: function 亚伦柯斯归魂回斩目标筛选(this: void, target: any): boolean {
        return 亚伦柯斯归魂目标允许(boss, target);
      },
      on命中: function 亚伦柯斯归魂回斩命中(this: void, target: any): void {
        if (!单位有效(target)) return;
        造成亡冥英斩伤害(boss, target, cfg.P3归魂伤害攻击力比例, cfg.P3归魂伤害目标最大生命比例, '亚伦柯斯·亡冥英斩-归魂回斩');
      },
      on结束: function 亚伦柯斯归魂回斩结束(this: void): void {
        结束亡冥英斩(context);
      },
    });
    context.清理.登记清理('亚伦柯斯-归魂回斩弹幕', 销毁归魂回斩弹幕, 弹幕);
  });
  context.清理.登记延迟回调('亚伦柯斯-归魂回斩', delayedId);
}

export function 释放亚伦柯斯亡冥英斩(this: void, context: 亚伦柯斯运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.当前大型技能 != null) return false;
  const cfg = 亚伦柯斯正式设计配置.亡冥英斩;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const dx = GetUnitX(target) - startX;
  const dy = GetUnitY(target) - startY;
  const rawDistance = SquareRoot(dx * dx + dy * dy);
  if (!(rawDistance > 1)) return false;
  const distance = rawDistance < cfg.推进距离 ? rawDistance : cfg.推进距离;
  const ratio = distance / rawDistance;
  const endX = startX + dx * ratio;
  const endY = startY + dy * ratio;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  const isP3 = context.阶段 === 'P3最后的誓约';
  const totalDuration = cfg.前摇秒 + cfg.推进秒 + (isP3 ? cfg.P3归魂延迟秒 + cfg.P3归魂推进秒 : 0);
  SetUnitFacing(boss, facing);
  context.当前大型技能 = 亡冥英斩技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (totalDuration + 0.4) * 1000;
  开始硬直(boss, cfg.前摇秒);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.前摇动画编号, 持续秒: cfg.前摇秒, 恢复动画: false });
  创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 宽度: cfg.路径宽度, 长度: distance, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  const charge = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.亡冥英斩蓄势特效路径, startX, startY);
  if (charge != null && charge !== 0) {
    EXEffectMatRotateZ(charge, facing);
    YDWETimerDestroyEffectSafe(cfg.前摇秒 + 0.2, charge);
  }
  播放亚伦柯斯台词(boss, isP3 ? '亡冥英斩归魂' : '亡冥英斩');
  播放Boss坐标音效(亚伦柯斯正式设计配置.音效.亡冥英斩蓄势, startX, startY, 亚伦柯斯正式设计配置.音效默认裁断距离);

  const delayedId = addDelayedCallback(cfg.前摇秒 * 1000, function 亚伦柯斯亡冥英斩开始(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) {
      结束亡冥英斩(context);
      return;
    }
    const chargeId = 开始冲锋(boss, {
      目标X: endX,
      目标Y: endY,
      距离: distance,
      持续时间: cfg.推进秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      位移特效: 亚伦柯斯正式设计配置.表现资源.亡冥英斩轨迹特效路径,
      附加位移特效: 亚伦柯斯正式设计配置.表现资源.亡冥英斩附加轨迹特效路径,
      命中半径: cfg.命中半径,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 亚伦柯斯亡冥英斩命中(this: void, source: any, hit: any): void {
        播放Boss坐标音效(亚伦柯斯正式设计配置.音效.亡冥英斩突进命中, GetUnitX(hit), GetUnitY(hit), 亚伦柯斯正式设计配置.音效默认裁断距离);
        造成亡冥英斩伤害(source, hit, cfg.伤害攻击力比例, cfg.伤害目标最大生命比例, '亚伦柯斯·亡冥英斩');
        const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.亡冥英斩命中特效路径, GetUnitX(hit), GetUnitY(hit));
        if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(0.6, effect);
        const overlay = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.亡冥英斩附加命中特效路径, GetUnitX(hit), GetUnitY(hit));
        if (overlay != null && overlay !== 0) YDWETimerDestroyEffectSafe(0.6, overlay);
      },
      开始回调: function 亚伦柯斯亡冥英斩动作(this: void): void {
        播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.推进秒 + 0.2, 恢复动画编号: 1 });
      },
      结束回调: function 亚伦柯斯亡冥英斩结束(this: void, _source: any, reason: string): void {
        const actualEndX = GetUnitX(boss);
        const actualEndY = GetUnitY(boss);
        if (isP3 && (reason === '完成' || reason === '撞墙')) {
          const actualDx = actualEndX - startX;
          const actualDy = actualEndY - startY;
          const actualDistance = SquareRoot(actualDx * actualDx + actualDy * actualDy);
          if (actualDistance > 1) 安排P3归魂回斩(context, startX, startY, actualEndX, actualEndY, actualDistance, facing + 180);
          else 结束亡冥英斩(context);
        } else {
          结束亡冥英斩(context);
        }
      },
    });
    if (chargeId === 0) 结束亡冥英斩(context);
  });
  context.清理.登记延迟回调('亚伦柯斯-亡冥英斩前摇', delayedId);
  return true;
}

export const 亡冥英斩迁移状态 = {
  旧技能ID: 'A0F4',
  通用技能壳ID: 'AT00',
  已保留旧原型语义: true,
  已完成TS实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '公共直线预警后由Boss本体沿路径冲锋，每个目标最多命中一次；P3剑痕按实际路径定向拉伸，并从终点向起点真实移动完成归魂结算。',
} as const;
