/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 极坐标X, 极坐标Y } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 单位是否在扇形区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

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
const { 创建原生弹幕, 创建直线定点轨迹 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index') as {
  创建原生弹幕: (this: void, 参数: any) => any;
  创建直线定点轨迹: (this: void, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number) => any;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const RAD_TO_DEG = 57.29577951308232;
const 亡者凝视技能Key = '亡者凝视';

export function 释放亚伦柯斯亡者凝视(this: void, context: 亚伦柯斯运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.当前大型技能 != null) return false;
  const cfg = 亚伦柯斯正式设计配置.亡者凝视;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - y, GetUnitX(target) - x) * RAD_TO_DEG;
  context.当前大型技能 = 亡者凝视技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (cfg.前摇秒 + 0.5) * 1000;
  SetUnitFacing(boss, facing);
  开始硬直(boss, cfg.前摇秒);
  创建技能提示圈({ 类型: '扇形', X: x, Y: y, 半径: cfg.半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.前摇秒 + 0.2, 恢复动画编号: 1 });
  播放亚伦柯斯台词(boss, '亡者凝视');
  const delayedId = addDelayedCallback(cfg.前摇秒 * 1000, function 亚伦柯斯亡者凝视结算(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) {
      if (context.当前大型技能 === 亡者凝视技能Key) context.当前大型技能 = undefined;
      return;
    }
    const endX = 极坐标X(x, facing, cfg.半径);
    const endY = 极坐标Y(y, facing, cfg.半径);
    创建原生弹幕({
      所有者: boss,
      载体模式: '特效',
      X: x,
      Y: y,
      方向角: facing,
      速度: cfg.半径 / cfg.冲击持续秒,
      生命周期: cfg.冲击持续秒,
      最大距离: cfg.半径,
      轨迹采样器: 创建直线定点轨迹(x, y, endX, endY),
      命中半径: 0,
      禁用碰撞: true,
      附加特效1: {
        模型: 亚伦柯斯正式设计配置.表现资源.亡者凝视特效路径,
        跟随主弹幕参数: true,
        缩放: 2,
      },
    });
    播放Boss坐标音效(亚伦柯斯正式设计配置.音效.亡者凝视, x, y, 亚伦柯斯正式设计配置.音效默认裁断距离);
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      const hit = heroes[i];
      if (!单位是否在扇形区域(hit, x, y, cfg.半径, facing, cfg.扇形角度)) continue;
      const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
      造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '亚伦柯斯·亡者凝视' });
      开始硬直(hit, cfg.硬直秒);
    }
    if (context.当前大型技能 === 亡者凝视技能Key) context.当前大型技能 = undefined;
  });
  context.清理.登记延迟回调('亚伦柯斯-亡者凝视', delayedId);
  return true;
}

export const 亡者凝视技能状态 = {
  类型: '代码侧周期技能',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: false,
  语义: '锁定目标朝向后预警正面扇形，结算伤害与短硬直；侧后方始终为安全方向。',
} as const;
