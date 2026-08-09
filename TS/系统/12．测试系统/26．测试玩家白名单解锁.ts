/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 登记测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  登记测试玩家: (this: void, 玩家: any) => void;
};

const 测试命令 = "test";

function on测试玩家白名单解锁(this: void, 玩家: any, 命令: string): void {
  if (命令 !== 测试命令 || 玩家 == null || 玩家 === 0) return;

  登记测试玩家(玩家);
}

注册聊天命令监听(测试命令, on测试玩家白名单解锁);

export {};
