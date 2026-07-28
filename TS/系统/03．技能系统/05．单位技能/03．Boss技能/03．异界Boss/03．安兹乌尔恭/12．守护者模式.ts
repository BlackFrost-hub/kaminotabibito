/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 单位间距离平方 as 两单位距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 雅儿贝德技能状态 } from './01．护卫雅儿贝德/index';
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取全部安兹运行时上下文, 绑定雅儿贝德到安兹上下文 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建联合战斗成员生命周期 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/20．联合战斗成员生命周期';
import { 创建可抢占独占状态管理器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/19．可抢占独占状态';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 推进雅儿贝德技能驱动 } from './01．护卫雅儿贝德/07．技能驱动';
import { 注册雅儿贝德至尊拦截 } from './01．护卫雅儿贝德/01．至尊拦截';
import { 注册雅儿贝德守护者之职责 } from './01．护卫雅儿贝德/03．守护者之职责';

const { 创建召唤物 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index') as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { 创建自定义护卫单位, 处理Boss结束全部护卫 } = require('系统.01．单位系统.10．护卫系统.index') as {
  创建自定义护卫单位: (this: void, 参数: any, 创建器: (this: void) => any) => any;
  处理Boss结束全部护卫: (this: void, boss: any) => void;
};
const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DEG_TO_RAD = 0.017453292519943295;

let 雅儿贝德伤害修正已注册 = false;
let 雅儿贝德运行时驱动已注册 = false;

function 查找联合上下文(this: void, unit: any): 安兹运行时上下文 | undefined {
  const contexts = 获取全部安兹运行时上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (context.安兹单位 === unit || context.雅儿贝德?.单位 === unit) return context;
  }
  return undefined;
}

function 雅儿贝德联合伤害修正(this: void, damage: any): number {
  const context = 查找联合上下文(damage.target);
  if (context == null || context.模式 !== '守护者介入' || context.雅儿贝德 == null) return damage.currentDamage;
  const albedo = context.雅儿贝德.单位;
  if (!单位有效(albedo)) return damage.currentDamage;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  if (damage.target === albedo) {
    const maxLife = GetUnitState(albedo, UNIT_STATE_MAX_LIFE);
    const minimumLife = maxLife * cfg.雅儿贝德锁血比例;
    const currentLife = GetUnitState(albedo, UNIT_STATE_LIFE);
    const allowed = currentLife - minimumLife;
    if (allowed <= 0) return 0;
    return damage.currentDamage > allowed ? allowed : damage.currentDamage;
  }
  if (damage.target !== context.安兹单位 || context.当前大型技能 != null) return damage.currentDamage;
  if (context.雅儿贝德.阶段状态 === '失衡' || context.雅儿贝德.阶段状态 === '已离场') return damage.currentDamage;
  const radius = cfg.护卫减伤有效距离;
  if (两单位距离平方(context.安兹单位, albedo) > radius * radius) return damage.currentDamage;
  const reduction = context.雅儿贝德.当前生命比例 < cfg.雅儿贝德狂怒阈值
    ? cfg.低血护卫减伤
    : cfg.常驻护卫减伤;
  return damage.currentDamage * (1 - reduction);
}

function 确保雅儿贝德伤害修正(this: void): void {
  if (雅儿贝德伤害修正已注册) return;
  雅儿贝德伤害修正已注册 = true;
  registerDamageModifier(雅儿贝德联合伤害修正, 55);
}

function 确保雅儿贝德运行时驱动(this: void): void {
  if (雅儿贝德运行时驱动已注册) return;
  雅儿贝德运行时驱动已注册 = true;
  创建周期机制调度器({
    名称: '安兹-雅儿贝德守护模式',
    间隔毫秒: 250,
    取上下文列表: 获取全部安兹运行时上下文,
    执行: 推进安兹守护者模式,
  });
}

function 创建雅儿贝德单位(this: void, context: 安兹运行时上下文): any {
  const boss = context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const facing = GetUnitFacing(boss);
  const angle = (facing + 90) * DEG_TO_RAD;
  return 创建自定义护卫单位({
    主Boss单位: boss,
    护卫类型: '安兹乌尔恭:雅儿贝德',
    护卫血条优先级: 300,
    标记为召唤单位: true,
    Boss结束处理: '移除',
  }, function 创建雅儿贝德召唤物(this: void): any {
    return 创建召唤物({
      主人单位: boss,
      所属玩家: GetOwningPlayer(boss),
      单位类型: 安兹乌尔恭单位技能配置.护卫.正式单位ID,
      单位名称: 安兹乌尔恭单位技能配置.护卫.单位名称,
      模型路径: 安兹乌尔恭单位技能配置.护卫.模型路径,
      X: GetUnitX(boss) + Cos(angle) * cfg.雅儿贝德出生距离,
      Y: GetUnitY(boss) + Sin(angle) * cfg.雅儿贝德出生距离,
      朝向: facing,
      生命值: GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.雅儿贝德生命比例,
      生命值受小怪倍率: false,
      攻击力: 读取单位攻击力(boss) * cfg.雅儿贝德攻击比例,
      攻击间隔: cfg.雅儿贝德攻击间隔,
      攻击范围: cfg.雅儿贝德攻击范围,
      索敌范围: cfg.雅儿贝德索敌范围,
      护甲: cfg.雅儿贝德护甲,
    });
  });
}

export function 启动安兹守护者模式(this: void, context: 安兹运行时上下文): boolean {
  if (!单位有效(context.安兹单位) || context.挑战已结束) return false;
  if (context.雅儿贝德?.已初始化 === true && context.雅儿贝德.成员生命周期 != null) return true;
  let albedo = context.雅儿贝德?.单位;
  if (!单位有效(albedo)) albedo = 创建雅儿贝德单位(context);
  if (!单位有效(albedo) || !绑定雅儿贝德到安兹上下文(context.安兹单位, albedo)) return false;
  context.模式 = '守护者介入';
  const state = context.雅儿贝德;
  if (state == null) return false;
  state.成员生命周期 = 创建联合战斗成员生命周期({
    名称: '安兹与雅儿贝德联合挑战',
    清理: context.清理,
    成员列表: [{
      key: '安兹',
      单位: context.安兹单位,
      角色: '主目标',
      初始状态: '活跃',
      参与最终结算: true,
      最终状态列表: ['离场'],
    }, {
      key: '雅儿贝德',
      单位: albedo,
      角色: '护卫',
      初始状态: '活跃',
      参与最终结算: false,
    }],
  });
  state.独占状态 = 创建可抢占独占状态管理器({
    名称: '安兹与雅儿贝德联合技能独占',
    清理: context.清理,
  });
  const boss = context.安兹单位;
  context.清理.登记清理('雅儿贝德护卫单位', function 清理雅儿贝德护卫单位(this: void): void {
    处理Boss结束全部护卫(boss);
  });
  确保雅儿贝德伤害修正();
  确保雅儿贝德运行时驱动();
  注册雅儿贝德至尊拦截();
  注册雅儿贝德守护者之职责();
  return true;
}

export function 推进安兹守护者模式(this: void, context: 安兹运行时上下文): void {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const maxLife = GetUnitState(albedo, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const minimumLife = maxLife * cfg.雅儿贝德锁血比例;
  let life = GetUnitState(albedo, UNIT_STATE_LIFE);
  if (life < minimumLife) {
    SetUnitState(albedo, UNIT_STATE_LIFE, minimumLife);
    life = minimumLife;
  }
  const now = getServerTime();
  state.当前生命比例 = life / maxLife;
  if (state.阶段状态 === '失衡' && now >= state.失衡结束Ms) {
    state.阶段状态 = state.当前生命比例 < cfg.雅儿贝德狂怒阈值 ? '狂怒护卫' : '正常护卫';
    state.成员生命周期?.设置状态('雅儿贝德', '活跃', '失衡结束');
  }
  if (state.阶段状态 !== '失衡' && state.当前生命比例 <= state.下一个失衡生命比例
    && state.下一个失衡生命比例 > cfg.雅儿贝德锁血比例) {
    state.阶段状态 = '失衡';
    state.失衡结束Ms = now + cfg.雅儿贝德失衡持续秒 * 1000;
    state.下一个失衡生命比例 -= cfg.雅儿贝德失衡生命步进;
    state.成员生命周期?.设置状态('雅儿贝德', '失衡', '累计损失20%最大生命');
  } else if (state.阶段状态 !== '失衡') {
    state.阶段状态 = state.当前生命比例 < cfg.雅儿贝德狂怒阈值 ? '狂怒护卫' : '正常护卫';
  }
  推进雅儿贝德技能驱动(context);
}

export const 安兹守护者模式状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  护卫技能: 雅儿贝德技能状态,
  语义: '雅儿贝德作为长期护卫介入，玩家通过压低护卫生命换取安兹减伤下降与阶段大招更易破解。',
  实现要求: '基础成员生命周期、锁血、失衡与护卫减伤已接入；主动技能和大招联动由护卫子目录继续实现。',
} as const;
