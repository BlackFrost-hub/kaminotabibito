/** @noSelfInFile */
/**
 * 异界背景框测试
 *
 * 输入 1048：触发 STES 异界Boss背景框动画。
 * 输入 1049：直接动态创建背景框并填入测试文字。
 * 输入 1050：动态创建自定义段落数量的背景框。
 * 输入 1051：销毁当前测试背景框。
 */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Fire: (this: void, name: string) => void;
};
const 背景框 = require("系统.09．表现系统.11．背景框.01．背景框创建") as {
  创建背景框: (this: void, config?: any) => any;
  设置段落文字: (this: void, 实例: any, 索引: number, 文字: string) => void;
  设置背景框透明度: (this: void, 实例: any, alpha: number) => void;
  显示背景框: (this: void, 实例: any) => void;
  隐藏背景框: (this: void, 实例: any) => void;
  销毁背景框: (this: void, 实例: any) => void;
};

const 模块名 = "异界背景框测试";
const STES命令 = "1048";
const 直接命令 = "1049";
const 自定义命令 = "1050";
const 销毁命令 = "1051";

let 测试帧组: any = null;

function 确保销毁(): void {
  if (测试帧组 !== null) {
    背景框.销毁背景框(测试帧组);
    测试帧组 = null;
  }
}

function onSTES触发测试(): void {
  确保销毁();
  STES_Fire("异界Boss背景框");
  debugLogForce(模块名, "已触发 STES_Fire('异界Boss背景框')");
}

function on直接显示测试(): void {
  确保销毁();
  测试帧组 = 背景框.创建背景框({
    段落数量: 4,
    段落文字: ["第一段：动态创建测试", "第二段：调用通用 API", "第三段：支持自定义文字", "第四段：一切正常！"],
  });
  if (测试帧组 === null) {
    debugLogForce(模块名, "错误：创建背景框失败");
    return;
  }
  背景框.设置背景框透明度(测试帧组, 255);
  背景框.显示背景框(测试帧组);
  debugLogForce(模块名, "已动态创建背景框（4段落，含初始文字）");
}

function on自定义段落测试(): void {
  确保销毁();
  测试帧组 = 背景框.创建背景框({
    段落数量: 6,
  });
  if (测试帧组 === null) {
    debugLogForce(模块名, "错误：创建背景框失败");
    return;
  }
  for (let i = 0; i < 6; i++) {
    背景框.设置段落文字(测试帧组, i, "自定义段落 #" + (i + 1).toString());
  }
  背景框.设置背景框透明度(测试帧组, 255);
  背景框.显示背景框(测试帧组);
  debugLogForce(模块名, "已动态创建 6 段落背景框");
}

function on销毁测试(): void {
  if (测试帧组 === null) {
    debugLogForce(模块名, "没有可销毁的测试背景框");
    return;
  }
  确保销毁();
  debugLogForce(模块名, "已销毁测试背景框");
}

注册聊天命令监听(STES命令, onSTES触发测试);
注册聊天命令监听(直接命令, on直接显示测试);
注册聊天命令监听(自定义命令, on自定义段落测试);
注册聊天命令监听(销毁命令, on销毁测试);
debugLogForce(模块名, "已注册测试：输入", STES命令, "STES；", 直接命令, "直接创建；", 自定义命令, "6段落；", 销毁命令, "销毁");

export {};
