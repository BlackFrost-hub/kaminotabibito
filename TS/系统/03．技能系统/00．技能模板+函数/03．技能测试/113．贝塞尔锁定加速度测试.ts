/** @noSelfInFile */
/**
 * 贝塞尔锁定加速度测试
 *
 * 输入 "1013"：
 * - 搜索 gg_unit_Hamg_0002 附近敌人作为锁定终点。
 * - 发射锁定单位二阶贝塞尔 XYZ 弹幕。
 * - 初速 260，飞行 250 码后开始加速度 650。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

import {
  创建原生弹幕,
  创建锁定单位二阶贝塞尔加速度XYZ轨迹,
  type 原生弹幕结束原因,
} from "../01．技能函数/01．弹幕/01．TS原生弹幕/index";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const SquareRoot = jass.SquareRoot as (x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const 模块名 = "贝塞尔锁定加速度测试";
const 测试命令 = "1013";
const 搜索半径 = 1000;
let 已注册 = false;

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

function 前方X(this: void, 单位: any, distance: number): number {
  const angle = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitX(单位) + (Cos(angle) as number) * distance;
}

function 前方Y(this: void, 单位: any, distance: number): number {
  const angle = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitY(单位) + (Sin(angle) as number) * distance;
}

function 锁定贝塞尔_命中(this: void, 目标单位: any, 弹幕ID: number): void {
  debugLogForce(模块名, "命中锁定弹幕", "弹幕ID=", 弹幕ID, "目标=", GetUnitName(目标单位), "#", GetHandleId(目标单位));
}

function 锁定贝塞尔_到达(this: void, 弹幕ID: number, 原因: "完成" | "距离结束"): void {
  debugLogForce(模块名, "到达目标点", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function 锁定贝塞尔_结束(this: void, 原因: 原生弹幕结束原因, 弹幕ID: number): void {
  debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function on聊天1013测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }
  const 目标 = 查找最近敌人(大法师);
  if (目标 == null || 目标 === 0) {
    debugLogForce(模块名, "错误：附近未找到敌人");
    return;
  }

  const startX = 前方X(大法师, 80);
  const startY = 前方Y(大法师, 80);
  const ctrlX = 前方X(大法师, 420);
  const ctrlY = 前方Y(大法师, 420);
  const 实例 = 创建原生弹幕({
    所有者: 大法师,
    X: startX,
    Y: startY,
    方向角: GetUnitFacing(大法师),
    速度: 0,
    生命周期: 8,
    命中半径: 110,
    碰撞消失: true,
    伤害值: 55,
    影响目标: "敌方",
    模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
    轨迹采样器: 创建锁定单位二阶贝塞尔加速度XYZ轨迹(
      startX, startY, 80,
      ctrlX, ctrlY, 420,
      目标,
      80,
      260,
      650,
      250,
    ),
    on命中单位: 锁定贝塞尔_命中,
    on到达目标点: 锁定贝塞尔_到达,
    on结束: 锁定贝塞尔_结束,
  });

  debugLogForce(模块名, "已发射锁定加速度贝塞尔弹幕", "弹幕ID=", 实例.弹幕ID, "目标=", GetUnitName(目标), "#", GetHandleId(目标));
}

function 注册聊天1013测试(): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1013测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "发射锁定加速度贝塞尔弹幕");
}

注册聊天1013测试();

export {};
