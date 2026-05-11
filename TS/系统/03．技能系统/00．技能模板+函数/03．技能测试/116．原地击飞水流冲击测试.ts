/** @noSelfInFile */
/**
 * 原地击飞水流冲击测试
 *
 * 输入 "1016"：
 * - 在 gg_unit_Hamg_0002 脚下持续创建娜迦死亡特效。
 * - 将大法师原地顶飞，Z 高度在 200-250 间随机抖动。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 开始原地击飞 } from "../01．技能函数/03．跳跃·击飞/index";

const CreateTrigger = jass["CreateTrigger"] as () => any;
const TriggerRegisterPlayerChatEvent = jass["TriggerRegisterPlayerChatEvent"] as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass["TriggerAddAction"] as (trig: any, action: () => void) => void;
const Player = jass["Player"] as (playerId: number) => any;

const 模块名 = "原地击飞水流冲击测试";
const 测试命令 = "1016";
const 娜迦死亡特效 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl";

let 已注册 = false;

function 原地击飞_结束(this: void, 单位: any, 原因: string, 击飞ID: number): void {
  debugLogForce(模块名, "结束", "原因=", 原因, "击飞ID=", 击飞ID);
}

function on聊天1016测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const 击飞ID = 开始原地击飞(大法师, {
    持续时间: 3.0,
    最小高度: 200,
    最大高度: 250,
    冲击波模型: 娜迦死亡特效,
    持续特效模型: 娜迦死亡特效,
    持续特效间隔: 0.08,
    结束回调: 原地击飞_结束,
  });

  debugLogForce(模块名, "开始", "击飞ID=", 击飞ID, "特效=", 娜迦死亡特效);
}

function 注册聊天1016测试(this: void): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1016测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "开始原地击飞水流冲击测试");
}

注册聊天1016测试();

export {};
