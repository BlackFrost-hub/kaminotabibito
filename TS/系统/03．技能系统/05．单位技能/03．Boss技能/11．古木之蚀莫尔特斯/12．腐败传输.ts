/** @noSelfInFile */

import { 增加玩家腐败值, 刷新Boss腐败护盾Buff, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 单位有效 } from "./16．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../00．公共/00．Boss音效播放";

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const AddLightning = jass.AddLightning as (codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const DestroyLightning = jass.DestroyLightning as (whichLightning: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};

function 当前生命百分比档位(this: void, boss: any): number {
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 100;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  let percent = 100;
  while (percent > 0 && ratio <= (percent - 5) * 0.01) {
    percent = percent - 5;
  }
  return percent;
}

function 莫尔特斯腐败传输连线销毁(this: void, variable?: any): void {
  const lightning = variable as any;
  if (lightning != null && lightning !== 0) DestroyLightning(lightning);
}

function 创建腐败传输连线(this: void, context: 莫尔特斯运行时上下文, target: any): void {
  const cfg = 莫尔特斯数值与表现配置.腐败传输;
  const lightning = AddLightning(cfg.连线效果, false, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), GetUnitX(target), GetUnitY(target));
  const id = addDelayedCallback(700, 莫尔特斯腐败传输连线销毁, lightning);
  context.清理.登记延迟回调("莫尔特斯-腐败传输连线", id);
}

function 执行一次腐败传输(this: void, context: 莫尔特斯运行时上下文): void {
  const target = 获取Boss技能随机敌对英雄(context.Boss单位);
  if (!单位有效(target)) return;
  const cfg = 莫尔特斯数值与表现配置.腐败传输;
  增加玩家腐败值(context, target, cfg.转移腐败值);
  context.腐败护盾值 = context.腐败护盾值 + cfg.转移腐败值 * cfg.护盾每点腐败值;
  刷新Boss腐败护盾Buff(context);
  创建腐败传输连线(context, target);
  播放Boss坐标音效(莫尔特斯音效配置.腐败传输.护盾增长, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 莫尔特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 莫尔特斯音效配置.怪物拟声.标识,
    音效路径列表: 莫尔特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(context.Boss单位),
    Y: GetUnitY(context.Boss单位),
    裁断距离: 莫尔特斯音效配置.默认裁断距离,
    冷却Ms: 莫尔特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 莫尔特斯音效配置.怪物拟声.关键机制触发概率百分比,
  });
}

export function 处理莫尔特斯腐败传输(this: void, context: 莫尔特斯运行时上下文, _nowMs: number): void {
  if (!单位有效(context.Boss单位)) return;
  const current = 当前生命百分比档位(context.Boss单位);
  while (context.下次腐败传输档位 >= current && context.下次腐败传输档位 > 0) {
    执行一次腐败传输(context);
    context.下次腐败传输档位 = context.下次腐败传输档位 - 5;
  }
}

export function 注册莫尔特斯腐败传输(this: void): void {
}
