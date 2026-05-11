/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (module: string, ...args: any[]) => void;
};

import { 开始单位组牵引 } from "./01．技能函数/05．吸附·牵引/index";

const CreateTrigger = jass["CreateTrigger"] as () => any;
const TriggerRegisterPlayerChatEvent = jass["TriggerRegisterPlayerChatEvent"] as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass["TriggerAddAction"] as (trig: any, action: () => void) => void;
const Player = jass["Player"] as (playerId: number) => any;
const CreateGroup = jass["CreateGroup"] as () => any;
const GroupEnumUnitsInRange = jass["GroupEnumUnitsInRange"] as (whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const DestroyGroup = jass["DestroyGroup"] as (whichGroup: any) => void;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;

const 模块名 = "吸附牵引测试";
const 聊天命令 = "111";
let 已注册 = false;

function 执行吸附测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const group = CreateGroup();
  GroupEnumUnitsInRange(group, GetUnitX(大法师), GetUnitY(大法师), 1000, null);
  开始单位组牵引(group, {
    中心单位: 大法师,
    每秒速度: 220,
    持续时间: 4.0,
    最小距离: 140,
    检查地形: true,
    禁用碰撞: true,
    暂停单位: false,
    朝向跟随牵引: true,
    外部暂停时中断: true,
    启用闪电效果: true,
    闪电效果代码: "CLPB",
    闪电高度: 60,
  });
  DestroyGroup(group);

  debugLogForce(模块名, "已开始测试", "输入=" + 聊天命令);
}

function on聊天111测试(): void {
  执行吸附测试();
}

function 注册聊天111测试(): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 聊天命令, true);
  TriggerAddAction(trig, on聊天111测试);
  debugLogForce(模块名, "已注册聊天测试", "输入 " + 聊天命令 + " 开始");
}

注册聊天111测试();

export {};
