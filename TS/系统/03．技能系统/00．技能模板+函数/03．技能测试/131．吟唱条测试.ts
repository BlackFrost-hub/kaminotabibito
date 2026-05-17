/** @noSelfInFile */
/**
 * 吟唱条系统测试
 *
 * 颜色ID: 1-gb(蓝绿), 2-t(青), 3-o(棕), 4-r(红), 5-p(紫), 6-g(金), 7-b(蓝)
 * 输入 131：显示红色吟唱条
 * 输入 132：显示指定颜色ID的吟唱条
 * 输入 133：显示自定义提示文本
 * 输入 134：测试连续两次启动覆盖
 * 输入 135：测试到时自动关闭
 * 输入 136：测试手动关闭
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};
const { 显示吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 模块名 = "吟唱条测试";
const 默认测试命令 = "131";
const 指定颜色命令 = "132";
const 自定义文本命令 = "133";
const 连续覆盖命令 = "134";
const 到时关闭命令 = "135";
const 手动关闭命令 = "136";

let 测试启动时间 = 0;

function 获取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit;
}

function 测试显示默认吟唱条(this: void): void {
  显示吟唱条({
    总时长: 5.0,
    颜色ID: 2,
  });
  测试启动时间 = os.time();
  debugLogForce(模块名, "显示金色吟唱条", "总时长=5秒", "颜色ID=2");
}

function 测试指定颜色(this: void): void {
  显示吟唱条({
    总时长: 4.0,
    颜色ID: 1,
  });
  测试启动时间 = os.time();
  debugLogForce(模块名, "显示颜色1吟唱条", "总时长=4秒", "颜色ID=1");
}

function 测试自定义提示文本(this: void): void {
  显示吟唱条({
    总时长: 3.0,
    颜色ID: 3,
    提示文本: "自定义提示：准备施法！",
  });
  测试启动时间 = os.time();
  debugLogForce(模块名, "显示自定义提示吟唱条", "总时长=3秒", "颜色ID=3");
}

function 测试连续覆盖(this: void): void {
  显示吟唱条({
    总时长: 10.0,
    颜色ID: 5,
  });
  测试启动时间 = os.time();

  addDelayedCallback(1500, function(): void {
    显示吟唱条({
      总时长: 2.0,
      颜色ID: 7,
      提示文本: "覆盖后的吟唱条",
    });
    debugLogForce(模块名, "覆盖启动", "新总时长=2秒", "新颜色ID=7");
  });
}

function 测试到时自动关闭(this: void): void {
  显示吟唱条({
    总时长: 2.0,
    颜色ID: 4,
    提示文本: "2秒后自动关闭",
  });
  测试启动时间 = os.time();
  debugLogForce(模块名, "显示吟唱条", "等待2秒后自动关闭");
}

function 测试手动关闭(this: void): void {
  显示吟唱条({
    总时长: 10.0,
    颜色ID: 2,
    提示文本: "手动关闭测试",
  });
  测试启动时间 = os.time();

  addDelayedCallback(1500, function(): void {
    关闭吟唱条();
    debugLogForce(模块名, "手动关闭吟唱条");
  });
}

function on聊天命令回调(this: void, player: any, command: string): void {
  if (command === 默认测试命令) {
    测试显示默认吟唱条();
  } else if (command === 指定颜色命令) {
    测试指定颜色();
  } else if (command === 自定义文本命令) {
    测试自定义提示文本();
  } else if (command === 连续覆盖命令) {
    测试连续覆盖();
  } else if (command === 到时关闭命令) {
    测试到时自动关闭();
  } else if (command === 手动关闭命令) {
    测试手动关闭();
  } else {
    debugLogForce(模块名, "未知命令", command);
  }
}

export function 初始化吟唱条测试(this: void): void {
  注册聊天命令监听(默认测试命令, on聊天命令回调);
  注册聊天命令监听(指定颜色命令, on聊天命令回调);
  注册聊天命令监听(自定义文本命令, on聊天命令回调);
  注册聊天命令监听(连续覆盖命令, on聊天命令回调);
  注册聊天命令监听(到时关闭命令, on聊天命令回调);
  注册聊天命令监听(手动关闭命令, on聊天命令回调);

  debugLogForce(模块名, "初始化完成", "输入 131-136 测试");
}

初始化吟唱条测试();
