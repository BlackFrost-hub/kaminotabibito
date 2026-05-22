/** @noSelfInFile */

declare const gg_snd_SecretFound: any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};

const 模块名 = "全局音效句柄测试";
const 测试命令 = "145";

function on聊天145测试(this: void): void {
  debugLogForce(模块名, "准备播放 gg_snd_SecretFound", "handle=", gg_snd_SecretFound);
  PlaySoundBJ(gg_snd_SecretFound);
}

注册聊天命令监听(测试命令, on聊天145测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "播放 gg_snd_SecretFound");

export {};
