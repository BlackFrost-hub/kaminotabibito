/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 创建雅儿贝德运行状态, type 雅儿贝德运行状态 } from './01．护卫雅儿贝德/00．状态';
import type { 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import type { 伤害生命下限保护控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
import { 播放安兹台词 } from './12．台词播放';

const jass = require('jass.common') as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 处理Boss结束全部护卫 } = require('系统.01．单位系统.10．护卫系统.index') as {
  处理Boss结束全部护卫: (this: void, boss: any) => void;
};

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export type 安兹挑战模式 = '至尊的试炼' | '守护者介入';
export type 安兹阶段 = '未启动' | 'P1至尊的审视' | 'P2死亡支配者' | 'P3死亡是众生的终点' | '挑战收束' | '已结束';

export interface 安兹运行时上下文 {
  安兹单位: any;
  雅儿贝德?: 雅儿贝德运行状态;
  模式: 安兹挑战模式;
  阶段: 安兹阶段;
  开战时间Ms: number;
  上次阶段变化Ms: number;
  普通机制忙碌到Ms: number;
  上次大型技能结束Ms: number;
  当前大型技能?: string;
  时间停止中: boolean;
  高阶亡灵召唤物?: any;
  亡灵箭削弱到Ms: number;
  天空坠落已释放: boolean;
  一切生命的终点已释放: boolean;
  终阶段预告已播放: boolean;
  至尊宣言已播放: boolean;
  挑战已结束: boolean;
  挑战生命下限保护?: 伤害生命下限保护控制器;
  已初始化: boolean;
  清理: 机制清理篮子;
}

let 安兹运行时已注册 = false;

function 创建安兹上下文(
  this: void,
  boss: any,
  清理: 机制清理篮子,
  模式: 安兹挑战模式,
): 安兹运行时上下文 {
  const nowMs = getServerTime();
  const context: 安兹运行时上下文 = {
    安兹单位: boss,
    模式,
    阶段: 'P1至尊的审视',
    开战时间Ms: nowMs,
    上次阶段变化Ms: nowMs,
    普通机制忙碌到Ms: 0,
    上次大型技能结束Ms: 0,
    时间停止中: false,
    亡灵箭削弱到Ms: 0,
    天空坠落已释放: false,
    一切生命的终点已释放: false,
    终阶段预告已播放: false,
    至尊宣言已播放: false,
    挑战已结束: false,
    已初始化: true,
    清理,
  };
  if (单位有效(boss)) {
    播放安兹台词(boss, '登场');
    const battleStartId = addDelayedCallback(安兹乌尔恭单位技能配置.开场台词时间.战斗开始延迟Ms, function 安兹战斗开始台词(this: void): void {
      if (单位有效(boss) && !context.挑战已结束) 播放安兹台词(boss, '战斗开始');
    });
    清理.登记延迟回调('安兹-战斗开始台词', battleStartId);
    if (模式 === '守护者介入') {
      const guardianId = addDelayedCallback(安兹乌尔恭单位技能配置.开场台词时间.守护者命令延迟Ms, function 安兹守护者命令台词(this: void): void {
        if (单位有效(boss) && !context.挑战已结束) 播放安兹台词(boss, '守护者命令');
      });
      清理.登记延迟回调('安兹-守护者命令台词', guardianId);
    }
  }
  return context;
}

export function 创建安兹运行时上下文(
  this: void,
  模式: 安兹挑战模式,
  boss?: any,
): 安兹运行时上下文 {
  return 创建安兹上下文(boss, 创建机制清理篮子('安兹·乌尔·恭'), 模式);
}

const 安兹上下文工厂 = 创建单位运行时上下文工厂<安兹运行时上下文>({
  名称: '安兹·乌尔·恭',
  创建上下文: function 创建安兹Boss上下文(this: void, boss: any, 清理: 机制清理篮子): 安兹运行时上下文 {
    return 创建安兹上下文(boss, 清理, '守护者介入');
  },
  on清理: function 清理安兹联合状态(this: void, context: 安兹运行时上下文): void {
    context.挑战已结束 = true;
    context.阶段 = '已结束';
    处理Boss结束全部护卫(context.安兹单位);
    if (context.雅儿贝德 != null) {
      context.雅儿贝德.守护连接生效 = false;
      context.雅儿贝德.共同护盾生效 = false;
      context.雅儿贝德.阶段状态 = '已离场';
    }
  },
});

export function 获取安兹运行时上下文(this: void, boss: any): 安兹运行时上下文 | undefined {
  return 安兹上下文工厂.获取(boss);
}

export function 获取全部安兹运行时上下文(this: void): 安兹运行时上下文[] {
  return 安兹上下文工厂.获取全部();
}

export function 标记安兹普通机制忙碌(this: void, context: 安兹运行时上下文, durationSeconds: number): void {
  const untilMs = getServerTime() + durationSeconds * 1000;
  if (untilMs > context.普通机制忙碌到Ms) context.普通机制忙碌到Ms = untilMs;
}

export function 获取或创建安兹运行时上下文(this: void, boss: any): 安兹运行时上下文 | undefined {
  return 安兹上下文工厂.获取或创建(boss);
}

export function 清理安兹运行时上下文(this: void, boss: any): void {
  安兹上下文工厂.清理上下文(boss);
}

export function 绑定雅儿贝德到安兹上下文(this: void, boss: any, albedo: any): boolean {
  if (!单位有效(boss) || !单位有效(albedo)) return false;
  const context = 获取或创建安兹运行时上下文(boss);
  if (context == null || context.挑战已结束) return false;
  context.雅儿贝德 = 创建雅儿贝德运行状态(albedo);
  context.模式 = '守护者介入';
  return true;
}

function 刷新安兹阶段(this: void, context: 安兹运行时上下文): void {
  if (context.挑战已结束 || context.阶段 === '挑战收束' || context.阶段 === '已结束') return;
  const maxLife = GetUnitStateJapi(context.安兹单位, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(context.安兹单位, UNIT_STATE_LIFE) / maxLife;
  if (!context.终阶段预告已播放 && ratio <= 安兹乌尔恭单位技能配置.阶段阈值.P3预告生命比例) {
    const 尚未进入P3 = ratio > 安兹乌尔恭单位技能配置.阶段阈值.P3生命比例;
    const P3大招已经结束 = context.一切生命的终点已释放 && context.当前大型技能 == null;
    if (尚未进入P3 || P3大招已经结束) {
      context.终阶段预告已播放 = true;
      播放安兹台词(context.安兹单位, '进入P3');
    }
  }
  if (!context.至尊宣言已播放
    && ratio <= 安兹乌尔恭单位技能配置.阶段阈值.至尊宣言生命比例
    && context.一切生命的终点已释放
    && context.当前大型技能 == null) {
    context.至尊宣言已播放 = true;
    播放安兹台词(context.安兹单位, '至尊宣言');
  }
  let nextStage = context.阶段;
  if (ratio <= 安兹乌尔恭单位技能配置.阶段阈值.P3生命比例) {
    nextStage = 'P3死亡是众生的终点';
  } else if (ratio <= 安兹乌尔恭单位技能配置.阶段阈值.P2生命比例) {
    nextStage = 'P2死亡支配者';
  }
  if (nextStage !== context.阶段) {
    context.阶段 = nextStage;
    context.上次阶段变化Ms = getServerTime();
    if (nextStage === 'P2死亡支配者') 播放安兹台词(context.安兹单位, '进入P2');
  }
}

function 推进安兹运行时(this: void, context: 安兹运行时上下文): void {
  if (!单位有效(context.安兹单位)) {
    清理安兹运行时上下文(context.安兹单位);
    return;
  }
  刷新安兹阶段(context);
}

export function 注册安兹运行时(this: void): void {
  if (安兹运行时已注册) return;
  安兹运行时已注册 = true;
  创建周期机制调度器({
    名称: '安兹-运行时阶段刷新',
    间隔毫秒: 250,
    取上下文列表: 获取全部安兹运行时上下文,
    执行: 推进安兹运行时,
  });
}
