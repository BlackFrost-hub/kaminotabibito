/** @noSelfInFile */
/**
 * 仇恨系统 测试
 *
 * 步骤1 — 链路验证：
 * 输入 "1021"：直接对大法师周围敌人手动加仇恨（addThreat），验证驱动层让敌人攻击大法师
 *
 * 步骤2 — 真实伤害：
 * 大法师手动攻击敌人，日志观察仇恨建立
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const {
  初始化仇恨系统,
  驱动单个敌人,
} = require("系统.01．单位系统.06．仇恨系统.index") as {
  初始化仇恨系统: (this: void) => void;
  驱动单个敌人: (this: void, 敌人: any) => void;
};

const { addThreat, clearAllThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  addThreat: (this: void, 敌人: any, 仇恨目标: any, 数值: number) => void;
  clearAllThreat: (this: void, 敌人: any) => void;
};

const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

const 模块名 = "仇恨测试";
const 测试命令 = "1021";
let 已注册 = false;

function on聊天测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  // 初始化仇恨系统
  初始化仇恨系统();

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);

  // 找周围敌人
  const 敌人列表 = getEnemyUnitsInRange(大法师, x, y, 1000);
  if (敌人列表.length === 0) {
    debugLogForce(模块名, "错误：大法师周围1000码内没有敌人");
    return;
  }

  const 敌人 = 敌人列表[0];
  if (敌人 == null || 敌人 === 0) {
    debugLogForce(模块名, "错误：找到的第一个敌人无效");
    return;
  }

  clearAllThreat(敌人);

  // 这里只是手动加 30 点仇恨，不是“造成 30 点伤害后的换算值”。
  addThreat(敌人, 大法师, 30);
  驱动单个敌人(敌人);
  debugLogForce(模块名, "加仇恨 敌人ID=", jass.GetHandleId(敌人), "对大法师 仇恨=30");
  debugLogForce(模块名, "步骤1完成：仅对第一个敌人注册30仇恨，并立即驱动其攻击大法师");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "给周围敌人加30仇恨，验证驱动攻击");
}

注册聊天测试();

export {};
