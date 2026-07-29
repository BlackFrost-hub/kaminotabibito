/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { Boss测试单位存活, 获取Boss测试玩家基准英雄 } = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
};
const { 播放Boss坐标音效 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放") as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};

interface Boss音效测试项 {
  名称: string;
  路径: string;
}

const 测试命令 = "soundtest";
const 测试裁断距离 = 2800;
const 测试音效列表: Boss音效测试项[] = [
  {
    名称: "火02",
    路径: "Sound\\Boss\\Phoenixel\\SFX\\phoenixel_element_burst_fire_02.mp3",
  },
  {
    名称: "毒02",
    路径: "Sound\\Boss\\Phoenixel\\SFX\\phoenixel_element_burst_poison_02.mp3",
  },
];

function onBoss音效3D播放测试(this: void, player: any, _command: string): void {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[Boss音效3D测试] 找不到大法师或已登记玩家英雄。");
    return;
  }

  const item = 测试音效列表[GetRandomInt(0, 测试音效列表.length - 1)];
  播放Boss坐标音效(item.路径, GetUnitX(hero), GetUnitY(hero), 测试裁断距离);
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[Boss音效3D测试] 本次随机播放：" + item.名称 + " | " + item.路径);
}

注册聊天命令监听(测试命令, onBoss音效3D播放测试);

export {};
