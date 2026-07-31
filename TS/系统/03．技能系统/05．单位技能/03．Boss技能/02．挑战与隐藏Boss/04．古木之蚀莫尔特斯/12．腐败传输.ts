/** @noSelfInFile */

import { 增加玩家腐败值, 取玩家腐败值, 同步Boss腐败护盾值, 刷新Boss腐败护盾Buff, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 单位有效 } from "./16．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 创建血量节点触发器 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/01．血量节点触发器";
import { 创建持续单位连线 } from "../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线";

const { SU_GetUnitLostHP } = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数") as {
  SU_GetUnitLostHP: (this: void, unit: any) => number;
};

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};

function 创建腐败传输连线(this: void, context: 莫尔特斯运行时上下文, target: any): void {
  const cfg = 莫尔特斯数值与表现配置.腐败传输;
  创建持续单位连线({
    清理: context.清理,
    名称: "莫尔特斯-腐败传输连线",
    起点单位: context.Boss单位,
    终点单位: target,
    闪电代码: cfg.连线效果,
    持续秒: cfg.连线持续秒,
    起点高度: cfg.连线起点高度,
    终点高度: cfg.连线终点高度,
    Tick间隔毫秒: cfg.连线Tick间隔毫秒,
  });
}

function 计算腐败传输护盾(this: void, target: any): number {
  const cfg = 莫尔特斯数值与表现配置.腐败传输;
  const 已损失生命值 = SU_GetUnitLostHP(target);
  const 计算护盾值 = 已损失生命值 * cfg.护盾目标已损生命比例;
  return 计算护盾值 < cfg.护盾最低值 ? cfg.护盾最低值 : 计算护盾值;
}

function 执行一次腐败传输(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const bossValid = 单位有效(boss);
  同步Boss腐败护盾值(context);
  if (!bossValid) return;

  const target = 获取Boss技能随机敌对英雄(boss);
  const targetValid = 单位有效(target);
  if (!targetValid) return;

  const cfg = 莫尔特斯数值与表现配置.腐败传输;
  增加玩家腐败值(context, target, cfg.转移腐败值);
  const shieldDelta = 计算腐败传输护盾(target);
  context.腐败护盾值 = context.腐败护盾值 + shieldDelta;
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

/** 测试入口：直接执行一次血量节点对应的腐败传输，便于验证连线、腐败值和 Boss 护盾。 */
export function 测试触发莫尔特斯腐败传输(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  执行一次腐败传输(context);
}

export function 注册莫尔特斯腐败传输节点(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.腐败传输节点已注册) return;
  context.腐败传输节点已注册 = true;
  const 节点列表: Array<{ ID: string; 百分比: number; on触发: (this: void, unit: any, 当前百分比: number) => void }> = [];
  for (let 百分比 = 95; 百分比 >= 5; 百分比 -= 5) {
    节点列表.push({
      ID: "腐败传输-" + 百分比 + "%",
      百分比: 百分比 * 0.01,
      on触发: function 莫尔特斯腐败传输节点触发(this: void, _unit: any, _当前百分比: number): void {
        执行一次腐败传输(context);
      },
    });
  }
  创建血量节点触发器({
    清理: context.清理,
    名称: "莫尔特斯-腐败传输节点",
    单位: context.Boss单位,
    节点列表,
    Tick间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
  });
}
