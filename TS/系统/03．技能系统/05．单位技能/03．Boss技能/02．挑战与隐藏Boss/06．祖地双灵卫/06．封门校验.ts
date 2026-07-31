/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 开始祖地双灵卫联合施法 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 释放誓锋壁进 } from './02．苍影灵卫/01．誓锋壁进';
import { 创建赤誓镇魂印 } from './01．赤誓灵卫/01．灵印折步';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建立即执行阶段, 创建延迟阶段 } from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 两点角度, 极坐标X, 极坐标Y, 点到线段距离平方 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 播放苍影灵卫台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 创建原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

function 誓盾是否阻挡(this: void, context: 祖地双灵卫运行时上下文, sourceX: number, sourceY: number, target: any): boolean {
  const shield = context.誓盾;
  if (shield == null || getServerTime() >= shield.到期Ms) return false;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const totalX = targetX - sourceX;
  const totalY = targetY - sourceY;
  const total2 = totalX * totalX + totalY * totalY;
  if (total2 <= 1) return false;
  const projection = ((shield.X - sourceX) * totalX + (shield.Y - sourceY) * totalY) / total2;
  if (projection <= 0 || projection >= 1) return false;
  const width = 祖地双灵卫数值与表现配置.P1.誓锋壁进.誓盾宽度;
  return 点到线段距离平方(shield.X, shield.Y, sourceX, sourceY, targetX, targetY) <= width * width * 0.25;
}

export function 释放祖地双灵卫封门校验(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const red = context.赤誓灵卫单位;
  const azure = context.苍影灵卫单位;
  if (context.战斗已结束 || context.阶段 !== 'P1双灵守门' || context.大型技能占用者 != null || target == null || target === 0) return false;
  let waveStartX = 0;
  let waveStartY = 0;
  let waveEndX = 0;
  let waveEndY = 0;
  let waveReady = false;
  const waveWarning = 1;
  const executor = 创建固定组合技能执行器<祖地双灵卫运行时上下文>({ 名称: '祖地双灵卫-封门校验', 清理: context.清理, 互斥组: '祖地双灵卫大型技能' });
  context.大型技能占用者 = '联合机制';
  context.大型机制忙碌到Ms = getServerTime() + 4200;
  const executionId = executor.开始({
    key: '封门校验',
    单位: azure,
    上下文: context,
    最大持续毫秒: 5000,
    阶段列表: [
      创建立即执行阶段(function 封门校验壁进(this: void): void {
        释放誓锋壁进(context, target);
      }, '苍影誓锋壁进'),
      创建延迟阶段(1650, '等待誓盾成形'),
      创建立即执行阶段(function 封门校验魂潮预警(this: void): void {
        const shield = context.誓盾;
        if (shield == null) return;
        const facing = shield.朝向;
        waveStartX = 极坐标X(shield.X, facing + 180, 420);
        waveStartY = 极坐标Y(shield.Y, facing + 180, 420);
        waveEndX = 极坐标X(shield.X, facing, context.场地半宽 + 500);
        waveEndY = 极坐标Y(shield.Y, facing, context.场地半宽 + 500);
        waveReady = true;
        执行战斗自身传送到坐标(red, waveStartX, waveStartY);
        const waveFacing = 两点角度(waveStartX, waveStartY, waveEndX, waveEndY);
        立即设置单位朝向(red, waveFacing);
        开始祖地双灵卫联合施法(context, waveWarning, '封门校验·灵魂潮', '誓盾成形后，灵魂潮将在读条结束时沿直线结算');
        播放限时单位动画({ 单位: red, 动画编号: 祖地双灵卫数值与表现配置.P1.灵印折步.动画编号, 持续秒: waveWarning + 0.4, 恢复动画编号: 祖地双灵卫数值与表现配置.动作.赤誓正常待机 });
        创建技能提示圈({ 类型: '方向直线', X: waveStartX, Y: waveStartY, 宽度: context.场地半高 * 2, 长度: context.场地半宽 * 2 + 900, 朝向: waveFacing, 持续时间: waveWarning, 来源单位: red });
      }, '灵魂潮预警'),
      创建延迟阶段(waveWarning * 1000, '等待灵魂潮'),
      创建立即执行阶段(function 封门校验魂潮结算(this: void): void {
        if (!waveReady) return;
        const heroes = 获取Boss技能敌对英雄列表(red);
        创建原生弹幕({
          所有者: red,
          载体模式: '单位',
          模型: 祖地双灵卫数值与表现配置.表现资源.封门校验.半场灵魂潮特效路径,
          缩放: 1.7,
          X: waveStartX,
          Y: waveStartY,
          方向角: 两点角度(waveStartX, waveStartY, waveEndX, waveEndY),
          速度: 1400,
          生命周期: 1.2,
          最大距离: context.场地半宽 + 500,
          命中半径: context.场地半高,
          影响目标: '敌方',
          每单位最大命中次数: 1,
          碰撞消失: false,
          目标筛选: function 封门校验灵魂潮目标筛选(this: void, unit: any): boolean {
            for (let i = 0; i < heroes.length; i++) if (heroes[i] === unit) return true;
            return false;
          },
          on命中: function 封门校验灵魂潮命中(this: void, hit: any): void {
            if (誓盾是否阻挡(context, waveStartX, waveStartY, hit)) return;
            const damage = 计算组合技能伤害(red, hit, { 来源攻击力比例: 0.95, 目标最大生命比例: 0.045 });
            造成AOE技能伤害({ 来源: red, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_SHADOW_STRIKE, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '祖地双灵卫·封门校验' });
          },
          on到达目标点: function 封门校验灵魂潮结束(this: void): void {
            创建赤誓镇魂印(context, waveStartX, waveStartY);
          },
        });
      }, '灵魂潮结算与留印'),
    ],
    结束回调: function 封门校验结束(this: void): void {
      if (context.大型技能占用者 === '联合机制') context.大型技能占用者 = undefined;
    },
  });
  if (executionId === 0) {
    context.大型技能占用者 = undefined;
    return false;
  }
  播放苍影灵卫台词(azure, '封门校验');
  播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.封门校验, GetUnitX(azure), GetUnitY(azure), 祖地双灵卫数值与表现配置.音效默认裁断距离);
  return true;
}

export const 封门校验机制状态 = {
  类型: 'P1联合组合技',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '苍影灵卫留下有朝向的誓盾，赤誓灵卫随后释放灵魂潮，教授盾可阻挡灵魂能量。',
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: true,
} as const;
