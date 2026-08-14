/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 创建固定组合技能执行器, type 固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建延迟阶段 } from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import { 创建固定受击次数机制单位, type 固定受击次数机制单位实例 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/03．固定受击次数机制单位';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 确保单位可设置飞行高度, GetUnitFlyHeight, SetUnitFlyHeight } from '../../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/01．跳跃系统/00．共享';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, source: any, text: string, durationMs: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 设置特效缩放 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};

const jass = require('jass.common') as any;
const japi = require("jass.japi") as any;
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (unit: any, order: string) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, timeScale: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const GetRectMinX = jass.GetRectMinX as (rect: any) => number;
const GetRectMinY = jass.GetRectMinY as (rect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (rect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (rect: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const 血之复生技能Key = '血之复生';
const 血之复生Boss暂停来源 = 'Boss:夏提雅:血之复生';
const 血之复生结晶暂停来源 = 'Boss:夏提雅:血之复生结晶';

interface 复生结晶点 {
  X: number;
  Y: number;
}

export type 夏提雅复生失败回调 = (this: void, context: 夏提雅运行时上下文) => void;

function 取复生结晶受击次数(this: void): number {
  let 玩家人数 = Number(取当前有效玩家人数()) || 1;
  if (玩家人数 < 1) 玩家人数 = 1;
  if (玩家人数 > 5) 玩家人数 = 5;
  return 玩家人数 * 夏提雅数值与表现配置.血之复生.每名玩家受击次数;
}

function 取复生结晶点(this: void, boss: any): 复生结晶点[] {
  const cfg = 夏提雅数值与表现配置.血之复生;
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  if (rect != null && rect !== 0) {
    const inset = cfg.场地边缘内缩;
    return [
      { X: GetRectCenterX(rect), Y: GetRectMaxY(rect) - inset },
      { X: GetRectMinX(rect) + inset, Y: GetRectMinY(rect) + inset },
      { X: GetRectMaxX(rect) - inset, Y: GetRectMinY(rect) + inset },
    ];
  }
  const centerX = GetUnitX(boss);
  const centerY = GetUnitY(boss);
  const radius = cfg.无场地矩形摆放半径;
  const facings = [90, 210, 330];
  const result: 复生结晶点[] = [];
  for (let i = 0; i < facings.length; i++) {
    result.push({ X: centerX + CosBJ(facings[i]) * radius, Y: centerY + SinBJ(facings[i]) * radius });
  }
  return result;
}

function 移动夏提雅到场地中心(this: void, boss: any): void {
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  if (rect != null && rect !== 0) 执行战斗自身传送到坐标(boss, GetRectCenterX(rect), GetRectCenterY(rect));
}

function 播放结晶破裂(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血之复生结晶模型路径, GetUnitX(unit), GetUnitY(unit));
  if (effect != null && effect !== 0) {
    设置特效缩放(effect, 夏提雅数值与表现配置.血之复生.结晶缩放);
    YDWETimerDestroyEffectSafe(0.05, effect);
  }
}

function 播放复生成功特效批次(this: void, boss: any, 持续秒: number): void {
  const cfg = 夏提雅数值与表现配置;
  if (!单位有效(boss) || !(持续秒 > 0)) return;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const weave = AddSpecialEffect(cfg.表现资源.血之复生重构丝流路径, x, y);
  const burst = AddSpecialEffect(cfg.表现资源.血之复生成功爆发路径, x, y);
  if (weave != null && weave !== 0) {
    设置特效缩放(weave, cfg.血之复生.复生成功重构丝流缩放);
    YDWETimerDestroyEffectSafe(持续秒, weave);
  }
  if (burst != null && burst !== 0) {
    设置特效缩放(burst, cfg.血之复生.复生成功爆发缩放);
    YDWETimerDestroyEffectSafe(持续秒, burst);
  }
}

function 登记复生成功特效批次(this: void, context: 夏提雅运行时上下文, boss: any, 延迟秒: number, 持续秒: number, 序号: number): void {
  const delayedId = addDelayedCallback(延迟秒 * 1000, function 夏提雅复生成功特效脉冲(this: void): void {
    if (!单位有效(boss) || context.挑战已结束) return;
    播放复生成功特效批次(boss, 持续秒);
  });
  context.清理.登记延迟回调('夏提雅-复生成功特效-' + String(序号), delayedId);
}

function 播放复生成功表现(this: void, context: 夏提雅运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.血之复生;
  const 总时长 = cfg.复生成功特效持续秒;
  const 间隔 = cfg.复生成功特效间隔秒 > 0 ? cfg.复生成功特效间隔秒 : 总时长;
  if (!(总时长 > 0) || !(间隔 > 0)) return;
  let 已经过秒 = 0;
  let 序号 = 1;
  while (已经过秒 < 总时长) {
    const 剩余秒 = 总时长 - 已经过秒;
    if (已经过秒 === 0) 播放复生成功特效批次(boss, 剩余秒);
    else 登记复生成功特效批次(context, boss, 已经过秒, 剩余秒, 序号);
    已经过秒 += 间隔;
    序号++;
  }
}

function 执行复生成功回血(this: void, context: 夏提雅运行时上下文, boss: any, 恢复量: number): void {
  if (!单位有效(boss) || context.挑战已结束 || !(恢复量 > 0)) return;
  doHeal({
    HealSource: boss,
    HealTarget: boss,
    HealAmount: 恢复量,
    ItemHeal: false,
    HealEffect: false,
  });
}

function 登记复生成功回血(this: void, context: 夏提雅运行时上下文, boss: any, 延迟秒: number, 恢复量: number, 序号: number): void {
  const delayedId = addDelayedCallback(延迟秒 * 1000, function 夏提雅复生成功回血脉冲(this: void): void {
    执行复生成功回血(context, boss, 恢复量);
  });
  context.清理.登记延迟回调('夏提雅-复生成功回血-' + String(序号), delayedId);
}

function 安排复生成功回血(this: void, context: 夏提雅运行时上下文, boss: any, 总恢复量: number): void {
  const 总时长 = 夏提雅数值与表现配置.血之复生.复生成功特效持续秒;
  const 次数 = 4;
  if (!(总恢复量 > 0) || !(总时长 > 0)) return;
  const 单次恢复量 = 总恢复量 / 次数;
  const 间隔秒 = 总时长 / 次数;
  for (let i = 0; i < 次数; i++) {
    const 延迟秒 = i * 间隔秒;
    if (i === 0) 执行复生成功回血(context, boss, 单次恢复量);
    else 登记复生成功回血(context, boss, 延迟秒, 单次恢复量, i + 1);
  }
}

function 恢复夏提雅复生动画速度(this: void, boss: any): void {
  if (boss == null || boss === 0) return;
  SetUnitTimeScale(boss, 1);
}

function 统计存活结晶(this: void, crystals: 固定受击次数机制单位实例[]): number {
  let count = 0;
  for (let i = 0; i < crystals.length; i++) {
    if (crystals[i].是否存活()) count++;
  }
  return count;
}

function 清理复生结晶(this: void, crystals: 固定受击次数机制单位实例[]): void {
  for (let i = 0; i < crystals.length; i++) {
    移除单位暂停(crystals[i].单位, 血之复生结晶暂停来源);
    crystals[i].销毁();
  }
}

interface 血之复生清理状态 {
  Boss单位: any;
  结晶列表: 固定受击次数机制单位实例[];
  恢复复生表现: (this: void) => void;
}

function 清理夏提雅血之复生暂停状态(this: void, variable?: any): void {
  const 状态 = variable as 血之复生清理状态 | undefined;
  if (状态 == null) return;
  状态.恢复复生表现();
  清理复生结晶(状态.结晶列表);
  解除暂停并取消无敌安全(状态.Boss单位, 血之复生Boss暂停来源);
}

function 完成复生成功(this: void, context: 夏提雅运行时上下文, 剩余结晶: number, 恢复复生表现: (this: void) => void): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.血之复生;
  const maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  const 总恢复量 = maxLife * cfg.单枚恢复生命比例 * 剩余结晶;
  播放夏提雅台词(boss, '复生成功');
  安排复生成功回血(context, boss, 总恢复量);
  恢复复生表现();
  播放复生成功表现(context);
  播放Boss坐标音效(夏提雅数值与表现配置.音效.血之复生成功, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
  context.阶段 = 'P3真祖血宴';
  context.上次阶段变化Ms = getServerTime();
  context.普通机制忙碌到Ms = context.上次阶段变化Ms + (cfg.复生成功恢复动作延迟秒 + 1) * 1000;
  const delayedId = addDelayedCallback(cfg.复生成功恢复动作延迟秒 * 1000, function 夏提雅复生成功恢复行动(this: void): void {
    if (!单位有效(boss) || context.挑战已结束 || context.阶段 !== 'P3真祖血宴') return;
    SetUnitAnimationByIndex(boss, 0);
    解除暂停并取消无敌安全(boss, 血之复生Boss暂停来源);
    if (context.当前大型技能 === 血之复生技能Key) context.当前大型技能 = undefined;
  });
  context.清理.登记延迟回调('夏提雅-复生成功恢复行动', delayedId);
}

export function 启动夏提雅血之复生(this: void, context: 夏提雅运行时上下文, on复生失败: 夏提雅复生失败回调): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.挑战已结束 || context.阶段 !== '复生仪式' || context.当前大型技能 !== 血之复生技能Key) return false;
  播放夏提雅台词(boss, '血之复生');
  播放Boss坐标音效(夏提雅数值与表现配置.音效.血之复生仪式, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
  const cfg = 夏提雅数值与表现配置.血之复生;
  let 冻结前飞行高度 = 0;
  let 已应用冻结高度 = false;
  const 恢复复生表现 = function 夏提雅复生恢复表现(this: void): void {
    恢复夏提雅复生动画速度(boss);
    if (!已应用冻结高度 || !单位有效(boss)) return;
    确保单位可设置飞行高度(boss);
    SetUnitFlyHeight(boss, 冻结前飞行高度, 0);
    已应用冻结高度 = false;
  };
  const 应用复生冻结高度 = function 夏提雅复生应用冻结高度(this: void): void {
    if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 !== 血之复生技能Key || 已应用冻结高度) return;
    确保单位可设置飞行高度(boss);
    冻结前飞行高度 = GetUnitFlyHeight(boss);
    SetUnitFlyHeight(boss, 冻结前飞行高度 + cfg.仪式动画冻结高度增加, 0);
    已应用冻结高度 = true;
  };
  const crystals: 固定受击次数机制单位实例[] = [];
  const points = 取复生结晶点(boss);
  const hitCount = 取复生结晶受击次数();
  let executor: 固定组合技能执行器<夏提雅运行时上下文> | undefined;
  let executionId = 0;

  IssueImmediateOrder(boss, 'stop');
  暂停并设置无敌安全(boss, 血之复生Boss暂停来源);
  context.清理.登记清理('夏提雅-血之复生暂停来源', 清理夏提雅血之复生暂停状态, {
    Boss单位: boss,
    结晶列表: crystals,
    恢复复生表现,
  } as 血之复生清理状态);
  移动夏提雅到场地中心(boss);
  重置夏提雅猎血连击(context);
  context.普通机制忙碌到Ms = getServerTime() + cfg.仪式秒 * 1000;

  for (let i = 0; i < cfg.结晶数量 && i < points.length; i++) {
    const point = points[i];
    const crystal = 创建固定受击次数机制单位({
      清理: context.清理,
      名称: '夏提雅-血之复生结晶-' + String(i + 1),
      主人单位: boss,
      所属玩家: GetOwningPlayer(boss),
      单位类型: cfg.结晶单位ID,
      模型路径: 夏提雅数值与表现配置.表现资源.血之复生结晶模型路径,
      X: point.X,
      Y: point.Y,
      最大生命: 999999,
      生命值受小怪倍率: false,
      受击次数: hitCount,
      计数模式: '纯普攻或最终伤害阈值',
      最终伤害计数阈值: cfg.技能伤害计数阈值,
      同步生命条: true,
      缩放: cfg.结晶缩放,
      on击破: function 夏提雅复生结晶击破(this: void, unit: any): void {
        播放结晶破裂(unit);
        移除单位暂停(unit, 血之复生结晶暂停来源);
        const remaining = 统计存活结晶(crystals);
        if (remaining > 0) {
          广播单位提示(
            boss,
            '|cffff99aa复生结晶破碎，剩余' + String(remaining) + '枚；仪式结束时每枚存活结晶使夏提雅恢复' + String(cfg.单枚恢复生命比例 * 100) + '%最大生命。（继续击破剩余结晶，全部摧毁即可阻止复生。）|r',
            3600,
          );
        } else {
          广播单位提示(boss, '|cffff99aa复生结晶已全部摧毁。（' + String(cfg.仪式秒) + '秒仪式将失败，保持输出。）|r', 2400);
        }
        if (remaining === 0 && executionId !== 0) executor?.停止(executionId, '完成');
      },
    });
    if (crystal == null) continue;
    添加单位暂停(crystal.单位, 血之复生结晶暂停来源);
    SetUnitPathing(crystal.单位, false);
    crystals.push(crystal);
  }

  if (crystals.length <= 0) {
    恢复复生表现();
    解除暂停并取消无敌安全(boss, 血之复生Boss暂停来源);
    return false;
  }

  executor = 创建固定组合技能执行器<夏提雅运行时上下文>({ 名称: '夏提雅-血之复生', 清理: context.清理, 互斥组: '夏提雅大型技能' });
  executionId = executor.开始({
    key: 血之复生技能Key,
    单位: boss,
    上下文: context,
    阶段列表: [创建延迟阶段(cfg.仪式秒 * 1000, '复生仪式倒计时')],
    最大持续毫秒: (cfg.仪式秒 + 1) * 1000,
    结束回调: function 夏提雅血之复生结束(this: void, event): void {
      关闭吟唱条('大招');
      if (event.原因 !== '完成' || context.挑战已结束) {
        恢复复生表现();
        清理复生结晶(crystals);
        解除暂停并取消无敌安全(boss, 血之复生Boss暂停来源);
        return;
      }
      const remaining = 统计存活结晶(crystals);
      清理复生结晶(crystals);
      if (remaining <= 0) {
        恢复复生表现();
        解除暂停并取消无敌安全(boss, 血之复生Boss暂停来源);
        播放夏提雅台词(boss, '复生失败');
        播放Boss坐标音效(夏提雅数值与表现配置.音效.血之复生失败, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
        on复生失败(context);
        return;
      }
      完成复生成功(context, remaining, 恢复复生表现);
    },
  });
  if (executionId === 0) {
    恢复复生表现();
    清理复生结晶(crystals);
    解除暂停并取消无敌安全(boss, 血之复生Boss暂停来源);
    return false;
  }

  播放限时单位动画({ 单位: boss, 动画编号: cfg.仪式动画编号, 持续秒: cfg.仪式秒, 恢复动画编号: 0 });
  const 抬高延迟秒 = cfg.仪式动画冻结秒 - cfg.仪式动画冻结高度提前秒;
  const 抬高动画ID = addDelayedCallback((抬高延迟秒 > 0 ? 抬高延迟秒 : 0) * 1000, function 夏提雅血之复生提前抬高(this: void): void {
    应用复生冻结高度();
  });
  context.清理.登记延迟回调('夏提雅-血之复生提前抬高', 抬高动画ID);
  const 冻结动画ID = addDelayedCallback(cfg.仪式动画冻结秒 * 1000, function 夏提雅血之复生冻结施法动画(this: void): void {
    if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 !== 血之复生技能Key) return;
    应用复生冻结高度();
    SetUnitTimeScale(boss, 0);
  });
  context.清理.登记延迟回调('夏提雅-血之复生冻结施法动画', 冻结动画ID);
  显示大招吟唱条({ 通道: '大招', 总时长: cfg.仪式秒, 颜色ID: 2, 标题文本: '血之复生', 提示文本: String(cfg.仪式秒) + '秒内摧毁' + String(cfg.结晶数量) + '枚复生结晶；每枚存活结晶恢复' + String(cfg.单枚恢复生命比例 * 100) + '%最大生命（全部击破即可阻止复生）' });
  return true;
}

export const 血之复生机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '一次性锁血复生机制',
  语义: '第一次归零后生成三枚复生结晶；每剩一枚恢复10%生命，全部摧毁则直接结束挑战。',
  实现要求: '只触发一次，结晶耐久按有效玩家人数调整；公共固定组合时间轴负责12秒仪式，公共机制单位负责受击次数与统一清理。',
} as const;
