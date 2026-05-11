/** @noSelfInFile */
/**
 * 幻象物品测试
 *
 * 输入 "1017"：
 * - 对 gg_unit_Hamg_0002 施放快速 Buff 马甲版“幻象物品”。
 * - 默认持续时间 15 秒。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setItemIllusion: (this: void, sourceUnit: any, u: any, time?: number) => boolean;
};

const CreateTrigger = jass["CreateTrigger"] as () => any;
const TriggerRegisterPlayerChatEvent = jass["TriggerRegisterPlayerChatEvent"] as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass["TriggerAddAction"] as (trig: any, action: () => void) => void;
const Player = jass["Player"] as (playerId: number) => any;
const GetUnitName = jass["GetUnitName"] as (whichUnit: any) => string;

const 模块名 = "幻象物品测试";
const 测试命令 = "1017";
const 幻象持续时间 = 15;

let 已注册 = false;

function on聊天1017测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const ok = fastBuff.SFB_setItemIllusion(大法师, 大法师, 幻象持续时间);
  debugLogForce(模块名, "施放结果=", ok, "目标=", GetUnitName(大法师), "持续=", 幻象持续时间);
}

function 注册聊天1017测试(this: void): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1017测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "对大法师施放幻象物品");
}

注册聊天1017测试();

export {};
