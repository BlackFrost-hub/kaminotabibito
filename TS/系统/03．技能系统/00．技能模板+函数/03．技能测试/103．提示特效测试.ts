/** @noSelfInFile */
/**
 * 提示特效测试
 *
 * 输入"1003"后，在 gg_unit_Hamg_0002 脚下创建红色圆形提示圈。
 * 这是临时测试文件，后续不用时可直接移除。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 创建薄圆形提示圈 } from "../02．通用函数/09．提示特效";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

const 模块名 = "提示特效测试";
const 测试命令 = "1003";
let 已注册 = false;

function on聊天1003测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);

  创建薄圆形提示圈(x, y, 300, 2.0);

  debugLogForce(模块名, "已创建红色圆形提示圈 x=", x, "y=", y, "半径=300");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1003测试);

  debugLogForce(模块名, "已注册测试：输入", 测试命令, "在大法师脚下创建红色圆形提示圈");
}

注册聊天测试();

export {};
