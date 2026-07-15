/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 净化落点内夏提雅鲜血印记 } from './04．鲜血印记';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 获取夏提雅英灵投影, 尝试触发英灵战乙女复刻 } from './09．英灵战乙女';
import { 创建点名预警执行器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/05．点名预警执行器';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[]) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as { 造成AOE技能伤害: (this: void, 参数: any) => boolean };
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as { YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void };
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const RAD_TO_DEG = 57.29577951308232;
function 尝试安排净化投枪英灵复刻(this: void, context: 夏提雅运行时上下文, x: number, y: number): void {
  const projection = 获取夏提雅英灵投影(context);
  if (!单位有效(projection)) return;
  const cfg = 夏提雅数值与表现配置.净化投枪;
  const p2 = 夏提雅数值与表现配置.P2;
  const delay = GetRandomReal(p2.英灵复刻延迟最小秒, p2.英灵复刻延迟最大秒);
  const facing = Atan2(y - GetUnitY(projection), x - GetUnitX(projection)) * RAD_TO_DEG;
  const started = 尝试触发英灵战乙女复刻(context, '净化投枪', {
    X: GetUnitX(projection),
    Y: GetUnitY(projection),
    朝向: facing,
    延迟秒: delay,
    复刻结算: function 夏提雅净化投枪英灵复刻(this: void): void {
      const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.净化投枪特效路径, x, y);
      if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.特效持续秒, effect);
      净化落点内夏提雅鲜血印记(context, x, y, cfg.伤害半径);
      const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
      for (let i = 0; i < heroes.length; i++) {
        const dx = GetUnitX(heroes[i]) - x;
        const dy = GetUnitY(heroes[i]) - y;
        if (dx * dx + dy * dy > cfg.伤害半径 * cfg.伤害半径) continue;
        const damage = 计算组合技能伤害(context.Boss单位, heroes[i], {
          来源攻击力比例: cfg.伤害攻击力比例 * p2.英灵复刻伤害比例,
          目标最大生命比例: cfg.伤害目标最大生命比例 * p2.英灵复刻伤害比例,
        });
        造成AOE技能伤害({ 来源: context.Boss单位, 目标: heroes[i], 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_MAGIC, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '夏提雅·英灵复刻-净化投枪' });
      }
    },
  });
  if (started) 创建技能提示圈({ 类型: '敌方圆形', X: x, Y: y, 半径: cfg.伤害半径, 持续时间: delay, 来源单位: context.Boss单位 });
}

function 结算净化投枪落点(this: void, context: 夏提雅运行时上下文, x: number, y: number, tag: string): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.净化投枪;
  const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.净化投枪特效路径, x, y);
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.特效持续秒, effect);
  净化落点内夏提雅鲜血印记(context, x, y, cfg.伤害半径);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const dx = GetUnitX(heroes[i]) - x;
    const dy = GetUnitY(heroes[i]) - y;
    if (dx * dx + dy * dy > cfg.伤害半径 * cfg.伤害半径) continue;
    const damage = 计算组合技能伤害(boss, heroes[i], { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
    造成AOE技能伤害({ 来源: boss, 目标: heroes[i], 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_MAGIC, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: tag });
  }
}

export function 释放夏提雅净化投枪(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) return false;
  const cfg = 夏提雅数值与表现配置.净化投枪;
  const x = GetUnitX(target);
  const y = GetUnitY(target);
  const isP3 = context.阶段 === 'P3真祖血宴';
  const secondTarget = isP3 ? 获取Boss技能随机敌对英雄(boss, undefined, undefined, [target]) : undefined;
  const secondX = 单位有效(secondTarget) ? GetUnitX(secondTarget) : x;
  const secondY = 单位有效(secondTarget) ? GetUnitY(secondTarget) : y;
  const totalDuration = cfg.预警秒 + (isP3 ? cfg.P3第二枚投枪延迟秒 : 0);
  context.上次净化投枪目标ID = GetHandleId(target);
  重置夏提雅猎血连击(context);
  context.普通机制忙碌到Ms = getServerTime() + (totalDuration + 0.4) * 1000;
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: totalDuration, 恢复动画编号: 0 });
  创建点名预警执行器({
    清理: context.清理,
    名称: '夏提雅-净化投枪',
    锁定X: x,
    锁定Y: y,
    延迟秒: cfg.预警秒,
    提示圈: { 类型: '敌方圆形', 半径: cfg.伤害半径, 持续时间: cfg.预警秒, 来源单位: boss },
    on结算: function 夏提雅净化投枪落下(this: void, result): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      结算净化投枪落点(context, result.锁定X, result.锁定Y, '夏提雅·净化投枪');
      if (!isP3) 尝试安排净化投枪英灵复刻(context, result.锁定X, result.锁定Y);
    },
  });
  if (isP3) {
    创建点名预警执行器({
      清理: context.清理,
      名称: '夏提雅-净化投枪-P3第二枚',
      锁定X: secondX,
      锁定Y: secondY,
      延迟秒: totalDuration,
      提示圈: { 类型: '敌方圆形', 半径: cfg.伤害半径, 持续时间: totalDuration, 来源单位: boss },
      on结算: function 夏提雅净化投枪第二枚落下(this: void, result): void {
        if (!单位有效(boss) || context.挑战已结束 || context.阶段 !== 'P3真祖血宴') return;
        结算净化投枪落点(context, result.锁定X, result.锁定Y, '夏提雅·净化投枪-P3第二枚');
      },
    });
  }
  return true;
}

export const 净化投枪技能状态 = { 已完成设计: true, 已完成实现: true, 已注册: true, 伤害形态: 'AOE', 包含战斗自身位移: false, 语义: '苍白金神圣投枪延迟落下；落点覆盖血印时摧毁血印，P3改为两枚提前锁定落点并先后结算。' } as const;
