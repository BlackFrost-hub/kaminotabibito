/** @noSelfInFile */
/**
 * 扩散伤害测试
 *
 * 输入"1002"后，gg_unit_Hamg_0002 对 gg_unit_hfoo_0021 造成扩散伤害。
 * 这是临时测试文件，后续不用时可直接移除。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; gg_unit_hfoo_0021?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 扩散伤害 } from "../01．技能函数/08．扩散伤害/index";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;

const 模块名 = "扩散伤害测试";
const 测试命令 = "1002";
let 已注册 = false;

function on聊天1002测试(): void {
  const 来源单位 = g.gg_unit_Hamg_0002;
  const 主目标 = g.gg_unit_hfoo_0021;
  if (来源单位 == null || 来源单位 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }
  if (主目标 == null || 主目标 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_hfoo_0021");
    return;
  }

  扩散伤害({
    来源单位,
    主目标,
    伤害值: 60,
    扩散半径: 300,
    扩散百分比: 0.5,
  });

  debugLogForce(模块名, "已执行扩散伤害，主目标全额500，半径300内敌方扩散250");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1002测试);

  debugLogForce(模块名, "已注册测试：输入", 测试命令, "对 hfoo_0021 造成扩散伤害");
}

注册聊天测试();

export {};
