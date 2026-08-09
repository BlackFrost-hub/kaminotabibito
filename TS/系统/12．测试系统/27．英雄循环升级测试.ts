/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令前缀监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令前缀监听: (
    this: void,
    前缀: string,
    回调: (this: void, player: any, command: string) => void,
  ) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};

const GetHeroLevel = jass.GetHeroLevel as (this: void, hero: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (this: void, hero: any, level: number, showEyeCandy: boolean) => void;
const S2I = jass.S2I as (this: void, text: string) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;

const 英雄升级命令前缀 = "-dj";

function 发送英雄升级提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 6, "[测试] " + text);
}

function 是十进制数字字符(this: void, text: string): boolean {
  return text === "0"
    || text === "1"
    || text === "2"
    || text === "3"
    || text === "4"
    || text === "5"
    || text === "6"
    || text === "7"
    || text === "8"
    || text === "9";
}

function 解析循环升级次数(this: void, command: string): number | undefined {
  let text = command.substring(英雄升级命令前缀.length).trim();
  if (text.substring(0, 1) === "+") {
    text = text.substring(1).trim();
  }
  if (text === "") return undefined;

  for (let i = 0; i < text.length; i++) {
    if (!是十进制数字字符(text.substring(i, i + 1))) return undefined;
  }

  const count = S2I(text);
  if (count <= 0) return undefined;
  return count;
}

function on英雄循环升级命令(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player)) return;

  const count = 解析循环升级次数(command);
  if (count == null) {
    发送英雄升级提示(player, "命令格式：-dj数字，例如：-dj5");
    return;
  }

  const hero = getRegisteredPlayerHero(player);
  if (hero == null || hero === 0) {
    发送英雄升级提示(player, "当前玩家没有已注册英雄");
    return;
  }

  let upgradedCount = 0;
  for (let i = 0; i < count; i++) {
    const previousLevel = GetHeroLevel(hero);
    SetHeroLevel(hero, previousLevel + 1, false);
    if (GetHeroLevel(hero) <= previousLevel) break;
    upgradedCount++;
  }

  发送英雄升级提示(player, "英雄已逐级提升 " + upgradedCount + " 级，当前等级 " + GetHeroLevel(hero));
}

注册聊天命令前缀监听(英雄升级命令前缀, on英雄循环升级命令);

export {};
