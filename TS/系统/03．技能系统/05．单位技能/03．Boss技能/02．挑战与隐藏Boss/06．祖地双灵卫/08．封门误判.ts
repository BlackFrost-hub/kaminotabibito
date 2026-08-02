/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 开始祖地双灵卫联合施法 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 推进祖地双灵卫下一个净化节点 } from './07．双钥净化';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 单位是否在胶囊区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/胶囊区域';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 两点角度, 距离XY, 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 创建点特效 } from '../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效';

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
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXSetEffectSize = (japi as any).EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

function 铺设月白通道(this: void, startX: number, startY: number, endX: number, endY: number, duration: number): void {
  const model = 祖地双灵卫数值与表现配置.表现资源.封门误判.月白安全通道特效路径;
  const segments = 6;
  for (let i = 0; i <= segments; i++) {
    const t = i / segments;
    const effect = AddSpecialEffect(model, startX + (endX - startX) * t, startY + (endY - startY) * t);
    if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(duration, effect);
  }
}

export function 释放祖地双灵卫封门误判(this: void, context: 祖地双灵卫运行时上下文): boolean {
  if (context.战斗已结束 || context.阶段 !== 'P3双蚀共鸣' || !context.封门误判待触发 || context.已净化节点数量 <= 0) return false;
  const node = context.净化节点列表[context.已净化节点数量 - 1];
  if (node == null) return false;
  const cfg = 祖地双灵卫数值与表现配置.P3;
  const red = context.赤誓灵卫单位;
  const azure = context.苍影灵卫单位;
  context.封门误判待触发 = false;
  if (单位有效(red)) 立即设置单位朝向(red, 两点角度(GetUnitX(red), GetUnitY(red), context.场地中心X, context.场地中心Y));
  if (单位有效(azure)) 立即设置单位朝向(azure, 两点角度(GetUnitX(azure), GetUnitY(azure), context.场地中心X, context.场地中心Y));
  开始祖地双灵卫联合施法(context, cfg.封门误判预警秒, '封门误判', '沿月白安全通道躲避中心冲击，读条结束后结算伤害');
  播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.封门误判, context.场地中心X, context.场地中心Y, 祖地双灵卫数值与表现配置.音效默认裁断距离);
  if (context.已净化节点数量 % 2 === 1) 播放赤誓灵卫台词(red, '封门误判');
  else 播放苍影灵卫台词(azure, '封门误判');
  context.大型技能占用者 = '联合机制';
  context.大型机制忙碌到Ms = getServerTime() + (cfg.封门误判预警秒 + 0.8) * 1000;
  创建技能提示圈({ 类型: '敌方圆形', X: context.场地中心X, Y: context.场地中心Y, 半径: context.场地半宽 > context.场地半高 ? context.场地半宽 : context.场地半高, 持续时间: cfg.封门误判预警秒, 来源单位: azure });
  创建技能提示圈({
    类型: '白色方向直线',
    X: node.X,
    Y: node.Y,
    宽度: cfg.封门误判安全通道半宽 * 2,
    长度: 距离XY(node.X, node.Y, context.场地中心X, context.场地中心Y),
    朝向: 两点角度(node.X, node.Y, context.场地中心X, context.场地中心Y),
    持续时间: cfg.封门误判预警秒,
  });
  创建点特效({
    模型路径: 祖地双灵卫数值与表现配置.表现资源.封门误判.入侵区域覆盖特效路径,
    X: context.场地中心X,
    Y: context.场地中心Y,
    缩放: 祖地双灵卫数值与表现配置.表现资源.封门误判.入侵区域覆盖特效缩放,
    持续秒: cfg.封门误判预警秒 + 0.8,
  });
  铺设月白通道(node.X, node.Y, context.场地中心X, context.场地中心Y, cfg.封门误判预警秒 + 0.6);
  播放限时单位动画({ 单位: red, 动画编号: 祖地双灵卫数值与表现配置.动作.裂誓下劈, 持续秒: cfg.封门误判预警秒 + 0.3, 恢复动画编号: 祖地双灵卫数值与表现配置.动作.裂誓待机 });
  播放限时单位动画({ 单位: azure, 动画编号: 祖地双灵卫数值与表现配置.动作.无面施法, 持续秒: cfg.封门误判预警秒 + 0.3, 恢复动画编号: 祖地双灵卫数值与表现配置.动作.无面待机 });
  const delayedId = addDelayedCallback(cfg.封门误判预警秒 * 1000, function 双灵卫封门误判结算(this: void): void {
    if (!context.战斗已结束 && context.阶段 === 'P3双蚀共鸣') {
      const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.封门误判.封门中心砸击特效路径, context.场地中心X, context.场地中心Y);
      const impactOverlay = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.封门误判.封门中心砸击叠加特效路径, context.场地中心X, context.场地中心Y);
      const impactScale = 祖地双灵卫数值与表现配置.表现资源.封门误判.封门中心砸击特效缩放;
      if (impact != null && impact !== 0 && EXSetEffectSize != null) EXSetEffectSize(impact, impactScale);
      if (impactOverlay != null && impactOverlay !== 0 && EXSetEffectSize != null) EXSetEffectSize(impactOverlay, impactScale);
      if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(1.2, impact);
      if (impactOverlay != null && impactOverlay !== 0) YDWETimerDestroyEffectSafe(1.2, impactOverlay);
      const heroes = 获取Boss技能敌对英雄列表(red);
      let 通道成功 = false;
      for (let i = 0; i < heroes.length; i++) {
        const target = heroes[i];
        if (单位是否在胶囊区域(target, node.X, node.Y, context.场地中心X, context.场地中心Y, cfg.封门误判安全通道半宽)) {
          通道成功 = true;
          continue;
        }
        执行BossAOE技能伤害({
          来源: red,
          目标: target,
          伤害公式: { 来源攻击力比例: cfg.封门误判伤害攻击力比例, 目标最大生命比例: cfg.封门误判目标最大生命比例 },
          attack: false,
          ranged: true,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
          标签: '祖地双灵卫·封门误判',
        });
      }
      if (通道成功) {
        const reflection = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.封门误判.净化反射特效路径, node.X, node.Y);
        if (reflection != null && reflection !== 0) YDWETimerDestroyEffectSafe(2.0, reflection);
      }
      context.大型技能占用者 = undefined;
      推进祖地双灵卫下一个净化节点(context);
    }
  });
  context.清理.登记延迟回调('祖地双灵卫-封门误判', delayedId);
  return true;
}

export const 封门误判机制状态 = {
  类型: 'P3阶段收束技',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '净化节点完成后投射月白安全通道，玩家借通道躲避两名守卫对封门区域的联合误判。',
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: false,
} as const;
