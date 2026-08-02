/** @noSelfInFile */

import { type 卡瑟拉运行时上下文, 增加玩家触手残片 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 登记护卫单位, 注销护卫单位 } = require("系统.01．单位系统.10．护卫系统.index") as {
  登记护卫单位: (this: void, unit: any, 参数: any) => any;
  注销护卫单位: (this: void, unit: any) => boolean;
};
const { 获取Boss技能最近敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
};

function 治疗Boss最大生命比例(this: void, boss: any, ratio: number): void {
  if (!单位有效(boss) || !(ratio > 0)) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio, ItemHeal: false, HealEffect: false });
}

function 幼鱿死亡掉落残片(this: void, context: 卡瑟拉运行时上下文, killer: any): void {
  if (!单位有效(killer)) return;
  const chance = 卡瑟拉数值与表现配置.触手鞭笞.触手残片掉落概率;
  if (GetRandomReal(0, 1) <= chance) 增加玩家触手残片(context, killer, 1);
}

function 注销卡瑟拉深渊幼鱿护卫(this: void, unit: any): void {
  注销护卫单位(unit);
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
    on死亡: function 卡瑟拉深渊幼鱿死亡(this: void, unit: any, killer: any): void {
      注销卡瑟拉深渊幼鱿护卫(unit);
      幼鱿死亡掉落残片(context, killer);
    },
    on销毁: 注销卡瑟拉深渊幼鱿护卫,
  });
  if (instance == null || !单位有效(instance.单位)) return;
  创建点特效({
    模型路径: cfg.幼鱿出现特效模型路径,
    X: x,
    Y: y,
    缩放: cfg.幼鱿出现特效缩放,
    持续秒: cfg.幼鱿出现特效持续秒,
  });
  临时调整攻击(instance.单位, cfg.幼鱿攻击力);
  登记护卫单位(instance.单位, {
    主Boss单位: boss,
    护卫类型: "卡瑟拉-深渊幼鱿",
    标记为召唤单位: true,
    Boss结束处理: "注销",
  });
  const target = 获取Boss技能最近敌对英雄(boss);
  if (单位有效(target)) IssueTargetOrder(instance.单位, "attack", target);
  const id = addDelayedCallback(cfg.吞噬等待秒 * 1000, function 卡瑟拉深渊幼鱿吞噬(this: void): void {
    if (!单位有效(boss) || !instance.是否存活()) return;
    instance.销毁();
    治疗Boss最大生命比例(boss, cfg.吞噬回血比例);
  });
  context.清理.登记延迟回调("卡瑟拉-深渊幼鱿吞噬", id);
}

function 召唤深渊幼鱿(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.深渊召唤;
  for (let i = 0; i < cfg.幼鱿数量; i++) {
    创建深渊幼鱿(context, i * 120);
  }
}

export function 释放卡瑟拉深渊召唤(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.深渊召唤;
  启动基础施法时间线({
    名称: "卡瑟拉-深渊召唤",
    施法者: boss,
    硬直秒: cfg.施法硬直秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 5,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.施法硬直秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 卡瑟拉深渊召唤开始提示(this: void): void {
      播放卡瑟拉台词(boss, "深渊召唤");
      播放Boss坐标音效(卡瑟拉音效配置.深渊召唤.幼鱿入场, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
      尝试播放Boss拟声池({
        标识: 卡瑟拉音效配置.怪物拟声.标识,
        音效路径列表: 卡瑟拉音效配置.怪物拟声.音效路径列表,
        X: GetUnitX(boss),
        Y: GetUnitY(boss),
        裁断距离: 卡瑟拉音效配置.默认裁断距离,
        冷却Ms: 卡瑟拉音效配置.怪物拟声.冷却Ms,
        触发概率百分比: 卡瑟拉音效配置.怪物拟声.关键机制触发概率百分比,
      });
    },
    on生效: function 卡瑟拉深渊召唤时间线生效(this: void): void {
      召唤深渊幼鱿(context);
    },
  });
}
