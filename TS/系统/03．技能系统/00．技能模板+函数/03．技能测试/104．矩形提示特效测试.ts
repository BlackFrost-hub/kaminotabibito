/** @noSelfInFile */
/**
 * 矩形提示特效测试
 *
 * 输入"1004"后，在 gg_unit_Hamg_0002 面前创建矩形提示特效。
 * 这是临时测试文件，后续不用时可直接移除。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 创建矩形提示圈 } from "../02．通用函数/09．提示特效";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (
  whichTrigger: any,
  whichPlayer: any,
  chatMessageToDetect: string,
  exactMatchOnly: boolean
) => any;
const TriggerAddAction = jass.TriggerAddAction as (whichTrigger: any, actionFunc: () => void) => any;
const Player = jass.Player as (playerId: number) => any;

const 模块名 = "矩形提示特效测试";
const 测试命令 = "1004";
let 已注册 = false;

function on聊天1004测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const fac = GetUnitFacing(大法师);

  创建矩形提示圈(x, y, 200, 600, fac, 2.0);

  debugLogForce(模块名, "已创建矩形提示特效 x=", x, "y=", y, "宽=200 长=600");
}

注册聊天命令监听(测试命令, on聊天1004测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "在大法师面前创建矩形提示圈");

export {};
