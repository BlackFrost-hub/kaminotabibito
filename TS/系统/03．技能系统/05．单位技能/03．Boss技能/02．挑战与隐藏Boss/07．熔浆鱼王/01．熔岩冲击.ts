/** @noSelfInFile */
/**
 * 熔浆鱼王 · 熔岩冲击（AUQ1）
 *
 * 一个"简单"的 Boss 技能：朝目标地点喷吐熔岩，对范围内敌人造成火焰伤害。
 * 结构完全沿用项目既有做法：
 *   1. 技能壳 = 通魔基座（物编）
 *   2. `创建单位运行时上下文工厂` 管上下文，并借 `主动技能提示` 在运行时改技能显示名
 *   3. `注册单位技能壳监听` 按「单位类型ID + 技能ID」接管施法，效果全在 TS
 */

import {
  熔浆鱼王单位类型ID,
  熔岩冲击技能ID,
  熔岩冲击技能类型ID,
  熔岩冲击配置,
} from "./00．配置";
import {
  创建单位运行时上下文工厂,
  type 单位运行时上下文基础,
} from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";

const jass = require("jass.common") as any;

const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, config: any) => any;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

export interface 熔浆鱼王技能上下文 extends 单位运行时上下文基础 {}

/** 单位上下文工厂：顺带负责运行时把技能壳的显示名改成中文。 */
const 熔浆鱼王技能工厂 = 创建单位运行时上下文工厂<熔浆鱼王技能上下文>({
  名称: "熔浆鱼王技能",
  主动技能提示: [
    {
      技能ID: 熔岩冲击技能ID,
      提示: "熔岩冲击",
      扩展提示: "朝目标地点喷出熔岩，对范围内敌人造成伤害。",
    },
  ],
  创建上下文: (_unit: any, 清理: any) => ({ 清理 }),
});

function 释放熔岩冲击(this: void, _上下文: 熔浆鱼王技能上下文, 施法者: any, 技能实例ID?: number): void {
  // 目标坐标必须在 SPELL_EFFECT 回调内即时读取。
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();

  // 预警：先在落点铺红橙熔灼圆盘，给玩家反应窗口。
  // 预警圈：项目通用「技能提示圈」，半径=伤害半径，持续到爆炸。
  创建技能提示圈({
    类型: "渐变圆形",
    X: 目标X,
    Y: 目标Y,
    半径: 熔岩冲击配置.范围,
    持续时间: 熔岩冲击配置.预警秒,
  });

  addDelayedCallback(熔岩冲击配置.预警秒 * 1000, () => {
    // 到点：爆炸 + 结算（落点固定，走出来就不会被打到）。
    创建点特效({
      路径: 熔岩冲击配置.爆炸特效,
      X: 目标X,
      Y: 目标Y,
      持续秒: 熔岩冲击配置.爆炸特效持续秒,
    });
    const 伤害 = 读取单位攻击力(施法者) * 熔岩冲击配置.攻击倍率;
    const 敌人列表 = getEnemyUnitsInRange(施法者, 目标X, 目标Y, 熔岩冲击配置.范围);
    for (let i = 0; i < 敌人列表.length; i++) {
      const 目标 = 敌人列表[i];
      if (目标 == null || 目标 === 0) continue;
      造成单体技能伤害({
        来源: 施法者,
        目标,
        伤害,
        技能ID: 熔岩冲击技能类型ID,
        技能实例ID,
      });
    }
  });
}

let 已注册 = false;

export function 注册熔浆鱼王熔岩冲击(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "熔浆鱼王-熔岩冲击",
    单位类型ID: 熔浆鱼王单位类型ID,
    技能ID: 熔岩冲击技能类型ID,
    获取或创建上下文: 熔浆鱼王技能工厂.获取或创建,
    释放技能: 释放熔岩冲击,
    创建独立技能实例: true,
    独立技能来源类型: "Boss技能",
    技能实例持续时间秒: 6,
  });
}

// 模块顶层自注册：被 index 导入即生效（与 01．灵力意识体 的写法一致）。
注册熔浆鱼王熔岩冲击();

export {};
