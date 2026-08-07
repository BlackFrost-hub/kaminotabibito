/** @noSelfInFile */

import { 祖地双灵卫副本配置 } from "./01．祖地双灵卫副本配置";
import { 祖地双灵卫副本状态 } from "./02．祖地双灵卫副本状态";

const jass = require("jass.common") as any;

const { addSelectionListener } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener: (
    this: void,
    listener: (this: void, player: any, playerId: number, unit: any, isSelected: boolean) => void,
  ) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, player: any) => any;
};
const { 打开首领奖励选择界面 } = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, rewardPoolId: string, player: any) => void;
};
const { 祖地双灵卫奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index") as {
  祖地双灵卫奖励池ID: string;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};

const GetPlayerController = jass.GetPlayerController as (this: void, player: any) => any;
const GetPlayerSlotState = jass.GetPlayerSlotState as (this: void, player: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, player: any, state: any) => number;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetPlayerState = jass.SetPlayerState as (this: void, player: any, state: any, value: number) => void;

const 玩家最小ID = 0;
const 玩家最大ID = 5;
let 奖励提交模块已初始化 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是在局用户(this: void, player: any): boolean {
  return 句柄有效(player)
    && GetPlayerController(player) === jass.MAP_CONTROL_USER
    && GetPlayerSlotState(player) === jass.PLAYER_SLOT_STATE_PLAYING;
}

function 发放祖地双灵卫全队奖励(this: void): void {
  for (let playerId = 玩家最小ID; playerId <= 玩家最大ID; playerId++) {
    const player = Player(playerId);
    if (!是在局用户(player)) continue;
    const current = GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_LUMBER);
    SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_LUMBER, current + 1);
    打开首领奖励选择界面(祖地双灵卫奖励池ID, player);
  }
}

function on拒绝祖地双灵卫奖励提交(this: void): void {
  // 玩家可以稍后再次与埃德里安交谈。
}

function on接受祖地双灵卫奖励提交(this: void): void {
  if (!祖地双灵卫副本状态.Boss战已完成 || 祖地双灵卫副本状态.奖励已提交) return;
  祖地双灵卫副本状态.奖励已提交 = true;
  发放祖地双灵卫全队奖励();
  if (句柄有效(祖地双灵卫副本状态.埃德里安单位)) {
    广播单位提示(
      祖地双灵卫副本状态.埃德里安单位,
      "祖地会记住你们替双灵结束的这场旧争。收下谢意，愿这份力量不再被誓言束缚。",
      5600,
    );
  }
}

function 打开已提交对话(this: void, player: any): void {
  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (this: void, player: any, data: any) => boolean;
  };
  UI函数.openNpcDialog(player, {
    lines: [
      {
        title: "埃德里安",
        text: "双灵的回响已经归于平静。祖地会记住你们做过的事。",
        duration: 4600,
      },
    ],
    npcUnit: 祖地双灵卫副本状态.埃德里安单位,
    对话目标单位: getRegisteredPlayerHero(player),
    NPC配置朝向: 祖地双灵卫副本配置.埃德里安.朝向,
  });
}

function 打开奖励提交对话(this: void, player: any): void {
  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (this: void, player: any, data: any) => boolean;
  };
  UI函数.openNpcDialog(player, {
    lines: [
      {
        title: "埃德里安",
        text: "你们身上还带着赤誓与苍影的灵息。看来守在深处的，果然是他们。",
        duration: 4600,
      },
      {
        title: "埃德里安",
        text: "他们曾共同守过祖地，后来却把彼此都当成背誓者。你们终结的，是一场拖得太久的争执。",
        duration: 5200,
      },
    ],
    quest: {
      title: "精灵往事·归还信物",
      text: "向埃德里安提交祖地调查结果。完成后，所有在局玩家获得双灵卫首领战利品选择与 1 能量碎片。",
      acceptText: "提交任务",
      rejectText: "稍后再谈",
      onAccept: on接受祖地双灵卫奖励提交,
      onReject: on拒绝祖地双灵卫奖励提交,
    },
    npcUnit: 祖地双灵卫副本状态.埃德里安单位,
    对话目标单位: getRegisteredPlayerHero(player),
    NPC配置朝向: 祖地双灵卫副本配置.埃德里安.朝向,
  });
}

function on祖地双灵卫奖励NPC选择(this: void, player: any, playerId: number, unit: any, isSelected: boolean): void {
  if (!isSelected || playerId < 玩家最小ID || playerId > 玩家最大ID) return;
  if (unit !== 祖地双灵卫副本状态.埃德里安单位 || !祖地双灵卫副本状态.Boss战已完成) return;
  if (祖地双灵卫副本状态.奖励已提交) 打开已提交对话(player);
  else 打开奖励提交对话(player);
}

export function init祖地双灵卫奖励提交(this: void): void {
  if (奖励提交模块已初始化) return;
  奖励提交模块已初始化 = true;
  addSelectionListener(on祖地双灵卫奖励NPC选择);
}

