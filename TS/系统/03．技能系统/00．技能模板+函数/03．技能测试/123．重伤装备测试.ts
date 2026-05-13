/** @noSelfInFile */
/**
 * 重伤系统 装备测试
 *
 * 输入 "1023"：给玩家1英雄设置50%装备重伤，攻击任何敌人即可触发重伤buff
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { 获取单位重伤 } = require("系统.04．伤害系统.03．重伤系统.index") as {
  获取单位重伤: (this: void, unit: any) => number;
};

const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};

const { YDUserDataSetSafe, YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (u: any) => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const StringHash = jass.StringHash as (value: string) => number;
const SaveReal = jass.SaveReal as (table: any, parentKey: number, childKey: number, value: number) => void;
const LoadReal = jass.LoadReal as (table: any, parentKey: number, childKey: number) => number;

const WOUND_BUFF_ID = "C021";
const 模块名 = "重伤装备测试";
const 测试命令 = "1023";
let 已注册 = false;

function 写入YD用户数据(this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any): void {
  debugLogForce(模块名, "测试写入YD用户数据：tableType=", tableType, "tableKey=", tostring(tableKey), "attr=", attr, "valueType=", valueType, "value=", value);
  YDUserDataSetSafe(tableType, tableKey, attr, valueType, value);
}

function 读取YD用户数据(this: void, tableType: string, tableKey: any, attr: string, valueType: string): any {
  const value = YDUserDataGetSafe(tableType, tableKey, attr, valueType);
  debugLogForce(模块名, "测试读取YD用户数据：tableType=", tableType, "tableKey=", tostring(tableKey), "attr=", attr, "valueType=", valueType, "value=", value);
  return value;
}

function 获取YD哈希表(this: void): any {
  const 候选 = [
    (g as any).YDHASH_HANDLE,
    (g as any).YDHT,
    (g as any).udg_YDHASH_HANDLE,
    (g as any).udg_YDHT,
  ];
  for (const 哈希表 of 候选) {
    if (哈希表 != null && 哈希表 !== 0) return 哈希表;
  }
  return null;
}

function 输出原始哈希诊断(this: void, owner: any): void {
  const 哈希表 = 获取YD哈希表();
  const 玩家句柄ID = GetHandleId(owner);
  const 玩家ID = GetPlayerId(owner);
  const 属性键 = StringHash("重伤");
  debugLogForce(模块名, "原始哈希诊断：hash=", tostring(哈希表), "playerHandleId=", 玩家句柄ID, "playerId=", 玩家ID, "attrHash=", 属性键);
  if (哈希表 == null || 哈希表 === 0) {
    debugLogForce(模块名, "原始哈希诊断：未找到YDHASH句柄");
    return;
  }

  SaveReal(哈希表, 玩家句柄ID, 属性键, 0.75);
  debugLogForce(模块名, "原始哈希诊断：按handleId写0.75后读取=", LoadReal(哈希表, 玩家句柄ID, 属性键));

  SaveReal(哈希表, 玩家ID, 属性键, 0.25);
  debugLogForce(模块名, "原始哈希诊断：按playerId写0.25后读取=", LoadReal(哈希表, 玩家ID, 属性键));
}

function on聊天测试(): void {
  debugLogForce(模块名, "===== 重伤装备测试 =====");

  const 英雄 = g.gg_unit_Hamg_0002;
  if (英雄 == null || 英雄 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  debugLogForce(模块名, "英雄handle：", 英雄);

  // 设置装备重伤50%（英雄走玩家）
  const owner = GetOwningPlayer(英雄);
  debugLogForce(模块名, "英雄owner：", owner);
  写入YD用户数据("player", owner, "重伤", "real", 0.5);
  debugLogForce(模块名, "已设置英雄装备重伤：", 读取YD用户数据("player", owner, "重伤", "real"));
  输出原始哈希诊断(owner);

  debugLogForce(模块名, "===== 请攻击任意敌人 =====");
  debugLogForce(模块名, "攻击后敌人会获得重伤buff");
  debugLogForce(模块名, "tooltip应显示'治疗效果降低50%'");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令);
}

注册聊天测试();

export {};
