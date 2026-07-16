/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 清理安兹运行时上下文 } from './01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 创建伤害生命下限保护 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
import { 播放安兹台词 } from './12．台词播放';
const { 主动结束Boss战运行 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动') as {
  主动结束Boss战运行: (this: void, boss: any, options?: any) => boolean;
};
const { 清理Boss自动技能启动上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  清理Boss自动技能启动上下文: (this: void, boss: any) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
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
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

function 播放挑战结束门扉(this: void, x: number, y: number): void {
  const cfg = 安兹乌尔恭数值与表现配置;
  const paths = [cfg.表现资源.挑战结束传送门框路径, cfg.表现资源.挑战结束传送核心路径, cfg.表现资源.挑战结束传送旋涡路径];
  for (let i = 0; i < paths.length; i++) {
    const effect = AddSpecialEffect(paths[i], x, y);
    if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.守护者模式.挑战收束门扉持续秒, effect);
  }
}

export function 启动安兹挑战收束(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  const albedo = context.雅儿贝德?.单位;
  if (context.挑战已结束 || !单位有效(boss)) return false;
  context.挑战已结束 = true;
  context.阶段 = '挑战收束';
  context.当前大型技能 = undefined;
  SetUnitInvulnerable(boss, true);
  PauseUnit(boss, true);
  if (单位有效(albedo)) {
    SetUnitInvulnerable(albedo, true);
    PauseUnit(albedo, true);
    if (context.雅儿贝德 != null) context.雅儿贝德.阶段状态 = '终局拦截';
  }
  context.雅儿贝德?.独占状态?.取消当前('清理', '安兹挑战收束');
  const cfg = 安兹乌尔恭数值与表现配置;
  播放限时单位动画({ 单位: boss, 动画编号: cfg.守护者模式.挑战收束安兹姿势动画编号, 持续秒: cfg.守护者模式.挑战收束离场延迟秒, 恢复动画编号: 0 });
  if (单位有效(albedo)) 播放限时单位动画({ 单位: albedo, 动画编号: cfg.守护者模式.挑战收束雅儿贝德姿势动画编号, 持续秒: cfg.守护者模式.挑战收束离场延迟秒, 恢复动画编号: 1 });
  播放挑战结束门扉(GetUnitX(boss), GetUnitY(boss));
  播放安兹台词(boss, '挑战结束');
  const delayedId = addDelayedCallback(cfg.守护者模式.挑战收束离场延迟秒 * 1000, function 安兹挑战离场(this: void): void {
    context.雅儿贝德?.成员生命周期?.设置状态('雅儿贝德', '离场', '服从至尊命令');
    context.雅儿贝德?.成员生命周期?.设置状态('安兹', '离场', '试炼结束');
    if (单位有效(albedo)) ShowUnit(albedo, false);
    ShowUnit(boss, false);
    主动结束Boss战运行(boss, { 跳过死亡音效: true, 跳过死亡剧情: true });
    清理Boss自动技能启动上下文(boss);
    清理安兹运行时上下文(boss);
  });
  context.清理.登记延迟回调('安兹-挑战收束离场', delayedId);
  return true;
}

export function 绑定安兹挑战生命下限(this: void, context: 安兹运行时上下文): void {
  if (context.挑战生命下限保护 != null) return;
  context.挑战生命下限保护 = 创建伤害生命下限保护({
    名称: '安兹-挑战收束锁血',
    单位: context.安兹单位,
    固定生命下限: 1,
    修正优先级: -100,
    清理: context.清理,
    过滤伤害: function 安兹锁血过滤(this: void): boolean {
      return !context.挑战已结束 && context.阶段 !== '挑战收束' && context.阶段 !== '已结束';
    },
    on首次触底: function 安兹首次触底(this: void): void {
      if (context.挑战已结束 || context.阶段 === '挑战收束') return;
      context.阶段 = '挑战收束';
      addDelayedCallback(0, function 安兹致死后启动收束(this: void): void { 启动安兹挑战收束(context); });
    },
  });
}

export const 安兹挑战入口与收束状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '亚伦柯斯战败归静并完成清理后生成挑战媒介；安兹归零时锁血、宣布试炼结束并通过黑金门离开。',
  实现要求: '该入口最终接剧情或异界挑战系统，不在普通技能文件中直接注册Boss死亡事件。',
} as const;
