/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
// 恢复魔法百分比：最大魔法走 JAPI、当前魔法走 JASS（unit-state-jass-japi-boundary 规则）
const { SetUnitManaPercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitManaPercentBJ: (this: void, whichUnit: any, percent: number) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const UnitResetCooldown = jass.UnitResetCooldown as (this: void, unit: any) => void;
const 模块名 = "重置玩家英雄技能冷却测试";
const 测试命令 = "-cd";

function on重置玩家英雄技能冷却(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;

  const hero = getRegisteredPlayerHero(player);
  if (hero == null || hero === 0) {
    debugLogForce(模块名, "未找到当前玩家已注册英雄");
    return;
  }

  UnitResetCooldown(hero);
  // -cd 附带把英雄当前魔法恢复到 100%（SetUnitManaPercentBJ 内部已按边界处理）
  SetUnitManaPercentBJ(hero, 100);
  debugLogForce(模块名, "已重置当前玩家英雄全部技能冷却并回满魔法");
}

注册聊天命令监听(测试命令, on重置玩家英雄技能冷却);
debugLogForce(模块名, "已注册测试命令：输入", 测试命令, "重置当前玩家英雄全部技能冷却");

export {};
