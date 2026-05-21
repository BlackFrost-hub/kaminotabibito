/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { 设置玩家幸运值, 取玩家幸运值 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  设置玩家幸运值: (this: void, 玩家: any, 幸运值: number) => void;
  取玩家幸运值: (this: void, 玩家: any) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

const 模块名 = "幸运值测试";
const 测试命令 = "1043";

function on聊天1043幸运值测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const 玩家 = GetOwningPlayer(大法师);
  设置玩家幸运值(玩家, 5);
  debugLogForce(模块名, "已设置大法师所属玩家幸运值", "playerId=", GetPlayerId(玩家), "幸运值=", 取玩家幸运值(玩家));
}

注册聊天命令监听(测试命令, on聊天1043幸运值测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "给大法师所属玩家设置500%幸运值");

export {};
