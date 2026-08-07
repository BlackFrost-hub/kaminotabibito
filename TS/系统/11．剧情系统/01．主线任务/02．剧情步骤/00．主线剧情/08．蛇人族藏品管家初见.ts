/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度, 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
export { 蛇人族藏品管家初见剧情片段, 蛇人族藏品管家食人魔任务确认剧情片段 } from "../01．第一章/08．蛇人族藏品管家初见";

const Player = jass.Player as (this: void, whichPlayer: number) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

let 待确认任务玩家: any = null;
let 待确认任务触发单位: any = null;
let 待确认任务NPC: any = null;

function 清理食人魔任务确认状态(this: void): void {
  待确认任务玩家 = null;
  待确认任务触发单位 = null;
  待确认任务NPC = null;
}

function on拒绝食人魔任务(this: void): void {
  清理食人魔任务确认状态();
}

function on接受食人魔任务(this: void): void {
  const 触发单位 = 待确认任务触发单位;
  if (读取剧情进度() !== 9 || 触发单位 == null || 触发单位 === 0) {
    清理食人魔任务确认状态();
    return;
  }

  const 剧情播放器 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  const 播放主线剧情片段 = 剧情播放器.播放主线剧情片段;
  清理食人魔任务确认状态();
  const 已启动 = 播放主线剧情片段("jlc_snake_ogre_task_accept", {
    片段ID: "jlc_snake_ogre_task_accept",
    触发配置名: "蛇人族藏品管家对话框接受食人魔任务",
    触发单位,
  });
  if (已启动) 写入剧情进度(10);
}

function 打开食人魔任务确认对话框(this: void): void {
  if (读取剧情进度() !== 9 || 待确认任务玩家 == null || 待确认任务玩家 === 0 || 待确认任务NPC == null || 待确认任务NPC === 0) {
    清理食人魔任务确认状态();
    return;
  }

  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (玩家: any, 数据: any) => boolean;
  };
  const openNpcDialog = UI函数.openNpcDialog;
  const 已打开 = openNpcDialog(待确认任务玩家, {
    lines: [],
    npcUnit: 待确认任务NPC,
    quest: {
      title: "蛇人族藏品管家",
      text: "【狩猎沙漠食人魔】\n\n接受委托后，蛇人族会开启通往沙漠食人魔巢穴的异常裂隙。击败它并带回凭证，便可换取夜光翡翠。\n\n该目标将开启 Boss 战，请确认队伍已经做好准备。",
      acceptText: "接受任务",
      rejectText: "暂不接受",
      onAccept: on接受食人魔任务,
      onReject: on拒绝食人魔任务,
    },
  });
  if (!已打开) 清理食人魔任务确认状态();
}

export function 执行蛇人族藏品管家初见(this: void, 参数: 剧情动作参数表): void {
  const npc引用 = String(参数.NPC ?? "");
  const 键名 = npc引用.includes(".") ? npc引用.split(".")[1] ?? "" : npc引用;
  if (键名 === "") return;
  const npc = 读取剧情运行时单位(npc引用)
    ?? YDUserDataGetSafe("string", "主线NPC", 键名, "unit")
    ?? (require("jass.globals") as any)[npc引用];
  if (npc == null || npc === 0) return;
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) IssueImmediateOrder(触发单位, "stop");
  SetUnitOwner(npc, Player(6), true);
}

export function 执行蛇人族藏品管家任务确认(this: void, 参数: 剧情动作参数表): void {
  if (读取剧情进度() !== 9) return;
  const npc引用 = String(参数.NPC ?? "主线NPC.蛇人族藏品管家");
  const 键名 = npc引用.includes(".") ? npc引用.split(".")[1] ?? "" : npc引用;
  const npc = 读取剧情运行时单位(npc引用) ?? YDUserDataGetSafe("string", "主线NPC", 键名, "unit");
  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  if (npc == null || npc === 0 || 触发单位 == null || 触发单位 === 0) return;
  const 玩家 = GetOwningPlayer(触发单位);
  if (玩家 == null || 玩家 === 0) return;

  待确认任务玩家 = 玩家;
  待确认任务触发单位 = 触发单位;
  待确认任务NPC = npc;
  addDelayedCallback(10, 打开食人魔任务确认对话框);
}

export const 蛇人族藏品管家初见剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_藏品管家初见": 执行蛇人族藏品管家初见,
  "SRZ蛇人族_打开食人魔任务确认": 执行蛇人族藏品管家任务确认,
};
