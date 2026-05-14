/** @noSelfInFile */
/**
 * 弹道跳链测试
 *
 * 输入 "1014"：
 * - 搜索 gg_unit_Hamg_0002 周围敌人作为起始目标。
 * - 每一跳都创建真实飞行弹幕，命中后再找下一跳。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

import { 开始弹道跳链 } from "../01．技能函数/01．弹幕/02．弹道跳链/index";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;

const 模块名 = "弹道跳链测试";
const 测试命令 = "1014";
const 搜索半径 = 900;

function 查找最近敌人(this: void, 来源单位: any): any {
  const x = GetUnitX(来源单位);
  const y = GetUnitY(来源单位);
  const 候选 = getUnitsInRange(x, y, 搜索半径);
  let 最佳目标: any = null;
  let 最佳距离 = 0;
  for (let i = 0; i < 候选.length; i++) {
    const 单位 = 候选[i];
    if (!isUnitEnemy(单位, 来源单位)) continue;
    const dx = GetUnitX(单位) - x;
    const dy = GetUnitY(单位) - y;
    const 距离 = SquareRoot(dx * dx + dy * dy);
    if (最佳目标 == null || 距离 < 最佳距离) {
      最佳目标 = 单位;
      最佳距离 = 距离;
    }
  }
  return 最佳目标;
}

function 弹道跳链_结束(this: void): void {
  debugLogForce(模块名, "弹道跳链结束");
}

function on聊天1014测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const 初始目标 = 查找最近敌人(大法师);
  if (初始目标 == null || 初始目标 === 0) {
    debugLogForce(模块名, "错误：附近未找到敌人");
    return;
  }

  开始弹道跳链({
    施法者: 大法师,
    初始目标,
    跳跃次数: 4,
    搜索半径,
    弹幕速度: 320,
    每跳延迟: 0.2,
    命中半径: 90,
    伤害值: 45,
    每跳伤害系数: 0.75,
    每单位只命中一次: true,
    模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
    on结束: 弹道跳链_结束,
  });

  debugLogForce(模块名, "已启动弹道跳链", "起始目标=", GetUnitName(初始目标), "#", GetHandleId(初始目标));
}

注册聊天命令监听(测试命令, on聊天1014测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "启动弹道跳链");

export {};
