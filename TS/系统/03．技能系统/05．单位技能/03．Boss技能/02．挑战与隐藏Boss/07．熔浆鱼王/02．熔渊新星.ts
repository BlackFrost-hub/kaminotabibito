/** @noSelfInFile */
/**
 * 熔浆鱼王 · 熔渊新星（AUW1）
 *
 * 无目标、以自身为中心炸开熔岩：惩罚贴脸输出。
 * 与「熔岩冲击」（点目标、拉远喷）形成一近一远的简单节奏。
 * 伤害 = 施法者攻击力 × 倍率。
 */

import {
  熔浆鱼王单位类型ID,
  熔渊新星技能ID,
  熔渊新星技能类型ID,
  熔渊新星配置,
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

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

export interface 熔浆鱼王新星上下文 extends 单位运行时上下文基础 {}

const 熔浆鱼王新星工厂 = 创建单位运行时上下文工厂<熔浆鱼王新星上下文>({
  名称: "熔浆鱼王新星技能",
  主动技能提示: [
    {
      技能ID: 熔渊新星技能ID,
      提示: "熔渊新星",
      扩展提示: "以自身为中心炸开熔岩，对周围敌人造成伤害。",
    },
  ],
  创建上下文: (_unit: any, 清理: any) => ({ 清理 }),
});

function 释放熔渊新星(this: void, _上下文: 熔浆鱼王新星上下文, 施法者: any, 技能实例ID?: number): void {
  // 以施法时自身位置为中心（预警圈固定在该点，走开就不挨打）。
  const 中心X = GetUnitX(施法者);
  const 中心Y = GetUnitY(施法者);

  // 预警：脚下先出现红橙熔灼圆盘。
  // 预警圈：项目通用「技能提示圈」，半径=伤害半径，持续到爆炸。
  创建技能提示圈({
    类型: "渐变圆形",
    X: 中心X,
    Y: 中心Y,
    半径: 熔渊新星配置.范围,
    持续时间: 熔渊新星配置.预警秒,
  });

  addDelayedCallback(熔渊新星配置.预警秒 * 1000, () => {
    创建点特效({
      路径: 熔渊新星配置.爆炸特效,
      X: 中心X,
      Y: 中心Y,
      持续秒: 熔渊新星配置.爆炸特效持续秒,
    });
    const 伤害 = 读取单位攻击力(施法者) * 熔渊新星配置.攻击倍率;
    const 敌人列表 = getEnemyUnitsInRange(施法者, 中心X, 中心Y, 熔渊新星配置.范围);
    for (let i = 0; i < 敌人列表.length; i++) {
      const 目标 = 敌人列表[i];
      if (目标 == null || 目标 === 0) continue;
      造成单体技能伤害({
        来源: 施法者,
        目标,
        伤害,
        技能ID: 熔渊新星技能类型ID,
        技能实例ID,
      });
    }
  });
}

let 已注册 = false;

export function 注册熔浆鱼王熔渊新星(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "熔浆鱼王-熔渊新星",
    单位类型ID: 熔浆鱼王单位类型ID,
    技能ID: 熔渊新星技能类型ID,
    获取或创建上下文: 熔浆鱼王新星工厂.获取或创建,
    释放技能: 释放熔渊新星,
    创建独立技能实例: true,
    独立技能来源类型: "Boss技能",
    技能实例持续时间秒: 6,
  });
}

// 模块顶层自注册：被 index 导入即生效（与 01．灵力意识体 的写法一致）。
注册熔浆鱼王熔渊新星();

export {};
