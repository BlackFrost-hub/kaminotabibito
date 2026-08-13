/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 发送头像提示给玩家, 广播单位提示, 播放广播对白序列 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送头像提示给玩家: (this: void, 玩家: any, 头像路径: string, 文本: string, 持续时间?: number) => void;
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
  播放广播对白序列: (this: void, 配置: any) => void;
};
const { 广播提示玩家槽数, 广播提示喇叭头像 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示玩家槽数: number;
  广播提示喇叭头像: string;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (
    this: void,
    unit: any,
    range: number,
    callback: (this: void, enteringUnit: any) => boolean,
    predicate?: (this: void, enteringUnit: any) => boolean,
  ) => (this: void) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 卡瑟拉奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index") as {
  卡瑟拉奖励池ID: string;
};
const { 打开首领奖励选择界面 } = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, 奖励池ID: string, 玩家: any) => void;
};
import { 创建剧情NPC单位 } from "../../00．公共/02．剧情NPC创建";

let 卡瑟拉已创建 = false;
let 当前卡瑟拉单位: any = null;
let 取消卡瑟拉入口范围监听: ((this: void) => void) | undefined;
let 卡瑟拉入口已触发 = false;
let 卡瑟拉入口对白已完成 = false;
let 已注册卡瑟拉死亡监听 = false;

const Player = jass.Player as (this: void, playerId: number) => any;
const PingMinimap = jass.PingMinimap as (this: void, x: number, y: number, duration: number) => void;

function 广播卡瑟拉挑战提示(this: void): void {
  const 文本 = "|cffffcc00『深海挑战』：|r前往原水龙蛇湖底区域挑战卡瑟拉！";
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    发送头像提示给玩家(Player(玩家ID), 广播提示喇叭头像, 文本, 5000);
  }
}

function 注销卡瑟拉入口范围监听(this: void): void {
  if (取消卡瑟拉入口范围监听 != null) 取消卡瑟拉入口范围监听();
  取消卡瑟拉入口范围监听 = undefined;
}

function 注销卡瑟拉死亡监听(this: void): void {
  if (!已注册卡瑟拉死亡监听) return;
  unregisterDeathListener(on卡瑟拉死亡);
  已注册卡瑟拉死亡监听 = false;
}

function 清理卡瑟拉入口监听(this: void): void {
  注销卡瑟拉入口范围监听();
  注销卡瑟拉死亡监听();
}

function on卡瑟拉入口对白结束(this: void): void {
  卡瑟拉入口对白已完成 = true;
}

function 读取卡瑟拉入口说话单位(this: void, _说话者键: string): any {
  return 当前卡瑟拉单位;
}

function 播放卡瑟拉入口广播(this: void): void {
  播放广播对白序列({
    对白列表: [
      { 说话者键: "卡瑟拉", 文本: "你们终于来到这里了……水龙蛇替我守住的最后一道屏障，竟也没能拦住你们。", 停留毫秒: 4800 },
      { 说话者键: "卡瑟拉", 文本: "沃利尔斯还在奢望重返故海。可从我自深渊苏醒的那一刻起，这片湖底便只听从我的意志。", 停留毫秒: 6800 },
      { 说话者键: "卡瑟拉", 文本: "潮汐战戟，还有你们想夺回的一切，都在这里。既然敢踏进我的领地，就用性命来证明你们配得上它。", 停留毫秒: 4200 },
    ],
    读取说话单位: 读取卡瑟拉入口说话单位,
    播放单句: 广播单位提示,
    播放完成: on卡瑟拉入口对白结束,
  });
}

function on卡瑟拉范围触发(this: void, _触发单位: any): boolean {
  if (卡瑟拉入口已触发 || 当前卡瑟拉单位 == null || 当前卡瑟拉单位 === 0) return true;

  卡瑟拉入口已触发 = true;
  清理卡瑟拉入口监听();
  播放卡瑟拉入口广播();
  return true;
}

function on卡瑟拉死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit !== 当前卡瑟拉单位) return;
  清理卡瑟拉入口监听();
}

function 注册卡瑟拉入口范围监听(this: void): void {
  取消卡瑟拉入口范围监听 = registerOneShotUnitRangeListener(
    当前卡瑟拉单位,
    1000,
    on卡瑟拉范围触发,
    是玩家英雄组单位,
  );
  registerDeathListener(on卡瑟拉死亡);
  已注册卡瑟拉死亡监听 = true;
}

export const 被驱逐的水怪入口配置 = {
  任务ID: 10020,
  前置Boss单位ID: "n011",
  前置Boss名称: "水龙蛇",
  前置Boss坐标X: 21068.2,
  前置Boss坐标Y: -27125.8,
  前置Boss朝向: 273.75,
} as const;

function 接受被驱逐的水怪任务后创建卡瑟拉(_任务配置?: any, _玩家ID?: number): void {
  if (卡瑟拉已创建) return;

  const 卡瑟拉 = 创建剧情NPC单位({
    单位ID: "N05V",
    X: 被驱逐的水怪入口配置.前置Boss坐标X,
    Y: 被驱逐的水怪入口配置.前置Boss坐标Y,
    朝向: 被驱逐的水怪入口配置.前置Boss朝向,
    玩家ID: 15,
  });
  if (卡瑟拉 == null || 卡瑟拉 === 0) return;
  当前卡瑟拉单位 = 卡瑟拉;
  卡瑟拉已创建 = true;
  卡瑟拉入口对白已完成 = false;
  注册卡瑟拉入口范围监听();

  广播卡瑟拉挑战提示();
  PingMinimap(
    被驱逐的水怪入口配置.前置Boss坐标X,
    被驱逐的水怪入口配置.前置Boss坐标Y,
    5,
  );
}

function 完成被驱逐的水怪任务后打开首领奖励(_任务配置?: any, _玩家ID?: number): void {
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    const 玩家 = Player(玩家ID);
    if (玩家 != null && jass.GetPlayerController(玩家) === jass.MAP_CONTROL_USER) {
      打开首领奖励选择界面(卡瑟拉奖励池ID, 玩家);
    }
  }
}

export const 被驱逐的水怪NPC配置列表 = [
  {
    NPC名称: "被驱逐的水怪-沃利尔斯",
    任务ID: 被驱逐的水怪入口配置.任务ID,
    NPC配置名: "被驱逐的水怪",
    单位ID: "n04Q",
    类型: "任务",
    坐标X: -19859.6,
    坐标Y: -16170.4,
    朝向: 150,
    自动创建: false,
    启用: true,
  },
];

export const 被驱逐的水怪任务配置列表 = [
  {
    任务ID: 被驱逐的水怪入口配置.任务ID,
    名称: "|cff33cccc被驱逐的水怪|r（|cffff0000深海Boss战任务|r）",
    类型: "目标击杀",
    开始NPC: "被驱逐的水怪-沃利尔斯",
    目标单位: "N05V",
    需求数量: 1,
    接取条件: "英雄等级＞30",
    奖励: "完成任务的玩家+1能量碎片",
    奖励显示: "完成任务的玩家+1能量碎片;卡瑟拉首领战利品（任选2件）",
    描述: "帮助沃利尔斯击败|cff33cccc深渊巨鱿·卡瑟拉|r，夺回被占据的深海家园与潮汐战戟。",
    进度文本: "击败深渊巨鱿·卡瑟拉 N/1",
    NPC开始对白: "NPC：你身上有水龙蛇的气息……它终于死了。\nPlayer：你一直在等有人杀死它？\nNPC：我叫沃利尔斯，曾是那片海域的守护者。直到深渊巨鱿·卡瑟拉从海沟中苏醒，它驱逐了我的族人，占据了我们的家园。\nNPC：它还夺走了维系海潮的|cff33cccc潮汐战戟|r，并派水龙蛇封锁海岸，不允许任何幸存者靠近。\nPlayer：所以你躲在这里，是为了寻找能击败它的人。\nNPC：没错。你能杀死水龙蛇，便有资格踏入卡瑟拉盘踞的深海。请帮我夺回家园，也夺回那柄战戟。",
    任务接受对白: "Player：我会去会会那头深渊巨鱿，让它把不属于它的东西吐出来。\nNPC：多谢。做好准备后再来找我，我会开启通往深海裂隙的道路。\nNPC：小心它的触手与墨汁。在海中，卡瑟拉远比水龙蛇危险。",
    接取后动作: 接受被驱逐的水怪任务后创建卡瑟拉,
    接取失败对白: "NPC：深海不会宽恕毫无准备的人。你们虽然击败了水龙蛇证明了实力，但再磨炼下为好（等级＞30），再来面对卡瑟拉。",
    NPC完成对白: "NPC：海潮的声音回来了……卡瑟拉真的死了。\nPlayer：你的家园和潮汐战戟都夺回来了。\nNPC：我失去的族人无法归来，但幸存者终于可以重返大海。冒险者，请接受被驱逐者最后的谢意。",
    完成后对白 : "默认",
    完成后动作: 完成被驱逐的水怪任务后打开首领奖励,
    可重复: false,
    启用: true,
  },
];

export function 读取卡瑟拉单位(this: void): any {
  return 当前卡瑟拉单位;
}

export function 是否卡瑟拉入口对白已完成(this: void): boolean {
  return 卡瑟拉入口对白已完成;
}
