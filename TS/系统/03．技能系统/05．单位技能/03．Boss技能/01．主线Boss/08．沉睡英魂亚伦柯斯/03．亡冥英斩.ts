/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 单位是否在胶囊区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/胶囊区域';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
const 亡冥英斩技能Key = '亡冥英斩';

function 造成亡冥英斩伤害(this: void, source: any, target: any, attackRatio: number, lifeRatio: number, tag: string): void {
  const damage = 计算组合技能伤害(source, target, { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio });
  造成AOE技能伤害({ 来源: source, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: tag });
}

function 结束亡冥英斩(this: void, context: 亚伦柯斯运行时上下文): void {
  if (context.当前大型技能 === 亡冥英斩技能Key) context.当前大型技能 = undefined;
}

function 安排P3归魂回斩(this: void, context: 亚伦柯斯运行时上下文, startX: number, startY: number, endX: number, endY: number, distance: number, reverseFacing: number): void {
  const boss = context.Boss单位;
  const cfg = 亚伦柯斯正式设计配置.亡冥英斩;
  创建技能提示圈({ 类型: '方向直线', X: endX, Y: endY, 宽度: cfg.路径宽度, 长度: distance, 朝向: reverseFacing, 持续时间: cfg.P3归魂延迟秒, 来源单位: boss });
  const trace = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.归魂剑痕特效路径, (startX + endX) * 0.5, (startY + endY) * 0.5);
  if (trace != null && trace !== 0) YDWETimerDestroyEffectSafe(cfg.P3归魂延迟秒 + 0.4, trace);
  const delayedId = addDelayedCallback(cfg.P3归魂延迟秒 * 1000, function 亚伦柯斯归魂回斩结算(this: void): void {
    if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约') {
      结束亡冥英斩(context);
      return;
    }
    播放限时单位动画({ 单位: boss, 动画编号: cfg.P3归魂动画编号, 持续秒: 1, 恢复动画编号: 1 });
    播放Boss坐标音效(亚伦柯斯正式设计配置.音效.归魂剑痕, endX, endY, 亚伦柯斯正式设计配置.音效默认裁断距离);
    const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.归魂剑痕特效路径, endX, endY);
    if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(0.8, effect);
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      const target = heroes[i];
      if (单位是否在胶囊区域(target, startX, startY, endX, endY, cfg.路径宽度)) {
        造成亡冥英斩伤害(boss, target, cfg.P3归魂伤害攻击力比例, cfg.P3归魂伤害目标最大生命比例, '亚伦柯斯·亡冥英斩-归魂回斩');
      }
    }
    结束亡冥英斩(context);
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
  const totalDuration = cfg.前摇秒 + cfg.推进秒 + (isP3 ? cfg.P3归魂延迟秒 : 0);
  context.当前大型技能 = 亡冥英斩技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (totalDuration + 0.4) * 1000;
  创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 宽度: cfg.路径宽度, 长度: distance, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  const charge = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.亡冥英斩蓄势特效路径, startX, startY);
  if (charge != null && charge !== 0) YDWETimerDestroyEffectSafe(cfg.前摇秒 + 0.2, charge);
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
      命中半径: cfg.命中半径,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 亚伦柯斯亡冥英斩命中(this: void, source: any, hit: any): void {
        播放Boss坐标音效(亚伦柯斯正式设计配置.音效.亡冥英斩突进命中, GetUnitX(hit), GetUnitY(hit), 亚伦柯斯正式设计配置.音效默认裁断距离);
        造成亡冥英斩伤害(source, hit, cfg.伤害攻击力比例, cfg.伤害目标最大生命比例, '亚伦柯斯·亡冥英斩');
        const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.亡冥英斩命中特效路径, GetUnitX(hit), GetUnitY(hit));
        if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(0.6, effect);
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
  语义: '公共直线预警后由Boss本体沿路径冲锋，每个目标最多命中一次；P3沿实际冲锋路径延迟反向归魂结算。',
} as const;
