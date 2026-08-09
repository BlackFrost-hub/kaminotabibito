/** @noSelfInFile */

const globals = require("jass.globals") as {
  gg_unit_Hamg_0002?: any;
  gg_unit_Obla_0004?: any;
};
const jass = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, 玩家: any) => boolean;
};
const { directRegisterPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  directRegisterPlayerHero: (this: void, 玩家: any, 英雄: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};

const 玩家 = jass.Player as (this: void, 玩家ID: number) => any;
const 测试命令 = "zc";
const 模块名 = "玩家英雄注册测试";

function on玩家英雄注册测试(this: void, _触发玩家: any, _命令: string): void {
  if (!是允许测试玩家(_触发玩家)) return;

  const 玩家1英雄 = globals.gg_unit_Hamg_0002;
  const 玩家2英雄 = globals.gg_unit_Obla_0004;
  if (玩家1英雄 == null || 玩家1英雄 === 0 || 玩家2英雄 == null || 玩家2英雄 === 0) {
    debugLogForce(模块名, "地图预置英雄句柄不存在", "玩家1英雄", 玩家1英雄, "玩家2英雄", 玩家2英雄);
    return;
  }

  directRegisterPlayerHero(玩家(0), 玩家1英雄);
  directRegisterPlayerHero(玩家(1), 玩家2英雄);
  debugLogForce(模块名, "已完成玩家英雄注册", "玩家1", "gg_unit_Hamg_0002", "玩家2", "gg_unit_Obla_0004");
}

注册聊天命令监听(测试命令, on玩家英雄注册测试);

export {};
