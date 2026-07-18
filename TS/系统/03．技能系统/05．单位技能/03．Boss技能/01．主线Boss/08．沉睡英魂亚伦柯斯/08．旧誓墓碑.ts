/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 进入亚伦柯斯P3 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 亚伦柯斯单位技能配置 } from './00．配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 单位是否在胶囊区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/胶囊区域';
import { 亚伦柯斯BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/07．亚伦柯斯';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};
const { getServerTime, addPeriodicCallback, removePeriodicCallback, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
const 旧誓残影技能Key = '旧誓墓碑残影';

interface 旧誓墓碑状态 {
  X: number;
  Y: number;
  安魂进度秒: number;
  已安魂: boolean;
  墓碑特效?: any;
  范围特效?: any;
  下次残影Ms: number;
}

function 销毁墓碑特效(this: void, state: 旧誓墓碑状态): void {
  if (state.墓碑特效 != null && state.墓碑特效 !== 0) DestroyEffect(state.墓碑特效);
  if (state.范围特效 != null && state.范围特效 !== 0) DestroyEffect(state.范围特效);
  state.墓碑特效 = undefined;
  state.范围特效 = undefined;
}

function 清理墓碑列表(this: void, context: 亚伦柯斯运行时上下文): void {
  for (let i = 0; i < context.墓碑状态列表.length; i++) 销毁墓碑特效(context.墓碑状态列表[i] as 旧誓墓碑状态);
  context.墓碑状态列表 = [];
  if (单位有效(context.Boss单位)) 移除单位指定Buff(context.Boss单位, 亚伦柯斯BuffID.旧誓加护);
}

function 刷新旧誓加护Buff(this: void, context: 亚伦柯斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const count = context.未安魂墓碑数量;
  if (count <= 0) {
    移除单位指定Buff(boss, 亚伦柯斯BuffID.旧誓加护);
    return;
  }
  const reduction = 亚伦柯斯正式设计配置.旧誓墓碑.未安魂减伤每层 * count * 100;
  registerManualBuff(boss, 亚伦柯斯BuffID.旧誓加护, 3600, reduction, { stack: count, sourceName: '亚伦柯斯-旧誓墓碑' });
}

function 完成墓碑安魂(this: void, context: 亚伦柯斯运行时上下文, state: 旧誓墓碑状态): void {
  if (state.已安魂) return;
  state.已安魂 = true;
  销毁墓碑特效(state);
  context.已安魂墓碑数量 += 1;
  context.未安魂墓碑数量 -= 1;
  if (context.未安魂墓碑数量 < 0) context.未安魂墓碑数量 = 0;
  刷新旧誓加护Buff(context);
  const release = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.墓碑安魂完成特效路径, state.X, state.Y);
  播放Boss坐标音效(亚伦柯斯正式设计配置.音效.墓碑安魂, state.X, state.Y, 亚伦柯斯正式设计配置.音效默认裁断距离);
  if (release != null && release !== 0) YDWETimerDestroyEffectSafe(1.4, release);
  播放亚伦柯斯台词(context.Boss单位, '墓碑安魂');
  if (context.未安魂墓碑数量 <= 0) 进入亚伦柯斯P3(context);
}

function 范围内存在玩家(this: void, context: 亚伦柯斯运行时上下文, state: 旧誓墓碑状态): boolean {
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  const radius = 亚伦柯斯正式设计配置.旧誓墓碑.安魂范围;
  for (let i = 0; i < heroes.length; i++) {
    const dx = GetUnitX(heroes[i]) - state.X;
    const dy = GetUnitY(heroes[i]) - state.Y;
    if (dx * dx + dy * dy <= radius * radius) return true;
  }
  return false;
}

function 设置全部墓碑下次残影(this: void, context: 亚伦柯斯运行时上下文, nextMs: number): void {
  for (let i = 0; i < context.墓碑状态列表.length; i++) {
    const state = context.墓碑状态列表[i] as 旧誓墓碑状态;
    if (!state.已安魂) state.下次残影Ms = nextMs;
  }
}

function 尝试释放墓碑残影(this: void, context: 亚伦柯斯运行时上下文, state: 旧誓墓碑状态, now: number): boolean {
  const boss = context.Boss单位;
  if (context.当前大型技能 != null || now < context.普通机制忙碌到Ms) return false;
  const target = 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return false;
  const cfg = 亚伦柯斯正式设计配置.旧誓墓碑;
  const dx = GetUnitX(target) - state.X;
  const dy = GetUnitY(target) - state.Y;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  const endX = state.X + CosBJ(facing) * cfg.残影斩击长度;
  const endY = state.Y + SinBJ(facing) * cfg.残影斩击长度;
  context.当前大型技能 = 旧誓残影技能Key;
  context.普通机制忙碌到Ms = now + (cfg.残影斩击预警秒 + 0.4) * 1000;
  设置全部墓碑下次残影(context, now + cfg.残影斩击间隔秒 * 1000);
  创建技能提示圈({ 类型: '方向直线', X: state.X, Y: state.Y, 宽度: cfg.残影斩击宽度, 长度: cfg.残影斩击长度, 朝向: facing, 持续时间: cfg.残影斩击预警秒, 来源单位: boss });
  const delayedId = addDelayedCallback(cfg.残影斩击预警秒 * 1000, function 亚伦柯斯墓碑残影结算(this: void): void {
    if (!context.战斗已结束 && context.阶段 === 'P2旧誓回响' && !state.已安魂) {
      const echo = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.墓碑残影模型路径, state.X, state.Y);
      if (echo != null && echo !== 0) YDWETimerDestroyEffectSafe(0.9, echo);
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) {
        const hit = heroes[i];
        if (!单位是否在胶囊区域(hit, state.X, state.Y, endX, endY, cfg.残影斩击宽度)) continue;
        const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.残影斩击伤害攻击力比例, 目标最大生命比例: cfg.残影斩击伤害目标最大生命比例 });
        造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: '亚伦柯斯·旧誓墓碑残影' });
      }
    }
    if (context.当前大型技能 === 旧誓残影技能Key) context.当前大型技能 = undefined;
  });
  context.清理.登记延迟回调('亚伦柯斯-墓碑残影', delayedId);
  return true;
}

export function 启动亚伦柯斯旧誓墓碑(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P2旧誓回响' || context.墓碑机制已启动) return false;
  const cfg = 亚伦柯斯正式设计配置.旧誓墓碑;
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  const centerX = rect != null && rect !== 0 ? GetRectCenterX(rect) : 亚伦柯斯单位技能配置.正式场地.中心X;
  const centerY = rect != null && rect !== 0 ? GetRectCenterY(rect) : 亚伦柯斯单位技能配置.正式场地.中心Y;
  const facings = [90, 210, 330];
  const now = getServerTime();
  context.墓碑机制已启动 = true;
  context.已安魂墓碑数量 = 0;
  context.未安魂墓碑数量 = cfg.数量;
  context.墓碑状态列表 = [];
  for (let i = 0; i < cfg.数量 && i < facings.length; i++) {
    const x = centerX + CosBJ(facings[i]) * cfg.场地中心偏移半径;
    const y = centerY + SinBJ(facings[i]) * cfg.场地中心偏移半径;
    const state: 旧誓墓碑状态 = {
      X: x,
      Y: y,
      安魂进度秒: 0,
      已安魂: false,
      墓碑特效: AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.誓约墓碑模型路径, x, y),
      范围特效: AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.墓碑安魂范围特效路径, x, y),
      下次残影Ms: now + cfg.残影斩击间隔秒 * 1000,
    };
    context.墓碑状态列表.push(state);
  }
  context.清理.登记清理('亚伦柯斯-旧誓墓碑统一清理', function 亚伦柯斯墓碑统一清理(this: void): void {
    清理墓碑列表(context);
  });
  刷新旧誓加护Buff(context);
  播放亚伦柯斯台词(boss, '旧誓墓碑');

  let periodicId = 0;
  periodicId = addPeriodicCallback(cfg.检查间隔秒 * 1000, function 亚伦柯斯墓碑推进(this: void): void {
    if (context.战斗已结束 || context.阶段 !== 'P2旧誓回响') {
      if (periodicId !== 0) removePeriodicCallback(periodicId);
      periodicId = 0;
      return;
    }
    const current = getServerTime();
    for (let i = 0; i < context.墓碑状态列表.length; i++) {
      const state = context.墓碑状态列表[i] as 旧誓墓碑状态;
      if (state.已安魂) continue;
      if (范围内存在玩家(context, state)) state.安魂进度秒 += cfg.检查间隔秒;
      else {
        state.安魂进度秒 -= cfg.离开每次回退秒;
        if (state.安魂进度秒 < 0) state.安魂进度秒 = 0;
      }
      if (state.安魂进度秒 >= cfg.安魂持续秒) {
        完成墓碑安魂(context, state);
        continue;
      }
      if (current >= state.下次残影Ms && 尝试释放墓碑残影(context, state, current)) break;
    }
  });
  context.清理.登记周期回调('亚伦柯斯-旧誓墓碑推进', periodicId);
  return true;
}

export const 旧誓墓碑机制状态 = {
  类型: 'P2阶段机制',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '固定生成三座不可攻击的誓约墓碑，玩家连续站入完成安魂；未安魂层数同步减伤Buff并锁定35%最低生命。',
  实现要求: '安魂进度、残影斩击、减伤层数和阶段血量锁统一挂入运行时清理篮子。',
} as const;
