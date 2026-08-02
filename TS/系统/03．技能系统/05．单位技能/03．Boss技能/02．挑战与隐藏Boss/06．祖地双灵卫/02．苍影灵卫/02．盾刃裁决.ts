/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 执行BossAOE技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 两点角度, 极坐标X, 极坐标Y, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 单位是否在扇形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 创建原生弹幕 } from '../../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口';
import { 创建点特效 } from '../../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效';
import { 创建固定组合技能执行器 } from '../../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from '../../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const SetUnitAnimationByIndex = (require('jass.common') as any).SetUnitAnimationByIndex as (unit: any, index: number) => void;

function 播放剑刃重斩直线弹幕(this: void, boss: any, x: number, y: number, facing: number, length: number, cfg: any): void {
  const barrage = 创建原生弹幕({
    所有者: boss,
    X: x,
    Y: y,
    方向角: facing,
    速度: 1400,
    最大距离: length,
    生命周期: 0.6,
    命中半径: cfg.直线宽度 * 0.5,
    影响目标: '敌方',
    模型: 祖地双灵卫数值与表现配置.表现资源.盾刃裁决.剑刃重斩特效路径,
    缩放: 1,
    每单位最大命中次数: 1,
    碰撞消失: false,
    目标筛选: function 剑刃重斩目标筛选(this: void, target: any): boolean {
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) if (heroes[i] === target) return true;
      return false;
    },
    on命中: function 剑刃重斩命中(this: void, target: any): void {
      造成裁决伤害(boss, target, cfg.重斩伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·盾刃裁决-重斩', WEAPON_TYPE_METAL_HEAVY_SLICE);
    },
  });
  if (barrage.弹幕单位 != null && barrage.弹幕单位 !== 0) SetUnitAnimationByIndex(barrage.弹幕单位, 0);
}

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

function 造成裁决伤害(this: void, boss: any, target: any, attackRatio: number, lifeRatio: number, tag: string, weaponType: any): void {
  执行BossAOE技能伤害({
    来源: boss,
    目标: target,
    伤害公式: { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType,
    标签: tag,
  });
}

export function 释放盾刃裁决(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.苍影灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束) return false;
  const cfg = 祖地双灵卫数值与表现配置.P1.盾刃裁决;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const facing = 两点角度(x, y, GetUnitX(target), GetUnitY(target));
  const firstWarning = cfg.两段间隔秒;
  context.大型机制忙碌到Ms = getServerTime() + (firstWarning + cfg.两段间隔秒 + 0.35) * 1000;
  立即设置单位朝向(boss, facing);
  开始祖地双灵卫常规施法(boss, firstWarning, '盾刃裁决', '先结算正面盾击，再沿锁定方向释放重斩');
  创建技能提示圈({ 类型: '扇形', X: x, Y: y, 半径: cfg.扇形半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: firstWarning, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.盾击动画编号, 持续秒: firstWarning + 0.15, 恢复动画编号: cfg.恢复动画编号 });
  const 事件列表: 固定时间轴事件[] = [{
    时点毫秒: firstWarning * 1000,
    名称: '盾刃裁决盾击',
    执行: function 盾刃裁决盾击(this: void): void {
      if (!单位有效(boss) || context.战斗已结束) return;
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) {
        if (单位是否在扇形区域(heroes[i], x, y, cfg.扇形半径, facing, cfg.扇形角度)) {
          造成裁决伤害(boss, heroes[i], cfg.盾击伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·盾刃裁决-盾击', WEAPON_TYPE_METAL_HEAVY_BASH);
        }
      }
      创建点特效({
        模型路径: 祖地双灵卫数值与表现配置.表现资源.盾刃裁决.盾击命中特效路径,
        X: 极坐标X(x, facing, cfg.扇形半径 * 0.45),
        Y: 极坐标Y(y, facing, cfg.扇形半径 * 0.45),
        缩放: 5.0,
        动画索引: 0,
        持续秒: 0.8,
      });
      开始祖地双灵卫常规施法(boss, cfg.两段间隔秒, '盾刃裁决·重斩', '重斩将沿刚才的方向结算');
      创建技能提示圈({ 类型: '方向直线', X: x, Y: y, 宽度: cfg.直线宽度, 长度: cfg.直线长度, 朝向: facing, 持续时间: cfg.两段间隔秒, 来源单位: boss });
      播放限时单位动画({ 单位: boss, 动画编号: cfg.重斩动画编号, 持续秒: cfg.两段间隔秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
    },
  }, {
    时点毫秒: (firstWarning + cfg.两段间隔秒) * 1000,
    名称: '盾刃裁决重斩',
    执行: function 盾刃裁决重斩(this: void): void {
      if (!单位有效(boss) || context.战斗已结束) return;
      播放剑刃重斩直线弹幕(boss, x, y, facing, cfg.直线长度, cfg);
    },
  }];
  const executor = 创建固定组合技能执行器<祖地双灵卫运行时上下文>({ 名称: '祖地双灵卫-盾刃裁决', 清理: context.清理, 互斥组: '祖地双灵卫主要技能' });
  return executor.开始({
    key: '盾刃裁决',
    单位: boss,
    上下文: context,
    最大持续毫秒: (firstWarning + cfg.两段间隔秒 + 0.35) * 1000,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  }) !== 0;
}

export const 盾刃裁决技能状态 = {
  所属守卫: '苍影灵卫', 所属形态: '正常', 已完成设计: true, 已完成实现: true, 已注册: true,
  伤害形态: 'AOE', 需要独立技能实例ID: false, 包含战斗自身位移: false,
  实现要求: '开始时锁定方向，盾击扇形与后续窄直线重斩分别预警、分别结算。',
} as const;
