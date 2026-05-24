/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { YDUserDataSetSafe, YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

const 模块名 = "魔法消耗减少扣蓝测试";
const 测试命令 = "146";
const 魔法消耗减少 = 0.2;
const 测试扣蓝值 = 100;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 读取当前魔法(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_MANA);
}

function 读取最大魔法(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_MAX_MANA);
}

function on聊天146魔法消耗减少扣蓝测试(this: void, player: any, _command: string): void {
  const 大法师 = getRegisteredPlayerHero(player);
  if (!单位有效(大法师)) {
    debugLogForce(模块名, "测试失败：当前玩家没有注册玩家英雄，无法验证只对玩家英雄生效的魔法消耗减少");
    return;
  }

  const 最大魔法 = 读取最大魔法(大法师);
  SetUnitState(大法师, UNIT_STATE_MANA, 最大魔法);
  YDUserDataSetSafe("player", player, "魔法消耗", "real", 魔法消耗减少);

  const 写入后属性 = YDUserDataGetSafe("player", player, "魔法消耗", "real");
  const 扣除前魔法 = 读取当前魔法(大法师);
  const 实际变化 = 减少魔法值(大法师, 测试扣蓝值, true, true);
  const 扣除后魔法 = 读取当前魔法(大法师);

  debugLogForce(
    模块名,
    "完成",
    "playerId=",
    GetPlayerId(player),
    "魔法消耗减少=",
    写入后属性,
    "请求扣蓝=",
    测试扣蓝值,
    "预期实际扣蓝=",
    80,
    "实际变化=",
    实际变化,
    "扣除前=",
    扣除前魔法,
    "扣除后=",
    扣除后魔法,
  );
}

注册聊天命令监听(测试命令, on聊天146魔法消耗减少扣蓝测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "给当前玩家英雄写入20%魔法消耗减少，并请求扣100蓝");

export {};
