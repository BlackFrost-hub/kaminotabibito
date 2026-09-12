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
const { 清空单位装备冷却 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as {
  清空单位装备冷却: (this: void, unit: any) => void;
};
const { 清除单位全部物品栏冷却 } = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示") as {
  清除单位全部物品栏冷却: (this: void, hero: any) => void;
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
  // 装备冷却分三层：平台技能冷却（UnitResetCooldown）、装备冷却表、物品栏UI记录。
  // 后两层独立于平台技能冷却，-CD 需一并清空，否则物品栏UI仍显示倒计时。
  清空单位装备冷却(hero);
  清除单位全部物品栏冷却(hero);
  // -cd 附带把英雄当前魔法恢复到 100%（SetUnitManaPercentBJ 内部已按边界处理）
  SetUnitManaPercentBJ(hero, 100);
  debugLogForce(模块名, "已重置当前玩家英雄全部技能/装备冷却、物品栏冷却UI并回满魔法");
}

注册聊天命令监听(测试命令, on重置玩家英雄技能冷却);
debugLogForce(模块名, "已注册测试命令：输入", 测试命令, "重置当前玩家英雄全部技能冷却");

export {};
