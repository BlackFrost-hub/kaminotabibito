/** @noSelfInFile */
/**
 * 反击系统测试
 *
 * 输入 1050：测试反击系统基本功能
 *   - 创建敌人单位并攻击大法师
 *   - 验证反击伤害触发
 *
 * 输入 1051：测试AOE反击
 *   - 创建多个敌人单位
 *   - 验证范围反击
 *
 * 输入 1052：测试距离条件反击
 *   - 测试最小距离/最大距离条件
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
import {
  注册反击,
  移除反击,
  获取反击数量,
  反击类型,
  反击伤害类型,
} from "../01．技能函数/13．反击/index";
const { debugLogForce, setDebug } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
  setDebug: (this: void, module: string, on: boolean) => void;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => any;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const Player = jass.Player as (playerId: number) => any;
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const SetUnitLifePercent = jass.SetUnitLifePercent as (whichUnit: any, percent: number) => void;
const SetUnitState = jass.SetUnitState as (whichUnit: any, whichUnitState: any, newVal: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;

const 步兵ID = "hfoo";
const 兽族步兵ID = "hpea";
const 中立敌对 = 12;
const 玩家1 = 0;

const 模块名 = "反击测试";

// 测试单位
let 测试反击单位: any = null;
let 测试攻击者1: any = null;
let 测试攻击者2: any = null;
let 测试攻击者3: any = null;
let 待清理单位: any[] = [];

/**
 * 清理测试单位
 */
function 清理测试单位(): void {
  for (const u of 待清理单位) {
    if (u != null && u !== 0) {
      RemoveUnit(u);
    }
  }
  待清理单位 = [];
  测试反击单位 = null;
  测试攻击者1 = null;
  测试攻击者2 = null;
  测试攻击者3 = null;
  debugLogForce(模块名, "已清理所有测试单位");
}

/**
 * 获取大法师（反击单位）
 */
function 获取测试大法师(): any {
  return g.gg_unit_Hamg_0002;
}

/**
 * 创建敌人单位（攻击者）
 */
function 创建敌人单位(x: number, y: number, unitId: string): any {
  const u = CreateUnit(Player(中立敌对), stringToFourCC(unitId), x, y, 0);
  待清理单位.push(u);
  return u;
}

/**
 * 执行伤害（模拟敌人攻击）
 */
function 模拟攻击(攻击者: any, 目标: any, 伤害值: number): void {
  if (!攻击者 || !目标) return;

  const j = jass as any;
  // 使用 SetUnitState 直接扣除生命值来模拟伤害
  const 当前生命 = GetUnitState(目标, UNIT_STATE_LIFE);
  const 新生命 = Math.max(1, 当前生命 - 伤害值);
  j.SetUnitState(目标, UNIT_STATE_LIFE, 新生命);

  debugLogForce(模块名, "模拟攻击: 攻击者=", GetHandleId(攻击者), "目标=", GetHandleId(目标), "伤害=", 伤害值);
}

const GetHandleId = jass.GetHandleId as (h: any) => number;

/**
 * 测试基本反击
 */
function 测试基本反击(): void {
  const 反击单位 = 获取测试大法师();
  if (!反击单位) {
    debugLogForce(模块名, "错误：未找到大法师");
    return;
  }

  // 清理之前的测试
  清理测试单位();

  // 在大法师旁边创建敌人
  const x = GetUnitX(反击单位) + 200;
  const y = GetUnitY(反击单位);
  测试攻击者1 = 创建敌人单位(x, y, 步兵ID);

  // 注册反击：受到任意伤害时反击，只反击伤害来源，固定50伤害
  const 实例ID = 注册反击({
    反击来源: 反击单位,
    反击类型: 反击类型.任意伤害,
    伤害计算方式: 反击伤害类型.固定值,
    伤害值: 50,
    距离条件: { 最小距离: 0, 最大距离: 1000 },
    冷却时间: 0,
    是否AOE: false,
    只反击来源: true,
    反击特效: "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapTargetArt.mdl",
    特效附着点: "origin",
  });

  const 反击数量 = 获取反击数量(反击单位);
  debugLogForce(模块名, "基本反击测试: 注册成功 实例ID=", 实例ID, "反击数量=", 反击数量);

  // 1秒后模拟敌人攻击
  createDelayedCall(1.0, () => {
    模拟攻击(测试攻击者1, 反击单位, 100);
    debugLogForce(模块名, "已模拟攻击，触发反击");

    // 5秒后清理
    createDelayedCall(5.0, 清理测试单位);
  });
}

/**
 * 测试AOE反击
 */
function 测试AOE反击(): void {
  const 反击单位 = 获取测试大法师();
  if (!反击单位) {
    debugLogForce(模块名, "错误：未找到大法师");
    return;
  }

  // 清理之前的测试
  清理测试单位();

  const baseX = GetUnitX(反击单位);
  const baseY = GetUnitY(反击单位);

  // 在大法师周围创建多个敌人
  测试攻击者1 = 创建敌人单位(baseX + 150, baseY, 步兵ID);
  测试攻击者2 = 创建敌人单位(baseX + 200, baseY + 100, 步兵ID);
  测试攻击者3 = 创建敌人单位(baseX + 250, baseY - 50, 步兵ID);

  // 注册AOE反击
  注册反击({
    反击来源: 反击单位,
    反击类型: 反击类型.任意伤害,
    伤害计算方式: 反击伤害类型.固定值,
    伤害值: 30,
    距离条件: { 最小距离: 0, 最大距离: 500 },
    冷却时间: 0,
    是否AOE: true,
    AOE半径: 400,
    只反击来源: false,
    反击特效: "Abilities\\Spells\\NightElf\\Regeneration\\RegenerationTarget.mdl",
    特效附着点: "origin",
  });

  debugLogForce(模块名, "AOE反击测试: 已注册，AOE半径400");

  // 1秒后模拟攻击任意一个敌人攻击大法师
  createDelayedCall(1.0, () => {
    模拟攻击(测试攻击者1, 反击单位, 80);
    debugLogForce(模块名, "已模拟攻击，触发AOE反击");

    // 5秒后清理
    createDelayedCall(5.0, 清理测试单位);
  });
}

/**
 * 测试百分比反击
 */
function 测试百分比反击(): void {
  const 反击单位 = 获取测试大法师();
  if (!反击单位) {
    debugLogForce(模块名, "错误：未找到大法师");
    return;
  }

  // 清理之前的测试
  清理测试单位();

  const x = GetUnitX(反击单位) + 200;
  const y = GetUnitY(反击单位);
  测试攻击者1 = 创建敌人单位(x, y, 步兵ID);

  // 注册百分比反击：反击伤害=受到伤害的50%
  注册反击({
    反击来源: 反击单位,
    反击类型: 反击类型.任意伤害,
    伤害计算方式: 反击伤害类型.百分比,
    伤害值: 0.5,
    距离条件: { 最小距离: 0, 最大距离: 1000 },
    冷却时间: 0,
    是否AOE: false,
    只反击来源: true,
  });

  debugLogForce(模块名, "百分比反击测试: 反击伤害=受到伤害的50%");

  // 1秒后模拟攻击，造成100伤害
  createDelayedCall(1.0, () => {
    模拟攻击(测试攻击者1, 反击单位, 100);
    // 预期反击伤害 = 100 * 0.5 = 50

    // 5秒后清理
    createDelayedCall(5.0, 清理测试单位);
  });
}

/**
 * 测试仅攻击反击
 */
function 测试仅攻击反击(): void {
  const 反击单位 = 获取测试大法师();
  if (!反击单位) {
    debugLogForce(模块名, "错误：未找到大法师");
    return;
  }

  // 清理之前的测试
  清理测试单位();

  const x = GetUnitX(反击单位) + 200;
  const y = GetUnitY(反击单位);
  测试攻击者1 = 创建敌人单位(x, y, 步兵ID);

  // 注册仅攻击反击：只有普攻才触发
  注册反击({
    反击来源: 反击单位,
    反击类型: 反击类型.仅攻击,
    伤害计算方式: 反击伤害类型.固定值,
    伤害值: 40,
    距离条件: {},
    冷却时间: 0,
    是否AOE: false,
    只反击来源: true,
  });

  debugLogForce(模块名, "仅攻击反击测试: 只有普攻触发");

  // 注意：由于这里无法真正区分普攻和技能伤害，这个测试主要验证注册成功
  createDelayedCall(3.0, 清理测试单位);
}

/**
 * 聊天命令回调
 */
function on聊天1050命令(): void {
  debugLogForce(模块名, "执行测试: 基本反击");
  测试基本反击();
}

function on聊天1051命令(): void {
  debugLogForce(模块名, "执行测试: AOE反击");
  测试AOE反击();
}

function on聊天1052命令(): void {
  debugLogForce(模块名, "执行测试: 百分比反击");
  测试百分比反击();
}

function on聊天1053命令(): void {
  debugLogForce(模块名, "执行测试: 仅攻击反击");
  测试仅攻击反击();
}

function on聊天1059命令(): void {
  debugLogForce(模块名, "清理所有测试单位");
  清理测试单位();
}

// 注册聊天命令
注册聊天命令监听("1050", on聊天1050命令);
注册聊天命令监听("1051", on聊天1051命令);
注册聊天命令监听("1052", on聊天1052命令);
注册聊天命令监听("1053", on聊天1053命令);
注册聊天命令监听("1059", on聊天1059命令);

debugLogForce(模块名, "已注册测试命令: 1050-基本反击, 1051-AOE反击, 1052-百分比反击, 1053-仅攻击反击, 1059-清理");

export {};