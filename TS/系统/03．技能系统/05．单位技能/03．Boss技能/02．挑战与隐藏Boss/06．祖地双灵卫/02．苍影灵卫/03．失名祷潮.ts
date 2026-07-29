/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文, 祖地双灵卫净化节点状态 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 两点角度, 极坐标X, 极坐标Y, 点到线段距离平方, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 单位是否在条形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域';
import { createTimedEffect, 设置特效XYZ轴旋转 } from '../../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效';
import { 播放苍影灵卫台词 } from '../12．台词播放';
import { 播放Boss坐标音效 } from '../../../00．公共/00．Boss音效播放';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { 开始牵引, 停止牵引 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口') as {
  开始牵引: (this: void, unit: any, params: any) => number;
  停止牵引: (this: void, id: number) => boolean;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as { 造成AOE技能伤害: (this: void, params: any) => boolean };
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

function 取祷潮目标列表(this: void, boss: any, target?: any): any[] {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  if (!单位有效(target)) return heroes;
  const result: any[] = [target];
  for (let i = 0; i < heroes.length; i++) if (heroes[i] !== target) result.push(heroes[i]);
  return result;
}

function 消耗镇魂印并压制(this: void, context: 祖地双灵卫运行时上下文, boss: any): void {
  const seal = context.镇魂印;
  if (seal?.特效 != null && seal.特效 !== 0) {
    DestroyEffect(seal.特效);
    seal.特效 = undefined;
  }
  context.镇魂印 = undefined;
  开始硬直(boss, 祖地双灵卫数值与表现配置.P2.失名祷潮.压制硬直秒);
  createTimedEffect(祖地双灵卫数值与表现配置.表现资源.失名祷潮.断线与挡潮特效路径, seal?.X ?? GetUnitX(boss), seal?.Y ?? GetUnitY(boss), 0, 1);
}

function 净化校准节点(this: void, context: 祖地双灵卫运行时上下文, node: 祖地双灵卫净化节点状态): void {
  if (node.阶段 !== '校准') return;
  node.阶段 = '已净化';
  node.校准截止Ms = 0;
  context.已净化节点数量 += 1;
  context.当前净化节点序号 = node.序号;
  if (context.P3共鸣层数 > 0) context.P3共鸣层数 -= 1;
  const stun = 祖地双灵卫数值与表现配置.P3.净化成功硬直秒;
  if (单位有效(context.赤誓灵卫单位)) 开始硬直(context.赤誓灵卫单位, stun);
  if (单位有效(context.苍影灵卫单位)) 开始硬直(context.苍影灵卫单位, stun);
  createTimedEffect(祖地双灵卫数值与表现配置.表现资源.双钥净化.节点净化完成特效路径, node.X, node.Y, 0, 1.4);
}

function 检查祷潮穿过校准节点(this: void, context: 祖地双灵卫运行时上下文, startX: number, startY: number, endX: number, endY: number): void {
  const radius = 祖地双灵卫数值与表现配置.P3.节点判定半径 + 祖地双灵卫数值与表现配置.P2.失名祷潮.宽度 * 0.5;
  for (let i = 0; i < context.净化节点列表.length; i++) {
    const node = context.净化节点列表[i];
    if (node.序号 !== context.当前净化节点序号 || node.阶段 !== '校准') continue;
    if (点到线段距离平方(node.X, node.Y, startX, startY, endX, endY) <= radius * radius) 净化校准节点(context, node);
    return;
  }
}

export function 释放失名祷潮(this: void, context: 祖地双灵卫运行时上下文, target?: any): boolean {
  const boss = context.苍影灵卫单位;
  播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.苍影镇魂印, GetUnitX(boss), GetUnitY(boss), 祖地双灵卫数值与表现配置.音效默认裁断距离);
  if (!单位有效(boss) || context.战斗已结束) return false;
  const targets = 取祷潮目标列表(boss, target);
  if (targets.length === 0) return false;
  const cfg = 祖地双灵卫数值与表现配置.P2.失名祷潮;
  const nodeIndex = context.当前净化节点序号 - 1;
  const isCalibratingNode = context.阶段 === 'P3双蚀共鸣'
    && nodeIndex >= 0
    && nodeIndex < context.净化节点列表.length
    && context.净化节点列表[nodeIndex].阶段 === '校准';
  播放苍影灵卫台词(boss, isCalibratingNode ? '双钥净化校准' : '失名祷潮');
  const primary = targets[0];
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const facing = 两点角度(startX, startY, GetUnitX(primary), GetUnitY(primary));
  const endX = 极坐标X(startX, facing, cfg.长度);
  const endY = 极坐标Y(startY, facing, cfg.长度);
  context.大型机制忙碌到Ms = getServerTime() + (cfg.预警秒 + 0.5) * 1000;
  立即设置单位朝向(boss, facing);
  创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 宽度: cfg.宽度, 长度: cfg.长度, 朝向: facing, 持续时间: cfg.预警秒, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.预警秒 + 0.35, 恢复动画编号: cfg.恢复动画编号 });
  createTimedEffect(祖地双灵卫数值与表现配置.表现资源.失名祷潮.祷潮蓄势特效路径, startX, startY, 0, cfg.预警秒);
  const pullIds: number[] = [];
  for (let i = 0; i < targets.length; i++) {
    if (!单位有效(targets[i])) continue;
    const pullId = 开始牵引(targets[i], { 中心单位: boss, 主单位: boss, 持续时间: cfg.预警秒, 每秒速度: cfg.宽度 * 0.3, 最小距离: cfg.宽度, 到达后结束: false, 暂停单位: false, 禁用碰撞: false, 朝向跟随牵引: false, 闪电效果代码: 'SPLK', 闪电高度: 70 });
    if (pullId > 0) pullIds.push(pullId);
  }
  context.清理.登记清理('祖地双灵卫-失名祷潮牵引', function 清理失名祷潮牵引(this: void): void {
    for (let i = 0; i < pullIds.length; i++) 停止牵引(pullIds[i]);
  });
  const resolveId = addDelayedCallback(cfg.预警秒 * 1000, function 失名祷潮结算(this: void): void {
    for (let i = 0; i < pullIds.length; i++) 停止牵引(pullIds[i]);
    if (!单位有效(boss) || context.战斗已结束) return;
    let absorbed = false;
    const seal = context.镇魂印;
    if (seal != null && seal.到期Ms > getServerTime()) {
      const hitRadius = seal.半径 + cfg.宽度 * 0.5;
      absorbed = 点到线段距离平方(seal.X, seal.Y, startX, startY, endX, endY) <= hitRadius * hitRadius;
    }
    const effect = createTimedEffect(祖地双灵卫数值与表现配置.表现资源.失名祷潮.定向灵魂潮特效路径, startX, startY, 0, 1);
    设置特效XYZ轴旋转(effect, { Z轴角度: facing });
    if (absorbed) {
      消耗镇魂印并压制(context, boss);
      return;
    }
    检查祷潮穿过校准节点(context, startX, startY, endX, endY);
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      const hit = heroes[i];
      if (!单位是否在条形区域(hit, startX, startY, endX, endY, cfg.宽度)) continue;
      const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
      造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '祖地双灵卫·失名祷潮' });
    }
  });
  context.清理.登记延迟回调('祖地双灵卫-失名祷潮结算', resolveId);
  return true;
}

export const 失名祷潮技能状态 = {
  所属形态: '无面祷影', 已完成设计: true, 已完成实现: true, 已注册: true,
  伤害形态: ['单体', 'AOE'], 需要独立技能实例ID: false, 包含战斗自身位移: false,
  实现要求: '牵魂目标复用公共牵引；祷潮命中镇魂印时压制自身，穿过当前校准节点时完成净化。',
} as const;
