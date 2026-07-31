/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 祖地双灵卫运行时上下文, 祖地双灵卫区域状态 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 执行战斗自身传送到坐标 } from '../../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 施加快速减速Buff } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 开始牵引 } from '../../../../../00．技能模板+函数/01．技能函数/05．吸附·牵引/01．牵引系统/03．对外接口';
import { 创建区域效果, type 区域效果实例 } from '../../../../../00．技能模板+函数/01．技能函数/04．区域效果/区域效果';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

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
const { 设置特效缩放 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const RAD_TO_DEG = 57.29577951308232;

interface 镇魂印运行状态 extends 祖地双灵卫区域状态 {
  区域实例?: 区域效果实例;
}

function 限制在场地内(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number): { X: number; Y: number } {
  const margin = 64;
  const minX = context.场地中心X - context.场地半宽 + margin;
  const maxX = context.场地中心X + context.场地半宽 - margin;
  const minY = context.场地中心Y - context.场地半高 + margin;
  const maxY = context.场地中心Y + context.场地半高 - margin;
  return { X: x < minX ? minX : x > maxX ? maxX : x, Y: y < minY ? minY : y > maxY ? maxY : y };
}

function 清除旧镇魂印(this: void, context: 祖地双灵卫运行时上下文): void {
  const oldSeal = context.镇魂印 as 镇魂印运行状态 | undefined;
  if (oldSeal?.区域实例 != null) oldSeal.区域实例.销毁();
  context.镇魂印 = undefined;
}

function 单位在列表中(this: void, unit: any, list: any[]): boolean {
  for (let i = 0; i < list.length; i++) if (list[i] === unit) return true;
  return false;
}

export function 创建赤誓镇魂印(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number): void {
  清除旧镇魂印(context);
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || context.战斗已结束) return;
  const cfg = 祖地双灵卫数值与表现配置.P1.灵印折步;
  const seal: 镇魂印运行状态 = {
    X: x,
    Y: y,
    半径: cfg.镇魂印半径,
    到期Ms: getServerTime() + cfg.镇魂印持续秒 * 1000,
  };
  const area = 创建区域效果({
    X: x,
    Y: y,
    半径: cfg.镇魂印半径,
    持续时间: cfg.镇魂印持续秒,
    检测间隔: 0.25,
    防抖间隔: 0,
    影响目标: '敌方',
    所有者: boss,
    模型路径: 祖地双灵卫数值与表现配置.表现资源.灵印折步.镇魂印地面特效路径,
    特效缩放: 祖地双灵卫数值与表现配置.表现资源.灵印折步.镇魂印特效缩放,
    提示圈: false,
    on周期: function 赤誓镇魂印周期(this: void, units: any[]): void {
      if (context.战斗已结束 || context.镇魂印 !== seal) {
        area.销毁();
        return;
      }
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < units.length; i++) {
        const target = units[i];
        if (!单位有效(target) || !单位在列表中(target, heroes)) continue;
        施加快速减速Buff(boss, target, 0.12, 0.12, 0.4);
        开始牵引(target, {
          中心X: x,
          中心Y: y,
          主单位: boss,
          主单位死亡时中断: true,
          持续时间: 0.28,
          每秒速度: 80,
          最小距离: 72,
          到达距离: 72,
          到达后结束: true,
          检查地形: true,
          禁用碰撞: false,
          暂停单位: false,
          启用闪电效果: false,
        });
      }
    },
    on销毁: function 赤誓镇魂印销毁(this: void): void {
      if (context.镇魂印 === seal) context.镇魂印 = undefined;
    },
  });
  seal.区域实例 = area;
  context.镇魂印 = seal;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const radius2 = cfg.镇魂印半径 * cfg.镇魂印半径;
  for (let i = 0; i < heroes.length; i++) {
    const hit = heroes[i];
    const dx = GetUnitX(hit) - x;
    const dy = GetUnitY(hit) - y;
    if (dx * dx + dy * dy > radius2) continue;
    const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
    造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '祖地双灵卫·灵印折步镇魂印' });
  }
  context.清理.登记清理('祖地双灵卫-镇魂印区域', function 清理赤誓镇魂印(this: void): void {
    area.销毁();
  });
}

export function 释放灵印折步(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.赤誓灵卫形态 !== '正常') return false;
  const cfg = 祖地双灵卫数值与表现配置.P1.灵印折步;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - startY, GetUnitX(target) - startX) * RAD_TO_DEG;
  const landing = 限制在场地内(context, startX + CosBJ(facing) * cfg.位移距离, startY + SinBJ(facing) * cfg.位移距离);
  立即设置单位朝向(boss, facing);
  开始祖地双灵卫常规施法(boss, cfg.前摇秒, '灵印折步', '赤誓灵卫将折步到锁定位置');
  创建技能提示圈({ 类型: '渐变圆形', X: landing.X, Y: landing.Y, 半径: cfg.镇魂印半径, 持续时间: cfg.前摇秒, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.前摇秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
  const vanish = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.灵印折步.消失特效路径, startX, startY);
  if (vanish != null && vanish !== 0) YDWETimerDestroyEffectSafe(cfg.前摇秒 + 0.4, vanish);
  const delayedId = addDelayedCallback(cfg.前摇秒 * 1000, function 灵印折步落地(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    if (!执行战斗自身传送到坐标(boss, landing.X, landing.Y)) return;
    创建赤誓镇魂印(context, startX, startY);
    const arrival = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.灵印折步.出现特效路径, landing.X, landing.Y);
    if (arrival != null && arrival !== 0) {
      设置特效缩放(arrival, 祖地双灵卫数值与表现配置.表现资源.灵印折步.出现特效缩放);
      YDWETimerDestroyEffectSafe(0.8, arrival);
    }
  });
  context.清理.登记延迟回调('祖地双灵卫-灵印折步落地', delayedId);
  return true;
}

export const 灵印折步技能状态 = {
  所属守卫: '赤誓灵卫',
  所属形态: '正常',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: true,
  实现要求: '瞬移走统一战斗自身传送封装；原位置只保留一个带低伤害脉冲、轻减速与柔和牵引的镇魂印。',
} as const;
