/** @noSelfInFile */

import { type 卡瑟拉运行时上下文, 增加玩家触手残片 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, 极坐标X, 极坐标Y } from "./14．公共工具";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};

function 治疗Boss最大生命比例(this: void, boss: any, ratio: number): void {
  if (!单位有效(boss) || !(ratio > 0)) return;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(boss, UNIT_STATE_LIFE);
  const next = life + maxLife * ratio;
  SetUnitState(boss, UNIT_STATE_LIFE, next > maxLife ? maxLife : next);
}

function 幼鱿死亡掉落残片(this: void, context: 卡瑟拉运行时上下文, killer: any): void {
  if (!单位有效(killer)) return;
  const chance = 卡瑟拉数值与表现配置.触手鞭笞.触手残片掉落概率;
  if (GetRandomReal(0, 1) <= chance) 增加玩家触手残片(context, killer, 1);
}

function 创建深渊幼鱿(this: void, context: 卡瑟拉运行时上下文, angle: number): void {
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.深渊召唤;
  const x = 极坐标X(GetUnitX(boss), angle, 480);
  const y = 极坐标Y(GetUnitY(boss), angle, 480);
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "卡瑟拉-深渊幼鱿",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.幼鱿单位类型,
    模型路径: cfg.幼鱿模型路径,
    X: x,
    Y: y,
    朝向: angle + 180,
    最大生命: cfg.幼鱿生命值,
    缩放: cfg.幼鱿缩放,
    持续时间: cfg.吞噬等待秒 + 2,
    on死亡: function 卡瑟拉深渊幼鱿死亡(this: void, _unit: any, killer: any): void {
      幼鱿死亡掉落残片(context, killer);
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  临时调整攻击(instance.单位, cfg.幼鱿攻击力);
  const id = addDelayedCallback(cfg.吞噬等待秒 * 1000, function 卡瑟拉深渊幼鱿吞噬(this: void): void {
    if (!单位有效(boss) || !instance.是否存活()) return;
    instance.销毁();
    治疗Boss最大生命比例(boss, cfg.吞噬回血比例);
  });
  context.清理.登记延迟回调("卡瑟拉-深渊幼鱿吞噬", id);
}

export function 释放卡瑟拉深渊召唤(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.深渊召唤;
  播放卡瑟拉台词(boss, "深渊召唤");
  for (let i = 0; i < cfg.幼鱿数量; i++) {
    创建深渊幼鱿(context, i * 120);
  }
}

export function 注册卡瑟拉深渊召唤(this: void): void {
}
