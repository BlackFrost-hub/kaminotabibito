/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 开始分批点名落点模板 } from '../../../../00．技能模板+函数/00．技能模板/05．点名技能模板/02．分批点名落点模板';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 英灵陨星技能Key = '英灵陨星';

function 取落点数量(this: void, context: 亚伦柯斯运行时上下文): number {
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  if (context.阶段 === 'P3最后的誓约') return cfg.P3落点数量;
  if (context.阶段 === 'P2旧誓回响') return cfg.P2落点数量;
  return cfg.P1落点数量;
}

function 结束英灵陨星(this: void, context: 亚伦柯斯运行时上下文): void {
  if (context.当前大型技能 === 英灵陨星技能Key) context.当前大型技能 = undefined;
}

function 结算英灵陨星(this: void, context: 亚伦柯斯运行时上下文, x: number, y: number, radius: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束) return;
  const cfg = 亚伦柯斯正式设计配置;
  const meteor = AddSpecialEffect(cfg.表现资源.英灵陨星正式特效路径, x, y);
  const impact = AddSpecialEffect(cfg.表现资源.英灵陨星落地特效路径, x, y);
  播放Boss坐标音效(cfg.音效.英灵陨星命中, x, y, cfg.音效默认裁断距离);
  if (meteor != null && meteor !== 0) YDWETimerDestroyEffectSafe(0.8, meteor);
  if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(0.8, impact);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const isP3 = context.阶段 === 'P3最后的誓约';
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    const dx = GetUnitX(target) - x;
    const dy = GetUnitY(target) - y;
    if (dx * dx + dy * dy > radius * radius) continue;
    const damage = 计算组合技能伤害(boss, target, {
      来源攻击力比例: isP3 ? cfg.英灵陨星.P3伤害攻击力比例 : cfg.英灵陨星.伤害攻击力比例,
      目标最大生命比例: isP3 ? cfg.英灵陨星.P3伤害目标最大生命比例 : cfg.英灵陨星.伤害目标最大生命比例,
    });
    造成AOE技能伤害({ 来源: boss, 目标: target, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: isP3 ? '亚伦柯斯·英灵陨星-送葬' : '亚伦柯斯·英灵陨星' });
  }
  const aftershock = AddSpecialEffect(cfg.表现资源.英灵陨星余波特效路径, x, y);
  if (aftershock != null && aftershock !== 0) YDWETimerDestroyEffectSafe(0.7, aftershock);
}

export function 释放亚伦柯斯英灵陨星(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.当前大型技能 != null) return false;
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  const count = 取落点数量(context);
  const isP3 = context.阶段 === 'P3最后的誓约';
  const radius = isP3 ? cfg.P3伤害半径 : cfg.常规伤害半径;
  const totalDuration = (count - 1) * cfg.落点间隔秒 + cfg.预警秒;
  context.当前大型技能 = 英灵陨星技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (totalDuration + 0.4) * 1000;
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: 1, 恢复动画编号: 1 });
  播放亚伦柯斯台词(boss, isP3 ? '英灵陨星送葬' : '英灵陨星');
  播放Boss坐标音效(亚伦柯斯正式设计配置.音效.英灵陨星坠落, GetUnitX(boss), GetUnitY(boss), 亚伦柯斯正式设计配置.音效默认裁断距离);

  开始分批点名落点模板({
    名称: '亚伦柯斯-英灵陨星',
    清理: context.清理,
    轮数: count,
    轮次间隔秒: cfg.落点间隔秒,
    预警秒: cfg.预警秒,
    锁定坐标: true,
    取目标列表: function 获取英灵陨星目标(this: void): any[] {
      return 获取Boss技能敌对英雄列表(boss);
    },
    提示圈: function 英灵陨星提示圈(this: void, result): any {
      return { 类型: '敌方圆形', X: result.锁定X, Y: result.锁定Y, 半径: radius, 持续时间: cfg.预警秒, 来源单位: boss };
    },
    on锁定: function 英灵陨星锁定表现(this: void, result): void {
      const warning = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.英灵陨星预警特效路径, result.锁定X, result.锁定Y);
      if (warning != null && warning !== 0) YDWETimerDestroyEffectSafe(cfg.预警秒, warning);
    },
    on结算: function 英灵陨星落点结算(this: void, result): void {
      结算英灵陨星(context, result.锁定X, result.锁定Y, radius);
    },
    on结束: function 英灵陨星全部结束(this: void): void {
      结束英灵陨星(context);
    },
    on取消: function 英灵陨星取消(this: void): void {
      结束英灵陨星(context);
    },
  });
  return true;
}

export const 英灵陨星迁移状态 = {
  旧技能ID: 'A0F5',
  通用技能壳ID: 'AN00',
  已保留旧原型语义: true,
  已完成TS实现: true,
  已注册: true,
  伤害形态: 'AOE',
  语义: '复用分批点名落点模板，每批重新取得有效玩家并锁定坐标；P3减少落点数量、扩大范围并提高单次冲击。',
} as const;
