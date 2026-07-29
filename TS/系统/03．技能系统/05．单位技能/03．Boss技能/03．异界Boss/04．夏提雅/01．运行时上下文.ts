/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 夏提雅单位技能配置 } from './00．配置';
import { 创建机制清理篮子, type 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 单位是否处于硬控制效果合集 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 创建Buff层数状态, type Buff层数状态控制器 } from '../../../../00．技能模板+函数/04．机制组件/01．层数状态/06．Buff层数状态';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 夏提雅BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/03．异界Boss/02．夏提雅';
import type { 伤害生命下限保护控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
import type { 固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 播放夏提雅台词 } from './18．台词播放';

const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const jass = require('jass.common') as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const { SGSS_SetState } = require('lib.扩展函数.Star扩展函数.00．SGSS') as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const 攻速属性ID = 10;

export type 夏提雅阶段 = '未启动' | 'P1鲜血女武神' | 'P2英灵战乙女' | 'P3真祖血宴' | '复生仪式' | '挑战收束' | '已结束';

export interface 夏提雅运行时上下文 {
  Boss单位: any;
  阶段: 夏提雅阶段;
  开战时间Ms: number;
  上次阶段变化Ms: number;
  普通机制忙碌到Ms: number;
  当前猎血目标?: any;
  当前猎血段数: number;
  猎血段数过期时间Ms: number;
  待结算强化穿刺目标?: any;
  血印句柄列表: any[];
  血之狂热控制器: Buff层数状态控制器;
  血宴层数: number;
  P3转阶段已处理: boolean;
  血宴攻速增量: number;
  英灵战乙女句柄?: any;
  英灵战乙女已登场: boolean;
  英灵复刻冷却到Ms: number;
  上次英灵复刻技能: string;
  镜像夹击句柄?: any;
  已触发复生: boolean;
  血月终舞已释放: boolean;
  上次净化投枪目标ID: number;
  血月轮舞组合执行器?: 固定组合技能执行器<夏提雅运行时上下文>;
  当前大型技能?: string;
  挑战已结束: boolean;
  挑战生命下限保护?: 伤害生命下限保护控制器;
  已初始化: boolean;
  清理: 机制清理篮子;
}

let 夏提雅运行时已注册 = false;

function 创建上下文(this: void, boss: any, 清理: 机制清理篮子): 夏提雅运行时上下文 {
  const now = getServerTime();
  const context: 夏提雅运行时上下文 = {
    Boss单位: boss,
    阶段: 'P1鲜血女武神',
    开战时间Ms: now,
    上次阶段变化Ms: now,
    普通机制忙碌到Ms: 0,
    当前猎血段数: 0,
    猎血段数过期时间Ms: 0,
    血印句柄列表: [],
    血之狂热控制器: undefined as unknown as Buff层数状态控制器,
    血宴层数: 0,
    P3转阶段已处理: false,
    血宴攻速增量: 0,
    英灵战乙女已登场: false,
    英灵复刻冷却到Ms: 0,
    上次英灵复刻技能: '',
    已触发复生: false,
    血月终舞已释放: false,
    上次净化投枪目标ID: 0,
    挑战已结束: false,
    已初始化: true,
    清理,
  };
  const frenzy = 夏提雅数值与表现配置.鲜血印记;
  context.血之狂热控制器 = 创建Buff层数状态({
    名称: '夏提雅-血之狂热',
    清理,
    BuffID: 夏提雅BuffID.血之狂热,
    Buff持续秒: frenzy.血之狂热持续秒,
    层数配置: {
      状态ID: '夏提雅-血之狂热',
      最大层数: 3,
      衰减: {
        等待秒: frenzy.血之狂热持续秒,
        间隔秒: frenzy.血之狂热持续秒,
        每次减少层数: 3,
      },
      on层数变化: function 夏提雅血之狂热层数变化(this: void, event): void {
        const delta = (event.新层数 - event.旧层数) * frenzy.血之狂热每层攻击速度提高;
        if (delta !== 0 && 单位有效(event.单位)) SGSS_SetState(event.单位, 攻速属性ID, delta);
      },
    },
    取Buff显示值: function 取血之狂热攻速显示(this: void, _unit: any, layers: number): number {
      return layers * frenzy.血之狂热每层攻击速度提高 * 100;
    },
    取Buff附加参数: function 取血之狂热附加显示(this: void, _unit: any, layers: number): any {
      return {
        stack: layers,
        effect2: layers * frenzy.血之狂热每层技能冷却恢复提高 * 100,
        sourceName: '夏提雅-鲜血回收',
      };
    },
  });
  if (单位有效(boss)) {
    播放夏提雅台词(boss, '登场');
    const battleStartId = addDelayedCallback(夏提雅单位技能配置.开场台词时间.战斗开始延迟Ms, function 夏提雅战斗开始台词(this: void): void {
      if (单位有效(boss) && !context.挑战已结束) 播放夏提雅台词(boss, '战斗开始');
    });
    清理.登记延迟回调('夏提雅-战斗开始台词', battleStartId);
  }
  return context;
}

/** 独立测试可显式创建；正式战斗使用上下文工厂。 */
export function 创建夏提雅运行时上下文(this: void, boss?: any): 夏提雅运行时上下文 {
  return 创建上下文(boss, 创建机制清理篮子('夏提雅·布拉德弗伦测试上下文'));
}

const 夏提雅上下文工厂 = 创建单位运行时上下文工厂<夏提雅运行时上下文>({
  名称: '夏提雅·布拉德弗伦',
  创建上下文,
  on清理: function 夏提雅上下文清理(this: void, context: 夏提雅运行时上下文): void {
    context.挑战已结束 = true;
    context.阶段 = '已结束';
    context.当前大型技能 = undefined;
    context.待结算强化穿刺目标 = undefined;
    if (context.血宴攻速增量 !== 0 && 单位有效(context.Boss单位)) {
      SGSS_SetState(context.Boss单位, 攻速属性ID, -context.血宴攻速增量);
      context.血宴攻速增量 = 0;
    }
    if (单位有效(context.Boss单位)) 移除单位指定Buff(context.Boss单位, 夏提雅BuffID.真祖血宴);
    if (单位有效(context.英灵战乙女句柄)) RemoveUnit(context.英灵战乙女句柄);
    if (单位有效(context.镜像夹击句柄)) RemoveUnit(context.镜像夹击句柄);
    context.英灵战乙女句柄 = undefined;
    context.镜像夹击句柄 = undefined;
    context.血印句柄列表 = [];
  },
});

export function 获取夏提雅运行时上下文(this: void, boss: any): 夏提雅运行时上下文 | undefined {
  return 夏提雅上下文工厂.获取(boss);
}

export function 获取或创建夏提雅运行时上下文(this: void, boss: any): 夏提雅运行时上下文 | undefined {
  return 夏提雅上下文工厂.获取或创建(boss);
}

export function 获取全部夏提雅运行时上下文(this: void): 夏提雅运行时上下文[] {
  return 夏提雅上下文工厂.获取全部();
}

export function 清理夏提雅运行时上下文(this: void, boss: any): void {
  夏提雅上下文工厂.清理上下文(boss);
}

export function 重置夏提雅猎血连击(this: void, context: 夏提雅运行时上下文): void {
  context.当前猎血目标 = undefined;
  context.当前猎血段数 = 0;
  context.猎血段数过期时间Ms = 0;
  context.待结算强化穿刺目标 = undefined;
}

function 刷新阶段(this: void, context: 夏提雅运行时上下文): void {
  if (context.挑战已结束 || context.阶段 === '复生仪式' || context.阶段 === '挑战收束' || context.阶段 === '已结束') return;
  const maxLife = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return;
  const ratio = GetUnitState(context.Boss单位, UNIT_STATE_LIFE) / maxLife;
  let next = context.阶段;
  if (ratio <= 夏提雅单位技能配置.阶段阈值.P3生命比例) next = 'P3真祖血宴';
  else if (ratio <= 夏提雅单位技能配置.阶段阈值.P2生命比例) next = 'P2英灵战乙女';
  if (next === context.阶段) return;
  context.阶段 = next;
  context.上次阶段变化Ms = getServerTime();
  context.当前大型技能 = undefined;
  重置夏提雅猎血连击(context);
  if (next === 'P2英灵战乙女') 播放夏提雅台词(context.Boss单位, '进入P2');
}

function 推进夏提雅运行时(this: void, context: 夏提雅运行时上下文, now: number): void {
  if (!单位有效(context.Boss单位)) {
    清理夏提雅运行时上下文(context.Boss单位);
    return;
  }
  if (context.猎血段数过期时间Ms > 0 && now >= context.猎血段数过期时间Ms) 重置夏提雅猎血连击(context);
  if (context.当前猎血段数 > 0 && 单位是否处于硬控制效果合集(context.Boss单位)) 重置夏提雅猎血连击(context);
  刷新阶段(context);
}

export function 注册夏提雅运行时(this: void): void {
  if (夏提雅运行时已注册) return;
  夏提雅运行时已注册 = true;
  创建周期机制调度器({
    名称: '夏提雅-运行时阶段刷新',
    间隔毫秒: 250,
    取当前时间: getServerTime,
    取上下文列表: 获取全部夏提雅运行时上下文,
    执行: 推进夏提雅运行时,
  });
}
