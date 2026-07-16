/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 清理夏提雅运行时上下文, 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅单位技能配置 } from './00．配置';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 启动夏提雅血之复生 } from './13．血之复生';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 创建伤害生命下限保护 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
const { 主动结束Boss战运行 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动') as {
  主动结束Boss战运行: (this: void, boss: any, options?: any) => boolean;
};
const { 清理Boss自动技能启动上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  清理Boss自动技能启动上下文: (this: void, boss: any) => void;
};
const { 打开Boss死亡首领奖励UI } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑') as {
  打开Boss死亡首领奖励UI: (this: void, rewardPoolId: string) => void;
};
const { 夏提雅奖励池ID } = require('系统.02．物品系统.18．首领奖励选择.01．奖励配置表.21．异界_夏提雅战利品') as {
  夏提雅奖励池ID: string;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, source: any, text: string, durationMs: number) => void;
};
const { 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (unit: any, flag: boolean) => void;
const ShowUnit = jass.ShowUnit as (unit: any, flag: boolean) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 血之复生技能Key = '血之复生';

export function 启动夏提雅挑战收束(this: void, context: 夏提雅运行时上下文, 是否再次战败 = false): boolean {
  const boss = context.Boss单位;
  if (context.挑战已结束 || !单位有效(boss)) return false;
  context.挑战已结束 = true;
  context.阶段 = '挑战收束';
  context.当前大型技能 = undefined;
  重置夏提雅猎血连击(context);
  关闭吟唱条('大招');
  SetUnitInvulnerable(boss, true);
  PauseUnit(boss, true);

  const cfg = 夏提雅数值与表现配置;
  const effect = AddSpecialEffect(cfg.表现资源.挑战结束离场特效路径, GetUnitX(boss), GetUnitY(boss));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.挑战收束.离场特效持续秒, effect);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.挑战收束.离场动画编号, 持续秒: cfg.挑战收束.离场延迟秒, 恢复动画编号: 0 });
  if (是否再次战败) 广播单位提示(boss, 夏提雅单位技能配置.台词.再次战败[0], 3600);

  const delayedId = addDelayedCallback(cfg.挑战收束.离场延迟秒 * 1000, function 夏提雅挑战离场(this: void): void {
    ShowUnit(boss, false);
    主动结束Boss战运行(boss, { 跳过死亡音效: true, 跳过死亡剧情: true });
    打开Boss死亡首领奖励UI(夏提雅奖励池ID);
    清理Boss自动技能启动上下文(boss);
    清理夏提雅运行时上下文(boss);
  });
  context.清理.登记延迟回调('夏提雅-挑战收束离场', delayedId);
  return true;
}

function 夏提雅复生失败后收束(this: void, context: 夏提雅运行时上下文): void {
  启动夏提雅挑战收束(context, false);
}

export function 绑定夏提雅挑战生命下限(this: void, context: 夏提雅运行时上下文): void {
  if (context.挑战生命下限保护 != null) return;
  context.挑战生命下限保护 = 创建伤害生命下限保护({
    名称: '夏提雅-复生与挑战收束锁血',
    单位: context.Boss单位,
    固定生命下限: 1,
    修正优先级: -100,
    清理: context.清理,
    过滤伤害: function 夏提雅锁血过滤(this: void): boolean {
      return !context.挑战已结束 && context.阶段 !== '挑战收束' && context.阶段 !== '已结束';
    },
    伤害预处理: function 夏提雅复生期免伤(this: void, _damage: any, current: number): number {
      return context.阶段 === '复生仪式' ? 0 : current;
    },
    离开下限后重置触底: true,
    on首次触底: function 夏提雅首次触底(this: void): void {
      if (!context.已触发复生) {
        context.已触发复生 = true;
        context.阶段 = '复生仪式';
        context.当前大型技能 = 血之复生技能Key;
        addDelayedCallback(0, function 夏提雅致死后启动复生(this: void): void {
          if (!启动夏提雅血之复生(context, 夏提雅复生失败后收束)) 启动夏提雅挑战收束(context, false);
        });
      } else {
        context.阶段 = '挑战收束';
        context.当前大型技能 = undefined;
        addDelayedCallback(0, function 夏提雅再次致死后启动收束(this: void): void {
          启动夏提雅挑战收束(context, true);
        });
      }
    },
  });
}

export const 夏提雅挑战入口与收束状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '巴尔扎罗斯战败清理后生成血红镜面挑战媒介；结束后夏提雅通过血雾或镜面离场，主线道路不受影响。',
  当前覆盖: '首次致死进入一次性复生仪式；复生失败或第二次致死后消散离场、主动结束Boss战并打开夏提雅首领奖励。',
  场景入口状态: '巴尔扎罗斯战后镜面挑战媒介仍需绑定真实场景事件挂点，不在Boss技能目录中猜测事件名。',
} as const;
