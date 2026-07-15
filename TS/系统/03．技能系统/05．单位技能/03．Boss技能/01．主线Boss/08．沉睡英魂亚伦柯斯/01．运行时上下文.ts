/** @noSelfInFile */

import { 亚伦柯斯单位技能配置 } from './00．配置';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 创建机制清理篮子, type 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建单位运行时上下文工厂 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 创建伤害生命下限保护 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';

const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { registerDeathListener } = require('系统.00．核心系统.01．事件中心.07．单位死亡事件中心') as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { SGSS_SetState } = require('lib.扩展函数.Star扩展函数.00．SGSS') as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};

const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 攻击力属性ID = 1;
const 攻速属性ID = 10;
const 亚伦柯斯单位类型ID = stringToFourCC(亚伦柯斯单位技能配置.单位ID);

export type 亚伦柯斯阶段 = '未启动' | 'P1守墓者苏醒' | 'P2旧誓回响' | 'P3最后的誓约' | '战败归静' | '已结束';

export interface 亚伦柯斯运行时上下文 {
  Boss单位: any;
  阶段: 亚伦柯斯阶段;
  开战时间Ms: number;
  上次阶段变化Ms: number;
  普通机制忙碌到Ms: number;
  当前大型技能?: string;
  已安魂墓碑数量: number;
  未安魂墓碑数量: number;
  墓碑机制已启动: boolean;
  墓碑状态列表: any[];
  不灭军魂已启用: boolean;
  已触发最终强化: boolean;
  最终强化攻击力增量: number;
  最终强化攻速增量: number;
  战斗已结束: boolean;
  已初始化: boolean;
  清理: 机制清理篮子;
}

let 亚伦柯斯运行时已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 创建上下文(this: void, boss: any, 清理: 机制清理篮子): 亚伦柯斯运行时上下文 {
  const now = getServerTime();
  const context: 亚伦柯斯运行时上下文 = {
    Boss单位: boss,
    阶段: 'P1守墓者苏醒',
    开战时间Ms: now,
    上次阶段变化Ms: now,
    普通机制忙碌到Ms: now + 1800,
    已安魂墓碑数量: 0,
    未安魂墓碑数量: 0,
    墓碑机制已启动: false,
    墓碑状态列表: [],
    不灭军魂已启用: false,
    已触发最终强化: false,
    最终强化攻击力增量: 0,
    最终强化攻速增量: 0,
    战斗已结束: false,
    已初始化: true,
    清理,
  };
  const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.开战苏醒特效路径, GetUnitX(boss), GetUnitY(boss));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(2, effect);
  创建伤害生命下限保护({
    名称: '亚伦柯斯-P2墓碑锁血',
    单位: boss,
    最大生命比例下限: 亚伦柯斯正式设计配置.旧誓墓碑.P2最低生命比例,
    修正优先级: -80,
    清理,
    过滤伤害: function 亚伦柯斯墓碑锁血过滤(this: void): boolean {
      return !context.战斗已结束 && context.阶段 === 'P2旧誓回响' && context.未安魂墓碑数量 > 0;
    },
    伤害预处理: function 亚伦柯斯墓碑减伤(this: void, _damage: any, current: number): number {
      const result = current * (1 - context.未安魂墓碑数量 * 亚伦柯斯正式设计配置.旧誓墓碑.未安魂减伤每层);
      return result > 0 ? result : 0;
    },
  });
  播放亚伦柯斯台词(boss, '开场');
  return context;
}

/** 独立测试可显式创建；正式战斗使用上下文工厂。 */
export function 创建亚伦柯斯运行时上下文(this: void, boss: any): 亚伦柯斯运行时上下文 {
  return 创建上下文(boss, 创建机制清理篮子('亚伦柯斯测试上下文'));
}

const 亚伦柯斯上下文工厂 = 创建单位运行时上下文工厂<亚伦柯斯运行时上下文>({
  名称: '沉睡英魂·亚伦柯斯',
  主动技能提示: 亚伦柯斯单位技能配置.主动技能提示,
  创建上下文,
  on清理: function 亚伦柯斯上下文清理(this: void, context: 亚伦柯斯运行时上下文): void {
    context.战斗已结束 = true;
    context.阶段 = '已结束';
    context.当前大型技能 = undefined;
    if (单位有效(context.Boss单位)) {
      if (context.最终强化攻击力增量 !== 0) SGSS_SetState(context.Boss单位, 攻击力属性ID, -context.最终强化攻击力增量);
      if (context.最终强化攻速增量 !== 0) SGSS_SetState(context.Boss单位, 攻速属性ID, -context.最终强化攻速增量);
    }
    context.最终强化攻击力增量 = 0;
    context.最终强化攻速增量 = 0;
    context.墓碑状态列表 = [];
  },
});

export function 获取亚伦柯斯运行时上下文(this: void, boss: any): 亚伦柯斯运行时上下文 | undefined {
  return 亚伦柯斯上下文工厂.获取(boss);
}

export function 获取或创建亚伦柯斯运行时上下文(this: void, boss: any): 亚伦柯斯运行时上下文 | undefined {
  return 亚伦柯斯上下文工厂.获取或创建(boss);
}

export function 获取全部亚伦柯斯运行时上下文(this: void): 亚伦柯斯运行时上下文[] {
  return 亚伦柯斯上下文工厂.获取全部();
}

export function 清理亚伦柯斯运行时上下文(this: void, boss: any): void {
  亚伦柯斯上下文工厂.清理上下文(boss);
}

export function 进入亚伦柯斯P3(this: void, context: 亚伦柯斯运行时上下文): void {
  if (context.战斗已结束 || context.阶段 !== 'P2旧誓回响' || context.未安魂墓碑数量 > 0) return;
  context.阶段 = 'P3最后的誓约';
  context.上次阶段变化Ms = getServerTime();
  context.普通机制忙碌到Ms = context.上次阶段变化Ms + 1800;
  context.当前大型技能 = undefined;
  播放亚伦柯斯台词(context.Boss单位, '记忆恢复');
  const delayedId = addDelayedCallback(1800, function 亚伦柯斯P3宣言(this: void): void {
    if (!context.战斗已结束 && context.阶段 === 'P3最后的誓约') 播放亚伦柯斯台词(context.Boss单位, '转阶段3最后誓约');
  });
  context.清理.登记延迟回调('亚伦柯斯-P3宣言', delayedId);
}

function 推进亚伦柯斯运行时(this: void, context: 亚伦柯斯运行时上下文, now: number): void {
  if (!单位有效(context.Boss单位) || context.战斗已结束) return;
  const maxLife = GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return;
  const ratio = GetUnitState(context.Boss单位, UNIT_STATE_LIFE) / maxLife;
  if (context.阶段 === 'P1守墓者苏醒' && ratio <= 亚伦柯斯正式设计配置.阶段阈值.P2生命比例) {
    context.阶段 = 'P2旧誓回响';
    context.上次阶段变化Ms = now;
    context.普通机制忙碌到Ms = now + 1500;
    context.当前大型技能 = '旧誓回响转阶段';
    context.未安魂墓碑数量 = 亚伦柯斯正式设计配置.旧誓墓碑.数量;
    播放亚伦柯斯台词(context.Boss单位, '转阶段2旧誓回响');
    const delayedId = addDelayedCallback(1500, function 亚伦柯斯P2转阶段结束(this: void): void {
      if (context.当前大型技能 === '旧誓回响转阶段') context.当前大型技能 = undefined;
    });
    context.清理.登记延迟回调('亚伦柯斯-P2转阶段结束', delayedId);
  }
}

function on亚伦柯斯死亡(this: void, dyingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) !== 亚伦柯斯单位类型ID) return;
  const context = 获取亚伦柯斯运行时上下文(dyingUnit);
  if (context == null || context.战斗已结束) return;
  context.战斗已结束 = true;
  context.阶段 = '战败归静';
  context.当前大型技能 = undefined;
  播放亚伦柯斯台词(dyingUnit, '战败');
  const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.战败归静特效路径, GetUnitX(dyingUnit), GetUnitY(dyingUnit));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(2.6, effect);
  const delayedId = addDelayedCallback(2300, function 亚伦柯斯战败归静完成(this: void): void {
    SetUnitVertexColor(dyingUnit, 255, 255, 255, 0);
    清理亚伦柯斯运行时上下文(dyingUnit);
  });
  context.清理.登记延迟回调('亚伦柯斯-战败归静', delayedId);
}

export function 注册亚伦柯斯运行时(this: void): void {
  if (亚伦柯斯运行时已注册) return;
  亚伦柯斯运行时已注册 = true;
  registerDeathListener(on亚伦柯斯死亡);
  创建周期机制调度器({
    名称: '亚伦柯斯-运行时阶段刷新',
    间隔毫秒: 200,
    取当前时间: getServerTime,
    取上下文列表: 获取全部亚伦柯斯运行时上下文,
    执行: 推进亚伦柯斯运行时,
  });
}
