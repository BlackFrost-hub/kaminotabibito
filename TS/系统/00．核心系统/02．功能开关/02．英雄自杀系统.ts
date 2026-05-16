/** @noSelfInFile */

const jass = require("jass.common") as any;
const 获取本地玩家 = jass.GetLocalPlayer as () => any;

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};

const KillUnit = jass.KillUnit as (unit: any) => void;
const 命令 = "-zs";
const 提示时间 = 5;

function 自杀命令(this: void, whichPlayer: any, command: string): void {
  const hero = getRegisteredPlayerHero(whichPlayer);
  if (hero == null || hero === 0) {
    jass.DisplayTimedTextToPlayer(whichPlayer, 0, 0.02, 提示时间, "|cffffff00『系统提示』|r：没有找到英雄！");
    return;
  }

  if (jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD)) {
    jass.DisplayTimedTextToPlayer(whichPlayer, 0, 0.02, 提示时间, "|cffffff00『系统提示』|r：英雄已死亡！");
    return;
  }

  KillUnit(hero);
}

export function 初始化自杀命令(this: void): void {
  聊天命令事件中心.注册聊天命令监听(命令, 自杀命令);
}

export {};